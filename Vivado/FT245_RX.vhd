----------------------------------------------------------------------------------
-- Módulo FT245_RX
----------------------------------------------------------------------------------
--------------------------------------------------------
-- 	INSTANCE TEMPLATE
--------------------------------------------------------

--  ft245if_inst : entity work.FT245_RX
--   port map (
--    clk  => ,   -- clk
--    rst  => ,  -- reset
--    DOUT => ,  -- data output
--    rd_en => ,  -- read enable
--    ready => ,  -- ready output signal
--    wr_tick : out STD_LOGIC;  -- read tick output
--    RxFn => ,  -- RXF input signal
--    RDn => ,  -- RD output signal
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

entity FT245_RX is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           -- user IO:
           DOUT : out STD_LOGIC_VECTOR (7 downto 0);
           rd_en : in STD_LOGIC;
           rd_tick : out STD_LOGIC;
           -- FT245-like interface:
           RxFn : in STD_LOGIC;
           RDn : out STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0));
end FT245_RX;

architecture Behavioral of FT245_RX is
-- estados:
    type STATES is (idle, wait_for_RXF, read_1, read_2, read_3, read_4, read_5);
    signal state_reg, state_next: STATES;
-- señales para las salidas:
    signal rd_tick_reg, rd_tick_next: STD_LOGIC;
    signal RDn_reg, RDn_next: STD_LOGIC;
    signal DOUT_reg, DOUT_next: STD_LOGIC_VECTOR (7 downto 0);
-- señal para el proceso sincronizador:
    signal synchronizer: STD_LOGIC_VECTOR (1 downto 0);
    signal RxFnSync: STD_LOGIC;  -- señal TxEn sincronizada

begin

    -- sincronizador:
    process begin
        wait until clk'EVENT and clk='1';
        synchronizer <= RxFn & synchronizer(1);
    end process;
    RxFnSync <= synchronizer(0);

    -- registro de estado:
    REG: process (clk,rst)
    begin
        if rst='1' then
            state_reg <= idle;  -- reset asíncrono
            rd_tick_reg <= '0';
            RDn_reg <= '1';
            DOUT_reg <= (others => '0');
        elsif clk'EVENT and clk='1' then
            state_reg <= state_next;      -- cambio de estado
            rd_tick_reg <= rd_tick_next;
            RDn_reg <= RDn_next;
            DOUT_reg <= DOUT_next;
        end if;
    end process REG;
    -- conexión de las señales registradas con las salidas
    rd_tick <= rd_tick_reg;
    RDn <= RDn_reg;
    DOUT <= DOUT_reg;
    
    -- lógica de estado siguiente:
    COMB: process (state_reg,RDn_reg,DOUT_reg,rd_en,RxFnSync,DATA,rd_tick_reg)
    begin
        state_next <= state_reg;
        rd_tick_next <= rd_tick_reg;
        RDn_next <= RDn_reg;
        DOUT_next <= DOUT_reg;
        case state_reg is
            when idle =>
                if rd_en='1' then  -- and RxFnSync='0'
                    state_next <= wait_for_RXF;
                end if;
            when wait_for_RXF =>
                if RxFnSync='0' then
                    state_next <= read_1;
                    RDn_next <= '0';
                end if;
            when read_1 =>
                state_next <= read_2;
            when read_2 =>
                state_next <= read_3;
            when read_3 =>
                state_next <= read_4;
                RDn_next <= '1';
                DOUT_next <= DATA;
                rd_tick_next <= '1';
            when others =>  -- read_4
                rd_tick_next <= '0';
                if rd_en='0' then
                    state_next <= idle;
                elsif RxFnSync='1' then
                    state_next <= wait_for_RXF;
                end if;
        end case;
    end process COMB;

end Behavioral;
