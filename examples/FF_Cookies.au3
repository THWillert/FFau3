Func _FF_CookieGet($sURL, $sName = "")
    ;https://developer.mozilla.org/en/Code_snippets/Cookies
    If Not __FFCheckURL($sURL) Then
        SetError(__FFError("_FF_CookieGet", $_FF_ERROR_InvalidDataType, "(URL) $sURL: " & $sURL))
        Return ""
    EndIf
    Local $sCmd = 'Components.classes["@mozilla.org/cookieService;1"].getService(Components.interfaces.nsICookieService).getCookieString(Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService).newURI("' & $sURL & '", null, null), null);'
    Local $sRet = _FFCmd($sCmd)
    If @error Then Return SetError(1, 0, "")

    If $sName Then
        $sRet = StringRegExpReplace($sRet, '^(.*?;\s*)*' & $sName & '=(.*?)(;|$).*', '$2')
        If Not @extended Then Return SetError(1, 0, $sRet)
    EndIf

    Return $sRet
EndFunc   ;==>_FF_CookieGet

Func _FF_CookieSet($sURL, $sName, $sValue)
    ;https://developer.mozilla.org/en/Code_snippets/Cookies
    If Not __FFCheckURL($sURL) Then
        SetError(__FFError("_FF_CookieGet", $_FF_ERROR_InvalidDataType, "(URL) $sURL: " & $sURL))
        Return ""
    EndIf
    Local $sCmd = 'Components.classes["@mozilla.org/cookieService;1"].getService(Components.interfaces.nsICookieService).setCookieString(Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService).newURI("' & $sURL & '", null, null), null, "' & $sName & '=' & $sValue & '", null);'
    Local $sRet = _FFCmd($sCmd)
    If @error Then Return SetError(1, 0, "")

    Return $sRet
EndFunc   ;==>_FF_CookieSet
