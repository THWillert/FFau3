#include <FF.au3>

If _FFStart("http://ff-au3-example.thorsten-willert.de/", Default, 2) Then
	_FFSetValue("Max Mustermann", "user", "id")
	_FFSetValue("My_Password", "pass", "id")

	_FFDisConnect()
EndIf