@echo off
TITLE First Time Setup
color 30

:CHOOSE_LAN
CLS
echo. ----------------------------------------
echo. 
echo. 
echo. e. English
echo. 
echo. c. Simplified Chinese ��������
echo. 
echo. x. EXIT
echo. 
echo. 
echo. ----------------------------------------
set choice=
set /p choice= Select Language and Press Enter:
IF NOT "%Choice%"=="" SET Choice=%Choice:~0,1%
if /i "%choice%"=="e" goto ENGLISH
if /i "%choice%"=="c" goto SCHINESE
if /i "%choice%"=="x" goto EXIT
echo.
goto CHOOSE_LAN

:ENGLISH
set opt_prompt1= 1. Automatic
set opt_prompt2= 2. Install TightVNC
set opt_prompt3= 3. Generate Script
set opt_prompt4= 4. Exit

set choice_prompt= Choose 1 for fresh setup and press Enter

set install_prompt1= Select "Complete" Setup unless you know what you are doing
set install_prompt2= You will be prompted to set up passwords for Remote Access and Administration
set install_prompt3= Select "Do not change" for both if you want less trouble

set install_prompt4= Installation Finished?

set profile_prompt1= Enter your Utorid
set profile_prompt2= Enter your UG password. It's your student number by default.

set profile_disclaimer1= DISCLAIMER!! Your password will be saved locally on this computer!
set profile_disclaimer2= Do not use this script on a public computer!!

set profile_prompt3= Set up a password for remote connection(at least 6 characters)

set profile_prompt4= Press any key to connect to the UG server, but plz read the following lines first
set profile_underline= -----------------------------------------------------------
set profile_prompt5= You don't need to enter anything in the upcoming window.
set profile_prompt6= Remember to close the upcoming BLACK Terminal when you see the the prompt
set profile_prompt7= ��Would you like to enter a view-only password (y/n)? n��
set profile_prompt8= Now you can press any key to continue
set fileName1= Tunnel
set fileName2= Remote

set finish_prompt1= Initialization finished! For further connections, you just need to
set finish_prompt2= Double click on "Remote.bat" to connect
set finish_prompt3= Press any key to show main menu


set enterMachineCode1= When the connection is established, the number after "ugXXX.eecg.toronto.edu :"
set enterMachineCode2= suggests how many people are using this remote machine. If you see any number other than 1,
set enterMachineCode3=  close all scripts and choose a different machine. (It's hard to set up even manually in this situation)
set enterMachineCode4= Please choose a machine from 132-180 or 201-249:

goto MENU

:SCHINESE
TITLE �״�����
set opt_prompt1= 1. ȫ�Զ�
set opt_prompt2= 2. ��װ TightVNC
set opt_prompt3= 3. �����Զ������ļ�
set opt_prompt4= 4. �˳�

set choice_prompt= �����ɶ����֪����ѡ1��

set install_prompt1= ��װѡ��ѡ��Complete��
set install_prompt2= ����ʾ�Ƿ����÷��ʺ͹������룬
set install_prompt3= ���鲻���ã���"Do not change"

set install_prompt4= װ��û

set profile_prompt1=����Զ���˻���¼��(Utorid)
set profile_prompt2= ����ug�˻����룬Ĭ��Ϊѧ��

set profile_disclaimer1= ����!! ��ĵ�½���뽫�����ڵ��Ա���
set profile_disclaimer2= �벻Ҫ�ڹ���������ʹ�øýű�!!

set profile_prompt3= ���Զ�����ӵĵ�¼���룬����6λ��

set profile_prompt4= ���������ʼ���ӵ�UG�����������Զ�������ã������Ķ����²�����
set profile_underline= -----------------------------------------------------------
set profile_prompt5= �ڼ��������Ĵ����в�������κ�����
set profile_prompt6= �ڳ��֡�Would you like to enter a view-only password (y/n)? n����
set profile_prompt7= ���ú�ɫ�����ر�}
set profile_prompt8= ���ڣ������������

set fileName1= ���
set fileName2= Զ������

set finish_prompt1= ��ʼ�����! �Ժ�����ʱֻ��
set finish_prompt2= ˫��"Զ������.bat" ����
set finish_prompt3= ��������������˵�

set enterMachineCode1= ������ɺ��ն˴�����"ugXXX.eecg.toronto.edu :"�������
set enterMachineCode2= ��ζ���ж���������ʹ�ø�Զ�̷��������������һ��ʹ�ø÷�������
set enterMachineCode3=  ��ر����нű�������ѡ����һ̨�����������������ӷ�ʽ������ͷ�������Լ���������
set enterMachineCode4= ���� 132-180 �� 201-249 ѡ�������������س�ȷ����

goto MENU

:MENU
CLS
echo. ----------------------------------------
echo. 
echo. %opt_prompt1%
echo. %opt_prompt2%
echo. %opt_prompt3%
echo. %opt_prompt4%
echo. 
echo. ----------------------------------------
echo. %profile_disclaimer1%
echo. %profile_disclaimer2%
echo. ----------------------------------------
echo. 
set choice=
set /p choice= %choice_prompt%:
IF NOT "%Choice%"=="" SET Choice=%Choice:~0,1%
if /i "%choice%"=="1" goto AUTO
if /i "%choice%"=="2" goto INSTALL
if /i "%choice%"=="3" goto SETPASSWORD
if /i "%choice%"=="4" goto EXIT
echo.
goto MENU

:AUTO
CLS
start tightvnc-2.8.11-gpl-setup-64bit.msi
set "reply=y"
echo. 
echo. %install_prompt1%
echo. %install_prompt2%
echo. %install_prompt3%
echo. 
set /p "reply=%install_prompt4%? [y|n]: "
if /i not "%reply%" == "y" goto :eof

CLS
echo. %profile_prompt1%
set /P userName=: 

echo. %profile_prompt2%

set /P realPassword=: 

echo. %profile_prompt3%
set /P fakePassword=: 
CLS
echo. 
echo. %profile_prompt4%
echo. 
echo. %profile_underline% 
echo. %profile_prompt5%
echo. %profile_prompt6%
echo. %profile_prompt7%
echo. %profile_underline% 
echo. 
echo. %profile_prompt8%
PAUSE >nul
set /a ranMachine=132+(%random%*49/32768)
kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%ranMachine%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc password\n\p\p\p\p%fakePassword%\n\p\p\p\p%fakePassword%\n\p\p\p\pn\n"

@echo @echo off > %fileName2%.bat
@echo echo. %enterMachineCode1% >> %fileName2%.bat
@echo echo. %enterMachineCode2% >> %fileName2%.bat
@echo echo. %enterMachineCode3% >> %fileName2%.bat
@echo echo. %enterMachineCode4% >> %fileName2%.bat
@echo set /P machineCode=: >> %fileName2%.bat

@echo @echo kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%%machineCode%%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc stop all \n \p \p  ece297vnc start"  ^> %fileName1%.bat >> %fileName2%.bat

@echo start %fileName1%.bat>> %fileName2%.bat
@echo TIMEOUT 8 >> %fileName2%.bat
@echo "C:\Program Files\TightVNC\tvnviewer.exe" 127.0.0.1:1 -password=%fakePassword%>> %fileName2%.bat

CLS
echo. %finish_prompt1%
echo. %finish_prompt2%
echo. %finish_prompt3%
PAUSE >nul

goto MENU

:INSTALL
CLS
start tightvnc-2.8.11-gpl-setup-64bit.msi
set "reply=y"
echo. 
echo. %install_prompt1%
echo. %install_prompt2%
echo. %install_prompt3%
echo. 
set /p "reply=%install_prompt4%? [y|n]: "
if /i not "%reply%" == "y" goto :eof
goto MENU

:SETPASSWORD
CLS
echo. %profile_prompt1%
set /P userName=: 

echo. %profile_prompt2%

set /P realPassword=: 

echo. %profile_prompt3%
set /P fakePassword=: 
CLS
echo. 
echo. %profile_prompt4%
echo. 
echo. %profile_underline% 
echo. %profile_prompt5%
echo. %profile_prompt6%
echo. %profile_prompt7%
echo. %profile_underline% 
echo. 
echo. %profile_prompt8%
PAUSE >nul
set /a ranMachine=132+(%random%*49/32768)
kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%ranMachine%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc password\n\p\p\p\p%fakePassword%\n\p\p\p\p%fakePassword%\n\p\p\p\pn\n"

@echo @echo off > %fileName2%.bat
@echo echo. %enterMachineCode1% >> %fileName2%.bat
@echo echo. %enterMachineCode2% >> %fileName2%.bat
@echo echo. %enterMachineCode3% >> %fileName2%.bat
@echo echo. %enterMachineCode4% >> %fileName2%.bat
@echo set /P machineCode=: >> %fileName2%.bat

@echo @echo kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%%machineCode%%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc stop all \n \p \p  ece297vnc start"  ^> %fileName1%.bat >> %fileName2%.bat

@echo start %fileName1%.bat>> %fileName2%.bat
@echo TIMEOUT 8 >> %fileName2%.bat
@echo "C:\Program Files\TightVNC\tvnviewer.exe" 127.0.0.1:1 -password=%fakePassword%>> %fileName2%.bat

CLS
echo. %finish_prompt1%
echo. %finish_prompt2%
echo. %finish_prompt3%
PAUSE >nul
goto MENU

:EXIT
exit