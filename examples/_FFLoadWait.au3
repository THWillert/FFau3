#include <FF.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/", Default, 2)

If _FFIsConnected() Then
	_FFClickImage("/gohome.png", "src", False)
	If _FFLoadWait() Then MsgBox(64, "", "Page was loaded in " & @extended & "ms")

	Sleep(3000)
	_FFQuit()
EndIf