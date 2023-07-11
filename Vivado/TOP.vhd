----------------------------------------------------------------------------------
-- FT245
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity TOP is
-- configuramos el reloj como entrada:
    Port ( CLK: in STD_LOGIC;
           RST: in STD_LOGIC;-- reset
           DATA_IO: inout STD_LOGIC_VECTOR (7 downto 0);-- Línea de transmisión/recepción de datos FT245
           TXEn: in STD_LOGIC;  -- transmisión FT245
           RXFn: in STD_LOGIC;  -- recepción FT245
           RDn: out STD_LOGIC;  -- salida FT245
           WRn: out STD_LOGIC;  -- salida FT245
           PWRSAVn: out STD_LOGIC;
           SIWUn: out STD_LOGIC;
           resetc: out STD_LOGIC;
           DATA_CAM: in STD_LOGIC_VECTOR (7 downto 0);  -- datos de la cámara
           HREF : in STD_LOGIC;  -- sincronismo de línea de la cámara
           VSYNC : in STD_LOGIC;  -- sincronismo de frame de la cámara
           XCLK : out STD_LOGIC;  -- reloj para la cámara
           PCLK : in STD_LOGIC;  -- reloj de píxel de la cámara
           LED : out STD_LOGIC_VECTOR (15 downto 0);  -- configuramos los leds como puertos de salida (para depuración)
           CAT : out STD_LOGIC_VECTOR (7 downto 0);  -- configuramos los cátodos como puertos de salida
           AN : out STD_LOGIC_VECTOR (3 downto 0));  -- configuramos los ánodos como puertos de salida
end TOP;

architecture Behavioral of TOP is
-- señal para los segmentos:
    alias SSEG: STD_LOGIC_VECTOR(6 downto 0) is CAT(6 downto 0);
-- definimos las señales internas que vamos a utilizar para interconectar las diferentes partes:
    signal R_DATA: STD_LOGIC_VECTOR (7 downto 0);  -- entrada de datos FIFO
    signal W_DATA: STD_LOGIC_VECTOR (7 downto 0);  -- entrada de datos FIFO
    signal RD: STD_LOGIC;  -- lectura de la FIFO
    signal RX_EMPTY: STD_LOGIC;  -- FIFO de recepción vacía
    signal WR: STD_LOGIC;  -- escritura de la FIFO
    signal TX_FULL: STD_LOGIC;  -- FIFO de transmisión llena
    signal WRnRD: STD_LOGIC;  -- señal de control del buffer para la e/s
    signal DATA_RX, DATA_TX: STD_LOGIC_VECTOR (7 downto 0);
    signal DATA_O: STD_LOGIC_VECTOR (7 downto 0);  -- para modelar los datos de salida de la e/s
    signal wr_ready: STD_LOGIC;  -- señales internas generadas por el receptor y el transmisor
    signal rd_tick, wr_tick: STD_LOGIC;  -- señales internas generadas por el receptor y el transmisor
    signal TX_EMPTY, RX_FULL: STD_LOGIC;  -- salidas de las FIFOS (no usadas)
    signal wr_en, rd_en: STD_LOGIC;
    signal SLED: STD_LOGIC_VECTOR (7 downto 0);  -- señal para depuración
-- señales para el MMCM:
    signal MCLK: STD_LOGIC;
    signal reset_in: STD_LOGIC;
    signal locked: STD_LOGIC;
-- señales para la cámara:
    signal startf, endf: STD_LOGIC;
    signal data_tick: STD_LOGIC;
    signal sXCLK, sXCLK2: STD_LOGIC;
    signal color: STD_LOGIC;

begin


miMMCM: entity WORK.clk_wiz_0
port map (
    clk_in1 => CLK,
    reset => reset_in,
    clk_out1 => MCLK,
    clk_out2 => sXCLK,
    clk_out3 => sXCLK2,
    locked => locked
);

BUFGMUX_inst : BUFGMUX_1
port map (
   O => XCLK,   -- 1-bit output: Clock output
   I0 => sXCLK, -- 1-bit input: Clock input (S=0)
   I1 => sXCLK2, -- 1-bit input: Clock input (S=1)
   S => color    -- 1-bit input: Clock select
);

-- receptor FT245:
FT245_RX: entity WORK.FT245_RX
port map (
    clk  => MCLK,   -- clk
    rst  => RST,  -- reset
    dout => DATA_RX,  -- data output -> salida de datos, que se conecta con la FIFO de recepción
    rd_en => rd_en,  -- read enable ->  se activará cuando la FIFO pueda recibir (not FULL)
    rd_tick => rd_tick,  -- read tick signal -> señal interna
    RXFn => RXFn,  -- RXF input signal -> entrada del sistema
    RDn => RDn,  -- RD output signal -> salida del sistema
    DATA => DATA_IO  -- data input -> e/s del sistema
);

-- transmisor FT245:
FT245_TX: entity WORK.FT245_IF
port map (
    clk  => MCLK,   -- clk
    rst  => RST,  -- reset
    din => DATA_TX,  -- data input -> entrada de datos desde la FIFO de transmisión
    wr_en => wr_en,  -- write enable ->  se activará cuando la FIFO tenga algo (not EMPTY)
    ready => wr_ready,  -- ready output signal -> señal interna
    wr_tick => wr_tick,  -- write tick signal -> señal interna
    TXEn => TXEn,  -- TXE input signal -> entrada del sistema
    WRn => WRn,  -- WR output signal -> salida del sistema
    DATA => DATA_O  -- data output -> e/s del sistema
);

-- FIFO de recepción:
FIFO_RX: entity WORK.FIFO
port map (
    CLK  => MCLK,   -- clk
    RST  => RST,  -- reset
    DIN => DATA_RX,  -- data input -> señal interna de entrada de datos desde el FT245
    PUSH => rd_tick,  -- push data -> señal interna desde el FT245
    FULL => RX_FULL,  -- fifo full -> señal interna hacia el FT245
    DOUT => R_DATA,  -- data output -> salida del sistema
    POP => RD,  -- pop data -> entrada del sistema
    EMPTY => RX_EMPTY  -- empty fifo -> salida del sistema
);

-- FIFO de transmisión:
FIFO_TX: entity WORK.FIFO
generic map (
    B => 17,
    W => 8
)
port map (
    CLK  => MCLK,   -- clk
    RST  => RST,  -- reset
    DIN => W_DATA,  -- data input -> entrada al sistema
    PUSH => WR,  -- push data -> entrada al sistema
    FULL => TX_FULL,  -- fifo full -> salida del sistema
    DOUT => DATA_TX,  -- data output -> señal interna de salida de datos a la FT245
    POP => wr_tick,  -- pop data -> señal interna desde el FT245 
    EMPTY => TX_EMPTY  -- empty fifo -> señal interna hacia el FT245
);

-- Controlador cámara:
CAM: entity WORK.MT9V111
port map (
    CLK  => MCLK,   -- clk
    RST  => RST,  -- reset
    HREF => HREF,  -- sincronismo de línea de la cámara
    VSYNC => VSYNC,  -- sincronismo de frame de la cámara
    PCLK => PCLK,  -- salida de reloj de la cámara
    startf => startf,  -- inicio frame
    endf => endf,  -- fin frame
    data_tick => data_tick,  -- señal para lectura dato cámara
    color => color  -- modo de imagen
);

-- Controlador principal:
CONTROL: entity WORK.CONTROL
port map (
    CLK  => MCLK,   -- clk
    RST  => RST,  -- reset
    RX_EMPTY => RX_EMPTY,  -- señal de fifo de recepción vacía
    TX_EMPTY => TX_EMPTY,  -- señal de fifo de transmisión vacía
    RD => RD,  -- lectura de la FIFO
    WR => WR,  -- escritura de la FIFO
    R_DATA => R_DATA,  -- salida de datos FIFO
    WRnRD => WRnRD,  -- señal de control del buffer para la e/s
    startf => startf,  -- inicio frame
    endf => endf,  -- fin frame
    data_tick => data_tick,  -- lectura dato cámara
    color => color,  -- selección de modo de imagen
    LED => SLED,  -- depuración
    resetc => resetc  -- señal de reset para la cámara
);


DATA_IO <= DATA_O when WRnRD='0' else "ZZZZZZZZ";  -- señal externa de control del buffer para la e/s

W_DATA <= DATA_CAM;

wr_en <= not TX_EMPTY;
rd_en <= WRnRD;

-- salidas para depuración:
LED(7 downto 0) <= SLED;
LED(8) <= RXFn;
LED(9) <= TXEn;
LED(10) <= '0';
LED(11) <= '0';
LED(12) <= VSYNC;
LED(13) <= HREF;
LED(14) <= PCLK;
LED(15) <= '0';
--LED(15 downto 8) <= (others => '0');

AN <= (others => '1');
CAT <= (others => '1');

reset_in <= RST;

-- necesario para que funcione el conversor USB adecuadamente:
PWRSAVn <= '1';
SIWUn <= '1';

end Behavioral;
