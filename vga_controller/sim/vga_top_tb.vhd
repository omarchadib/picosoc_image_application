----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/14/2024 02:02:54 PM
-- Design Name: 
-- Module Name: vga_top_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_top_tb is
--  Port ( );
end vga_top_tb;

architecture Behavioral of vga_top_tb is

component vga_top is 
    port(
        clk, reset : in std_logic ;
        hsync, vsync : out std_logic;
        rgb: out std_logic_vector(2 downto 0)
                
    );
end component;

 signal clk_tb , reset_tb :  std_logic ;
  signal hsync_tb , vsync_tb :  std_logic:='0' ;
  signal rgb_tb : std_logic_vector (2 downto 0);
  
  
begin
    PCLK: process
    begin
        clk_tb <= '1';
        wait for 10ns;
        clk_tb <= '0';
        wait for 10ns;
    end process ;
    
        reset : process
    begin
    reset_tb <= '0';
    wait for 5 ns;
    reset_tb <= '1';
    wait for 10 ns;
    reset_tb <= '0';
    wait;
    end process;


vga_top_inst : component vga_top
port map(
    clk => clk_tb,
    reset => reset_tb,
    hsync => hsync_tb,
    vsync => vsync_tb,
    rgb => rgb_tb);
end Behavioral;
