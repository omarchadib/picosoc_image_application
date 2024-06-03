

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    use IEEE.STD_LOGIC_MISC.or_reduce;
    use ieee.std_logic_textio.all;
    use STD.textio.all;

entity picorv32_mem_model is
    generic (
        G_DATA_WIDTH : integer := 32;
        FNAME_HEX : string := "data.dat";
        FNAME_OUT : string := "data.out"
    );
    port (
        resetn : IN STD_LOGIC;
        clock : IN STD_LOGIC;

        mem_valid : IN STD_LOGIC;
        mem_instr : IN STD_LOGIC;
        mem_addr : IN STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
        mem_wdata : IN STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
        mem_wstrb : IN STD_LOGIC_VECTOR(G_DATA_WIDTH/8-1 downto 0);

        mem_ready : OUT STD_LOGIC;
        mem_rdata : OUT STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0)
    );
end entity picorv32_mem_model;

architecture Behavioural of picorv32_mem_model is

    -- localised inputs
    signal resetn_i : STD_LOGIC;
    signal clock_i : STD_LOGIC;
    signal mem_valid_i : STD_LOGIC;
    signal mem_instr_i : STD_LOGIC;
    signal mem_addr_i : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
    signal mem_wdata_i : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
    signal mem_wstrb_i : STD_LOGIC_VECTOR(G_DATA_WIDTH/8-1 downto 0);
    signal mem_ready_i : STD_LOGIC;
    signal mem_rdata_i : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);

    file fh : text;

    type T_memory is array(0 to 16384-1) of STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
    signal mem : T_memory;

    signal masked_data, mask : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
    signal outgoing_data : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
    signal flag : STD_LOGIC;
    signal mem_addr_int : integer range 0 to 16384-1;
    signal write_operation : STD_LOGIC;

    signal mem_content : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);

begin

    -------------------------------------------------------------------------------
    -- (DE-)LOCALISING IN/OUTPUTS
    -------------------------------------------------------------------------------
    resetn_i <= resetn;
    clock_i <= clock;

    mem_valid_i <= mem_valid;
    mem_instr_i <= mem_instr;
    mem_addr_i <= mem_addr;
    mem_wdata_i <= mem_wdata;
    mem_wstrb_i <= mem_wstrb;
    mem_ready <= mem_ready_i;
    mem_rdata <= mem_rdata_i;

    -------------------------------------------------------------------------------
    -- COMBINATORIAL
    -------------------------------------------------------------------------------
    mem_ready_i <= flag;
    mem_rdata_i <= outgoing_data;

    mem_addr_int <= to_integer(unsigned(mem_addr_i(15 downto 2)));
    write_operation <= or_reduce(mem_wstrb);

    -- mask out the read and write data based on the STROBE
    mask <= mem_wstrb_i(3) & mem_wstrb_i(3) & mem_wstrb_i(3) & mem_wstrb_i(3) & mem_wstrb_i(3) & mem_wstrb_i(3) & mem_wstrb_i(3) & mem_wstrb_i(3) & 
    mem_wstrb_i(2) & mem_wstrb_i(2) & mem_wstrb_i(2) & mem_wstrb_i(2) & mem_wstrb_i(2) & mem_wstrb_i(2) & mem_wstrb_i(2) & mem_wstrb_i(2) & 
    mem_wstrb_i(1) & mem_wstrb_i(1) & mem_wstrb_i(1) & mem_wstrb_i(1) & mem_wstrb_i(1) & mem_wstrb_i(1) & mem_wstrb_i(1) & mem_wstrb_i(1) & 
    mem_wstrb_i(0) & mem_wstrb_i(0) & mem_wstrb_i(0) & mem_wstrb_i(0) & mem_wstrb_i(0) & mem_wstrb_i(0) & mem_wstrb_i(0) & mem_wstrb_i(0);
    masked_data <= mem_wdata_i and mask;

    mem_content <= mem(mem_addr_int) and not(mask);

    -------------------------------------------------------------------------------
    -- MEMORY
    -------------------------------------------------------------------------------

    PMEM: process(resetn_i, clock_i)
        variable v_line : line;
        variable v_temp : STD_LOGIC_VECTOR(G_DATA_WIDTH-1 downto 0);
        variable v_pointer : integer;
    begin
        if resetn_i = '0' then 
            outgoing_data <= (others => '0');
            mem <= (others => (others => '0'));
            flag <= '0';

            v_pointer := 0;
            file_open(fh, FNAME_HEX, read_mode);

            while not endfile(fh) loop
                readline(fh, v_line);
                hread(v_line, v_temp);
                mem(v_pointer) <= v_temp;
                v_pointer := v_pointer + 1;
            end loop;

            file_close(fh);

            file_open(fh, FNAME_OUT, write_mode);
            
        elsif rising_edge(clock_i) then 

            if(mem_valid_i = '1') then 
                if write_operation = '1' then 
                    if mem_addr_i = x"10000000" and mem_ready_i = '1' then 
                        write(v_line, masked_data);
                        writeline(fh,  v_line);
                    else
                        mem(mem_addr_int) <= masked_data OR mem_content;
                        outgoing_data <= (others => '0');
                    end if;
                else
                    outgoing_data <= mem(mem_addr_int);
                end if;
            end if;
            flag <= mem_valid_i;
        end if;
    end process;



end Behavioural;
