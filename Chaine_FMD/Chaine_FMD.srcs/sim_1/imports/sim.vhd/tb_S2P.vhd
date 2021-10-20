-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity S2P_tb is
end;

architecture bench of S2P_tb is

  component S2P
      GENERIC (width: integer := 4);
      PORT (
          clk : in std_logic;
          reset : in std_logic;
          i_data_valid : in std_logic;
          serial_data : in std_logic;
          par_data : out std_logic_vector(width-1 downto 0);
          o_data_valid : out std_logic);
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal i_data_valid: std_logic;
  signal serial_data: std_logic;
  signal par_data: std_logic_vector(4-1 downto 0);
  signal o_data_valid: std_logic;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: S2P generic map ( width        =>  4)
              port map ( clk          => clk,
                         reset        => reset,
                         i_data_valid => i_data_valid,
                         serial_data  => serial_data,
                         par_data     => par_data,
                         o_data_valid => o_data_valid );

  stimulus: process
  begin
  
    -- Put initialisation code here
    serial_data <= '0';
    i_data_valid <= '0';
    reset <= '1';
    wait for 4 * clock_period;
    reset <= '0';
    wait for 4 * clock_period;

    -- Put test bench stimulus code here
    serial_data <= '1';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
    
    serial_data <= '0';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
    
    serial_data <= '1';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
    
    serial_data <= '1';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
        
    serial_data <= '0';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
    
    serial_data <= '1';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
    
    serial_data <= '0';
    i_data_valid <= '1';
    wait for clock_period;
    i_data_valid <= '0';
    wait for 2 * clock_period;
    
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;