library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    use IEEE.STD_LOGIC_MISC.or_reduce;
    use STD.textio.all;
    use ieee.std_logic_textio.all;
    
    entity uart_transmitter is
    generic (
        BAUD_RATE : integer := 9600
    );
    port (
        clk : in std_logic;
        reset : in std_logic;
        mem_wdata : in std_logic_vector(31 downto 0);
        transmit_enable : in std_logic;
        uart_tx : out std_logic
    );
end entity uart_transmitter;

architecture behavioral of uart_transmitter is
    -- Define states for UART transmission
    type state_type is (IDLE, START_BIT, TRANSMIT_DATA, STOP_BIT);
    signal state : state_type := IDLE;
    
    -- Define constants for timing
constant BAUD_PERIOD : time := 104 ns; -- Baud period in microseconds
    constant BIT_PERIOD : time := BAUD_PERIOD / 10; -- Divide baud period by 10 for bit period

    
    -- Internal counter for bit transmission
    signal bit_counter : integer range 0 to 31 := 0;
    
    -- Internal signals for data transmission
    signal data_to_transmit : std_logic_vector(33 downto 0);

begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= IDLE;
                bit_counter <= 0;
            else
                case state is
                    when IDLE =>
                        if transmit_enable = '1' then
                            state <= START_BIT;
                            bit_counter <= 0;
                        end if;
                    
                    when START_BIT =>
                        uart_tx <= '0';
                        state <= TRANSMIT_DATA;
                    
                    when TRANSMIT_DATA =>
                        uart_tx <= data_to_transmit(bit_counter);
                        if bit_counter = 31 then
                            state <= STOP_BIT;
                        else
                            bit_counter <= bit_counter + 1;
                        end if;
                    
                    when STOP_BIT =>
                        uart_tx <= '1';
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;

    -- Convert mem_wdata to serial stream
    data_to_transmit <= '0' & mem_wdata & '1'; -- Start and stop bits

end architecture behavioral;
