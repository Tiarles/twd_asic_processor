library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.AsicWavelet_pkg.all;

entity tb_DataPath is
end tb_DataPath;

architecture tb of tb_DataPath is
    signal clk : std_logic := '0';
    signal rst : std_logic;
    
    signal s_uinst_o : Uinst_DP_to_CP;
    signal s_uinst_i : Uinst_CP_to_DP;

    signal s_data_i : std_logic_vector(7 downto 0);
    signal s_data_o : std_logic_vector(7 downto 0);
    signal s_address_o : std_logic_vector(4 downto 0);

    signal en_MEM, wr_MEM, start, done : std_logic;
begin
    
    clk <= not clk after 5 ns;
    rst <= '1', '0' after 10 ns;
    
    s_uinst_i.en_I <= '1';
    s_uinst_i.mx_I <= '0', '1' after 30 ns;
    
    DP : entity work.DataPath        
        port map(
            clk => clk,
            rst => rst,

            address_o  => s_address_o,
            data_i     => s_data_i,
            data_o     => s_data_o,

            uinst_i => s_uinst_i,
            uinst_o => s_uinst_o
        );

    
end tb;

