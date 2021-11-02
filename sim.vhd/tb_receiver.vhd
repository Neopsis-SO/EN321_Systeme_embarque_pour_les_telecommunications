----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2017 02:27:32 PM
-- Design Name: 
-- Module Name: tb_UART_loop - Behavioral
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

entity tb_receiver is
--  Port ( );
end tb_receiver;

architecture Behavioral of tb_receiver is

component read_int_file is
generic (
		file_name:       string  := "default.txt";
		line_size:			integer := 32;
		symb_max_val : integer := 3;
		data_size : integer := 2
	 );
port(	clk : in  STD_LOGIC;
		rst : in std_logic;
		enable : in  STD_LOGIC;
		stream_out : out STD_LOGIC_vector(data_size-1 downto 0));
end component;

component receiver is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           stream_in : in STD_LOGIC_VECTOR(7 downto 0);
           stream_out : out STD_LOGIC_VECTOR(7 downto 0);
           data_valid : out std_logic);
end component;


signal rst : STD_LOGIC;
signal clk : std_logic := '0';
--signal sw : std_logic_vector(1 downto 0);
--signal led : std_logic_vector(9 downto 0);
--signal i_uart : STD_LOGIC;
--signal o_uart : STD_LOGIC;
signal incoming_byte : std_logic_vector(7 downto 0);
signal counter : unsigned(15 downto 0);
signal enable : std_logic;
signal enable_read_byte : std_logic;
--signal tx, busy : std_logic;
signal stream_out : std_logic_vector(7 downto 0); 
signal data_valid : std_logic;
signal enable_shift_byte : std_logic;
signal counter_limit : integer := 10; --156

---------------Path for every documents--------------------
--signal PATH_BCH_only : string := "C:\Users\max95\OneDrive\Documents\Personnel\Etudes\ENSEIRB\03_SEE_3A\EN321_Systeme_embarque_pour_les_telecommunications\TP\test_files\BCH_only.txt";
--signal PATH_Entrelaceur_only : string := "C:\Users\max95\OneDrive\Documents\Personnel\Etudes\ENSEIRB\03_SEE_3A\EN321_Systeme_embarque_pour_les_telecommunications\TP\test_files\Entrelaceur_only.txt";
--signal PATH_Coder_conv_only : string := "C:\Users\max95\OneDrive\Documents\Personnel\Etudes\ENSEIRB\03_SEE_3A\EN321_Systeme_embarque_pour_les_telecommunications\TP\test_files\Codeur_conv_only.txt";

begin

rst <= '1', '0' after 131 ns;
clk <= not(clk) after 5 ns;

enable <= '1';

counters : process (clk, rst) begin
    if (rst = '1') then
        counter <= (others => '0');
        enable_read_byte <= '0';		
    elsif (rising_edge(clk)) then
        if(enable = '1') then
            if(counter = counter_limit) then
                counter <= (others => '0');
                enable_read_byte <= '1';			
            else
                counter <= counter + 1;
                enable_read_byte <= '0';
            end if;			
        end if;
    end if;
end process;

input_file : read_int_file generic map("C:\Users\max95\OneDrive\Documents\Personnel\Etudes\ENSEIRB\03_SEE_3A\EN321_Systeme_embarque_pour_les_telecommunications\TP\test_files\P2S_BCH_inv_S2P.txt", 1, 255, 8)
port map(clk, rst, enable_read_byte, incoming_byte);

delay : process (clk, rst) begin
    if (rst = '1') then
        enable_shift_byte <= '0';
    elsif (rising_edge(clk)) then
        enable_shift_byte <= enable_read_byte;
    end if;
end process;

uut : receiver port map(rst, clk, enable_shift_byte, incoming_byte, stream_out, data_valid);
          
end Behavioral;
