# CPE-487 Snake Game Project

## Description of the Expected Behavior

The expected behavior of the project follows what one would expect from the game snake. There is a user controlled snake that is able to move around the screen on a fixed grid. The user should be allowed to move the snake up, down, left, or right with the direction that is the direct opposite of the current direction being blocked. The users goal is to move and collect balls which spawn randomly on the screen. The randomness is driven by constantly running through a table of pseudo-random numbers and picking a set of numbers to use as the coordinates to spawn the ball. When the user puts the head of the snake on a ball three things should happen: first the counter on the board should increase by one, next the snake's length should grow, and finally the ball should spawn in a random location. The snakes length is controlled by an array, set to the max size allowed for the snake, when the snake is supposed to grow the next set of values in the array are flipped into a high state. When the snake is drawn onto the board we check which values are in the high state and draw those parts of the snake, so if the first 20 elements of the array are high we draw the snake 20 elements long. As the snake grows the challenge becomes to continue collecting these balls while avoiding colliding with the walls or yourself. This collision works by checking the position of the snake's head, if the head ever comes passes the designated thresholds for the walls or overlaps with the body positions then the game ends. When the game ends we have to reset everything, we do this by having a reset flag that gets triggered by any of the collisions. When the reset flag is set it places the ball and snake into the default positions, reduces the snake's size to default, resets the counter, and then flips all flags back to low to avoid being stuck in a reset. All of these features allow us to have a game the functions nearly identical to the classic game snake while running on the fpga.

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

In this project John and Anthony accuratly replicated the game snake on a FPGA using VHDL. The work was split fairly evenly between the two group members. Anthony worked on the movment which allowed the player to move the snake around the screen and kept the snake aligned with the desired grid. Anthony also worked on the random number table which allowed the ball to spawn in a random location when eatten. John worked on the snakes length which allowed the snake to get longer as it ate balls and on the counter which tracked the number of balls eatten. Anthony worked on collisions with the walls while John worked on collisions with the snakes body. For when the snake did collide with somehthing John worked on the reset of the game. The final polish was done by Anthony. The work started around early April with the movment and slowly ramped up over the month and into May. By early May a rough outline of the game was made, with some serious features lacking such as collison with the snakes body. Throughout the first week of may the work became nearly daily up until the project was completed on the eleventh. Two major problems we encountered when making this project were how to randomly spawn the ball and how to get the snake to grow. The first was solved by Anthony when he remembered how random numbers were generated in the orginal doom game. This revolation led him to implmenting a random number table that was constantly being cycled through, when called upon it would send out whatever number it was on at that moment. This created a pseudo-randomness that was very useful when spawning the ball. The other issue was making the snake longer. John was able to solves this one by creating an array that held high and low values, if an element in the array was high then it was to be drawn by the games graphics if it was low then it was to be ignored. By switching values between high and low John was able to control the length of the snake. This project had many smaller challenges which were each handled as they came resulting in a functioning version of snake.
