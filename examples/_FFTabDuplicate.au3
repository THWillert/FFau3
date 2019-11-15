#include <FF.au3>

If _FFConnect() Then
	_FFTabAdd("www.google.de")
	Sleep(3000)
	_FFTabDuplicate()
EndIf

