EESchema Schematic File Version 4
LIBS:BurnedHead-cache
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 6
Title "Burned Head"
Date "2019-11-10"
Rev "A"
Comp "Justin Alexander"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 4525 2250 750  650 
U 5D50BAEE
F0 "PowerAndUSB" 50
F1 "PowerAndUSB.sch" 50
F2 "VSUPPLY" O L 4525 2450 50 
F3 "3V3" O R 5275 2400 50 
F4 "VSS" I R 5275 2525 50 
F5 "ON_SWITCH_5V" O R 5275 2725 50 
F6 "POWER_EN" O R 5275 2825 50 
F7 "BATT_STAT" I R 5275 2625 50 
$EndSheet
$Sheet
S 3025 2350 1050 1900
U 5D5104C9
F0 "LCD" 50
F1 "LCD.sch" 50
F2 "LCD_B[0...7]" O R 4075 4200 50 
F3 "LCD_G[0...7]" O R 4075 4100 50 
F4 "LCD_R[0...7]" O R 4075 4000 50 
F5 "VSS" I R 4075 2650 50 
F6 "3V3" I R 4075 2550 50 
F7 "LCD_NRESET" I R 4075 3400 50 
F8 "LCD_DE" I R 4075 3600 50 
F9 "LCD_HSYNC" I R 4075 3900 50 
F10 "LCD_VSYNC" I R 4075 3800 50 
F11 "LCD_DCLK" I R 4075 3700 50 
F12 "LCD_VLED" I R 4075 2450 50 
F13 "LCD_DIM" I R 4075 3300 50 
$EndSheet
Text Label 5275 2400 0    50   ~ 0
VDD
Text Label 4075 2550 0    50   ~ 0
VDD
Text Label 5275 2525 0    50   ~ 0
VSS
Text Label 4075 2650 0    50   ~ 0
VSS
Wire Wire Line
	4075 2450 4525 2450
$Sheet
S 5625 2350 1450 2800
U 5D53885E
F0 "MCU" 50
F1 "MCU.sch" 50
F2 "LCD_G[0...7]" I L 5625 4100 50 
F3 "LCD_B[0...7]" I L 5625 4200 50 
F4 "LCD_DIM" I L 5625 3300 50 
F5 "LCD_NRESET" I L 5625 3400 50 
F6 "LCD_DE" I L 5625 3600 50 
F7 "LCD_CLK" I L 5625 3700 50 
F8 "LCD_VSYNC" I L 5625 3800 50 
F9 "LCD_HSYNC" I L 5625 3900 50 
F10 "VDD" I L 5625 2475 50 
F11 "VSS" I L 5625 2575 50 
F12 "POWER_EN" I L 5625 2825 50 
F13 "ON_SWITCH_5V" I L 5625 2725 50 
F14 "LCD_R[0...7]" I L 5625 4000 50 
F15 "SDMMC_CK" I R 7075 2900 50 
F16 "SDMMC_CMD" I R 7075 3000 50 
F17 "SDMMC_DETECT" I R 7075 3100 50 
F18 "SDMMC_D[0...3]" I R 7075 2800 50 
F19 "LEFT_STICK_X" I R 7075 4725 50 
F20 "LEFT_STICK_Y" I R 7075 4800 50 
F21 "RIGHT_STICK_X" I R 7075 4450 50 
F22 "RIGHT_STICK_Y" I R 7075 4525 50 
F23 "BUT_A" I R 7075 4075 50 
F24 "BUT_B" I R 7075 4150 50 
F25 "BUT_X" I R 7075 4225 50 
F26 "BUT_Y" I R 7075 4300 50 
F27 "BUT_U" I R 7075 3725 50 
F28 "BUT_D" I R 7075 3800 50 
F29 "BUT_L" I R 7075 3875 50 
F30 "BUT_R" I R 7075 3950 50 
F31 "BUT_LSTICK" I R 7075 4875 50 
F32 "BUT_RSTICK" I R 7075 4600 50 
F33 "BUT_SEL" I R 7075 5000 50 
F34 "BUT_START" I R 7075 5100 50 
F35 "BUT_RTRIG" I R 7075 3575 50 
F36 "BUT_LTRIG" I R 7075 3500 50 
F37 "BATT_STAT" I L 5625 2650 50 
$EndSheet
Wire Wire Line
	4075 3900 5625 3900
Wire Wire Line
	4075 3800 5625 3800
Wire Wire Line
	4075 3700 5625 3700
Wire Wire Line
	4075 3600 5625 3600
Wire Wire Line
	4075 3400 5625 3400
Wire Wire Line
	4075 3300 5625 3300
Wire Wire Line
	5275 2825 5625 2825
$Sheet
S 7575 2425 800  850 
U 5D7F744B
F0 "MicroSDCard" 50
F1 "MicroSDCard.sch" 50
F2 "3V3" I L 7575 2550 50 
F3 "VSS" I L 7575 2650 50 
F4 "SDMMC_CMD" I L 7575 3000 50 
F5 "SDMMC_CK" I L 7575 2900 50 
F6 "SDMMC_DETECT" I L 7575 3100 50 
F7 "SDMMC_D[0...3]" I L 7575 2800 50 
$EndSheet
Text Label 7575 2550 2    50   ~ 0
VDD
Text Label 7575 2650 2    50   ~ 0
VSS
Text Label 5625 2475 2    50   ~ 0
VDD
Text Label 5625 2575 2    50   ~ 0
VSS
Wire Bus Line
	4075 4000 5625 4000
Wire Bus Line
	4075 4100 5625 4100
Wire Bus Line
	7075 2800 7575 2800
Wire Wire Line
	7075 2900 7575 2900
Wire Wire Line
	7075 3000 7575 3000
Wire Wire Line
	7075 3100 7575 3100
Wire Bus Line
	4075 4200 5625 4200
$Sheet
S 7425 3675 1225 1475
U 5D951D45
F0 "Buttons" 50
F1 "Buttons.sch" 50
F2 "GND" I R 8650 4575 50 
F3 "VREF" I R 8650 4350 50 
F4 "BUT_X" I L 7425 4225 50 
F5 "BUT_Y" I L 7425 4300 50 
F6 "BUT_B" I L 7425 4150 50 
F7 "BUT_A" I L 7425 4075 50 
F8 "BUT_D" I L 7425 3800 50 
F9 "BUT_R" I L 7425 3950 50 
F10 "BUT_U" I L 7425 3725 50 
F11 "BUT_L" I L 7425 3875 50 
F12 "BUT_SEL" I L 7425 5000 50 
F13 "BUT_START" I L 7425 5100 50 
F14 "AGND" I R 8650 4450 50 
F15 "BUT_LSTICK" I L 7425 4875 50 
F16 "LSTICK_X" I L 7425 4725 50 
F17 "LSTICK_Y" I L 7425 4800 50 
F18 "BUT_RSTICK" I L 7425 4600 50 
F19 "RSTICK_X" I L 7425 4450 50 
F20 "RSTICK_Y" I L 7425 4525 50 
F21 "BUT_LTRIG" I R 8650 3900 50 
F22 "BUT_RTRIG" I R 8650 3800 50 
$EndSheet
Text Label 8825 4350 2    50   ~ 0
VDD
Text Label 8825 4450 2    50   ~ 0
VSS
Wire Wire Line
	8650 4350 8825 4350
Wire Wire Line
	8650 4450 8825 4450
Wire Wire Line
	8650 4575 8825 4575
Text Label 8825 4575 2    50   ~ 0
VSS
Wire Wire Line
	7425 3725 7075 3725
Wire Wire Line
	7425 3800 7075 3800
Wire Wire Line
	7425 3875 7075 3875
Wire Wire Line
	7425 3950 7075 3950
Wire Wire Line
	7425 4075 7075 4075
Wire Wire Line
	7425 4150 7075 4150
Wire Wire Line
	7425 4225 7075 4225
Wire Wire Line
	7425 4300 7075 4300
Wire Wire Line
	7425 4450 7075 4450
Wire Wire Line
	7425 4525 7075 4525
Wire Wire Line
	7425 4600 7075 4600
Wire Wire Line
	7425 4725 7075 4725
Wire Wire Line
	7425 4800 7075 4800
Wire Wire Line
	7425 4875 7075 4875
Wire Wire Line
	7425 5000 7075 5000
Wire Wire Line
	7425 5100 7075 5100
Wire Wire Line
	8650 3800 8675 3800
Wire Wire Line
	8675 3800 8675 3575
Wire Wire Line
	8675 3575 7075 3575
Wire Wire Line
	8650 3900 8725 3900
Wire Wire Line
	7075 3500 8725 3500
Wire Wire Line
	8725 3500 8725 3900
Wire Wire Line
	5275 2625 5450 2625
Wire Wire Line
	5450 2625 5450 2650
Wire Wire Line
	5450 2650 5625 2650
Wire Wire Line
	5275 2725 5625 2725
$EndSCHEMATC
