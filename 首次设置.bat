@echo off
TITLE �״�����
color 30

:MENU
CLS
echo. ----------------------------------------

echo. 1. ȫ�Զ�
echo. 2. ��װTightVNC
echo. 3. �����Զ������ļ�
echo. 4. �˳�
echo. ----------------------------------------

set choice=
set /p choice= �����ɶ����֪���Ͱ�1��:
IF NOT "%Choice%"=="" SET Choice=%Choice:~0,1%
if /i "%choice%"=="1" goto AUTO
if /i "%choice%"=="2" goto INSTALL
if /i "%choice%"=="3" goto SETPASSWORD
if /i "%choice%"=="4" goto EXIT
echo.
goto MENU

:AUTO
start tightvnc-2.8.11-gpl-setup-64bit.msi
set "reply=y"
echo. ��װѡ��ѡ��Complete��
echo. ����ʾ�Ƿ����÷������룬���鲻����
set /p "reply=װ��û? [y|n]: "
if /i not "%reply%" == "y" goto :eof

echo. ����Զ���˻���¼��
set /P userName=: 

echo. ����ug�˻����룬Ĭ��Ϊѧ��
set /P realPassword=: 

echo. ���Զ�����ӵĵ�¼���룬����6λ��
set /P fakePassword=: 

echo. [�ڳ��֡�Would you like to enter a view-only password (y/n)? n���󽫴��ڹر�]
echo. ������ѧУVNC���������Զ���ʼ�������������ʼ

PAUSE >nul
set /a ranMachine=132+(%random%*49/32768)
kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%ranMachine%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc password\n\p\p\p\p%fakePassword%\n\p\p\p\p%fakePassword%\n\p\p\p\pn\n"

@echo @echo on > ���.bat
@echo set /a ranMachine=132+(%%random%%*49/32768) >> ���.bat
@echo kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%%ranMachine%%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc stop all \n \p \p  ece297vnc start" >> ���.bat

@echo start ���.bat > Զ������.bat
@echo TIMEOUT 8 >> Զ������.bat
@echo "C:\Program Files\TightVNC\tvnviewer.exe" 127.0.0.1:1 -password=%fakePassword% >> Զ������.bat

echo. ��ʼ�����
echo. ˫����Զ������.bat�����ɽ�������
echo. ��������������˵�
PAUSE >nul

goto MENU

:INSTALL
start tightvnc-2.8.11-gpl-setup-64bit.msi
set "reply=y"
set /p "reply=װ��û? [y|n]: "
if /i not "%reply%" == "y" goto :eof
goto MENU

:SETPASSWORD

echo. ����Զ���˻���¼��
set /P userName=: 

echo. ����ug�˻����룬Ĭ��Ϊѧ��
set /P realPassword=: 

echo. ���Զ�����ӵĵ�¼���룬����6λ��
set /P fakePassword=: 

echo. [�ڳ��֡�Would you like to enter a view-only password (y/n)? n���󽫴��ڹر�]
echo. ������ѧУVNC���������Զ���ʼ�������������ʼ

PAUSE >nul
set /a ranMachine=132+(%random%*49/32768)
kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%ranMachine%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc password\n\p\p\p\p%fakePassword%\n\p\p\p\p%fakePassword%\n\p\p\p\pn\n"

@echo @echo on > ���.bat
@echo set /a ranMachine=132+(%%random%%*49/32768) >> ���.bat
@echo kitty_portable.exe -ssh -L 5901:127.0.0.1:5901 %userName%@ug%%ranMachine%%.eecg.toronto.edu -pw %realPassword% -cmd "ece297vnc stop all \n \p \p  ece297vnc start" >> ���.bat

@echo start ���.bat > Զ������.bat
@echo TIMEOUT 8 >> Զ������.bat
@echo "C:\Program Files\TightVNC\tvnviewer.exe" 127.0.0.1:1 -password=%fakePassword% >> Զ������.bat

echo. ��ʼ�����
echo. ˫����Զ������.bat�����ɽ�������
echo. ��������������˵�
PAUSE >nul

goto MENU
:EXIT
exit