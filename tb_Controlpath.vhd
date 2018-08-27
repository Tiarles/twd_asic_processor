library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.AsicWavelet_pkg.all;

entity tb_ControlPath is
end tb_ControlPath;

architecture tb of tb_ControlPath is
    signal clk : std_logic := '0';
    signal rst : std_logic;
    
    signal s_uinst_DP_to_CP : Uinst_DP_to_CP;
    signal s_uinst_CP_to_DP : Uinst_CP_to_DP;
    
    signal en_MEM, wr_MEM, start, done : std_logic;
begin
    
    clk <= not clk after 5 ns;
    rst <= '0', '1' after 10 ns, '0' after 15 ns;
    
    start <= '0', '1' after 20 ns, '0' after 30 ns;
    
    s_uinst_DP_to_CP.I_sm_SIZE_ALFA <= '0';
    s_uinst_DP_to_CP.SIZE_ALFA_bt_SIZE_FILTER <= '0';
    
    CP : entity work.ControlPath
        port map(
            clk     => clk,
            rst     => rst,
            
            uinst_i => s_uinst_DP_to_CP,
            uinst_o => s_uinst_CP_to_DP,
            
            en_MEM  => en_MEM,
            wr_MEM  => wr_MEM,

            start_i => start,
            done_o  => done
        );
    
end tb;

