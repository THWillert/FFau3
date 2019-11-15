#include <FF.au3>

 _FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then
	$sStringToSearch = "Informationen"

	If _FFSearch($sStringToSearch) Then
		MsgBox(0,"Found:", $sStringToSearch)
	Else
		MsgBox(0,"Can't find:", $sStringToSearch)
	EndIf

	Sleep(3000)
	_FFWindowClose()
Else
	MsgBox(0,"Error:", "Can't connect to FireFox!")
EndIf
