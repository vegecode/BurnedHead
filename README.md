# BurnedHead

A handheld, portable video game system designed with Kicad and programmed in C.

# Description

The processor is the STM32F767ZG, a Cortex-M7 processor selected for the ample
size of the instruction and data caches.  Currently at the board bring-up stage,
the functionality includes an RGB parallel interface, an MMC card socket, a 32MB
SDRAM clocked at 108MHz, D-pad, 4 front facing buttons, 2 shoulder buttons, 2
joysticks, and a speaker. The device is powered through a Micro-USB connector or
a rechargeable LiPo battery for portability.

The final product will load user-selectable ELF files off of the MMC compatible
card into the external RAM and run them as a process.

The project originally began in Zig but is transitioning to C to reduce
friction when integrating with libraries and vendor code and to allow progress
without requiring fiddling with a language still in beta.

# Building

## Cloning the Repository

This repository uses submodules to manage dependencies.

```bash
git clone --recurse-submodules https://github.com/vegecode/BurnedHead.git
```

## Building the Application

BurnedHead uses Makefiles.
Navigate to the base directory of the clone, and
point to the specific Makefile you want to build (currently only one):

Example:

```bash
make -f configurations/${CONFIGURATION_NAME}/Makefile
```

The resulting executable(s) are in `./build/${CONFIGURATION_NAME}`

# Debugging on the Target

Debugging is done using GDB in a shell with the JLink GDBServer providing the
connection to the remote target.

Running the shell script `./debug/start_debug /path/to/elf_file` will start the
GDBServer and connect GDB to it, then a gdb script loads the executable and sets
a temporary breakpoint at the reset handler.

A sample of some external RAM tests during board bring-up in a Vim/GDB session:
![ram testing](renders/BurnedHead-R0-Ram-Testing.png)

Another easy alternative if you are using a JLink debug probe is to use Ozone,
the standalone debugger from Segger or Segger Embedded Workbench which are
both free to use for non-commercial purposes.

Integrating with Eclipse should also be possible using the MCU GNU Eclipse
plugins.

# Hand-Assembled Revision 0 Board

The back of the first revision of the board was assembled using solder paste and
a cast-iron skillet over a stand-alone burner for reflow. Some rework was
required as applying the paste without a stencil resulted in uneven application.
The front side components were hand soldered.

![assembled front](renders/BurnedHead-R0-Assembled-Front.jpg)

![assembled back](renders/BurnedHead-R0-Assembled-Back.jpg)

# Renders

![render](renders/BurnedHead-Front.jpg)

![render](renders/BurnedHead-Back.jpg)

# Attributions

Some symbols and footprints  came from www.snapeda.com. See the library folder for the required
license and attributions.
