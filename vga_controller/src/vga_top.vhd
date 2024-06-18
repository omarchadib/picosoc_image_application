
--  
-- Omar Chadib
-- 
-- Create Date: 06/14/2024 01:04:00 PM
-- Design Name: 
-- Module Name: vga_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    use IEEE.STD_LOGIC_MISC.or_reduce;
    use ieee.std_logic_textio.all;
    use STD.textio.all;


entity vga_top is
    port (
        clk, reset: in std_logic;
--        sw: in std_logic_vector(2 downto 0);
        hsync, vsync: out std_logic;
        rgb: out std_logic_vector(2 downto 0)
    );
end vga_top;

  architecture behavioural of vga_top is

signal rgb_reg: std_logic_vector (2 downto 0);
signal video_on: std_logic;
signal p_tick: std_logic;


type memory_array is array (0 to 307199) of std_logic_vector(2 downto 0); -- Memory array for 90000 3-bit values
signal mem : memory_array := (others => (others => '0')); -- Initialize the memory with zeros
signal mem_addr : std_logic_vector(18 downto 0):= ( others => '0'); -- Initialize start adress at zero

begin
-- instantiate VGA sync circuit 
vga_sync_unit : entity work.vga_sync
    port map(
        clk => clk,
        reset => reset,
        hsync => hsync,
        p_tick => p_tick,
        vsync => vsync,
        video_on => video_on
    );


-- Process to read memory initialization file
  process
    file hex_file : text open read_mode is "C:\Users\pn327\Downloads\image.txt";
    variable line_buffer : line;
    variable line_str : string(1 to 3); -- Assuming each line contains 3 binary characters
    variable data_read : std_logic_vector(2 downto 0);
    variable index : integer := 0;
  begin
    -- Read the file line by line
    while not endfile(hex_file) loop
      readline(hex_file, line_buffer);
      read(line_buffer, line_str);  -- Read the line as a string of binary characters
      

        -- Convert string to std_logic_vector
        data_read(2) := '0';
        data_read(1) := '0';
        data_read(0) := '0';

        if line_str(1) = '1' then
            data_read(2) := '1';
        end if;
        
        if line_str(2) = '1' then
            data_read(1) := '1';
        end if;
        
        if line_str(3) = '1' then
            data_read(0) := '1';
        end if;

      mem(index) <= data_read;       -- Assign the value to the memory array
      index := index + 1;
    end loop;
    
    file_close(hex_file);
    wait; -- Wait indefinitely to keep the process running
  end process;




-- rgb buffer 
process (clk, reset) 
begin 
    if reset = '1' then 
        rgb <= (others => '0'); 
        mem_addr <= (others => '0');

elsif rising_edge(clk) then
    if p_tick = '1' then                     -- 25MHz of the monitor
        if video_on = '1' then                       --when the display is on to avoid displaying on black porch when handling wrap around 
            if to_integer(unsigned(mem_addr)) < 307199 then    -- picture size 
                rgb <= mem(to_integer(unsigned(mem_addr)));
                mem_addr <= std_logic_vector(unsigned(mem_addr) + 1);
            else
                mem_addr <= (others => '0'); -- Reset address or handle wrap-around
            end if;
        else
            rgb <= (others => '0');
        end if;
    end if;
end if;

end process;



--rgb <= rgb_reg when video_on = '1' else "000";

end behavioural;
