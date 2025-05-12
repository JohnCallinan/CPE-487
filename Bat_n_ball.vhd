LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


ENTITY bat_n_ball IS
    PORT (
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        bat_x : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
        bat_y : IN STD_LOGIC_VECTOR (10 DOWNTO 0); 
        serve : IN STD_LOGIC; 
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        RNG_x : in std_logic_vector (6 downto 0);
        RNG_y : in std_logic_vector (7 downto 0);
        count1: out std_logic_vector (15 downto 0);
        crash: out std_logic;
        reset: in std_logic := '1'
    );
END bat_n_ball;

ARCHITECTURE Behavioral OF bat_n_ball IS
    CONSTANT bsize : INTEGER := 10; 
    CONSTANT bat_w : INTEGER := 10; 
    CONSTANT bat_h : INTEGER := 10; 
    signal starter :integer := 0;
    signal cnt : std_logic_vector (15 downto 0);
    signal crash1 : std_logic := '0';
    constant MAX_LEN   : integer := 350;
    type coord_pair    is record x,y: integer; end record;
    type snake_array   is array (0 to MAX_LEN-1) of coord_pair;
    signal snake_body  : snake_array := (others => (x=>0, y=>0));
    signal snake_len   : integer range 1 to MAX_LEN := 1;
    signal prev_bat_x_i : integer := 0;  
    signal prev_bat_y_i : integer := 0;  
    signal curr_x_i : integer;
    signal curr_y_i : integer;
    signal res : std_logic := '0';


   
    CONSTANT ball_speed : STD_LOGIC_VECTOR (10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR (6, 11);
    SIGNAL ball_on : STD_LOGIC; 
    SIGNAL bat_on : STD_LOGIC;
    SIGNAL game_on : STD_LOGIC := '0'; 
    signal random_x : integer;
    signal random_y : integer;
    signal temporary_x : integer;
    signal temporary_y : integer;
    SIGNAL ball_x : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL ball_y : STD_LOGIC_VECTOR(10 DOWNTO 0);
    SIGNAL reset_sig : std_logic;
   
BEGIN
    red <= NOT bat_on; 
    green <= NOT ball_on;
    blue <= NOT ball_on;

      balldraw : PROCESS (ball_x, ball_y, pixel_row, pixel_col) IS
     
     
        VARIABLE vx, vy : STD_LOGIC_VECTOR (10 DOWNTO 0); 
    BEGIN
   
 
   
        IF pixel_col <= ball_x THEN 
            vx := ball_x - pixel_col;
        ELSE
            vx := pixel_col - ball_x;
        END IF;
        IF pixel_row <= ball_y THEN 
            vy := ball_y - pixel_row;
        ELSE
            vy := pixel_row - ball_y;
        END IF;
        IF ((vx * vx) + (vy * vy)) < (bsize * bsize) THEN
            ball_on <= game_on;
        ELSE
            ball_on <= '0';
        END IF;
    END PROCESS;
      snake_draw : PROCESS(snake_body, snake_len, pixel_row, pixel_col)
        variable vx, vy : integer;
        variable on_seg : std_logic := '0';
      begin
        on_seg := '0';
       
        for i in 0 to MAX_LEN-1 loop
          if i < snake_len then
            vx := abs(snake_body(i).x - conv_integer(pixel_col));
            vy := abs(snake_body(i).y - conv_integer(pixel_row));
            if (vx <= bat_w) and (vy <= bat_h) then
              on_seg := '1';
            end if;
          end if;
        end loop;
        bat_on <= on_seg;
       
           
      end process;
    mball : PROCESS(v_sync, reset)
        VARIABLE temp : STD_LOGIC_VECTOR (11 DOWNTO 0);
   
    BEGIN
        if reset = '1' then
            cnt       <= (others => '0');
            snake_len <= 1;
            ball_x    <= conv_std_logic_vector(700, 11);
            ball_y    <= conv_std_logic_vector(300, 11);
            game_on   <= '0';
            starter   <= 0;
            crash <= '0';

        elsif rising_edge(v_sync) then
               
               crash <= '0';
               for i in 3 to MAX_LEN-1 loop
               if i < snake_len then
                  if snake_body(i).x = conv_integer(bat_x) And snake_body(i).y = conv_integer(bat_y) then
                    crash <= '1';
                  end if;
               end if;
          end loop;
               
               curr_x_i <= conv_integer(bat_x);
               curr_y_i <= conv_integer(bat_y);
           
               if (curr_x_i /= prev_bat_x_i) or (curr_y_i /= prev_bat_y_i) then
                 
               for j in MAX_LEN-1 downto 1 loop
                    if j <= snake_len then
                        snake_body(j) <= snake_body(j-1);
                    end if;
               end loop;
                 
                 snake_body(0) <= ( x => curr_x_i,y => curr_y_i );
               end if;
               prev_bat_x_i <= curr_x_i;  
               prev_bat_y_i <= curr_y_i;        
      if starter = 0 then
           snake_len <= 1;
           cnt <= cnt-cnt;
           ball_x <= conv_std_logic_vector(700, 11);
           ball_y <= conv_std_logic_vector(300, 11);
           starter <= 1;
           end if;
   
           IF game_on = '0' THEN 
   
           ball_x <= conv_std_logic_vector(700, 11);
           ball_y <= conv_std_logic_vector(300, 11);
                game_on <= '1';
            END IF;
           
            IF (ball_x + bsize/2) >= (bat_x - bat_w) AND
            (ball_x - bsize/2) <= (bat_x + bat_w) AND
            (ball_y + bsize/2) >= (bat_y - bat_h) AND
            (ball_y - bsize/2) <= (bat_y + bat_h) THEN
                   temporary_x <= conv_integer(rng_x) * 10;
                   temporary_y <= conv_integer(rng_y) * 10; 
                   
                   for Q in 0 to max_len - 1 loop
                   if (snake_body(Q).x <= ball_x and snake_body(Q).y <= ball_y) then
                        res <= '1';
                   end if;
                   end loop;
                   
                   if res = '0' then
                        ball_x <= conv_std_logic_vector(temporary_x, 11);
                        ball_y <= conv_std_logic_vector(temporary_y, 11);
                        cnt <= cnt + 1;
                   else 
                        res <= '0';
                   end if;
                   
                   if snake_len < MAX_LEN then
                        snake_len <= snake_len + 5;
                   end if;
                   
            END IF;
           
        end if;
    END PROCESS;
    count1 <= cnt;
   
END Behavioral;
