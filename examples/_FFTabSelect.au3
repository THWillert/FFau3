#include <FF.au3>

$Socket = _FFStart()

If $Socket > -1 Then
	; add a new tab with an URL
	_FFTabAdd($Socket,"http://ff-au3-example.thorsten-willert.de/")
	sleep(3000)
	; add a new blank tab and bring it to front
	_FFTabAdd($Socket,default,true)
	Sleep(3000)
	; select the tab with "FF" in the label
	_FFTabSelect($Socket,"FF","label")
	; shows the number of tabs
	MsgBox(64,"Number of tabs:",_FFTabLength($Socket))
	; closing all tabs except the current
	_FFTabCloseAll($Socket)
	Sleep(3000)
	; closes FireFox
	_FFQuit($Socket)
EndIf

