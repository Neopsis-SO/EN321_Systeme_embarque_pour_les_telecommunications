-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity codeur_conv_tb is
end;

architecture bench of codeur_conv_tb is

  component codeur_conv
      Port(
  		iClock            : in	std_logic;
  		iReset            : in	std_logic;
  		iEN	    		    : in	std_logic;
  		iData            	: in	std_logic;
  		oDataX           	: out std_logic;
  		oDataY           	: out std_logic
  	 );
  end component;

  signal iClock: std_logic;
  signal iReset: std_logic;
  signal iEN: std_logic;
  signal iData: std_logic;
  signal oDataX: std_logic;
  signal oDataY: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: codeur_conv    port map ( iClock         => iClock,
                                 iReset         => iReset,
                                 iEN            => iEN,
                                 iData          => iData,
                                 oDataX         => oDataX,
                                 oDataY         => oDataY );

  stimulus: process
  begin
  
    -- Put initialisation code here
    iData <= '0';
    iReset <= '1';
    wait for 4 * clock_period;
    iReset <= '0';
    wait for 4 * clock_period;

    -- Put test bench stimulus code here
    iData <= '1';
    wait for 2 * clock_period;
    iData <= '1';
    wait for 2 * clock_period;
    iData <= '1';
    wait for 2 * clock_period;
    
    iData <= '1';
    wait for 2 * clock_period;
    iData <= '0';
    wait for 2 * clock_period;
    iData <= '1';
    wait for 2 * clock_period;
    
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      iClock <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

    clock_enable: process
    begin
        while not stop_the_clock loop
            iEN <= '1';
            iEN <= '0' after clock_period;
            wait for 2*clock_period;
        end loop;
        wait;
    end process;
end;