LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pong IS
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        btnu : in std_logic;
        btnd : in std_logic;
        btnl : IN STD_LOGIC;
        btnr : IN STD_LOGIC;
        btn0 : IN STD_LOGIC;
        SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); 
        SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
END pong;

ARCHITECTURE Behavioral OF pong IS
    SIGNAL pxl_clk : STD_LOGIC := '0'; 
    
   
    signal rng_x_signal : std_logic_vector(6 downto 0);
    signal rng_y_signal : std_logic_vector(7 downto 0);

   
    SIGNAL S_red, S_green, S_blue : STD_LOGIC;
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL batpos : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL batposY : STD_LOGIC_VECTOR (10 DOWNTO 0);
    SIGNAL count : STD_LOGIC_VECTOR (20 DOWNTO 0);
    signal repeat : integer;
    signal direction : integer;
    signal temp_direction : integer;
    signal start : integer;
    signal start_2 :integer;
    signal move_count : integer := 8;
    
    signal speedy : integer := 3;
    SIGNAL display : std_logic_vector (15 DOWNTO 0); -- value to be displayed
    SIGNAL led_mpx : STD_LOGIC_VECTOR (2 DOWNTO 0); -- 7-seg multiplexing clock
    signal randx : std_logic_vector(6 downto 0);
    signal randy : std_logic_vector(7 downto 0);
    signal crashp : std_logic;
    signal reset : std_logic;
    COMPONENT bat_n_ball IS
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
            count1 : out std_logic_vector (15 downto 0);
            crash : out std_logic;
            reset : in std_logic
        );
    END COMPONENT;
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clk_wiz_0 is
        PORT (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
    END COMPONENT;
    COMPONENT leddec16 IS
        PORT (
            dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
        );
    END COMPONENT;
   
    component RNG_Table is
    port (
        clk : in std_logic;
        x_table_value : out std_logic_vector (6 downto 0); 
        y_table_value : out std_logic_vector (7 downto 0) 
    );
    END COMPONENT;
   
BEGIN
    pos : PROCESS (clk_in) is
    BEGIN
   
        if (start /= 1) then
        start <= 1;
        batpos <= CONV_STD_LOGIC_VECTOR(200, 11);
        batposY <= CONV_STD_LOGIC_VECTOR(300, 11);
        end if;
       
        if rising_edge(clk_in) then
      count <= count + 1;
     
                if (btnl = '1' and repeat /= 1 and count = 0)THEN
                    direction <= 1;
                    
                elsif (btnr = '1' and repeat /= 1 and count = 0)THEN
                    direction <= 2;
                    
                elsif (btnd = '1' and repeat /= 2 and count = 0) THEN
                    direction <= 3;
                    
                elsif (btnu = '1' and repeat /= 2 and count = 0) THEN
                    direction <= 4;
                   
                end if;              
       
       
        if (move_count = 8 and count = 0) then
            temp_direction <= direction;
           
        elsif (move_count > 0 and count = 0) then
            case temp_direction is
            when 0 =>
                if count = 0 then
                    repeat <= 0;
                end if;
            when 1 =>
                if count = 0 then
                    batpos <= batpos - 3;
                    repeat <= 1;
                end if;
            when 2 =>
                if count = 0 then
                    batpos <= batpos + 3;
                    repeat <= 1;
                end if;
            when 3 =>
                if count = 0 then
                    batposY <= batposY + 3;
                    repeat <= 2;
                end if;
            when 4 =>
                if count = 0 then
                    batposY <= batposY - 3;
                    repeat <= 2;
                end if;
            when others =>
                null;
        end case;
     
        end if;
       
       if (count = 0) then
           move_count <= move_count - 1;  
       end if;
       
        if (move_count = 0 and count = 0) then
            move_count <= 8;
         end if;

        if (batpos <= 10 or batpos >= 800 or batposy <= 10 or batposy >= 600 or crashp = '1') THEN
            start <= 0;
            start_2 <= 0;
            temp_direction <= 0;
            direction <= 0;
            repeat <= 0;
            reset <= '1';
        else
            reset <= '0';
        end if;
           
        end if;
         
    END PROCESS;
  
   
    led_mpx <= count(19 DOWNTO 17);
    add_bb : bat_n_ball
    PORT MAP(
        v_sync => S_vsync,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col,
        bat_x => batpos,
        bat_y => batposY,
        serve => btn0,
        red => S_red,
        green => S_green,
        blue => S_blue,
        rng_x => randx,
        rng_y => randy,
        count1 => display,
        crash => crashp,
        reset => reset
--        zoom => speedy
    );
   
    vga_driver : vga_sync
    PORT MAP(
        pixel_clk => pxl_clk,
        red_in => S_red & "000",
        green_in => S_green & "000",
        blue_in => S_blue & "000",
        red_out => VGA_red,
        green_out => VGA_green,
        blue_out => VGA_blue,
        pixel_row => S_pixel_row,
        pixel_col => S_pixel_col,
        hsync => VGA_hsync,
        vsync => S_vsync
    );
    VGA_vsync <= S_vsync; 
       
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
   
    led1 : leddec16
    PORT MAP(
      dig => led_mpx, data => display,
      anode => SEG7_anode, seg => SEG7_seg
    );
   
    rng : RNG_Table
    port map(
    clk => clk_in,
    x_table_value => randx,
    y_table_value => randy
    );
 
END Behavioral;
