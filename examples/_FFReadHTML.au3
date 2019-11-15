#include <FF.au3>

If _FFStart("http://ff-au3-example.thorsten-willert.de/") Then
	$sHTML = _FFReadHTML()
	If Not @error Then MsgBox(64,"Sourcecode",StringLeft($sHTML,1000))

	; filtered source-code
	$sHTML = _FFReadHTML("html",7)
	If Not @error Then MsgBox(64,"Sourcecode",$sHTML)
EndIf
