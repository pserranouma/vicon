----------------------------------------------------------------------------------
-- Módulo CONTROL
----------------------------------------------------------------------------------
--------------------------------------------------------
-- 	INSTANCE TEMPLATE
--------------------------------------------------------

--  mt9v111_inst : entity WORK.CONTROL
--port map (
--    CLK  => MCLK,   -- clk
--    RST  => RST,  -- reset
--    RX_EMPTY => RX_EMPTY,  -- señal de fifo de recepción vacía
--    TX_EMPTY => TX_EMPTY,  -- señal de fifo de transmisión vacía
--    RD => RD,  -- lectura de la FIFO
--    WR => WR,  -- escritura de la FIFO
--    R_DATA => R_DATA,  -- salida de datos FIFO
--    WRnRD => WRnRD,  -- señal de control del buffer para la e/s
--    startf => startf,  -- inicio frame
--    endf => endf,  -- fin frame
--    data_tick => data_tick,  -- lectura dato cámara
--    color => color,  -- selección de modo de imagen
--    LED => SLED,  -- depuración
--    resetc => resetc  -- señal de reset para la cámara
--);

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL is
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        RX_EMPTY : in STD_LOGIC;  -- señal de fifo de recepción vacía
        TX_EMPTY : in STD_LOGIC;  -- señal de fifo de transmisión vacía
        RD: out STD_LOGIC;  -- lectura de la FIFO
        WR: out STD_LOGIC;  -- escritura de la FIFO
        R_DATA: in STD_LOGIC_VECTOR (7 downto 0);  -- salida de datos FIFO
        WRnRD: out STD_LOGIC;  -- señal de control del buffer para la e/s
        startf : in STD_LOGIC;  -- señal de inicio de frame procedente de la cámara
        endf : in STD_LOGIC;  -- señal de fin de frame procedente de la cámara
        data_tick : in STD_LOGIC;
        color : out STD_LOGIC;
        LED: out STD_LOGIC_VECTOR(7 downto 0);  -- depuración
        resetc: out STD_LOGIC  -- reset cámara
        );
end CONTROL;

architecture Behavioral of CONTROL is
-- estados:
    type STATES is (wait_for_request, read_request, process_request, ready_to_send, send_data, wait_for_finish_tx);
    signal state_reg, state_next: STATES;
-- señales para las salidas de la máquina de estados:
    signal RD_reg, RD_next: STD_LOGIC;
    signal WR_reg, WR_next: STD_LOGIC;
    signal WRnRD_reg, WRnRD_next: STD_LOGIC;
    signal REC_DATA, REC_DATA_reg, REC_DATA_NEXT: STD_LOGIC_VECTOR (7 downto 0);
    signal color_reg, color_next: STD_LOGIC;
    
begin

    -- registro de estado:
    REG: process (CLK,RST)
    begin
        if RST='1' then
            state_reg <= wait_for_request;  -- reset asíncrono
            RD_reg <= '0';
            WR_reg <= '0';
            WRnRD_reg <= '1';
            REC_DATA_reg <= (others => '0');
            resetc <= '0';
            color_reg <= '0';
        elsif CLK'EVENT and CLK='1' then
            state_reg <= state_next;      -- cambio de estado
            RD_reg <= RD_next;
            WR_reg <= WR_next;
            WRnRD_reg <= WRnRD_next;
            REC_DATA_reg <= REC_DATA_next;
            resetc <= '1';
            color_reg <= color_next;
        end if;
    end process REG;
    -- conexión de las señales registradas con las salidas
    RD <= RD_reg;
    WR <= WR_reg;
    WRnRD <= WRnRD_reg;
    REC_DATA <= REC_DATA_reg;
    color <= color_reg;
    
    -- lógica de estado siguiente:
    COMB: process (state_reg,RD_reg,WR_reg,WRnRD_reg,REC_DATA_reg,RX_EMPTY,TX_EMPTY,R_DATA,startf,endf,data_tick,color_reg)
    begin
        state_next <= state_reg;
        RD_next <= RD_reg;
        WR_next <= WR_reg;
        WRnRD_next <= WRnRD_reg;
        REC_DATA_next <= REC_DATA_reg;
        color_next <= color_reg;
        case state_reg is
            when wait_for_request =>
                if RX_EMPTY='0' then
                    RD_next <= '1';  -- pop FIFO_RX
                    state_next <= read_request;
                end if;
            when read_request =>  -- leemos comando (1 byte)
                REC_DATA_next <= R_DATA;
                RD_next <= '0';
                state_next <= process_request;
            when process_request =>
                if REC_DATA_reg="00000001" then
                    color_next <= '0';
                    WR_next <= '0';
                    state_next <= ready_to_send;
                elsif REC_DATA_reg="00000010" then
                    color_next <= '1';
                    WR_next <= '0';
                    state_next <= ready_to_send;
                else
                    state_next <= wait_for_request;
                end if;
            when ready_to_send =>
                if startf='1' then
                    WRnRD_next <= '0';
                    state_next <= send_data;
                end if;
            when send_data =>
                if endf='1' then
                    WR_next <= '0';
                    state_next <= wait_for_finish_tx;
                else
                    if data_tick='1' then
                        WR_next <= '1';  -- push FIFO_TX
                    else WR_next <= '0';
                    end if;
                end if;
            when others =>  -- wait_for_finish_tx
                if TX_EMPTY='1' then
                    WRnRD_next <= '1';
                    state_next <= wait_for_request;
                end if;
        end case;
    end process COMB;


-- salidas para depuración:
LED(7 downto 4) <= std_logic_vector(REC_DATA(3 downto 0));
LED(0) <= '1' when state_reg=wait_for_request else '0';
LED(1) <= '1' when state_reg=read_request else '0';
LED(2) <= '1' when state_reg=ready_to_send else '0';
LED(3) <= '1' when state_reg=wait_for_finish_tx else '0';

end Behavioral;
