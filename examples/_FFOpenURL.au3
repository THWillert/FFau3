#include <FF.au3>

If _FFConnect() Then
	If _FFOpenURL("http://www.google.de") Then
		MsgBox(64,"","www.google.de is loaded")
	Else
		MsgBox(64,"","Can't open www.google.de")
	EndIf
	Sleep(3000)

	; Opens the browser-history in the current tab
	_FFOpenURL("chrome:history")
Else
	MsgBox(64,"Error","Can't connect to FireFox")
EndIf
