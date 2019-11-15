#include <FF.au3>

_FFConnect()

If _FFIsConnected() Then
	_FFTabAdd("http://ff-au3-example.thorsten-willert.de/")

	_FFXPath("//form[1]//input[position()=2]","",9)
	MsgBox(64,"", _FFObj("xpath","type"))
	; OR
	MsgBox(64,"", _FFObj("xpath.value"))
	_FFObj("xpath.checked=true")

	Sleep(5000)

	_FFOpenURL("google.com")

	If _FFObjNew("google", "window.content.document") Then
		MsgBox(64, "Cookie", _FFObj("google","cookie"))
		; OR
		MsgBox(64, "Domain", _FFObj("google.domain"))
		_FFObjDelete("google") ; :D
	EndIf

	$sInput = _FFObjGet("q", "name") ; returns a string - no object!
	_FFObj($sInput, "value", "autoit")
	MsgBox(64, "Suche: ", _FFObj($sInput, "value"))

	_FFTabClose("Google", "label")

	_FFDisConnect()
EndIf