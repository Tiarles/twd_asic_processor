library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.AsicWavelet_pkg.all;

entity ControlPath is
    port(
        clk, rst : in std_logic;
        
        uinst_i : in Uinst_DP_to_CP;
        uinst_o : out Uinst_CP_to_DP;
        
        en_MEM : out std_logic;
        wr_MEM : out std_logic;

        start_i : in std_logic;
        done_o  : out std_logic
    );
end ControlPath;

architecture behav of ControlPath is
    signal currentState : State;    -- In AsicWavelet_pkg
begin
    
    process(clk)
    begin
        if rst = '1' then
            currentState <= S0;
        elsif rising_edge(clk) then
            case currentState is
                when S0 =>
                    if start_i = '1' then
                        currentState <= S1;
                    else
                        currentState <= S0;
                    end if;

                when S1 =>
                    currentState <= S2;
                    
                when S2 =>
                    if uinst_i.I_sm_SIZE_ALFA = '1' then
                        currentState <= S1;
                    elsif uinst_i.SIZE_ALFA_bt_SIZE_FILTER = '1' then
                        -- currentState <= S3
                        currentState <= DONE; -- teste dos primeiros estados
                    else
                        currentState <= DONE;
                    end if;
                when others => -- DONE
                        currentState <= S0;
            end case;
        end if;
    end process;
    
    uinst_o.mx_I  <= '0';
    uinst_o.en_I  <= '1' when currentState = S2 else '0';
    uinst_o.rst_I <= '1' when currentState = S0 else '0';
        
    uinst_o.en_SIZE_ALFA <= '1' when currentState = S0 else '0';
    uinst_o.mx_SIZE_ALFA <= '0';
        
    uinst_o.en_AUX <= '1' when currentState = S1 else '0';
        
    uinst_o.en_SIZE_BETA  <= '1' when currentState = S0 else '0';
    uinst_o.rst_SIZE_BETA <= '1' when currentState = S0 else '0';
    
    uinst_o.en_MULT0     <= '0';
    uinst_o.mx_MULT0     <= '0';
         
    uinst_o.en_MULT1     <= '0';
        
    uinst_o.mx_data_o    <= '0';
        
    uinst_o.mx_address_o <= "000" when currentState = S0 else
                            "001" when currentState = S1 else
                            "010";
    
    en_MEM <= '1' when currentState = S0 or currentState = S0 or
                       currentState = S2                      else
              '0';
    wr_MEM <= '1' when currentState = S2 else '0';
    
    done_o <= '1' when currentState = DONE else '0';
    
end behav;

