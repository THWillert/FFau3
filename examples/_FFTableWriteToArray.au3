#include <FF.au3>
#include <Array.au3>

_FFStart("http://ff-au3-example.thorsten-willert.de/",default,2)

If _FFIsConnected() Then

	$aTable = _FFTableWriteToArray(1)
	_ArrayDisplay($aTable)
EndIf
