# Zybo Dice Roller Game

This project implements a digital dice roller game on the **Zybo Z7 FPGA board**, using a **two-digit 7-segment display (SSD)** and a **Linear Feedback Shift Register (LFSR)** to simulate random number generation.

---

## Project Overview

- The game simulates rolling a six-sided die (D6).
- The output is shown one digit at a time on a **dual-digit 7-segment display**.
- It uses a **pseudo-random number generator (PRNG)** based on a **Linear Feedback Shift Register (LFSR)**.
- The player presses a **button to roll the dice**, alternating which digit (left or right) displays the result.

---

## How It Works

1. **Initial State**  
   The display starts at `00`.

2. **First Button Press**  
   - The LFSR generates a pseudo-random number between 1 and 6.  
   - The number is shown on the **right digit** of the SSD (J1).  
   - The left digit is set to `0`.

3. **Second Button Press**  
   - Another random number is generated (independent of the first).  
   - It’s displayed on the **left digit** (J2).  
   - The right digit resets to `0`.

4. This pattern continues, alternating on each digit side the display with each roll.

---

## Linear Feedback Shift Register (LFSR)

An LFSR (Linear Feedback Shift Register) is a hardware method to generate a sequence of random numbers.  Since there is no proper random function in Verilog out of the box.

- A 4-bit LFSR** is used.
- The value is modulo 6 (`% 6`) and offset by 1** to map into the range `[1, 6]`, representing a fair D6 roll.

## To do
1. Add pictures
2. Create video 
3. Add button debouncer
