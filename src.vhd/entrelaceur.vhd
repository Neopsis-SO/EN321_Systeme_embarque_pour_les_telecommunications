----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.10.2021 08:29:39
-- Design Name: 
-- Module Name: P2S - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity entrelaceur is 
generic (width : integer := 7);
PORT(
    iClock : in std_logic;
	iReset : in std_logic;
	iEN    : in std_logic;
	par_data : in std_logic_vector(width-1 downto 0);
	serial_data : out std_logic;
	serial_data_valid : out std_logic);
end entrelaceur;

architecture Behavioral of entrelaceur is
signal counter : UNSIGNED(2 downto 0);
signal ligne_1 : STD_LOGIC;
signal ligne_2 : STD_LOGIC_VECTOR(1 downto 0);
signal ligne_3 : STD_LOGIC_VECTOR(2 downto 0);
signal ligne_4 : STD_LOGIC_VECTOR(3 downto 0);
signal ligne_5 : STD_LOGIC_VECTOR(4 downto 0);
signal ligne_6 : STD_LOGIC_VECTOR(5 downto 0);
signal ligne_7 : STD_LOGIC_VECTOR(6 downto 0);

begin
counters : process (iClock, iReset) begin
    if (iReset = '1') then
        counter <= to_unsigned(6, 3);
        serial_data_valid <= '0';
    elsif (iClock'EVENT and iClock = '1') then
        serial_data_valid <= '0';
        if(iEN = '1') then
            counter <= (others => '0');
            serial_data_valid <= '1';
        elsif (counter /= 6) then
            counter <= counter + 1;
            serial_data_valid <= '1';
        end if;
    end if;
end process;

serial : process (iClock, iReset) begin
    if (iReset = '1') then
        ligne_2 <= (others => '0');
        ligne_3 <= (others => '0');
        ligne_4 <= (others => '0');
        ligne_5 <= (others => '0');
        ligne_6 <= (others => '0');
        ligne_7 <= (others => '0');
    elsif (iClock'EVENT and iClock = '1') then
        if (iEN = '1') then
            -- Récupération de la valeur d'entrée
            ligne_2(0) <= par_data(1);
            ligne_3(0) <= par_data(2);
            ligne_4(0) <= par_data(3);
            ligne_5(0) <= par_data(4);
            ligne_6(0) <= par_data(5);
            ligne_7(0) <= par_data(6);
            
            -- Décalage des registres
            -- Décalage de la ligne 2
            ligne_2(1) <= ligne_2(0);
            
            -- Décalage de la ligne 3
            ligne_3(1) <= ligne_3(0);
            ligne_3(2) <= ligne_3(1);
            
            -- Décalage de la ligne 4
            ligne_4(1) <= ligne_4(0);
            ligne_4(2) <= ligne_4(1);
            ligne_4(3) <= ligne_4(2);
            
            -- Décalage de la ligne 5
            ligne_5(1) <= ligne_5(0);
            ligne_5(2) <= ligne_5(1);
            ligne_5(3) <= ligne_5(2);
            ligne_5(4) <= ligne_5(3);
            
            -- Décalage de la ligne 6
            ligne_6(1) <= ligne_6(0);
            ligne_6(2) <= ligne_6(1);
            ligne_6(3) <= ligne_6(2);
            ligne_6(4) <= ligne_6(3);
            ligne_6(5) <= ligne_6(4);
            
            -- Décalage de la ligne 7
            ligne_7(1) <= ligne_7(0);
            ligne_7(2) <= ligne_7(1);
            ligne_7(3) <= ligne_7(2);
            ligne_7(4) <= ligne_7(3);
            ligne_7(5) <= ligne_7(4);  
            ligne_7(6) <= ligne_7(5);
                  
            
        end if;    
    end if;   
end process;

ligne_1 <= par_data(0);

mux : process(counter, ligne_1, ligne_2, ligne_3, ligne_4, ligne_5, ligne_6, ligne_7)
    begin
            case counter is
                when "000" =>
                    serial_data <= ligne_1;
                when "001" =>
                    serial_data <= ligne_2(to_integer(counter));
                when "010" =>
                    serial_data <= ligne_3(to_integer(counter));
                when "011" =>
                    serial_data <= ligne_4(to_integer(counter));
                when "100" =>
                    serial_data <= ligne_5(to_integer(counter));
                when "101" =>
                    serial_data <= ligne_6(to_integer(counter));
                when "110" =>
                    serial_data <= ligne_7(to_integer(counter));
                when OTHERS =>
                    serial_data <= '0';
            end case;
end process;

end Behavioral;
