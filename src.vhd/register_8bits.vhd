----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2021 09:45:43 AM
-- Design Name: 
-- Module Name: register_8bits - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity register_8bits is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           stream_in : in STD_LOGIC_VECTOR(7 downto 0);
           stream_out : out STD_LOGIC_VECTOR(7 downto 0);
           data_valid : out std_logic);
end register_8bits;

architecture Behavioral of register_8bits is   
    signal bascule_8bits : STD_LOGIC_VECTOR (7 downto 0);
    signal data_ok : STD_LOGIC;
begin
    process(clk, rst)
    begin
        if (rst = '1') then
            bascule_8bits <= (OTHERS=> '0');
            data_ok <= '0';
        elsif (clk'event and clk = '1') then
            if (data_ok = '1') then
                data_ok <= '0';
            end if;
            if (enable = '1') then
                bascule_8bits <= stream_in;
                data_ok <= '1';
            end if;
        end if;
    end process;

stream_out <= bascule_8bits;
data_valid <= data_ok;

end Behavioral;