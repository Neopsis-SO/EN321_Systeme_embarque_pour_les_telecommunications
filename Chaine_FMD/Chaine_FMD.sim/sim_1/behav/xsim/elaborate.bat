@echo off
REM ****************************************************************************
REM Vivado (TM) v2019.2 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Tue Oct 19 10:53:15 +0200 2021
REM SW Build 2708876 on Wed Nov  6 21:40:23 MST 2019
REM
REM Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 6cf68de89a02486e9b5d54ff3570c936 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_transmitter_behav xil_defaultlib.tb_transmitter -log elaborate.log"
call xelab  -wto 6cf68de89a02486e9b5d54ff3570c936 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_transmitter_behav xil_defaultlib.tb_transmitter -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
