----------------------------------------------------------------------------------
-- Omar Chadib
-- 
-- 
-- Create Date: 06/13/2024 03:06:52 PM
-- Design Name: 
-- Module Name: vga_test_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_test_tb is
--  Port ( );
end vga_test_tb;

architecture Behavioral of vga_test_tb is

component vga_test is 
    port (
        clk, reset: in std_logic;
        sw: in std_logic_vector(2 downto 0);
        hsync, vsync: out std_logic;
        rgb: out std_logic_vector(2 downto 0)
    );
  end component;
  
 -- in
 signal clk_tb , reset_tb :  std_logic ;
 signal sw_tb : std_logic_vector(2 downto 0);
 -- out 
 signal hsync_tb , vsync_tb :  std_logic ;
 signal rgb_tb : std_logic_vector(2 downto 0);

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
    
    stinuli : process 
    begin     -- 8 colours combinations
    sw_tb <= "101";
    wait for 20 ns;
    sw_tb <= "100";
    wait for 20 ns;
    sw_tb <= "111";
    wait for 20 ns;
    sw_tb <= "001";
    wait for 20 ns;
    sw_tb <= "000";
    wait for 20 ns;
    sw_tb <= "010";
    wait for 20 ns;
    sw_tb <= "011";
    wait for 20 ns;
    sw_tb <= "110";
    wait for 20 ns;
    sw_tb <= "111";
    wait for 20 ns;
    sw_tb <= "001";
    wait for 20 ns;
    sw_tb <= "000";
    wait for 20 ns;
    wait; -- Continue waiting indefinitely

    end process;
    
    vga_test_inst : component vga_test
    port map(
        clk => clk_tb,
        reset => reset_tb,
        sw => sw_tb,
        hsync => hsync_tb,
        vsync => vsync_tb,        
        rgb=> rgb_tb
    );


end Behavioral;
