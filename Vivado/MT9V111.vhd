----------------------------------------------------------------------------------
-- Módulo MT9V111
----------------------------------------------------------------------------------
--------------------------------------------------------
-- 	INSTANCE TEMPLATE
--------------------------------------------------------

--  mt9v111_inst : entity WORK.MT9V111
--port map (
--    CLK  => CLK,   -- clk
--    RST  => RST,  -- reset
--    HREF => HREF,  -- sincronismo de línea de la cámara
--    VSYNC => VSYNC,  -- sincronismo de frame de la cámara
--    PCLK => PCLK,  -- salida de reloj de la cámara
--    startf => startf,  -- inicio frame
--    endf => endf,  -- fin frame
--    data_tick => data_tick,  -- lectura dato cámara
--    color => color  -- modo de imagen
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

entity MT9V111 is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        HREF : in STD_LOGIC;  -- sincronismo de línea de la cámara
        VSYNC : in STD_LOGIC;  -- sincronismo de frame de la cámara
        PCLK : in STD_LOGIC;  -- Reloj de píxel de la cámara
        startf : out STD_LOGIC;  -- comienzo de frame (flanco de subida de VSYNC)
        endf : out STD_LOGIC;  -- final de frame (flanco de bajada de VSYNC)
        data_tick : out STD_LOGIC;  -- señal para lectura dato cámara
        color : in STD_LOGIC);  -- modo de imagen
end MT9V111;

architecture Behavioral of MT9V111 is
    signal startfs : STD_LOGIC;  -- señal interna = startf
    signal pos : STD_LOGIC;
    signal tick, tick_down: STD_LOGIC;
    
begin

PCLK_Edge_Detect: entity work.edge_detect
port map (
    c => clk,
    level => PCLK,
    tick => tick,  -- el dato estará estable en el flanco de subida
    tick_down => tick_down  -- sale el dato en el flanco de bajada
);

VSYNC_Edge_Detect: entity work.edge_detect
port map (
    c => clk,
    level => VSYNC,
    tick => startfs,  -- comienzo de frame (flanco de subida de VSYNC)
    tick_down => endf  -- final de frame (flanco de bajada de VSYNC)
);

process
begin
    wait until clk'EVENT and clk='1';
    if rst = '1' or startfs = '1' then
        data_tick <= '0';
        pos <= '0';
    elsif tick = '1' and HREF = '1' then
        if color='0' then
            if pos = '0' then
                pos <= '1';
                data_tick <= '1';
            else
                pos <= '0';
                data_tick <= '0';
            end if;
        else
            data_tick <= '1';
        end if;
    else
        data_tick <= '0';
    end if;
end process;

startf <= startfs;

end Behavioral;
