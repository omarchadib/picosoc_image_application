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
    use STD.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_sync is
--  Port ( );

port(
    clk, reset : in std_logic ;
    hsync, vsync : out std_logic;
    video_on, p_tick : out std_logic
     );
end vga_sync;

architecture Behavioral of vga_sync is
 constant HD: integer :=640; --horizontal display area 
 constant HF: integer:=16 ; --h. front porch 
 constant HB: integer:=48 ; --h. back porch 
 constant HR: integer:=96 ; --h. retrace 
 constant VD: integer :=480; --vertical display area 
 constant VF: integer:=10; -- v. front porch 
 constant VB: integer :=33; -- v. back porch 
 constant VR: integer :=2; -- v. retrace

--mod2 counter
signal mod2_reg, mod2_next : std_logic; 

--signal counters
signal v_count_reg , v_count_next : unsigned(9 downto 0) ; 
signal h_count_reg , h_count_next : unsigned(9 downto 0) ;

--output buffer
signal v_sync_reg, h_sync_reg : std_logic ;
signal v_sync_next, h_sync_next : std_logic ;

--status signal
signal h_end, v_end, pixel_tick : std_logic ;


begin
    --reset process and registers
    process (clk, reset)
    begin
        if reset = '1' then 
            mod2_reg <= '0'; 
            v_count_reg <= (others=>'0'); 
            h_count_reg <= (others=>'0'); 
            v_sync_reg <= '0'; 
            h_sync_reg <= '0'; 
        elsif (clk'event and clk='1') then 
            mod2_reg <= mod2_next ; 
            v_count_reg <= v_count_next; 
            h_count_reg <= h_count_next; 
            v_sync_reg <= v_sync_next ; 
            h_sync_reg <= h_sync_next ; 
        end if ;
    
    end process;
   
   --mod2 circuit to generate 25Mhz enable tick
   mod2_next <= not mod2_reg;
   --25 MHz pixel tick
   pixel_tick <= '1' when mod2_reg = '1' else '0';
   -- status
   h_end <= '1' when h_count_reg=(HD+HF+HB+HR-1) else '0';     --799
   v_end <= '1' when v_count_reg=(VD+VF+VB+VR-1) else '0';     --524

   -- MOD 800 HORIZONTAL COUNTER
   process( h_count_reg, h_end, pixel_tick)
   begin
   if pixel_tick = '1' then
        if h_end = '1' then
            h_count_next <= (others=>'0'); 
        else
            h_count_next <= h_count_reg + 1 ;
        end if;
   else
        h_count_next <= h_count_reg;
   end if;   
   end process;
   
   -- MOD 525 VERTICAL COUNTER
      process( v_count_reg, v_end, pixel_tick)
   begin
   if (pixel_tick = '1') and ( h_end = '1') then
        if v_end = '1' then
            v_count_next <= (others=>'0'); 
        else
            v_count_next<= v_count_reg + 1 ;
        end if;
   else
        v_count_next <= v_count_reg;
   end if;   
   end process;
   
   h_sync_next <= '1' when (h_count_reg >= (HD+HF)) and (h_count_reg <= (HD+HF+HR-1)) else '0';  -- 656 and 751
   v_sync_next <= '1' when (v_count_reg >= (VD+VF)) and (v_count_reg <= (VD+VF+VR-1)) else '0';  -- 490 and 491
   
   -- video on/off
   video_on <= '1' when (h_count_reg < HD) and (v_count_reg < VD) else '0';
   
   -- output signals
   hsync <= h_sync_reg;
   vsync <= v_sync_reg;
   p_tick <= pixel_tick;

   
end Behavioral;
