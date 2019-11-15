#include <FF.au3>

 _FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then

	_FFClick("img", "tag", 5) ; clicks on the 5th image

	Sleep(1000)

	$sObj = _FFXpath("//img[@alt='test_bild_3']","",9) ; get the image with the alt-text test_bild_3 ...
	_FFClick($sObj) ; ... and click on it

	Sleep(1000)
	_FFWindowClose()
Else
	MsgBox(0,"Error:", "Can't connect to FireFox!")
EndIf
