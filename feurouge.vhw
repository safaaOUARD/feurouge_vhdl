--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2i
--  \   \         Application : ISE
--  /   /         Filename : feurouge.vhw
-- /___/   /\     Timestamp : Thu Apr 23 10:43:52 2026
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: feurouge
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY feurouge IS
END feurouge;

ARCHITECTURE testbench_arch OF feurouge IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT feu_tricolore
        PORT (
            CLK : In std_logic;
            RST : In std_logic;
            R_A : Out std_logic;
            O_A : Out std_logic;
            V_A : Out std_logic;
            R_B : Out std_logic;
            O_B : Out std_logic;
            V_B : Out std_logic
        );
    END COMPONENT;

    SIGNAL CLK : std_logic := '0';
    SIGNAL RST : std_logic := '0';
    SIGNAL R_A : std_logic := '0';
    SIGNAL O_A : std_logic := '0';
    SIGNAL V_A : std_logic := '0';
    SIGNAL R_B : std_logic := '0';
    SIGNAL O_B : std_logic := '0';
    SIGNAL V_B : std_logic := '0';

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : feu_tricolore
        PORT MAP (
            CLK => CLK,
            RST => RST,
            R_A => R_A,
            O_A => O_A,
            V_A => V_A,
            R_B => R_B,
            O_B => O_B,
            V_B => V_B
        );

        PROCESS    -- clock process for CLK
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                CLK <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                CLK <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            BEGIN
                -- -------------  Current Time:  185ns
                WAIT FOR 185 ns;
                RST <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  385ns
                WAIT FOR 200 ns;
                RST <= '0';
                -- -------------------------------------
                WAIT FOR 815 ns;

            END PROCESS;

    END testbench_arch;

