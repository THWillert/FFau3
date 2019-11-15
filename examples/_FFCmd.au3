#include <FF.au3>

 _FFConnect()

If _FFIsConnected() Then
	; href of the current page
	$sHref = _FFCmd(".location.href")
	If Not @error Then MsgBox(64,"Current href:",$sHref)

	_FFOpenURL("http://ff-au3-example.thorsten-willert.de/")
	; href from an image link
	$sHref = _FFCmd(".images[0].parentNode.href")
	If Not @error Then MsgBox(64,"Href of the first image-link:",$sHref)

	; title of the current page
	$sTitle = _FFCmd( ".title")
	If Not @error Then MsgBox(64,"Title of the current page:",$sTitle)

	; browser version
	$sVersion = _FFCmd("navigator.userAgent")
	If Not @error Then MsgBox(64,"Browser version:",$sVersion)
Else
	MsgBox(64,"Error:","Can't conncect to FireFox")
EndIf
