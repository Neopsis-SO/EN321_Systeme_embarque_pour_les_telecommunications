----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.10.2021 17:14:50
-- Design Name: 
-- Module Name: hamenc - Behavioral
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

entity hamenc is
    Port ( rst    : in  std_logic;
           clk    : in  std_logic;
           i_data : in  std_logic_vector(3 downto 0);
           i_dv   : in  std_logic;
           o_data : out std_logic_vector(7 downto 0);
           o_dv   : out std_logic);

end hamenc;

architecture Behavioral of hamenc is
    
begin
    process(clk)
        begin
           if(clk'EVENT and clk= '1')	then
              if(rst = '1')	then
                 o_data <= (others=>'0');
                 o_dv <= '0';
              elsif(i_dv = '1')	then
                 o_dv      <= '1';
                 o_data(0) <= i_data(0);
                 o_data(1) <= i_data(1);
                 o_data(2) <= i_data(2);
                 o_data(3) <= i_data(3);
                 o_data(4) <= i_data(0) xor i_data(1) xor i_data(2);
                 o_data(5) <= i_data(1) xor i_data(2) xor i_data(3);
                 o_data(6) <= i_data(0) xor i_data(1) xor i_data(3);
                 o_data(7) <= '0';
              else 
                 o_dv      <= '0';
                 o_data(0) <= i_data(0);
                 o_data(1) <= i_data(1);
                 o_data(2) <= i_data(2);
                 o_data(3) <= i_data(3);
                 o_data(4) <= i_data(0) xor i_data(1) xor i_data(2);
                 o_data(5) <= i_data(1) xor i_data(2) xor i_data(3);
                 o_data(6) <= i_data(0) xor i_data(1) xor i_data(3);
                 o_data(7) <= '0';
              end if;			
       end if;
    end process;
end Behavioral;