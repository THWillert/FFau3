#include <FF.au3>

_FFConnect()

If _FFIsConnected() Then
	; changing HTTP-proxy port:
	_FFPrefSet("network.proxy.http", "localhost")
	_FFPrefReset("network.proxy.http")

	; disabling image loading
	_FFPrefSet("permissions.default.image", 2)
	MsgBox(64, "Old value:", @extended)
	MsgBox(64, "Current value:", _FFPrefGet("permissions.default.image"))
	; reset to old value
	_FFPrefReset("permissions.default.image")
	; reading prefs
	MsgBox(64, "Reseted value:", _FFPrefGet("permissions.default.image"))
EndIf