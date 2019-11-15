#include <FF.au3>

If _FFStart("http://ff-au3-example.thorsten-willert.de/") Then
	$sText = _FFReadText()
	If Not @error Then MsgBox(64,"Text:",StringLeft($sText,300))

	; compressed text
	$sText = _FFReadText(7)
	If Not @error Then MsgBox(64,"Compressed text:",$sText)
EndIf
