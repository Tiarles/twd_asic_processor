library IEEE;

use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use work.AsicWavelet_pkg.all;

entity DataPath is
    port(
        clk, rst : in std_logic; 

        address_o  : out std_logic_vector(4 downto 0);
        data_i     : in  std_logic_vector(7 downto 0);
        data_o     : out std_logic_vector(7 downto 0);

        uinst_i : in Uinst_CP_to_DP;
        uinst_o : out Uinst_DP_to_CP
    );
end DataPath;

architecture behavioral of DataPath is    
    signal s_dI, s_I :                      std_logic_vector(7 downto 0); 
    signal s_AUX :                          std_logic_vector(7 downto 0);
    signal s_dSIZE_ALFA, s_SIZE_ALFA :      std_logic_vector(7 downto 0); 
	signal s_dSIZE_TMP, s_SIZE_TMP :        std_logic_vector(7 downto 0);
	signal s_dSIZE_BETA, s_SIZE_BETA :      std_logic_vector(7 downto 0); 
	signal s_MULT0, s_dMULT0 :              std_logic_vector(7 downto 0); 
	signal s_dMULT1, s_MULT1 : 		        std_logic_vector(7 downto 0); 
	signal s_soma : 				        std_logic_vector(7 downto 0);
    signal s_H1 :   				        std_logic_vector(7 downto 0);

    signal s_rst_I, s_rst_SIZE_TMP, s_rst_SIZE_BETA: std_logic;

--	--uinstructions_i
--	signal muxI, en_I, rst_I : 	  		    std_logic;
--	signal en_SIZE_ALFA, mx_SIZE_ALFA :     std_logic;
--	signal en_SIZE_TMP, rst_SIZE_TMP :      std_logic;
--	signal en_AUX, en_SIZE_BETA :           std_logic;
--	signal rst_SIZE_BETA, en_MULT0 :        std_logic;
--	signal mx_MULT0, en_MULT1, mx_data_o :  std_logic;
--	signal mx_address_o :                   std_logic_vector(4 downto 0);
--	-- end of uinstructions_i
	
	-- uinstructions_o
    signal s_uinst_o : Uinst_DP_to_CP;
	-- end of uinstructions_o
    
	-- CONSTANTS
	
	--  Tiarles: - Essas constant sï¿½ irï¿½o funcionar se o 8 = 8 e o 
    --	ADDR_WIDTH = 5
    
	constant H1_0 : 		std_logic_vector(7 downto 0) := x"FE";
    constant H1_1 : 		std_logic_vector(7 downto 0) := x"02";
	constant H0 : 			std_logic_vector(7 downto 0) := x"02";
	constant DATA : 		std_logic_vector(7 downto 0) := x"00";
	constant ALFA : 		std_logic_vector(7 downto 0) := x"08";
	constant BETA : 	    std_logic_vector(7 downto 0) := x"10";
	constant TMP : 		    std_logic_vector(7 downto 0) := x"18";
	constant SIZE_FILTER :  std_logic_vector(7 downto 0) := x"02";
	constant LAST_POS_MEM : std_logic_vector(4 downto 0) := "11111";
	-- END OF CONSTANTS
	
begin
    
    -- Register's
    
    s_dI <= s_I + 1 when uinst_i.mx_I = '0' else -- 
			s_I + 2;
    
    s_rst_I <= rst or uinst_i.rst_I;

    I: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map (
		clk => clk,
		rst	=> s_rst_I,
		ce  => uinst_i.en_I,
		d   => s_dI,
		q   => s_I
	);
	
	s_dSIZE_ALFA <= data_i when uinst_i.mx_SIZE_ALFA = '0' else -- 
				    s_SIZE_TMP;

    SIZE_ALFA: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map(
		clk => clk,
		rst	=> rst,
		ce  => uinst_i.en_SIZE_ALFA,
		d   => s_dSIZE_ALFA,
		q   => s_SIZE_ALFA
	);
	
	s_dSIZE_TMP <= s_SIZE_TMP + 1; --
	s_rst_SIZE_TMP <= uinst_i.rst_SIZE_TMP or rst;


	SIZE_TMP: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map(
		clk => clk,
		rst => s_rst_SIZE_TMP,
		ce	=> uinst_i.en_SIZE_TMP,
		d	=> s_dSIZE_TMP,
		q 	=> s_SIZE_TMP
	);
	
	AUX: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map(
		clk => clk,
		rst	=> rst,
		ce  => uinst_i.en_AUX,
		d   => data_i,
		q   => s_AUX
	);
	
	s_dSIZE_BETA <= s_SIZE_BETA + s_SIZE_TMP;
	s_rst_SIZE_BETA <= uinst_i.rst_SIZE_BETA or rst;

	SIZE_BETA: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map(
		clk => clk,
		rst	=> s_rst_SIZE_BETA,
		ce  => uinst_i.en_SIZE_BETA,
		d   => s_dSIZE_BETA,
		q   => s_SIZE_BETA
	);
	
	s_H1 <= H1_0 when uinst_i.mx_MULT0 = '0' else
		    H1_1;
				
	s_dMULT0 <= std_logic_vector(unsigned(data_i) / unsigned(s_H1));
	
	MULT0: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map(
		clk => clk,
		rst	=> rst,
		ce  => uinst_i.en_MULT0,
		d   => s_dMULT0,
		q   => s_MULT0
	);
	
	s_dMULT1 <= std_logic_vector(unsigned(data_i) / unsigned(H0));
	
	MULT1: entity work.RegisterNbits
	generic map (
		WIDTH => 8
	)
	port map(
		clk => clk,
		rst	=> rst,
		ce  => uinst_i.en_MULT1,
		d   => s_dMULT1,
		q   => s_MULT1
	);
	
	s_soma <= s_MULT0 + s_MULT1;
 
    -- End of Register's	
    
    -- Out's
    address_o <=    LAST_POS_MEM                    when uinst_i.mx_address_o = "000" else
                    DATA + s_I                      when uinst_i.mx_address_o = "001" else 
				    ALFA + s_I		                when uinst_i.mx_address_o = "010" else
				    std_logic_vector(unsigned(s_I + 1) mod unsigned(s_SIZE_ALFA)) + ALFA
                                                    when uinst_i.mx_address_o = "011" else
				    TMP + s_SIZE_TMP 				when uinst_i.mx_address_o = "100" else
				    TMP + s_I                       when uinst_i.mx_address_o = "101" else
				    (BETA + s_SIZE_BETA) + s_I;       --when mx_address_o = "110"
				   
    data_o <= s_AUX when uinst_i.mx_data_o = '0' else
			  s_soma;
            
    -- End of Out's    
	
	-- uinstructions_o
	
	s_uinst_o.I_sm_SIZE_ALFA              <= '1' when (s_I < s_SIZE_ALFA)         else '0';
    s_uinst_o.SIZE_ALFA_bt_SIZE_FILTER    <= '1' when (s_SIZE_ALFA > SIZE_FILTER) else '0';
    s_uinst_o.I_sm_SIZE_TMP               <= '1' when (s_I < s_SIZE_TMP)          else '0';
    
    uinst_o <= s_uinst_o;	

	-- end of uinstructions_o

end behavioral;
