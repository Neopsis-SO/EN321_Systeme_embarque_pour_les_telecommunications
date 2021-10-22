-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 19.10.2021 08:34:25 UTC

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity tb_entrelaceur is
end tb_entrelaceur;

architecture tb of tb_entrelaceur is
    component P2S
        port (iClock            : in std_logic;
              iReset            : in std_logic;
              iEN               : in std_logic;
              par_data          : in std_logic_vector (6 downto 0);
              serial_data       : out std_logic;
              serial_data_valid : out std_logic);
    end component;

    signal iClock            : std_logic;
    signal iReset            : std_logic;
    signal iEN               : std_logic;
    signal par_data          : std_logic_vector (6 downto 0);
    signal serial_data       : std_logic;
    signal serial_data_valid : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : entrelaceur
    port map (iClock            => iClock,
              iReset            => iReset,
              iEN               => iEN,
              par_data          => par_data,
              serial_data       => serial_data,
              serial_data_valid => serial_data_valid);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that iClock is really your main clock signal
    iClock <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        iEN <= '0';
        par_data <= (others => '0');

        -- Reset generation
        -- EDIT: Check that iReset is really your reset signal
        iReset <= '1';
        wait for 100 ns;
        iReset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
        iEN <= '1';
        par_data <= "1001011";
        
        wait for TbPeriod;
        iEN <= '0';
        par_data <= "1001011";
        
        wait for 100 * TbPeriod;
        iEN <= '1';
        par_data <= "1111111";
        
        wait for TbPeriod;
        iEN <= '0';
        par_data <= "1111111";

        -- Stop the clock and hence terminate the simulation
        wait for 100 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_entrelaceur of tb_entrelaceur is
    for tb
    end for;
end cfg_tb_entrelaceur;