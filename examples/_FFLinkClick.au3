#include <FF.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then
	; clicks on the third (0-n) link on the page
	_FFLinkClick(2, "index")
	_FFLoadWait()
	Sleep(3000)
	; back to the last page
	_FFAction("back")
	Sleep(3000)
	; clicks on the link with the (sub)string "/index.php" in the href
	_FFLinkClick("/index.php")
	_FFLoadWait()
	Sleep(3000)
	_FFAction("back")
	Sleep(3000)
	; clicks on the link with the visible (sub)string "developer center"
	_FFLinkClick("developer center", "text")
	_FFLoadWait()
	Sleep(3000)
EndIf