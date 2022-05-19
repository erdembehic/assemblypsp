# assemblypsp
Assembly Picture Sliding Project
This project designed for the Microprocessor Systems lecture in Istanbul Technical University 2022 Spring term.

In this project we have a picture RGB datas inside image.c file and assembly code that makes move right down and left in 320x320 LCD screen.

 <img src="https://imgur.com/a/TBf9JRq" alt="Alt text" title="Optional title">
To run this project I use Keil.
Keil steps for the running project.
  1. Download Keil from official ARM web site.
  2. Copy 2 .dll file to Keil_v5/ARM/BIN folder.
  3. In Keil create new project 
        Select ARM Cortex M0
        Select "Target 1" fro project column on the left in default.
          Go to Project > Options for the Target 1 > Debug and paste this statement to "Dialog DLL Parameter" tab on the bottom left box "-pCM0 -dLCDDLL.dll".
          Again in same window on the top left check box, select "Use Simulator"
  4. Add image.c and main.s file to project
  5. Click "Manage Run Time Environment
      Select Device. Click Startup check box and tick it. And change its variant to empty
      After that expand CMSIS and tick Core selection check box.
   6. Build target. Use short-cut F7
   7. Start debug mode. Use short-cut Ctrl-F5 
   8. Open Peripherals > LCD
   9. Run the project. Use short-cut F5


It is done. If you have any questions contact me. erdembe17@itu.edu.tr
   
 
