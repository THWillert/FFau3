#include <FF.au3>

Global $sMsg = "", $aTmp

Global $aElements[12] = ["links", "images", "forms", "frames", "anchors", _
	"styleSheets", "tabs", "history", "applets", "embeds", "plugins", "br"]

_FFConnect()

If _FFIsConnected() Then
	For $i = 0 To UBound($aElements)-1
		$sTmp = _FFGetLength($aElements[$i])
		If Not @error Then
			$sMsg &= $aElements[$i] & ": " & $sTmp & @crlf
		EndIf
	Next
	MsgBox(64,"Found:",$sMsg)
EndIf
