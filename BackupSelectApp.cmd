@ECHO OFF
COLOR A
CHCP 866
SetLocal EnableExtensions EnableDelayedExpansion
ECHO @ECHO OFF >"%~dp0exec.cmd"
ECHO @ECHO OFF >"%~dp0rvexec.cmd"
REM Имя сохраняемого профиля:
SET "NCAT=%COMPUTERNAME%\"

IF "%~1"=="b" SET "ARG=b" & GOTO SKIP_SEL_OPT
IF "%~1"=="r" SET "ARG=r" & GOTO SKIP_SEL_OPT
CLS
ECHO ******************************************************************************
ECHO КОПИРОВАНИЕ/ВОССТАНОВЛЕНИЕ НАСТРОЕК ВЫБРАННЫХ ПРОГРАММ ИЗ ПРОФИЛЯ
ECHO ******************************************************************************
ECHO.
ECHO b - Копировать настройки (по умолчанию)
ECHO r - Восстановить настройки
ECHO.
SET "ARG=b"
SET /p "ARG=Выберите вариант: "
:SKIP_SEL_OPT

	REM Папки исключения (не поддерживаются папки с пробелами):
	SET "EXCLUDE=Microsoft %EXCLUDE%"
	
	REM Обработка LocalLow:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%APPDATA%\..\LocalLow" "%EXCLUDE%" "%NCAT%LOCALLOW" "LocalLow"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%LOCALLOW" "%EXCLUDE%" "%APPDATA%\..\LocalLow" "LocalLow"
	ECHO.
	
	REM Папки исключения (не поддерживаются папки с пробелами):
	SET "EXCLUDE=vlc %EXCLUDE%"
	SET "EXCLUDE=Apps %EXCLUDE%"
	SET "EXCLUDE=Temp %EXCLUDE%"
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
	
	REM Обработка Local:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%APPDATA%\..\Local" "%EXCLUDE%" "%NCAT%LOCAL" "Local"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%LOCAL" "%EXCLUDE%" "%APPDATA%\..\Local" "Local"
	ECHO.
	
	REM Папки исключения (не поддерживаются папки с пробелами):
	SET "EXCLUDE=ABBYY %EXCLUDE%"
	SET "EXCLUDE=MPC-HC %EXCLUDE%"
	SET "EXCLUDE=WinRAR %EXCLUDE%"
	SET "EXCLUDE=NVIDIA %EXCLUDE%"
	SET "EXCLUDE=uTorrent %EXCLUDE%"
	SET "EXCLUDE=Desktop %EXCLUDE%"
	SET "EXCLUDE=Шаблоны %EXCLUDE%"
	SET "EXCLUDE=Документы %EXCLUDE%"
	SET "EXCLUDE=Documents %EXCLUDE%"
	SET "EXCLUDE=Templates %EXCLUDE%"
	SET "EXCLUDE=Macromedia %EXCLUDE%"
	SET "EXCLUDE=LibreOffice %EXCLUDE%"
	SET "EXCLUDE=ScreenCapture %EXCLUDE%"
	SET "EXCLUDE=regid.1986-12.com.adobe %EXCLUDE%"
	SET "EXCLUDE=regid.1991-06.com.microsoft %EXCLUDE%"
	
	REM Обработка Roaming:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%APPDATA%" "%EXCLUDE%" "%NCAT%APPDATA" "Roaming"
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%APPDATA" "%EXCLUDE%" "%APPDATA%" "Roaming"
	ECHO.
	
	REM Обработка ProgramData:
	IF "!ARG!"=="b" CALL :BACKUP_DATA "%PROGRAMDATA%" "%EXCLUDE%" "%NCAT%PROGRAMDATA" ""
	IF "!ARG!"=="r" CALL :BACKUP_DATA "%NCAT%PROGRAMDATA" "%EXCLUDE%" "%PROGRAMDATA%" ""
	ECHO.
	
	REM Запуск копирования/восстановления выбранных приложений:
	CALL "%~dp0exec.cmd"

GOTO SKIP_FUNC
	
	REM Главная фукнция:
	:BACKUP_DATA
		SET "JH="
		SET "STH="
		SET "KEYS=/MIR /R:1 /W:1 /MT:30 /COPYALL /B /XJ"
		:mBACKUP_DATA
		CLS
		ECHO ******************************************************************************
		IF "!ARG!"=="b" ECHO КОПИРОВАНИЕ %~1
		IF "!ARG!"=="r" ECHO ВОССТАНОВЛЕНИЕ %~1
		ECHO ******************************************************************************
		ECHO.
		SET /A "H=0"
		FOR /F "tokens=*" %%N IN ('DIR "%~1" /A:D /B') DO (
		
			REM Обработка папок исключений:
			SET "T=n"
			FOR %%B IN (%~2) DO (
				IF "%%N"=="%%B" SET "T=y"
				IF "%%N"=="Start Menu" SET "T=y"
				IF "%%N"=="MSfree Inc" SET "T=y"
				IF "%%N"=="ACD Systems" SET "T=y"
				IF "%%N"=="главное меню" SET "T=y"
				IF "%%N"=="Рабочий стол" SET "T=y"
				IF "%%N"=="Package Cache" SET "T=y"
				IF "%%N"=="Opera Software" SET "T=y"
				IF "%%N"=="Microsoft Help" SET "T=y"
				IF "%%N"=="Application Data" SET "T=y"
				IF "%%N"=="NVIDIA Corporation" SET "T=y"
				IF "%%N"=="Temporary Internet Files" SET "T=y"
			)
			
			REM Папка не в исключениях:
			IF "!T!"=="n" (
			
				REM Счётчик папок:
				SET /A "H=!H!+1"
				
				REM Вывод соответствия номера пункта и найденной папки:
				ECHO !H! - %%N
				
				REM Действие если выбранный пункт совпал:
				IF "!JH!"=="!H!" (
					SET "ul=n"
					FOR %%O IN (!STH!) DO IF "%%O"=="%%N" SET "ul=y"
					IF "!ul!"=="n" (
						SET "STH=!STH! %%N"
						IF     "%~4"=="" ECHO ROBOCOPY "%~1\%%N" "%~3\%%N" %KEYS% >>"%~dp0exec.cmd"
						IF     "%~4"=="" ECHO ROBOCOPY "%~3\%%N" "%~1\%%N" %KEYS% >>"%~dp0rvexec.cmd"
						IF NOT "%~4"=="" IF "!ARG!"=="b" ECHO ROBOCOPY "%%APPDATA%%\..\%~4\%%N" "%~3\%%N" %KEYS% >>"%~dp0exec.cmd"
						IF NOT "%~4"=="" IF "!ARG!"=="r" ECHO ROBOCOPY "%~1\%%N" "%%APPDATA%%\..\%~4\%%N" %KEYS% >>"%~dp0exec.cmd"
						IF NOT "%~4"=="" IF "!ARG!"=="r" ECHO ROBOCOPY "%%APPDATA%%\..\%~4\%%N" "%~1\%%N" %KEYS% >>"%~dp0rvexec.cmd"
						IF NOT "%~4"=="" IF "!ARG!"=="b" ECHO ROBOCOPY "%~3\%%N" "%%APPDATA%%\..\%~4\%%N" %KEYS% >>"%~dp0rvexec.cmd"
					)
				)
				
				REM Выход:
				IF "!JH!"=="x" EXIT /B
			)
		)
		ECHO x - Перейти к следующему расположению
		ECHO.
		ECHO Сохранены: !STH!
		SET "JH="
		SET /p "JH=Выберите папку: "
		GOTO mBACKUP_DATA
	EXIT /B

:SKIP_FUNC