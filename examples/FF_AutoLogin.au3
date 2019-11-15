#include-once
#include <FF.au3>
; #FUNCTION# ===================================================================
; Name ..........: _FF_AutoLogin
; Description ...: Auto login for HTML-forms / Generator for login-functions
; AutoIt Version : V3.3.0.0
; Requirement(s).: FF.au3
; Syntax ........: _FF_AutoLogin($sUserName, $sPassWord[, $sURL = ""[, $sStatus = ""[, $sSubmitMode = "keypress"[, $iMode = 0[, $iFormOffset = 0]]]]])
; Parameter(s): .: $sUserName   -
;                  $sPassWord   -
;                  $sURL        - Optional: (Default = "") : login page
;                  $sStatus     - Optional: (Default = "") : Message to search on the web-page if the login was successful
;                  $sSubmitMode - Optional: (Default = "keypress") : if any methode fails the next in the list is tried
;                               | keypress
;                               | click
;                               | submit
;                               | off (fills only the inputs)
;                  $iMode       - Optional: (Default = 0) : login-only
;                               | 1: login and returns login-function
;                  $iFormOffset - Optional: (Default = 0) : offset for some sites, with multiple password-inputs
; Return Value ..: Success      - 1 / string (function)
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Date ..........: Fri Nov 13 21:36:39 CET 2009
; Version .......: 4.1
; ==============================================================================
Func _FF_AutoLogin($sUserName, $sPassWord, $sURL = "", $sStatus = "", $sSubmitMode = "keypress", $iMode = 0, $iFormOffset = 0)
	Local $bTrace = $_FF_COM_TRACE
	;$_FF_COM_TRACE = False

	If $sStatus = Default Then $sStatus = ""
	If $sSubmitMode = Default Then $sSubmitMode = "keypress"

	Local $sError = @TAB & "If @error Then Return 0" & @CRLF
	Local $sScript = "Func _FFLogin($sUserName, $sPassWord) ; generated with _FF_AutoLogin, by Stilgar" & @CRLF, $sPassElement
	Local $sCmd

	If $sURL <> '' Then
		_FFOpenURL($sURL)
		If @error Then Return 0
		$sScript &= @TAB & StringFormat("_FFOpenURL('%s')", $sURL) & @CRLF & $sError
	EndIf

	For $i = $iFormOffset To _FFGetLength("forms")
		If _FFXpath("//form[" & $i + 1 & "]//input[@type='password']", Default, 10) > 0 Then
			If @error Then Return 0

			Local $aType = _FFXpath("//form[" & $i + 1 & "]//input", "type", 6)
			Local $aID = _FFXpath("//form[" & $i + 1 & "]//input", "id", 6)
			Local $aName = _FFXPath("//form[" & $i + 1 & "]//input", "name", 6)

			For $j = 1 To $aType[0]
				If $aType[$j] = "password" Then
					If $aID[$j] <> "" Then
						_FFSetValue($sPassWord, $aID[$j], "id")
						$sScript &= @TAB & StringFormat("_FFSetValue($sPassWord,'%s','id')", $aID[$j]) & @CRLF & $sError
						$sPassElement = ".getElementById('" & $aID[$j] & "')"
					ElseIf $aName[$j] <> "" Then
						_FFSetValue($sPassWord, $aName[$j], "name")
						$sScript &= @TAB & StringFormat("_FFSetValue($sPassWord,'%s','name')", $aName[$j]) & @CRLF & $sError
						$sPassElement = StringFormat(".getElementsByName('%s')[0]", $aName[$j])
					Else
						$sPassElement = StringFormat(".form[%i].input[%i]", $i, $j)
						$sCmd = $sPassElement & ".value='" & $sPassWord & "'"
						_FFCmd($sCmd)
						$sScript &= @TAB & StringFormat('_Cmd("%s")', $sCmd) & @CRLF & $sError
					EndIf

					For $k = $j - 1 To 0 Step -1
						If $aType[$k] = "text" Then
							If $aID[$k] <> "" Then
								_FFSetValue($sUserName, $aID[$k], "id")
								$sScript &= @TAB & StringFormat("_FFSetValue($sUserName,'%s','id')", $aID[$k]) & @CRLF & $sError
							ElseIf $aName[$k] <> "" Then
								_FFSetValue($sUserName, $aName[$k], "name")
								$sScript &= @TAB & StringFormat("_FFSetValue($sUserName,'%s','name')", $aName[$k]) & @CRLF & $sError
							Else
								$sCmd = StringFormat(".form[%i].input[%i].value='%s'", $i, $j, $sUserName)
								_FFCmd($sCmd)
								$sScript &= @TAB & StringFormat('_Cmd("%s")', $sCmd) & @CRLF & $sError
							EndIf
							ExitLoop
						EndIf
					Next
					ExitLoop
				EndIf
			Next
			Switch StringLower($sSubmitMode)
				Case "off"
					If $iMode = 0 Then
						Return 1
					Else
						$sScript &= "EndFunc ;==> _FFLogin" & @CRLF
						Return $sScript
					EndIf
				Case "keypress"
					If Not _FFDispatchEvent($sPassElement, "keypress", 13) Then ContinueCase
					$sScript &= @TAB & StringFormat('_FFDispatchEvent("%s", "keypress", 13)', $sPassElement) & @CRLF & $sError
				Case "click"
					For $k = $j To $aType[0]
						If $aType[$k] = "submit" Or $aType[$k] = "image" Then
							If $aID[$k] <> "" Then
								$sCmd = StringFormat(".getElementById('%s')", $i, $aID[$k])
								_FFClick($sCmd)
								$sScript &= '_FFClick("' & $sCmd & '")' & @CRLF & $sError
							ElseIf $aName[$k] <> "" Then
								$sCmd = StringFormat(".getElementsByName('%s')[0]", $i, $aName[$k])
								_FFClick($sCmd)
								$sScript &= '_FFClick("' & $sCmd & '")' & @CRLF & $sError
							Else
								ContinueCase
							EndIf
							ExitLoop
						EndIf
					Next
				Case "submit"
					_FFCmd(".forms[" & $i & "].submit()")
					If @error Then Return 0

					$sScript &= @TAB & "_FFCmd('.forms[" & $i & "].submit()')" & @CRLF & $sError
				Case Else
					Return 0
			EndSwitch

			$sScript &= @TAB & "_FFLoadWait()" & @CRLF & $sError & @TAB & "Sleep(500)" & @CRLF
			_FFLoadWait()
			Sleep(500)

			$_FF_COM_TRACE = $bTrace

			If $iMode = 0 Then
				If $sStatus <> "" Then Return _FFSearch($sStatus)
				Return 1
			Else
				If $sStatus <> "" Then $sScript &= @TAB & "Return _FFSearch('" & $sStatus & "')" & @CRLF
				$sScript &= "EndFunc ;==> _FFLogin" & @CRLF
				Return $sScript
			EndIf

		EndIf
	Next

	$_FF_COM_TRACE = $bTrace
	Return 0
EndFunc   ;==>_FF_AutoLogin