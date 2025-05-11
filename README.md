# CPE-487 Snake Game Project

## Description of the Expected Behavior

The expected behavior of the project follows what one would expect from the game snake. There is a user controlled snake that is able to move around the screen on a fixed grid. The user should be allowed to move the snake up, down, left, or right with the direction that is the direct opposite of the current direction being blocked. The users goal is to move and collect balls which spawn randomly on the screen. The randomness is driven by constantly running through a table of pesdo-random numbers and picking a set of numbers to use as the coordinates to spawn the ball. When the user puts the head of the snake on a ball three things should happen first the counter on the board should increment by one, next the snakes length should grow, and finnaly the ball should spawn in a random location. The snakes length is controlled by an array, set to the max size allowed for the snake, when the snake is supposed to grow the next set of values in the array are flipped into a high state. When the snake is drawn onto the board we check which values are in the high state and draw those parts of the snake, so if the first 20 elements of the array are high we draw the snake 20 elements long. As the snake grows the challenge becomes to continue collecting these balls while avoiding colliding with the walls or yourself. 

## How to Run the Project

### 1. Create a new RTL project pong in Vivado Quick Start
* Create seven new source files of file type VHDL called clk_wiz_0, clk_wiz_0_clk_wiz, vga_sync, bat_n_ball, leddec16, rng_table and pong
* Create a new constraint file of file type XDC called **_pong_**
* Choose Nexys A7-100T board for the project
* Click 'Finish'
* Click design sources and copy the VHDL code from clk_wiz_0, clk_wiz_0_clk_wiz, vga_sync.vhd, bat_n_ball.vhd, leddec16.vhd, rng_table.vhd pong.vhd
* Click constraints and copy the code from pong.xdc

### 2. Run synthesis

### 3. Run implementation

### 4. Generate bitstream, open hardware manager, and program device

### 5. Use the BTNU, BTND, BTNL, and BTNR buttons to control the snakes movment

## Inputs and Outputs

## Video of Project

## Modifications

## Conclusion
