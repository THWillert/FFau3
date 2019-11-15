#include <FF.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/",default,2)

If _FFIsConnected() Then
	$sUser = _FFGetValueById("user")
	MsgBox(64,"Username:",$sUser)

	$sPass = _FFGetValueById("pass")
	MsgBox(64,"Password:",$sPass)

	_FFQuit()
EndIf
