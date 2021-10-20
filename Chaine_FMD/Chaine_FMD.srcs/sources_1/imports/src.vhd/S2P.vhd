----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/19/2021 08:28:13 AM
-- Design Name: 
-- Module Name: S2P - Behavioral
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

entity S2P is
    GENERIC (width: integer := 4);
    PORT (
        clk : in std_logic;
        reset : in std_logic;
        i_data_valid : in std_logic;
        serial_data : in std_logic;
        par_data : out std_logic_vector(width-1 downto 0);
        o_data_valid : out std_logic);
end S2P;

architecture Behavioral of S2P is
    signal counter : unsigned(width-1 downto 0);
begin

counters : process (clk, reset)
    begin
    if (reset = '1') then
        counter <= (others => '0');
        o_data_valid <= '0';	
    elsif (clk'event and clk = '1') then
        o_data_valid <= '0';
        if(i_data_valid = '1') then
            if(counter = (width-1)) then
                counter <= (others => '0');
                o_data_valid <= '1';		
            else
                counter <= counter + 1;
            end if;			
        end if;
    end if;
end process;

S2P : process(clk, reset)
    begin
        if (reset = '1') then
            par_data <= (OTHERS=> '0');
        elsif (clk'event and clk = '1') then
            if (i_data_valid = '1') then
                par_data(to_integer(counter)) <= serial_data;
            end if;
        end if;
    end process;

end Behavioral;