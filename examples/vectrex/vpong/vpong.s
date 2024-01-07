#include "c2/vectrex/vectrex.s"

// this game was written on 08.02.1998 bye Christopher Salomon
// it is public domain
//
// comments and vectrex talk are welcome
// my email: chrissalo@aol.com
//
//
// followin command line was used to assemble:
//
// C:>as09.exe -h0 -l -cti vpong.asm >error
//
// I used the 6809 assembler:
// as09 [1.11].
// Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
// Available at:
// http://www.falstaff.demon.co.uk/cross.html
//
// Converted to c2 by John Hammarberg
// c2 doesn't require capital letters for psudo op codes but those have been left as is

// user variable definitions
//$c890
#define	user_ram             $c890
#define	music_active         user_ram
#define	paddle_pos           music_active + 2
#define	paddle_y             paddle_pos
#define	paddle_x             paddle_y + 1
#define	paddle_speed_y       paddle_x + 1
#define	paddle_speed_x       paddle_speed_y + 1

#define	ball_pos             paddle_speed_x + 1
#define	ball_y               ball_pos
#define	ball_x               ball_y + 1
#define	ball_speed_y         ball_x + 1
#define	ball_speed_x         ball_speed_y + 1   // speed like $hl, low for every round
#define	ball_speed_y_hi      ball_speed_x + 1
#define	ball_speed_x_hi      ball_speed_y_hi+ 1
#define	ball_speed_y_reset   ball_speed_x_hi + 1
#define	ball_speed_x_reset   ball_speed_y_reset+ 1
#define	ball_available       ball_speed_x_reset + 1   // high for when next round

#define	game_level           ball_available + 1
#define	paddle_check         game_level + 1
#define	paddle_increase      paddle_check + 1
#define	court1_scale2        paddle_increase + 1
#define	paddle_intensity     court1_scale2 + 1
#define	court1_intensity     paddle_intensity + 1
#define	difficult_counter    court1_intensity +1
#define	difficulty           difficult_counter + 1
#define	game_over_intensity  difficulty + 1
#define	game_over_scaley     game_over_intensity + 1
#define	game_over_scalex     game_over_scaley + 1
#define	game_over_ypos      (((game_over_scalex + 2)/2)*2)
#define	game_over_xpos      game_over_ypos + 1

#define	tmp                  (game_over_xpos + 1)
// see bottom of file for further addresses!

// user defines
// vectrex coordinates use range from -128 to +127
// these top and bottom values are in scale factor $ff
#define	FALSE              (lo(0))
#define	TRUE               (lo(1))
#define	SCREEN_TOP         (lo($7f))
#define	SCREEN_BOTTOM      (lo(-$80))
#define	SCREEN_LEFT        (lo(-$80))
#define	SCREEN_RIGHT       (lo($7f))
#define	SCREEN_CENTER      (lo(0))

#define	NORMAL_TEXT_SIZE  $F160
#define	SCORE_TEXT_SIZE   $fb30
#define	LETTER_WIDTH      (lo(16))
#define	LETTER_HIGHT      (lo(16))

#define	PADDLE_WIDTH      (lo(20))
#define	PADDLE_HIGHT      (lo(5))

#define	PADDLE_X_RIGHT    (lo(SCREEN_RIGHT-PADDLE_WIDTH-$10))
#define	PADDLE_X_LEFT     (lo(SCREEN_LEFT+$11))

#define	PADDLE_INIT_XPOS  (lo(SCREEN_CENTER-(PADDLE_WIDTH/2)))   // center
#define	PADDLE_INIT_YPOS  (lo(SCREEN_BOTTOM+($12)))              // bottom of screen plus court1 modification
#define	PADDLE_INIT_POS   (PADDLE_INIT_YPOS*256+PADDLE_INIT_XPOS)
#define	PADDLE_INIT_SPEED  (lo(2))
#define	PADDLE_INIT_INCREASE  (lo(3))
#define	PADDLE_INTENSITY_INIT  (lo($7f))

#define	SIZE_OF_WALL1     (lo($70))
#define	COURT1_XPOS       (SCREEN_LEFT+$10)
#define	COURT1_YPOS       (SCREEN_BOTTOM+$10)
#define	COURT1_POS        (COURT1_YPOS*256+(COURT1_XPOS))
#define	COURT1_COMPENSATE  (0*256+(-SIZE_OF_WALL1))
#define	COURT1_INTENSITY_INIT  (lo($7f))

#define	BALL_SIZE         (lo(5))
#define	BALL_INIT_YPOS    (lo($6a))
#define	BALL_X_RIGHT      (lo(SCREEN_RIGHT-BALL_SIZE-$10))
#define	BALL_X_LEFT       (lo(SCREEN_LEFT+$11))

#define	SCORE_YPOS        (SCREEN_TOP-8)
#define	SCORE_XPOS        (SCREEN_LEFT+8)
#define	LEVEL_YPOS        (SCREEN_TOP-8)
#define	LEVEL_XPOS        (lo(0-30))
#define	BALLS_YPOS        (SCREEN_TOP-8)
#define	BALLS_XPOS        (SCREEN_RIGHT-60)
#define	MAX_SPEED         (lo(10))

#define	PADDLE_SCALE_INIT  (lo($7f))
#define	COURT1_SCALE_INIT1  (lo($ff))
#define	COURT1_SCALE_INIT2  (lo($7f))
#define	DIFFICULT_THRESHOLD  (lo(5))
#define	BALLS_PER_GAME    (lo('5'))

#define	copy_start           ((tmp/2)*2 + 100)
#define	score_string         (copy_start)
#define	score_only_string    (copy_start+(_score_only_string-_copy_start))
#define	no_score_string      (copy_start+(_no_score_string-_copy_start))
#define	level_string         (copy_start+(_level_string-_copy_start))
#define	no_level_string      (copy_start+(_no_level_string-_copy_start))
#define	balls_string         (copy_start+(_balls_string-_copy_start))
#define	no_balls             (copy_start+(_no_balls-_copy_start))
#define	bottom_paddle        (copy_start+(_bottom_paddle-_copy_start))
#define	bottom_paddle_scale  (copy_start+(_bottom_paddle_scale-_copy_start))
#define	court1               (copy_start+(_court1-_copy_start))
#define	court1_scale1        (copy_start+(_court1_scale1-_copy_start))

// **************************************************************************

                @   =   0

// start of vectrex memory with cartridge name...
                byte      "g GCE 1998", $80  // 'g' is copyright sign
                word      music7             // music from the rom
                byte      $F8, $50, $20, $C8 // hight, width, rel x, rel y (from 0,0)
                byte      "VECTREX PONG", $80// some game information, ending with $80
                byte      $F8, $50, -$0, -$70 // hight, width, rel x, rel y (from 0,0)
                byte      "g CHRISTOPHER SALOMON", $80// some game information, ending with $80
                byte      0                  // end of game header
// **************************************************************************
// here the cartridge program starts off
entry_point:
new_game:
                JSR     init_screen        // startup screen
                JSR     init_vars          // initialize game variables
main_loop:
                JSR     do_my_sound        // do own sound stuff
                JSR     Wait_Recal         // sets dp to d0, and pos at 0, 0
                JSR     Do_Sound           // play sound via rom
                JSR     draw_court         // draw the court
                // note: the paddle drawing could be optimized,
                // since the bottom line of the paddle should
                // have the same y position as there would be
                // left after drawing the court
                // for now the pen position is moved back to zero
                // and the paddle is drawn independently
                JSR     draw_paddle
                JSR     draw_ball
                JSR     draw_strings
                LDA     no_balls           // test for game over
                CMPA    #'0'               // when balls are zero
                BEQ     game_lost          // than game lost
                BRA     main_loop          // start another round
// **************************************************************************
game_lost:
                // do some extro
                CLRA                       // clear A
                STA     game_over_intensity// and store in intensity
                STA     game_over_scalex   // scale x
                STA     game_over_scaley   // scale y
                STA     game_over_ypos     // pos y
                STA     game_over_xpos     // pos x of game over string
                // the next instructions initialize a new sound
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #musicb            // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
game_over_loop1:
                JSR     do_my_sound        // do own sound stuff
                JSR     Wait_Recal         // sets dp to d0, and pos at 0, 0
                JSR     Do_Sound           // do sound stuff
                // now print something on screen
                LDA     game_over_scaley   // prepare drawing of game over string
                LDB     game_over_scalex   // load scaling stuff
                STD     Vec_Text_HW        // poke it to ram location
                LDA     game_over_intensity// load intensity
                JSR     Intensity_a        // set it
                LDA     game_over_ypos     // load position
                LDB     game_over_xpos     // to D (A,B) register
                LDU     #game_over_string  // and the address of the string itself
                JSR     Print_Str_d        // and draw it
                // calculate new appearence
                LDA     game_over_intensity// increase intensity
                ADDA    #3                 // three per step
                STA     game_over_intensity// store it
                ANDA    #$1                // every second step increase
                BEQ     no_y_scale_now     // y scale of string
                LDA     game_over_scaley   // load it
                SUBA    #1                 // increase it
                STA     game_over_scaley   // save it
no_y_scale_now:
                LDA     game_over_ypos     // now look at the position of the
                ADDA    #2                 // string, first y pos
                CMPA    #$70               // increase it by two, but not to much
                BLO     use_y              //
                LDA     #$70               // maximum at $70
use_y:
                STA     game_over_ypos     // store it
                LDA     game_over_xpos     // likewise treat x pos load it
                SUBA    #2                 // decrease it
                CMPA    #-$70              // till -$70
                BGE     use_x              //
                LDA     #-$70              // or use minimum of -$70
use_x:
                STA     game_over_xpos     // store it
                LDA     game_over_scalex   // now do the x scaling
                ADDA    #3                 // every round add 3
                STA     game_over_scalex   // and store it
                LDA     game_over_intensity// do all this
                CMPA    #$7f               // till intensity is full
                BLO     game_over_loop1    // do the game loop
                JSR     Read_Btns          // get button status once, since only
                                           // differences are noticed
                LDA     game_over_scalex   // now do the x scaling
                SUBA    #3                 // every round add 3
                STA     game_over_scalex   // and store it
game_over_loop2:
                JSR     do_my_sound        // do own sound stuff
                JSR     Wait_Recal         // sets dp to d0, and pos at 0, 0
                JSR     Do_Sound           // do sound stuff
                JSR     Intensity_7F       // draw at full brightness
                LDD     #SCORE_TEXT_SIZE
                STD     Vec_Text_HW        // poke it to ram location
                LDA     #-$20              // load position
                LDB     #-$30              // to D (A,B) register
                LDU     #score_only_string
                JSR     Print_Str_d        // and draw it
                LDA     game_over_scaley   // prepare drawing of game over string
                LDB     game_over_scalex   // load scaling stuff
                STD     Vec_Text_HW        // poke it to ram location
                LDA     game_over_ypos     // load position
                LDB     game_over_xpos     // to D (A,B) register
                LDU     #game_over_string  // and the address of the string itself
                JSR     Print_Str_d        // and draw it
                JSR     Read_Btns          // get button status
                CMPA    #$00               // is a button pressed?
                BEQ     game_over_loop2    // no, than stay in init_screen_loop
                LDU     #Vec_High_Score    // 'OS' high score
                LDX     #no_score_string   // own last score
                JSR     New_High_Score     // if own was higher, set 'OS' == own
                BRA     new_game           // start a new game
// **************************************************************************
// this routine calculates the new paddle position for only x movement
// expected:dp is allready pointing to d0
// expects coordinates at 0,0
// possibly changes 'paddle_pos'
// nothing is returned
draw_paddle:
                JSR     Joy_Digital        // read joystick positions
                LDB     paddle_x           // load old paddle pos to B
                LDA     Vec_Joy_1_X        // load joystick 1 position X to A
                BEQ     no_new_pos         // no joystick input available
                BMI     pos_left           // joystick moved to left
pos_right:
                CMPB    #PADDLE_X_RIGHT    // is it at maximum right position?
                BEQ     no_new_pos         // if so, do nothing
                ADDB    paddle_speed_x     // increase position with speed faktor
                STB     paddle_x           // and store new position
                CMPB    #PADDLE_X_RIGHT    // compare it again to right border
                BLE     new_pos_exit       // if lower or same (RIGHT) than ok
                LDB     #PADDLE_X_RIGHT    // otherwise use the right
                STB     paddle_x           // border as new position
                BRA     new_pos_exit       // and exit joystick position routine
pos_left:
                CMPB    #PADDLE_X_LEFT     // is it at maximum left position?
                BEQ     no_new_pos         // if so, do nothing
                SUBB    paddle_speed_x     // decrease position with speed faktor
                STB     paddle_x           // and store new position
                CMPB    #PADDLE_X_LEFT     // compare it again to left border
                BGE     new_pos_exit       // if higher or same (LEFT) than ok
                LDB     #PADDLE_X_LEFT     // otherwise use the left
                STB     paddle_x           // border as new position
new_pos_exit:
no_new_pos:
                LDD     paddle_pos         // load current paddle position to D
                JSR     Moveto_d           // move to rel position D
                LDA     paddle_intensity   // load paddle brightness
                JSR     Intensity_a        // switch intensity, Joy_Digital destroys this
                LDX     #bottom_paddle     // address of paddle vector list
                JSR     Draw_VLcs          // Draw vector list
                RTS
// **************************************************************************
// this routine draws the outer court
// expecting dp is allready pointing to d0
// expects coordinates at 0,0
// nothing is returned
draw_court:
                LDA     court1_intensity   // load court1 brightness
                JSR     Intensity_a        // switch intensity
                LDA     court1_scale2      // scale for placing firt point
                STA     VIA_t1_cnt_lo      // move to time 1 lo, this means scaling
                LDD     #COURT1_POS        // first coordinate of COURT 1
                JSR     Moveto_d           // move to rel position D
                LDX     #court1            // address of court vector list
                JSR     Draw_VLcs          // Draw vector list
                LDD     #COURT1_COMPENSATE // compensates the 'open' court
                JSR     Moveto_d           // move to rel position D
                LDA     court1_scale2      // scale for placing firt point
                STA     VIA_t1_cnt_lo      // move to time 1 lo, this means scaling
                LDB     #COURT1_XPOS       // goes back to
                NEGB                       // position
                LDA     #COURT1_YPOS       // before court
                NEGA                       // was drawn
                JSR     Moveto_d           // move to rel position D
                RTS
// **************************************************************************
// this routine moves the ball and draws it
// expecting dp is allready pointing to d0
// expects intensity set to 7f
// nothing is returned
// optimization could easily be done e.g. via direct addressing!
draw_ball:
                LDA     ball_available     // check if there is a ball
                CMPA    #FALSE             // allready in play
                BNE     ball_is_available  // if not
                JSR     get_new_ball       // get a new ball
ball_is_available:                         // now start moving + drawing
                // now we change the y position
                LDA     ball_speed_y_hi    // load y speed hi counter
                BEQ     no_y_wait          // if zero, change y pos now
                DECA                       // decreas high counter
                STA     ball_speed_y_hi    // and store it again
                BRA     y_change_done      // go to where no y change will be done
no_y_wait:
                LDB     ball_y             // change the y position
                ADDB    ball_speed_y       // with the speed factor
                STB     ball_y             // and store it back
                LDA     ball_speed_y_reset // reset the
                STA     ball_speed_y_hi    // high counter
y_change_done:
                // now we change the x position
                LDA     ball_speed_x_hi    // load x speed hi counter
                BEQ     no_x_wait          // if zero, change x pos now
                DECA                       // decreas high counter
                STA     ball_speed_x_hi    // and store it again
                BRA     x_change_done      // go to where no x change will be done
no_x_wait:
                LDB     ball_x             // change the x position
                ADDB    ball_speed_x       // with the speed factor
                STB     ball_x             // and store it back
                LDA     ball_speed_x_reset // reset the
                STA     ball_speed_x_hi    // high counter
x_change_done:
                // now we check if the ball bounces off a wall
                LDA     ball_speed_x       // in what direction is the ball moving?
                BMI     check_left         // negative, than we check left border
                CMPB    #BALL_X_RIGHT      // ball right out of bounds?
                BLE     x_right_ok         //
                NEG     ball_speed_x       // yes, than change direction
                // the next instructions initialize a new sound
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #PING2             // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
check_left:
                CMPB    #BALL_X_LEFT       // ball left out of bounds?
                BGE     x_left_ok          //
                NEG     ball_speed_x       // yes, than change direction
                // the next instructions initialize a new sound
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #PING2             // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
x_left_ok:
x_right_ok:                                // x position is OK
                LDA     ball_speed_y       // checking for bottom?
                BPL     check_for_upper_border // or upper border?
                // now we check if the ball is hit with paddle (bottom)
                LDB     ball_y             // load y position
                LDA     paddle_check       // is ball allready lost?
                CMPA    #FALSE             // allready lost?
                BEQ     allready_lost      // yep... than don't check again
                SUBB    #BALL_SIZE         // we must look at the bottom edge of the ball
                CMPB    #PADDLE_INIT_YPOS  // compare to paddle y
                BGE     nothing_happens    // if not there, than go on
                LDA     paddle_x           // get the x pos of the paddle
                CMPA    ball_x             // compare to x of ball
                BGE     paddle_greater_ball// if paddle higher...
paddle_lesser_ball:                        // here paddle smaller than ball
                ADDA    #PADDLE_WIDTH      // check if we have hit the ball
                CMPA    ball_x             // with the body of the paddle
                BLT     paddle_not_there   // no!
                NEG     ball_speed_y       // yep, reflected, change y speed
                BRA     ball_reflected     // and go on
paddle_greater_ball:                       // paddle higher ball
                SUBA    #BALL_SIZE         // take the size of the ball into account
                CMPA    ball_x             // and check again
                BGT     paddle_not_there   // oops, ball seems lost!
                NEG     ball_speed_y       // yep, reflected, change y speed
                BRA     ball_reflected     // and go on
paddle_not_there:
                LDA     #FALSE             // this ball is now lost
                STA     paddle_check       // next time we don't check the paddle
allready_lost:
                CMPB    #SCREEN_BOTTOM     // will ball move off the screen?
                BGT     is_roll_over       // not yet, than go on
get_lost:
                STA     ball_available     // next time a ball is not available
                JSR     ball_lost          // ball is now lost
                RTS                        // bye!
is_roll_over:
                TSTB                       // test for
                BMI     nothing_happens    // rollover otherwise do nothing
                BRA     get_lost           // now restart
check_for_upper_border:
// now we check if we are at the upper border
                LDB     ball_y             // load y position
                CMPB    #BALL_INIT_YPOS    // compare upper
                BLE     nothing_happens    // if not there, than go on
                LDA     #BALL_INIT_YPOS    // otherwise use init position
                STA     ball_y             // store it
                NEG     ball_speed_y       // and reflect, using opposite y speed
                // the next instructions initialize a new sound
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #PING2             // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
nothing_happens:
draw_ball_on_screen:
                JSR     Reset0Ref          // reset screen position
                LDD     ball_pos           // load position of ball
                JSR     Moveto_d_7F        // move to rel position D and scale factor 7F
                LDX     #ball              // address of ball vector list
                JSR     Draw_VLc           // Draw vector list
                RTS
ball_reflected:
                LDB     ball_x             // load x position of ball again!
                ADDB    #(BALL_SIZE/2)     // and get the center of it
                LDA     paddle_x           // load x position of paddle
                ADDA    #(PADDLE_WIDTH/2)  // and get the center of it
                STA     tmp                // store ball center
                SUBB    tmp                // in A now the offset of the
                                           // ball center to the center of
                                           // the paddle
                                           // should be abs(10)
                ASRB                       // only a quarter should remain
                ASRB                       //
                LDA      difficulty        // load difficulty setting
                MUL                        // multiply A*B
                ADDB     ball_speed_x      // and modify the x speed accordingly
                STB      ball_speed_x      // store it
                LDA      #1                // score 1 for reflecting
                LDX      #no_score_string  // load score address
                JSR      Add_Score_a       // add to score
                LDA      #1                // score 1 for reflecting
                LDX      #no_level_string  // load level address
                JSR      Add_Score_a       // add to level
                INC      game_level        // add to level
                // let's see if we can make it a bit more difficult!
                INC     difficult_counter  // increase counter
                LDA     difficult_counter  // load it
                CMPA    #DIFFICULT_THRESHOLD // and check if new difficult level is reached
                BNE     no_difficult_change// no, not yet
                INC     difficulty         // difficulty + 1
                CLRA                       // difficult_counter to zero
                STA     difficult_counter  // store it
                INC     ball_speed_y       // y speed one up :-)
                LDA     ball_speed_y       // load speed to A
                CMPA    #MAX_SPEED         // check if not too fast
                BLE     no_speed_overflow  // do nothing
                LDA     #MAX_SPEED         // store MAX_SPEED
                STA     ball_speed_y       // to ball y speed
no_speed_overflow:
no_difficult_change:
                LDA     ball_speed_x       // load x speed
                CMPA    #0                 // check for 0 speed
                BNE     no_x_zero_speed    // if none zero do nothing
                JSR     Random             // get random
                TFR     A,B                // copy to B
                ANDB    #$1                // look at first bit
                CMPB    #0                 // test for zero
                BEQ     no_x_speed_change  // do nothing if zero
                TSTA                       // positive or negative random?
                BPL     change_to_plus1    // or plus
                LDA     #-1                // -1
                STA     ball_speed_x       // store x speed
                BRA     done_speed_change  //
change_to_plus1:
                LDA     #1                 // 1
                STA     ball_speed_x       // store x speed
no_x_speed_change:
no_x_zero_speed:
done_speed_change:
                LDA     ball_speed_y       // load y speed of ball
                CMPA    paddle_increase    // and see if paddle should be faster
                BLT     no_paddle_speed_change // no, not yet
                INC     paddle_speed_x     // go faster in x
                LDA     paddle_increase    // and new increase threshold
                ADDA    #2                 // old plus 2
                STA     paddle_increase    // and store
no_paddle_speed_change:
                // the next instructions initialize a new sound
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #PING1             // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
                BRA     draw_ball_on_screen
// **************************************************************************
// this routine initiates a new ball
// not finnished yet
// nothing is returned
get_new_ball:
                LDA     #TRUE              // next time a ball is
                STA     ball_available     // available
                STA     paddle_check       // next time we check the paddle
                CLRA                       // start in the middle of screen
                STA     ball_x             // this is the next x position
                LDA     #BALL_INIT_YPOS    // start at top of screen
                STA     ball_y             // this is the next y position
                LDA     #-1                // ball y speed // allway negativ, since ball must
                                           // move down!
                STA     ball_speed_y       // not randomized yet
                LDA     #0                 // hi value for y speed for now
                STA     ball_speed_y_hi    // allways zero
                STA     ball_speed_y_reset // as is the reset value
                JSR     Random             // get random number to A
                ANDA    #($3)              // only the 2 lower bits are needed
                TFR     A,B                // copy it to A
                JSR     Random             // get random number to A
                TSTA                       // is it positive?
                BPL     positiv_x          // if so use positiv x speed
                NEGB                       // else negative
positiv_x:
                STB     ball_speed_x       // now store the speed
                LDA     #0                 // hi value for x speed for now
                STA     ball_speed_x_hi    // allways zero
                STA     ball_speed_x_reset // as is the reset value
                RTS
// **************************************************************************
ball_lost:
                // the next instructions initialize a new sound
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #ball_lost_sound   // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
                LDA     court1_scale1      // just for the loop, might do a bra as a jump into the loop
lost_loop:
                STA     court1_scale1      // store the last changed court 1 scale factor
                JSR     do_my_sound        // do own sound stuff
                JSR     Wait_Recal         // sets dp to d0, and pos at 0, 0
                JSR     Do_Sound           // play sound via rom
                JSR     draw_court         // draw the court
                JSR     draw_paddle        // draw paddle
                JSR     draw_strings       // draw strings (not scaled, should I?)
                LDA     court1_scale2      // load scale value2 of court (for positioning)
                SUBA    #3                 // decrease it
                STA     court1_scale2      // and write it back
                LDA     bottom_paddle_scale// load scale value of paddle
                SUBA    #3                 // decrease it
                STA     bottom_paddle_scale// and write it back
                LDA     court1_intensity   // load intensity of court
                SUBA    #3                 // decrease it
                STA     court1_intensity   // and write it back
                LDA     paddle_intensity   // load intensity of paddle
                SUBA    #3                 // decrease it
                STA     paddle_intensity   // and write it back
                LDA     court1_scale1      // load scale value1 of court (for sizing)
                SUBA    #6                 // decrease it
                BCC     lost_loop          // and write it back
                DEC     no_balls           // one ball less
                JSR     init_new_ball_vars // and reinit all destroyed variables
                RTS
// **************************************************************************
// this routine initializes the game variables
// nothing is expected and nothing is returned
init_vars:
                JSR     Init_OS            // init OS, should allready been done...
                LDU     #_copy_start       // my 'ram' address (source)
                LDX     #copy_start        // copy my 'ram' to vectrex ram (destination)
                LDA     #(_copy_end-_copy_start) // number of bytes to be copied, must be less than $81
                JSR     Move_Mem_a         // and copy...
                LDA     #FALSE             // no ball availabel
                STA     ball_available     // upon startup
                LDA     #1                 // initial game level
                STA     game_level         // upon startup
                LDX     #no_score_string   // get the address of score string
                JSR     Clear_Score        // clear score
                LDA     #BALLS_PER_GAME    // balls 5
                STA     no_balls           // and store five balls
                LDD     #PADDLE_INIT_POS   // load init values
                STD     paddle_pos         // and store them...
init_new_ball_vars:
                LDX     #no_level_string   // get level string
                JSR     Clear_Score        // clear level string
                CLRA                       // clear level number
                LDA     #PADDLE_INIT_SPEED // initial paddle speed x
                STA     paddle_speed_x     // and store it
                LDA     #PADDLE_INIT_SPEED // initial paddle speed y
                STA     paddle_speed_y     // and store it
                LDA     #PADDLE_INIT_INCREASE // set paddle increase
                STA     paddle_increase    // and store
                LDA     #COURT1_SCALE_INIT1// init value for court scale 1
                STA     court1_scale1      // scale for placing first point
                LDA     #COURT1_SCALE_INIT2// init value for court scale 2
                STA     court1_scale2      // scale for court size
                LDA     #PADDLE_SCALE_INIT // init value for paddle size
                STA     bottom_paddle_scale// paddle scale value
                LDA     #PADDLE_INTENSITY_INIT // set the brightness
                STA     paddle_intensity   // of the paddle
                LDA     #COURT1_INTENSITY_INIT // set the brightness
                STA     court1_intensity   // of the court
                CLRA                       // difficult to zero
                STA     difficult_counter  // store it
                INCA                       // difficulty to 1
                STA     difficulty         // store it
                RTS
// **************************************************************************
// this routine draws the initial screen
// with information about the game
// nothing is expected and nothing is returned
init_screen:
                JSR     Read_Btns          // get button status once, since only
                                           // differences are noticed
                LDD     #NORMAL_TEXT_SIZE  // load default text height & width
                STD     Vec_Text_HW        // poke it to ram location
                JSR     Intensity_7F       // draw at full brightness
                // the next 5 instructions initialize a new sound
                JSR     DP_to_C8           // set DP...
                LDA     #$01               // load #1
                STA     Vec_Music_Flag     // set this as marker for music start
                LDU     #music4            // load a music structure
                STU     music_active       // and store it to my own music active pointer
                                           // next a do_my_sound and than do sound must be called
init_screen_loop:
                JSR     do_my_sound        // do own sound stuff
                JSR     Wait_Recal         // sets dp to d0, and pos at 0, 0
                JSR     Do_Sound           // do sound stuff
                LDU     #game_name         // load text start to U
                                           // Get A=Y, B=X (D=AB) coordinate
                LDA     #(LETTER_HIGHT/2)  // Center Text Y
                LDB     #(-(LETTER_WIDTH*11)/2) // Center Text X
                JSR     Print_Str_d        // Print the string
                JSR     Read_Btns          // get button status
                CMPA    #$00               // is a button pressed?
                BEQ     init_screen_loop   // no, than stay in init_screen_loop
exit_init_screen:                          // otherwise proceed
                RTS
// **************************************************************************
// expecting dp is allready pointing to d0
// prints 'score', 'hits' and 'balls'
draw_strings:
                JSR     Intensity_7F       // draw at full brightness
                JSR     Reset0Ref          // reset screen position
                LDU     #score_string      // load text start to U
                                           // Get A=Y, B=X (D=AB) coordinate
                JSR     Print_List_hw      // Print the string
                RTS
// **************************************************************************
// leaves with DP set to C8
// expects music to be initialized
// and pointer in music_active
do_my_sound:
                JSR     DP_to_C8           // set DP to C8
                LDU     music_active       // get active music
                JSR     Init_Music_chk     // and init new notes
                RTS
// **************************************************************************
game_name:
                byte   "VECTREX PONG", $80
game_over_string:
                byte   "GAME OVER", $80
// **************************************************************************
ball:
                byte    3                    // 4 vectors are drawn
                byte    0,   BALL_SIZE       // next point relativ (y,x)
                byte   BALL_SIZE,    0       // next point relativ (y,x)
                byte    0,  -BALL_SIZE       // next point relativ (y,x)
                byte  -BALL_SIZE,    0       // next point relativ (y,x)
// **************************************************************************
// note: PING1 and PING2 stolen from patriots, hope you don't mind John!
PING1:
                word     $FD69
                word     $FD79
                byte     $20,$0A
                byte     0, $80
// **************************************************************************
PING2:
                word     $FD69
                word     $FD79
                byte     $0A,$0A
                byte     0, $80
// **************************************************************************
ball_lost_sound:
                word     $FE66,$FEB6
                byte     $07, $12
                byte     $07, $06
                byte     $00, $3C
                byte     $18, $80
// **************************************************************************
// entries following must be copied to vectrex ram...
// start of 'my ram'
_copy_start:
// **************************************************************************
_score_string:
                byte   hi(SCORE_TEXT_SIZE)
                byte   lo(SCORE_TEXT_SIZE)
                byte   SCORE_YPOS, SCORE_XPOS
_score_only_string:
                byte   "SCORE:"
_no_score_string:
                byte   "000000", $80
_level_string:
                byte   hi(SCORE_TEXT_SIZE)
                byte   lo(SCORE_TEXT_SIZE)
                byte   LEVEL_YPOS, LEVEL_XPOS
                byte   "HITS:"
_no_level_string:
                byte   "000000", $80
_balls_string:
                byte   hi(SCORE_TEXT_SIZE)
                byte   lo(SCORE_TEXT_SIZE)
                byte   BALLS_YPOS, BALLS_XPOS
                byte   "BALLS:"
_no_balls:
                byte    BALLS_PER_GAME,$80
_string_list_end:
                byte   0
// **************************************************************************
_bottom_paddle:
                byte    3                    // 4 vectors are drawn
_bottom_paddle_scale:
                byte    PADDLE_SCALE_INIT    // 4 size of paddle
                byte    0,   PADDLE_WIDTH    // next point relativ (y,x)
                byte   PADDLE_HIGHT,    0    // next point relativ (y,x)
                byte    0,  -PADDLE_WIDTH    // next point relativ (y,x)
                byte  -PADDLE_HIGHT,    0    // next point relativ (y,x)
// **************************************************************************
_court1:
                byte    2                    // 3 vectors are drawn
_court1_scale1:
                byte    COURT1_SCALE_INIT2   // size of court
                byte    SIZE_OF_WALL1,     0 // next point relativ (y,x)
                byte      0,   SIZE_OF_WALL1 // next point relativ (y,x)
                byte   -SIZE_OF_WALL1,     0 // next point relativ (y,x)
// **************************************************************************
_copy_end:
// **************************************************************************
