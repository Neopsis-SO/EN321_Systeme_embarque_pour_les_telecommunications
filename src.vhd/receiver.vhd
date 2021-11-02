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

-- Only to test our transmission chain with matlab (can be hide)
component register_8bits is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           stream_in : in STD_LOGIC_VECTOR(7 downto 0);
           stream_out : out STD_LOGIC_VECTOR(7 downto 0);
           data_valid : out std_logic);
end component;
-- Only to test our transmission chain with matlab (can be hide)

component S2P is
generic (width: integer := 7);
port (
	clk : in std_logic;
	reset : in std_logic;
	i_data_valid : in std_logic;
	serial_data : in std_logic;
	par_data : out std_logic_vector(width-1 downto 0);
	o_data_valid : out std_logic);
end component;

component hamenc_inv is
    Port ( rst    : in  std_logic;
           clk    : in  std_logic;
           i_data : in  std_logic_vector(7 downto 0);
           i_dv   : in  std_logic;
           o_data : out std_logic_vector(3 downto 0);
           o_dv   : out std_logic);
end component;

component P2S is
    GENERIC (width : positive :=4);
    Port ( clk               : in STD_LOGIC;
           reset             : in STD_LOGIC;
           load              : in STD_LOGIC;
           par_data          : in STD_LOGIC_VECTOR (width - 1 downto 0);
           serial_data       : out STD_LOGIC;
           serial_data_valid : out STD_LOGIC);
end component;

component descrambler is
port(
   iClock            : in	std_logic;
   iReset            : in	std_logic;
   iEN      		 : in	std_logic;
   iData           	 : in	std_logic;
   oDataValid        : out  std_logic;
   oData      		 : out	std_logic);
end component;

signal scrambler_out_dv, S2P_out_dv, bch_out_dv, p2s_out_dv, entrelaceur_out_dv : std_logic;
signal scrambler_out : std_logic;
signal S2P_out : std_logic_vector(7 downto 0);
signal bch_out : std_logic_vector(3 downto 0);
signal p2s_out : std_logic;
signal intrl_out : std_logic;
signal x1, x2 : std_logic;
signal tb_selected_bit : std_logic;
signal s2p_out_raw : std_logic_vector (7 downto 0);
signal bch_out_raw : std_logic_vector (3 downto 0);

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
-----------COMMUNICATION only---------------
--------------------------------------------           
--	reg_test : register_8bits port map( rst => rst,
--		                      clk => clk,
--		                      enable => enable,
--		                      stream_in => stream_in,
--		                      stream_out => stream_out,
--		                      data_valid => data_valid);

--------------------------------------------
--------------BCH_INV only------------------
--------------------------------------------

--bch_inv_test : hamenc_inv port map(rst => rst,
--                          clk => clk,
--                          i_data => stream_in,
--                          i_dv => enable,
--                          o_data => stream_out(3 downto 0),
--                          o_dv => data_valid);
                          
--stream_out(7 downto 4) <= (others => '0');

--------------------------------------------
----------P2S BCH_INV and S2P---------------
--------------------------------------------
S2P_test : S2P generic map(width => 7)
               port map( clk => clk,
                         reset => rst,
                         i_data_valid => enable,
                         serial_data => stream_in(0),
                         par_data => s2p_out_raw(6 DOWNTO 0),
                         o_data_valid => S2P_out_dv);

----S2P_out(0) <= s2p_out_raw(6);
----S2P_out(1) <= s2p_out_raw(5);
----S2P_out(2) <= s2p_out_raw(4);
----S2P_out(3) <= s2p_out_raw(3);
----S2P_out(4) <= s2p_out_raw(2);
----S2P_out(5) <= s2p_out_raw(1);
----S2P_out(6) <= s2p_out_raw(0);
S2P_out(7) <= '0';
S2P_out(6 downto 0) <= s2p_out_raw(6 downto 0);
                         
bch_inv_test : hamenc_inv port map(rst => rst,
                          clk => clk,
                          i_data => S2P_out,
                          i_dv => S2P_out_dv,
                          o_data => bch_out_raw,
                          o_dv => bch_out_dv);

--bch_out(3) <= bch_out_raw(0);
--bch_out(2) <= bch_out_raw(1);
--bch_out(1) <= bch_out_raw(2);
--bch_out(0) <= bch_out_raw(3);
bch_out <= bch_out_raw;

P2S_test : P2S generic map(width => 4)
               port map( clk => clk,
                         reset => rst,
                         load => bch_out_dv,
                         par_data => bch_out,
                         serial_data => p2s_out,
                         serial_data_valid => p2s_out_dv);


stream_out(7 downto 1) <= (others => '0');
stream_out(0) <= p2s_out;

data_valid <= p2s_out_dv;

--------------------------------------------
------------DESCRAMBLEUR only---------------
--------------------------------------------
--descramb_test : descrambler port map(  iClock => clk,
--                              iReset => rst,
--                              iEN => enable,
--                              iData => stream_in(0),
--                              oDataValid => scrambler_out_dv,
--                              oData  => scrambler_out);
                              
--stream_out(7 downto 1) <= (others => '0');
--stream_out(0) <= scrambler_out;

--data_valid <= scrambler_out_dv;

--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------
-------------End Test part------------------

end Behavioral;