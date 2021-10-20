----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/11/2021 09:45:43 AM
-- Design Name: 
-- Module Name: codeur_conv - Behavioral
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

entity codeur_conv is
    Port(
		iClock            : in	std_logic;
		iReset            : in	std_logic;
		iEN	    		    : in	std_logic;
		iData            	: in	std_logic;
		oDataX           	: out std_logic;
		oDataY           	: out std_logic
	 );
end codeur_conv;

architecture Behavioral of codeur_conv is   
    signal bascule_Nbits : STD_LOGIC_VECTOR (1 downto 0);
begin
    process(iClock, iReset)
    begin
        if (iReset = '1') then
            bascule_Nbits <= (OTHERS=> '0');
        elsif (iClock'event and iClock = '1') then
            if (iEN = '1') then
                bascule_Nbits(1) <= bascule_Nbits(0) ;
                bascule_Nbits(0) <= iData ;
            end if;
        end if;
    end process;

oDataX <= iData             XOR bascule_Nbits(1);
oDataY <= bascule_Nbits(0)  XOR bascule_Nbits(1);

end Behavioral;