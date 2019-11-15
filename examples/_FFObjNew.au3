#include <FF.au3>

_FFConnect()

If _FFIsConnected() Then
	_FFOpenURL("google.com")

	If _FFObjNew("google", "window.content.document") Then
		MsgBox(64, "Cookie", _FFObj("google","cookie"))
		; OR
		MsgBox(64, "Domain", _FFObj("google.domain"))
		_FFObjDelete("google")
	EndIf
EndIf

Exit