#include <Array.au3>
#include <FF.au3>

If _FFConnect() Then
	_FFTabAdd( "http://ff-au3-example.thorsten-willert.de/")

	; counting the number of results from the Xpath query
	MsgBox(64, "Number of password fields:", _FFXPath( "//input[@type='password']", "", 10))

	; the textContent from the query result
	MsgBox(64, "Fieldset-Legend:", _FFXPath( "//form[1]/fieldset/legend"))

	; the textContent from option 2
	MsgBox(64, "Text from 0ption 5:", _FFXPath( "//option[2]"))

	; Method and action of the first form
	$vTmp = "Method: " & _FFXPath( "//form[1]/@method") & @crlf
	$vTmp &= "Action: " & _FFXPath( "//form[1]/@action")
	MsgBox(64, "Form 2", $vTmp)

	; array with the textContent of all options
	$aArray = _FFXPath("//option","value",7)
	_ArrayDisplay($aArray)

	; working with the object returned from the query
	_FFXPath("//form[1]//input[@type='checkbox' and position()=2]","",9)
	MsgBox(64,"", _FFObj("xpath.type") & @crlf & _FFObj("xpath.value"))
	_FFObj("xpath.checked=true")

EndIf