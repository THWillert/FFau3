#include <FF.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then
	Sleep(2000)
	_FFAction("presentationmode", True)
	Sleep(2000)
	_FFOpenURL("http://www.google.com")
	Sleep(2000)
	_FFAction("back")
	_FFAction("presentationmode", False)
	Sleep(2000)
	_FFOpenURL("chrome:bookmarks")
	Sleep(2000)
	_FFAction("alert", "Bye bye ...")
	_FFQuit()
EndIf