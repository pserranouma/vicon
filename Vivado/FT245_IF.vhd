----------------------------------------------------------------------------------
-- Módulo FT245_TX
----------------------------------------------------------------------------------
--------------------------------------------------------
-- 	INSTANCE TEMPLATE
--------------------------------------------------------

--  ft245if_inst : entity work.FT245_IF
--   port map (
--    clk  => ,   -- clk (100 MHz)
--    rst  => ,  -- reset
--    din => ,  -- data input
--    wr_en => ,  -- write enable
--    ready => ,  -- ready output signal
--    wr_tick : out STD_LOGIC;  -- write tick output
--    TXEn => ,  -- TXE input signal
--    WRn => ,  -- WR output signal
--    DATA => ,  -- data output
--   );

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FT245_IF is
    Port ( clk : in STD_LOGIC;  -- 100 MHz
           rst : in STD_LOGIC;
           -- user IO:
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           wr_en : in STD_LOGIC;
           ready : out STD_LOGIC;
           wr_tick : out STD_LOGIC;
           -- FT245-like interface:
           TXEn : in STD_LOGIC;
           WRn : out STD_LOGIC;
           DATA : out STD_LOGIC_VECTOR (7 downto 0));
end FT245_IF;

architecture Behavioral of FT245_IF is
-- estados:
    type STATES is (idle, wait_for_TXE, output_data, gen_tick, write_1, write_2, write_3);
    signal state_reg, state_next: STATES;
-- señales para las salidas:
    signal ready_reg, ready_next: STD_LOGIC;
    signal wr_tick_reg, wr_tick_next: STD_LOGIC;
    signal WRn_reg, WRn_next: STD_LOGIC;
    signal DATA_reg, DATA_next: STD_LOGIC_VECTOR (7 downto 0);
-- señal para el proceso sincronizador:
    signal synchronizer: STD_LOGIC_VECTOR (1 downto 0);
    signal TxEnSync: STD_LOGIC;  -- señal TxEn sincronizada

begin

    -- sincronizador:
    process begin
        wait until clk'EVENT and clk='1';
        synchronizer <= TxEn & synchronizer(1);
    end process;
    TxEnSync <= synchronizer(0);

    -- registro de estado:
    REG: process (clk,rst)
    begin
        if rst='1' then
            state_reg <= idle;  -- reset asíncrono
            ready_reg <= '1';
            WRn_reg <= '1';
            wr_tick_reg <= '0';
            DATA_reg <= (others => '0');
        elsif clk'EVENT and clk='1' then
            state_reg <= state_next;      -- cambio de estado
            ready_reg <= ready_next;
            wr_tick_reg <= wr_tick_next;
            WRn_reg <= WRn_next;
            DATA_reg <= DATA_next;
        end if;
    end process REG;
    -- conexión de las señales registradas con las salidas
    ready <= ready_reg;
    WRn <= WRn_reg;
    DATA <= DATA_reg;
    wr_tick <= wr_tick_reg;
    
    -- lógica de estado siguiente:
    COMB: process (state_reg,ready_reg,WRn_reg,DATA_reg,wr_en,TxEnSync,DIN,wr_tick_reg)
    begin
        state_next <= state_reg;
        ready_next <= ready_reg;
        wr_tick_next <= wr_tick_reg;
        WRn_next <= WRn_reg;
        DATA_next <= DATA_reg;
        case state_reg is
            when idle =>
                if wr_en='1' then
                    state_next <= wait_for_TXE;
                    ready_next <= '0';
                end if;
            when wait_for_TXE =>
                if TxEnSync='0' then
                    state_next <= output_data;
                    wr_tick_next <= '1';
                    DATA_next <= DIN;
                end if;
            when output_data =>
                state_next <= write_1;
                wr_tick_next <= '0';
                WRn_next <= '0';
            when write_1 =>
                state_next <= write_2;
            when write_2 =>
                state_next <= write_3;
            when others =>  -- write_3
                WRn_next <= '1';
                if wr_en='0' then
                    state_next <= idle;
                    ready_next <= '1';
                else
                    state_next <= wait_for_TXE;
                end if;
        end case;
    end process COMB;

end Behavioral;
