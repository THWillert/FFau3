; #FUNCTION# ===================================================================
; Name ..........: _FF_RecordForm
; Description ...:
; AutoIt Version : V3.3.0.0
; Requirement(s).: FF.au3 / MozRepl
; Syntax ........: _FF_RecordForm()
; Parameter(s): .:              -
; Return Value ..: Success      - FF.au3 functions to fill the form
;                  Failure      - empty string
; Author(s) .....: Thorsten Willert
; Date ..........: Thu Nov 05 13:43:14 CET 2009
; Version .......: 0.3
; ==============================================================================
Func _FF_RecordForm()
    Local $sScript = ""
    Local $sCmd, $tmp, $iElements, $sType

    _FFCmd("FFau3.tmp=window.content.document.activeElement;")
    For $i = 0 To _FFGetLength("form") -1
        $iElements = _FFFormGetElementsLength($i) - 1
        For $j = 0 To $iElements
            If _FFCmd("FFau3.tmp==window.content.document.forms[" & $i & "].elements[" & $j & "] ? 1 : 0") = 1 Then ExitLoop
        Next
        ExitLoop
    Next

    For $j = 0 To $iElements
        $sType = _FFCmd(".forms[" & $i & "].elements[" & $j & "].type")
        Switch $sType
            Case "textarea","text","password"
                $sCmd = StringFormat(".forms[%i].elements[%i].value", $i, $j)
                $tmp = _FFCmd($sCmd)
                $sScript &= '_FFCmd("' & $sCmd & "='" & __FFValue2JavaScript($tmp) & "'"")" & @CRLF
            Case "radio","checkbox"
                $sCmd = StringFormat(".forms[%i].elements[%i].checked", $i, $j)
                $tmp = _FFCmd($sCmd)
                $sScript &= '_FFCmd("' & $sCmd & '=' & __FFB2S($tmp) & '")' & @CRLF
            Case "select-one"
                $sCmd = StringFormat(".forms[%i].elements[%i].selectedIndex", $i, $j)
                $tmp = _FFCmd($sCmd)
                $sScript &= '_FFCmd("' & $sCmd & '=' & $tmp & '")' & @CRLF
        EndSwitch
    Next

    Return $sScript
EndFunc   ;==>_FF_RecordForm
