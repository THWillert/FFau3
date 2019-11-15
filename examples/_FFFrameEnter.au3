#include <FF.au3>

If _FFConnect() Then
	If _FFOpenURL("http://www.autoit.de") Then
		_FFFrameEnter(2)
		MsgBox(0,"Frame 2 URL", _FFCmd(".location.href") )
		_FFFrameLeave()
		MsgBox(0,"Top URL",_FFCmd(".location.href") )
	EndIf
EndIf
