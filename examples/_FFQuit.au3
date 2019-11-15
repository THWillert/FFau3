#include <FF.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then
	; do something ...
	Sleep(2000)
	_FFAction("alert","Bye bye ...")

	; ... and then closing FireFox
	_FFQuit()
EndIf
