-- Testbench automatically generated online
-- at https://vhdl.lapinoo.net
-- Generation date : 18.10.2021 16:20:02 UTC

library ieee;
use ieee.std_logic_1164.all;

entity tb_hamenc is
end tb_hamenc;

architecture tb of tb_hamenc is

    component hamenc
        port (rst    : in std_logic;
              clk    : in std_logic;
              i_data : in std_logic_vector (3 downto 0);
              i_dv   : in std_logic;
              o_data : out std_logic_vector (7 downto 0);
              o_dv   : out std_logic);
    end component;

    signal rst    : std_logic;
    signal clk    : std_logic;
    signal i_data : std_logic_vector (3 downto 0);
    signal i_dv   : std_logic;
    signal o_data : std_logic_vector (7 downto 0);
    signal o_dv   : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : hamenc
    port map (rst    => rst,
              clk    => clk,
              i_data => i_data,
              i_dv   => i_dv,
              o_data => o_data,
              o_dv   => o_dv);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        i_data <= (others => '0');
        i_dv <= '0';

        -- Reset generation
        -- EDIT: Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;
        i_data <= "1010";
        i_dv   <= '1';
        wait for 100 * TbPeriod;
        i_data <= "0100";
        i_dv   <= '0';
        wait for 100 * TbPeriod;
        i_dv   <= '1';
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_hamenc of tb_hamenc is
    for tb
    end for;
end cfg_tb_hamenc;

