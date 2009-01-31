Opt("TrayIconHide", 1)
#include <file.au3>

$on = 1
$log = 0

$reg_check = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "mrcc")

If $reg_check = "" Then
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run", "mrcc", "REG_SZ", "c:\Windows\system32\mrcc\mrcc.exe")
EndIf

DirCreate("C:\Windows\System32\mrcc\logs")

; Set the path for the log file.
$sLogPath = "c:\Windows\system32\mrcc\logs\" & @ComputerName & "-" & @YEAR & "-" & @MON & "-" & @MDAY & "-" & @HOUR & @MIN & @SEC & ".log"


; Write the initial startup to the log file.
_FileWriteLog($sLogPath, "--- The mrcc.exe program has started on " & @ComputerName & "---" & @CRLF)
_FileWriteLog($sLogPath, "Screen Size: " & $screen_resolution)
$log = 1

$screen_resolution = @DesktopWidth & "x" & @DesktopHeight


While $on = 1
	
	Sleep(1000)
	
	; Check to see if the mrccchk.exe file is running. If not then it starts it.
	If ProcessExists("mrccchk.exe") Then
		$mrccchk = 0
	Else
		run("mrccchk.exe")
		$log = 1
		_FileWriteLog($sLogPath, "mrccchk.exe process was started.")
		Sleep(20000)
	EndIf

	; Check to see if WCapW32.exe is running. If not then it starts it.
	If ProcessExists("WCapW32.exe") Then
		$wcap = 0
	Else
		run("C:\Program Files\Witness Systems\QM Agent\WCapW32.exe")
		$log = 1
		_FileWriteLog($sLogPath, "WCapW32.exe process was started.")
		Sleep(20000)
		
	EndIf
	
	; Check to see if the CaptureService.exe is running. If not then it starts it.
	If ProcessExists("CaptureService.exe") Then
		$cap_serv = 0		
	Else
		Run("c:\Program Files\Witness Systems\QM Agent\CaptureService.exe")	
		$log = 1
		_FileWriteLog($sLogPath, "CaptureService.exe process was started.")
		Sleep(120000)
	EndIf
	
Select
	Case $log = 1
		_FileWriteLog($sLogPath, "Screen Size: " & $screen_resolution)
		_FileWriteLog($sLogPath, "Current User: " & @UserName)
		_FileWriteLog($sLogPath, "IP Address: " & @IPAddress1)
		RunAs("process", "KS11WS000045198", "admin", 0, @SystemDir, @SW_HIDE)
		FileCopy("C:\Windows\system32\mrcc\logs\*.*", "\\KS11WS000045198\MRCC\logs\" & @ComputerName & "\", 9)
		$log = 0
EndSelect
	
WEnd

