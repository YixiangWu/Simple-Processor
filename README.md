# Simple Processor Project

Design of a simple processor with an 8-bit ALU and a ROM block  
(This project is mainly built for DE-10 Lite)  
**Top-Level Entity: main.vhd**

## Input/Output Descriptions

- Inputs:  
  - MemClock: memory clock  
  - PCClock: processor clock  
  - Reset: **active-low** Reset that resets both the processor block and the ROM block  
  - Run: **active-high** Run for the processor block  
  - SysClock: system clock  
- Outputs:  
  - Done: signals the instruction is done  
  - BusWires: displays instruction codes, immediate values, and operation results  
  - Hex0, Hex1: present hexadecimal operation results on 7-segment displays

## Pin Assignments for **DE-10 Lite**

|    Output   |   Pin   |  Signal Name  |
|    :---:    |  :---:  |     :---:     |
|     Done    | PIN_B11 |      LEDR9    |
| BusWires[7] | PIN_D14 |      LEDR7    |
| BusWires[6] | PIN_E14 |      LEDR6    |
| BusWires[5] | PIN_C13 |      LEDR5    |
| BusWires[4] | PIN_D13 |      LEDR4    |
| BusWires[3] | PIN_B10 |      LEDR3    |
| BusWires[2] | PIN_A10 |      LEDR2    |
| BusWires[1] |  PIN_A9 |      LEDR1    |
| BusWires[0] |  PIN_A8 |      LEDR0    |
|   Hex0[7]   | PIN_D15 |      HEX07    |
|   Hex0[6]   | PIN_C17 |      HEX06    |
|   Hex0[5]   | PIN_D17 |      HEX05    |
|   Hex0[4]   | PIN_E16 |      HEX04    |
|   Hex0[3]   | PIN_C16 |      HEX03    |
|   Hex0[2]   | PIN_C15 |      HEX02    |
|   Hex0[1]   | PIN_E15 |      HEX01    |
|   Hex0[0]   | PIN_C14 |      HEX00    |
|   Hex1[7]   | PIN_A16 |      HEX17    |
|   Hex1[6]   | PIN_B17 |      HEX16    |
|   Hex1[5]   | PIN_A18 |      HEX15    |
|   Hex1[4]   | PIN_A17 |      HEX14    |
|   Hex1[3]   | PIN_B16 |      HEX13    |
|   Hex1[2]   | PIN_E18 |      HEX12    |
|   Hex1[1]   | PIN_D18 |      HEX11    |
|   Hex1[0]   | PIN_C18 |      HEX10    |

|     Input   |   Pin   |  Signal Name  |
|    :---:    |  :---:  |     :---:     |
|   MemClock  |  PIN_B8 |      KEY0     |
|   PCClock   |  PIN_A7 |      KEY1     |
|    Reset    | PIN_C10 |      SW0      |
|     Run     | PIN_C11 |      SW1      |
|   SysClock  | PIN_P11 | MAX10_CLK1_50 |
