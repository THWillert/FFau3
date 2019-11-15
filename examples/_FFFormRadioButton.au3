#include <FF.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then
	_FFFormRadioButton(1, 0, "index")
	Sleep(3000)
	_FFFormRadioButton("size", 2, "name", "Pizza", "name")
EndIf