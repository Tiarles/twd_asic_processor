library IEEE;

use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use work.AsicWavelet_pkg.all;

entity AsicWavelets is
    port(
        clk : in std_logic; 
        rst : in std_logic;
		
        wr_o : out std_logic; -- TO RAM
        en_o : out std_logic; -- TO RAM

        address_o  : out std_logic_vector(4 downto 0);
        data_i     : in  std_logic_vector(7 downto 0);
        data_o     : out std_logic_vector(7 downto 0);

        start_i : in std_logic;
        done_o  : out std_logic		
    );
end AsicWavelets;

architecture behavioral of AsicWavelets is
    signal s_address :          std_logic_vector(4 downto 0);   
    signal s_data_i, s_data_o : std_logic_vector(7 downto 0);
    signal s_uinst_CP_to_DP :   Uinst_CP_to_DP;
    signal s_uinst_DP_to_CP :   Uinst_DP_to_CP;
    signal start, done :        std_logic;
begin
    
    DATAPATH: entity work.DataPath
        port map(
            clk => clk,
            rst => rst,

            address_o => s_address,
            data_i    => s_data_i,
            data_o    => s_data_o,

            uinst_i   => s_uinst_CP_to_DP,
            uinst_o   => s_uinst_DP_to_CP
        );

    CONTROLPATH: entity work.ControlPath
        port map(
            clk => clk,
            rst => rst,
            
            uinst_i => s_uinst_DP_to_CP,
            uinst_o => s_uinst_CP_to_DP,
            
            en_MEM  => en_o,
            wr_MEM  => wr_o,

            start_i => start,
            done_o  => done
        );
end behavioral;

