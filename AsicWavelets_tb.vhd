library IEEE;

use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AsicWavelets_tb is
end AsicWavelets_tb;

architecture behavioral of AsicWavelets_tb is
    signal clk : std_logic := '0';
    signal rst_n : std_logic;
    
    signal start, done : std_logic;

    signal s_rst, s_wr, s_en   : std_logic;
    signal s_address           : std_logic_vector(4 downto 0);
    signal s_data_asic_to_ram  : std_logic_vector(7 downto 0);
    signal s_data_ram_to_asic  : std_logic_vector(7 downto 0);
    
    constant clk_half_period : time := 5 ns; -- 100 MHz (p = 10ns)
begin	
	
    rst_n <= '1', '0' after 0.5*clk_half_period, '1' after clk_half_period;

    clk <= not clk after clk_half_period; -- 100 MHz
    s_rst <= not rst_n;
    
    start <= '0', '1' after 4*clk_half_period, '0' after 6*clk_half_period; 

    ASIC: entity work.AsicWavelets
        port map(
            clk  => clk, 
            rst => s_rst, 
		
            wr_o => s_wr,
            en_o => s_en,

            address_o => s_address,
            data_i    => s_data_ram_to_asic,
            data_o    => s_data_asic_to_ram,

            start_i => start,
            done_o  => done
        );
    
    RAM: entity work.Memory
        generic map (
            ADDR_WIDTH   => 5,
            DATA_WIDTH   => 8,
            IMAGE => "memoryContent.txt"
        )
        port map (
            clk          => clk,
            
            wr           => s_wr,                    -- in
            en           => s_en,                    -- in
            
            address      => s_address,               -- in
            data_in      => s_data_asic_to_ram,      -- in
            data_out     => s_data_ram_to_asic       -- out
        );
        
    process
    begin
        wait until done = '1';
    end process;

end behavioral;

