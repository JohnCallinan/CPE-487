library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RNG_Table is
  Port (
    clk : in std_logic;
    x_table_value : out std_logic_vector (6 downto 0); --0 to 78
    y_table_value : out std_logic_vector (7 downto 0) -- 79 to 137
   );
end RNG_Table;

architecture Behavioral of RNG_Table is


type table is array (0 to 137) of integer;
constant thing : table := (0 => 47,  1 => 28,  2 => 10,  3 => 45,  4 => 23,
    5 => 26,  6 => 41,  7 => 8,   8 => 35,  9 => 1,
    10 => 39, 11 => 72, 12 => 16, 13 => 60, 14 => 77,
    15 => 32, 16 => 14, 17 => 65, 18 => 43, 19 => 49,
    20 => 2,  21 => 29, 22 => 18, 23 => 12, 24 => 4,
    25 => 63, 26 => 20, 27 => 75, 28 => 53, 29 => 19,
    30 => 34, 31 => 36, 32 => 58, 33 => 31, 34 => 42,
    35 => 78, 36 => 25, 37 => 76, 38 => 37, 39 => 73,
    40 => 24, 41 => 9,  42 => 15, 43 => 17, 44 => 64,
    45 => 13, 46 => 44, 47 => 27, 48 => 67, 49 => 22,
    50 => 5,  51 => 7,  52 => 59, 53 => 71, 54 => 70,
    55 => 33, 56 => 68, 57 => 48, 58 => 21, 59 => 62,
    60 => 66, 61 => 61, 62 => 40, 63 => 3,  64 => 38,
    65 => 50, 66 => 30, 67 => 6,  68 => 57, 69 => 56,
    70 => 11, 71 => 55, 72 => 46, 73 => 69, 74 => 74,
    75 => 51, 76 => 52, 77 => 79, 78 => 54, 79 => 2,   
    80 => 38,  81 => 6,   82 => 20,  83 => 32,
    84 => 12,  85 => 9,   86 => 50,  87 => 30,  88 => 1,
    89 => 17,  90 => 22,  91 => 28,  92 => 47,  93 => 19,
    94 => 31,  95 => 57,  96 => 27,  97 => 36,  98 => 14,
    99 => 16, 100 => 35, 101 => 44, 102 => 8,  103 => 26,
   104 => 54, 105 => 5,  106 => 33, 107 => 59, 108 => 13,
   109 => 41, 110 => 15, 111 => 46, 112 => 49, 113 => 39,
   114 => 3,  115 => 45, 116 => 21, 117 => 48, 118 => 55,
   119 => 10, 120 => 7,  121 => 11, 122 => 56, 123 => 23,
   124 => 40, 125 => 24, 126 => 37, 127 => 4,  128 => 58,
   129 => 18, 130 => 25, 131 => 43, 132 => 34, 133 => 52,
   134 => 29, 135 => 51, 136 => 42, 137 => 53 

);

signal x_i : integer range 0 to 78 := 0;
signal y_i : integer range 0 to 137 := 78;
signal x_val : integer range 0 to 255;
signal y_val : integer range 0 to 255;

begin

process(clk)
    begin
    if rising_edge(clk) then

        if (x_i = 78) then
            x_i <= 0;
        else
            x_i <= x_i + 1;
        end if;
    
        if (y_i = 137) then
            y_i <= 78;
        else
            y_i <= y_i + 1;
        end if;
    
    x_val <= thing(x_i);
    y_val <= thing(y_i);
    end if;
    
end process;

x_table_value <= std_logic_vector(to_unsigned(x_val, 7));
y_table_value <= std_logic_vector(to_unsigned(y_val, 8));

end Behavioral;

