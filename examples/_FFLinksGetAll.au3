#include <FF.au3>
#include <Array.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/")

If _FFIsConnected() Then
	$aLinks = _FFLinksGetAll()
	_ArrayDisplay($aLinks)
EndIf
