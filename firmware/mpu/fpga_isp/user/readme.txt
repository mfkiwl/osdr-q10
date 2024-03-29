*************************************************************************
   ____  ____ 
  /   /\/   / 
 /___/  \  /   
 \   \   \/    � Copyright 2012 Xilinx, Inc. All rights reserved.
  \   \        This file contains confidential and proprietary 
  /   /        information of Xilinx, Inc. and is protected under U.S. 
 /___/   /\    and international copyright and other intellectual 
 \   \  /  \   property laws. 
  \___\/\___\ 
 
*************************************************************************

Vendor: Xilinx 
Current readme.txt Version: 1.0
Date Last Modified: 05/21/2012
Date Created:  05/21/2012

Associated Filename: xapp583.zip
Associated Document: 
   XAPP583, Using a Microprocessor to Configure 7 Series FPGAs via Slave
   Serial or Slave SelectMAP Mode

Supported Device(s):  Virtex-6 FPGAs, Spartan-6 FPGAs, Kintex-7 FPGAs,
Virtex-7 FPGAs, Artix-7 FPGAs
   
*************************************************************************

Disclaimer: 

      This disclaimer is not a license and does not grant any rights to 
      the materials distributed herewith. Except as otherwise provided in 
      a valid license issued to you by Xilinx, and to the maximum extent 
      permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE 
      "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL 
      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
      INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, 
      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and 
      (2) Xilinx shall not be liable (whether in contract or tort, 
      including negligence, or under any other theory of liability) for 
      any loss or damage of any kind or nature related to, arising under 
      or in connection with these materials, including for any direct, or 
      any indirect, special, incidental, or consequential loss or damage 
      (including loss of data, profits, goodwill, or any type of loss or 
      damage suffered as a result of any action brought by a third party) 
      even if such damage or loss was reasonably foreseeable or Xilinx 
      had been advised of the possibility of the same.

Critical Applications:

      Xilinx products are not designed or intended to be fail-safe, or 
      for use in any application requiring fail-safe performance, such as 
      life-support or safety devices or systems, Class III medical 
      devices, nuclear facilities, applications related to the deployment 
      of airbags, or any other applications that could lead to death, 
      personal injury, or severe property or environmental damage 
      (individually and collectively, "Critical Applications"). Customer 
      assumes the sole risk and liability of any use of Xilinx products 
      in Critical Applications, subject only to applicable laws and 
      regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS 
FILE AT ALL TIMES.

*************************************************************************

This readme file contains these sections:

1. REVISION HISTORY
2. OVERVIEW
3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS
4. DESIGN FILE HIERARCHY
5. INSTALLATION AND OPERATING INSTRUCTIONS
6. OTHER INFORMATION
7. SUPPORT


1. REVISION HISTORY 

            Readme  
Date        Version      Revision Description
=========================================================================
05/21/2012  1.0          Initial Xilinx release.
=========================================================================

2. OVERVIEW

This README describes how to use the files that come with XAPP583

There are two C source files, slave_serial.c and slave_selectmap.c.

There is also a xparameters.h file which includes #define macro
definitions that describe a hardware system these C files could target.


3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS

These C files have been tested on MicroBlaze with the GNU GCC compiler
called from within the EDK SDK environment:
    mb-gcc (GCC) 4.1.2 20070214 (Xilinx 13.4 Build EDK_O.87 25 Nov 2011)

4. DESIGN FILE HIERARCHY
    \slave_serial.c
    \slave_selectmap.c
    \xparamters.h
    \readme.txt

5. INSTALLATION AND OPERATING INSTRUCTIONS 

The C files are targeted for memory mapped IO processors such as
MicroBlaze or ARM. The memory mapping for the GPIO peripheral are stored
in the xparameters.h file. This should be adjusted for the target system.

6. OTHER INFORMATION

The #define VERBOSE, #define DEBUG, and #define DEBUG2, macros are only
used for displaying potentially useful information to stdout if a UART is
available in the system. Comment all of these if UART is not available.
The DEBUG #define enables printing the same information passed onto the
DIN or D[07:00] ports to stdout. This can be useful to check that the
correct data is being sent over the data bus, but is extremely slow.

7. SUPPORT

To obtain technical support for this reference design, go to 
www.xilinx.com/support to locate answers to known issues in the Xilinx
Answers Database or to create a WebCase.  
