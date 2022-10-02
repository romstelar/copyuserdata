@ECHO OFF
COLOR A
CHCP 866
SetLocal EnableExtensions EnableDelayedExpansion

REM ��� ��࠭塞��� ��䨫�:
SET "NCAT=%~dp0%COMPUTERNAME%\"

IF "%~1"=="b" SET "ARG=b" & GOTO SKIP_SEL_OPT
IF "%~1"=="r" SET "ARG=r" & GOTO SKIP_SEL_OPT
CLS
ECHO ******************************************************************************
ECHO �����������/�������������� �������� �������� �� �������
ECHO ******************************************************************************
ECHO.
ECHO b - ����஢��� ����ன�� (�� 㬮�砭��)
ECHO r - ����⠭����� ����ன��
ECHO.
SET "ARG=b"
SET /p "ARG=�롥�� ��ਠ��: "
:SKIP_SEL_OPT

	REM ����� �᪫�祭�� (�� �����ন������ ����� � �஡�����):
	SET "EXCLUDE=Oracle %EXCLUDE%"
	SET "EXCLUDE=Microsoft %EXCLUDE%"
	
	REM ��ࠡ�⪠ LocalLow:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%APPDATA%\..\LocalLow" "%EXCLUDE%" "%NCAT%LOCALLOW"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%LOCALLOW" "%EXCLUDE%" "%APPDATA%\..\LocalLow"
	ECHO.
	
	REM ����� �᪫�祭�� (�� �����ন������ ����� � �஡�����):
	SET "EXCLUDE=vlc %EXCLUDE%"
	SET "EXCLUDE=Apps %EXCLUDE%"
	SET "EXCLUDE=Temp %EXCLUDE%"
	SET "EXCLUDE=Sony %EXCLUDE%"
	SET "EXCLUDE=Nero %EXCLUDE%"
	SET "EXCLUDE=ABBYY %EXCLUDE%"
	SET "EXCLUDE=VMware %EXCLUDE%"
	SET "EXCLUDE=NVIDIA %EXCLUDE%"
	SET "EXCLUDE=History %EXCLUDE%"
	SET "EXCLUDE=Charles %EXCLUDE%"
	SET "EXCLUDE=Packages %EXCLUDE%"
	SET "EXCLUDE=Programs %EXCLUDE%"
	SET "EXCLUDE=STDUViewer %EXCLUDE%"
	SET "EXCLUDE=Thunderbird %EXCLUDE%"
	SET "EXCLUDE=ClassicShell %EXCLUDE%"
	
	REM ��ࠡ�⪠ Local:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%APPDATA%\..\Local" "%EXCLUDE%" "%NCAT%LOCAL"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%LOCAL" "%EXCLUDE%" "%APPDATA%\..\Local"
	ECHO.
	
	REM ����� �᪫�祭�� (�� �����ন������ ����� � �஡�����):
	SET "EXCLUDE=ABBYY %EXCLUDE%"
	SET "EXCLUDE=MPC-HC %EXCLUDE%"
	SET "EXCLUDE=WinRAR %EXCLUDE%"
	SET "EXCLUDE=NVIDIA %EXCLUDE%"
	SET "EXCLUDE=uTorrent %EXCLUDE%"
	SET "EXCLUDE=Macromedia %EXCLUDE%"
	SET "EXCLUDE=LibreOffice %EXCLUDE%"
	SET "EXCLUDE=ScreenCapture %EXCLUDE%"
	SET "EXCLUDE=regid.1986-12.com.adobe %EXCLUDE%"
	SET "EXCLUDE=regid.1991-06.com.microsoft %EXCLUDE%"
	
	REM ��ࠡ�⪠ Roaming:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%APPDATA%" "%EXCLUDE%" "%NCAT%APPDATA"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%APPDATA" "%EXCLUDE%" "%APPDATA%"
	ECHO.
	
	REM ��ࠡ�⪠ ProgramData:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%PROGRAMDATA%" "%EXCLUDE%" "%NCAT%PROGRAMDATA"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%PROGRAMDATA" "%EXCLUDE%" "%PROGRAMDATA%"
	ECHO.

GOTO SKIP_FUNC
	
	REM ������� �㭪��:
	:BACKUP_DATA
		FOR /F "tokens=*" %%A IN ('DIR "%~1" /A:D /B') DO (
			SET "T=n"
			FOR %%B IN (%~2) DO (
				IF "%%A"=="%%B" SET "T=y"
				IF "%%A"=="Start Menu" SET "T=y"
				IF "%%A"=="MSfree Inc" SET "T=y"
				IF "%%A"=="ACD Systems" SET "T=y"
				IF "%%A"=="������� ����" SET "T=y"
				IF "%%A"=="����稩 �⮫" SET "T=y"
				IF "%%A"=="Package Cache" SET "T=y"
				IF "%%A"=="Opera Software" SET "T=y"
				IF "%%A"=="Microsoft Help" SET "T=y"
				IF "%%A"=="Application Data" SET "T=y"
				IF "%%A"=="NVIDIA Corporation" SET "T=y"
				IF "%%A"=="Temporary Internet Files" SET "T=y"
			)
			IF "!T!"=="n" ROBOCOPY "%~1\%%A" "%~3\%%A" /MIR /R:1 /W:1 /MT:30 /COPYALL /B /XJ
		)
	EXIT /B

:SKIP_FUNC