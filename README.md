# Simple Processor Project

Design of a simple processor with an 8-bit ALU and a ROM block  
(This project is mainly built for DE-10 Lite)

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

|     Input   |   Pin   |  Signal Name  |
|    :---:    |  :---:  |     :---:     |
|   MemClock  |  PIN_B8 |      KEY0     |
|   PCClock   |  PIN_A7 |      KEY1     |
|    Reset    | PIN_C10 |      SW0      |
|     Run     | PIN_C11 |      SW1      |
|   SysClock  | PIN_P11 | MAX10_CLK1_50 |
