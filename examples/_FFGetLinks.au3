#include <FF.au3>
#include <Array.au3>

$Socket = _FFStart("http://ff-au3-example.thorsten-willert.de/")

If $Socket > -1 Then
	$aMsg = _FFGetLinks($Socket)
	_ArrayDisplay($aMsg)
	; not all Links have text!
	$aMsg = _FFGetLinks($Socket,"text")
	_ArrayDisplay($aMsg)
EndIf
