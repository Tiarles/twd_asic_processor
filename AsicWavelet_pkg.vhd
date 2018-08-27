library ieee;

use ieee.std_logic_1164.all;

package AsicWavelet_pkg is
    
    type State is (
        S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, 
        S10, S11, S12, S13, S14, S15, S16, S17, S18, DONE
    );
    
    type Uinst_CP_to_DP is record
        mx_I  : std_logic;
        en_I  : std_logic;
        rst_I : std_logic;
        
        en_SIZE_ALFA : std_logic;
        mx_SIZE_ALFA : std_logic;
        
        en_SIZE_TMP : std_logic;
        rst_SIZE_TMP : std_logic;

        en_AUX : std_logic;
        
        en_SIZE_BETA : std_logic;
        rst_SIZE_BETA : std_logic;

        en_MULT0 : std_logic;
        mx_MULT0 : std_logic;
        
        en_MULT1 : std_logic;
        
        mx_data_o : std_logic;
        
        mx_address_o: std_logic_vector(2 downto 0);
    end record uinst_CP_to_DP; 

    type Uinst_DP_to_CP is record
        I_sm_SIZE_ALFA : std_logic;
        SIZE_ALFA_bt_SIZE_FILTER : std_logic;   
        I_sm_SIZE_TMP : std_logic;
    end record uinst_DP_to_CP;
    
end AsicWavelet_pkg;
