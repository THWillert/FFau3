#include <FF.au3>

_FFConnect()

If _FFIsConnected() Then
	_FFOpenURL("http://ff-au3-example.thorsten-willert.de/")

	_FFImageClick("test_bild_1", "alt")

	Sleep(3000) ; to see the alert
	_FFDialogWait("bild")
	MsgBox(64,"","Alert closed ...")
EndIf
