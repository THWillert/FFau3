#include <Array.au3>
#include <FF.au3>

_FFConnect()

If _FFIsConnected() Then
	; shows all informations about the window-object
	$a = _FFGetObjectInfo()
	_ArraySort($a)
	_ArrayDisplay($a)
EndIf
