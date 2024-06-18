----------------------------------------------------------------------------------
-- 
-- Omar Chadib
-- 
-- Create Date: 06/13/2024 01:42:55 PM
-- Design Name: 
-- Module Name: vga_sync - Behavioral
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


entity vga_test is
    port (
        clk, reset: in std_logic;
        sw: in std_logic_vector(2 downto 0);
        hsync, vsync: out std_logic;
        rgb: out std_logic_vector(2 downto 0)
    );
end vga_test;

  architecture behavioural of vga_test is

signal rgb_reg: std_logic_vector (2 downto 0);
signal video_on: std_logic;

begin
-- instantiate VGA sync circuit 
vga_sync_unit : entity work.vga_sync
    port map(
        clk => clk,
        reset => reset,
        hsync => hsync,
        p_tick => open,
        vsync => vsync,
        video_on => video_on
    );

-- rgb buffer 
process (clk, reset) 
begin 
    if reset = '1' then 
        rgb_reg <= (others => '0'); 
    elsif (clk'event and clk = '1') then 
        rgb_reg <= sw; 
    end if; 
end process;

rgb <= rgb_reg when video_on = '1' else "000";

end behavioural;

