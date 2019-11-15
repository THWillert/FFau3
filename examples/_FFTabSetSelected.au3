#include <FF.au3>

If _FFStart() Then
	; add a new tab with an URL
	_FFTabAdd("http://ff-au3-example.thorsten-willert.de/")
	sleep(3000)
	; add a new blank tab and bring it to front
	_FFTabAdd(default,true)
	Sleep(3000)
	; select the tab with "FF" in the label
	_FFTabSetSelected("FF","label")
	; shows the number of tabs
	MsgBox(64,"Number of tabs:",_FFTabGetLength())
	; closing all tabs except the current
	_FFTabCloseAll()
	Sleep(3000)
	; closes FireFox
	_FFQuit()
EndIf

