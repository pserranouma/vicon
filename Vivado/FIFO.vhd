----------------------------------------------------------------------------------
-- M�dulo FIFO
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
    Generic (
        B : NATURAL := 6;  -- ancho del bus de direcciones
        W : NATURAL := 8 -- anchura de los buses de datos
    );
    Port ( CLK : in STD_LOGIC;  -- reloj
           RST : in STD_LOGIC;  -- reset
           DIN : in STD_LOGIC_VECTOR(W-1 downto 0);  -- bus de datos de entrada
           PUSH : in STD_LOGIC;  -- introducir un datos
           FULL : out STD_LOGIC;  -- la FIFO est� llena
           DOUT : out STD_LOGIC_VECTOR(W-1 downto 0);  -- bus de datos de salida
           POP : in STD_LOGIC;  -- sacar un dato
           EMPTY : out STD_LOGIC);  -- la FIFO est� vac�a
end FIFO;

architecture Behavioral of FIFO is
-- definimos el array de memoria y la se�al de dicho tipo para modelarla:
    type ram_type is array (2**B-1 downto 0) of STD_LOGIC_VECTOR(W-1 downto 0);
    signal ram: ram_type;
-- se�ales de habilitaci�n de lectura y escritura:
    signal RD_EN, WR_EN: STD_LOGIC;
-- se�ales para modelar los punteros de lectura y escritura:
    signal RD_PTR, WR_PTR: UNSIGNED(B-1 downto 0);
-- se�ales internas para controlar el estado de la FIFO:
    signal SFULL, SEMPTY: STD_LOGIC;
-- se�al para llevar la cuenta del n�mero de palabras almacenadas:
    signal CONTADOR: NATURAL range 0 to 2**B;

begin
-- bloque RAM:
    process (clk)
    begin
        if rising_edge(clk) then  -- escritura s�ncrona:
            if WR_EN='1' then
                ram(to_integer(WR_PTR)) <= DIN;
            end if;
        end if;
    end process;
    -- lectura as�ncrona:
    DOUT <= ram(to_integer(RD_PTR));
-- bloque l�gica de control:
    process (clk)
    begin
        if rising_edge(clk) then
            if RST='1' then  -- inicializaci�n s�ncrona de los punteros:
                RD_PTR <= (others => '0');
                WR_PTR <= (others => '0');
            else
                if WR_EN='1' then  -- actualizaci�n del puntero de escritura:
                    WR_PTR <= WR_PTR+1;
                end if;
                if RD_EN='1' then -- actualizaci�n del puntero de lectura:
                    RD_PTR <= RD_PTR+1;
                end if;
            end if;
        end if;
    end process;
    WR_EN <= PUSH and not SFULL;
    RD_EN <= POP and not SEMPTY;
-- bloque l�gica de estado:
    process (clk)
    begin
        if rising_edge(clk) then
            if RST='1' then  -- inicializaci�n s�ncrona del contador:
                CONTADOR <= 0;
            else
                if WR_EN='1' and RD_EN='0' then
                    CONTADOR <= CONTADOR +1;
                end if;
                if RD_EN='1' and WR_EN='0' then
                    CONTADOR <= CONTADOR -1;
                end if;
            end if;
        end if;
    end process;
    SEMPTY <= '1' when CONTADOR=0 else '0';
    SFULL <= '1' when CONTADOR=2**B else '0';
    EMPTY <= SEMPTY;
    FULL <= SFULL;
end Behavioral;
