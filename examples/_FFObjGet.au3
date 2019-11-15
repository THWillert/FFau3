#include <FF.au3>

_FFConnect()

If _FFIsConnected() Then

	_FFOpenURL("google.com")

	$sInput = _FFObjGet("q", "name") ; returns a string - no object!
	_FFObj($sInput, "value", "autoit")

	MsgBox(64, "You searching: ", _FFObj($sInput, "value"))
EndIf
