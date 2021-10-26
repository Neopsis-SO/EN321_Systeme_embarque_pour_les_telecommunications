----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2017 04:03:43 PM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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

entity receiver is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           stream_in : in STD_LOGIC_VECTOR(7 downto 0);
           stream_out : out STD_LOGIC_VECTOR(7 downto 0);
           data_valid : out std_logic);
end receiver;

architecture Behavioral of receiver is   

component scrambler is
port(
   iClock            : in	std_logic;
   iReset            : in	std_logic;
   iEN      		 	: in	std_logic;
   iData           	: in	std_logic;
   oDataValid        : out std_logic;
   oData      			: out	std_logic);
end component;

signal scrambler_out_dv, S2P_out_dv, bch_out_dv, entrelaceur_out_dv : std_logic;
signal scrambler_out : std_logic;
signal S2P_out : std_logic_vector(3 downto 0);
signal bch_out : std_logic_vector(7 downto 0);
signal p2s_out : std_logic;
signal intrl_out : std_logic;
signal x1, x2 : std_logic;
signal tb_selected_bit : std_logic;

begin

--descramb : scrambler port map(  iClock => clk,
--                              iReset => rst,
--                              iEN => bch_out_dv,
--                              iData => p2s_out,
--                              oDataValid => scrambler_out_dv,
--                              oData  => scrambler_out);

--stream_out(7 downto 1) <= (others => '0');
--stream_out(0) <= scrambler_out;

--data_valid <= scrambler_out_dv;


---------------Test part--------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

--------------------------------------------
-----------------BCH only-------------------
--------------------------------------------
descramb : scrambler port map(  iClock => clk,
                              iReset => rst,
                              iEN => enable,
                              iData => stream_in(0),
                              oDataValid => data_valid,
                              oData  => stream_out(0));

stream_out(0) <= scrambler_out;

--------------------------------------------
-----------------BCH only-------------------
--------------------------------------------
--bch_enc_test : hamenc port map(rst => rst,
--                          clk => clk,
--                          i_data => stream_in(3 downto 0),
--                          i_dv => enable,
--                          o_data => stream_out,
--                          o_dv => data_valid);

--------------------------------------------
-------------Entrelaceur only---------------
--------------------------------------------
--intrl_test : entrelaceur port map( iClock => clk,
--                              iReset => rst,
--                              iEN => enable,
--                              par_data => stream_in(6 downto 0),
--                              serial_data => stream_out(0),
--                              serial_data_valid => data_valid);
							  
--stream_out(7 downto 1) <= (others => '0');

--------------------------------------------
-------------Coder_conv only----------------
--------------------------------------------
--cc_test : codeur_conv port map(	  iClock => clk,
--                              iReset => rst,
--                              iEN => enable,
--                              iData => stream_in(0),
--                              oDataX => x1,
--                              oDataY => x2);
							  
--stream_out(7 downto 2) <= (others => '0');
--stream_out(0) <= x1;
--stream_out(1) <= x2;
--data_valid <= enable;

--------------------------------------------
-----------BCH and Entrelaceur--------------
--------------------------------------------
--bch_enc : hamenc port map(rst => rst,
--                          clk => clk,
--                          i_data => stream_in(3 downto 0),
--                          i_dv => enable,
--                          o_data => bch_out,
--                          o_dv => bch_out_dv);

--intrl : entrelaceur port map( iClock => clk,
--                              iReset => rst,
--                              iEN => bch_out_dv,
--                              par_data => bch_out(6 downto 0),
--                              serial_data => stream_out(0),
--                              serial_data_valid => data_valid);

--stream_out(7 downto 1) <= (others => '0');

--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------
-------------End Test part------------------

end Behavioral;