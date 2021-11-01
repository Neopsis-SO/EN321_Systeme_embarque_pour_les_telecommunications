----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2017 11:28:53 AM
-- Design Name: 
-- Module Name: UART_loop - Behavioral
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

entity UART_loop is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           sw : in std_logic_vector(1 downto 0);
           led : out std_logic_vector(15 downto 0);
           i_uart : in STD_LOGIC;
           o_uart : out STD_LOGIC);
end UART_loop;

architecture Behavioral of UART_loop is

component UART_fifoed_send is
    Generic ( fifo_size             : integer := 4096;
              fifo_almost           : integer := 4090;
              drop_oldest_when_full : boolean := False;
              asynch_fifo_full      : boolean := True;
              baudrate              : integer := 921600;   -- [bps]
              clock_frequency       : integer := 100000000 -- [Hz]
    );
    Port (
        clk_100MHz : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        dat_en     : in  STD_LOGIC;
        dat        : in  STD_LOGIC_VECTOR (7 downto 0);
        TX         : out STD_LOGIC;
        fifo_empty : out STD_LOGIC;
        fifo_afull : out STD_LOGIC;
        fifo_full  : out STD_LOGIC
    );
end component;


component UART_recv is
   Port ( clk    : in  STD_LOGIC;
          reset  : in  STD_LOGIC;
          rx     : in  STD_LOGIC;
          dat    : out STD_LOGIC_VECTOR (7 downto 0);
          dat_en : out STD_LOGIC);
end component;

component transmitter is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           stream_in : in STD_LOGIC_VECTOR(7 downto 0);
           stream_out : out STD_LOGIC_VECTOR(7 downto 0);
           data_valid : out std_logic);
end component;

component receiver is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           stream_in : in STD_LOGIC_VECTOR(7 downto 0);
           stream_out : out STD_LOGIC_VECTOR(7 downto 0);
           data_valid : out std_logic);
end component;

signal SIG_SW : std_logic_vector(1 downto 0);
signal rst_tx, rst_rx : std_logic;
signal dat_en, dat_en_tx, dat_en_rx : std_logic;
signal dat, dat_tx, dat_rx : std_logic_vector(7 downto 0);
signal scrambled_bit : std_logic;
signal sent_byte, sent_byte_tx, sent_byte_rx : std_logic_vector(7 downto 0);
signal data_valid, data_valid_tx, data_valid_rx : std_logic;
signal en_counter : unsigned(13 downto 0) := (others => '0');

signal fifo_empty, fifo_afull, fifo_full : std_logic;

begin

    SIG_SW <= sw;
    
	enable_counters:
	process (clk, rst) begin
		if (rising_edge(clk)) then
         if (rst = '1') then
               en_counter <= (others => '0');
         elsif(dat_en = '1') then				
				  en_counter <= en_counter + 1;				
         else
               en_counter <= en_counter;				
         end if;
		end if;
	end process;
	
	led(15 downto 9) <= std_logic_vector(en_counter(6 downto 0));
	led(0) <= fifo_empty;
	led(1) <= fifo_afull;
	led(2) <= fifo_full;
	led(8 downto 3) <= (others => '1'); 

	recv : UART_recv port map(  clk => clk,
		                    reset => rst,
		                    rx => i_uart,
		                    dat => dat,
		                    dat_en => dat_en);
		                    
	trans_num : transmitter port map( rst => rst_tx,
		                      clk => clk,
		                      enable => dat_en_tx,
		                      stream_in => dat_tx,
		                      stream_out => sent_byte_tx,
		                      data_valid => data_valid_tx);          

    recv_num : receiver port map( rst => rst_rx,
		                      clk => clk,
		                      enable => dat_en_rx,
		                      stream_in => dat_rx,
		                      stream_out => sent_byte_rx,
		                      data_valid => data_valid_rx);  
		                      
trans_receiv_choose : process (sw, dat_en, dat, sent_byte_tx, data_valid_tx, sent_byte_rx, data_valid_rx)
begin
    if(SIG_SW = "00") then
        dat_en_tx  <= dat_en;
        dat_tx     <= dat;
        sent_byte  <= sent_byte_tx;
        data_valid <= data_valid_tx;
    else
        dat_en_rx  <= dat_en;
        dat_rx     <= dat;
        sent_byte  <= sent_byte_rx;
        data_valid <= data_valid_rx;
    end if;
end process;

rst_gestion : process (rst, sw)
begin
    if(SIG_SW = "00") then
        rst_rx <= '1';
        rst_tx <= rst;
    else
        rst_tx <= '1';
        rst_rx <= rst;
    end if;
end process;
                      	                      
	send : UART_fifoed_send Generic map( fifo_size => 4096,
					      fifo_almost => 8,
					      drop_oldest_when_full => false,
					      asynch_fifo_full => True,
					      baudrate => 115200,
					      clock_frequency => 100000000)
	    Port map(   clk_100MHz => clk,
			reset => rst,
			dat_en => data_valid,
			dat    => sent_byte,
			TX     => o_uart,
			fifo_empty => fifo_empty, 
			fifo_afull => fifo_afull,
			fifo_full  => fifo_full);

end Behavioral;
