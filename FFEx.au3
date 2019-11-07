; :collapseFolds=0:maxLineLen=80:mode=autoitscript:tabSize=8:indentSize=8:folding=indent:
#include-once
#include <FF.au3>
; Mon Jun 12 21:53:03 CEST 2017 @870 /Internet-Zeit/
; by Thorsten Willert

#Region #CURRENT# ==============================================================
; _FFDisPatchKeyEvent
; _FFFormGetLength
; _FFGetValueById
; _FFGetValueByName
; _FFSetValueById
; _FFSetValueByName
; _FFTabCloseAll
; _FFTabGetLength
; _FFTableGetCell
; _FF_Call
; _FF_CookiesAllow
; _FF_CookiesDeny
; _FF_CookiesRemoveAll
; _FF_CookiesSetAccess
; _FF_EmptyCache
; _FF_EmptyCookies / _FF_CookiesRemoveAll
; _FF_EmptyHistory
; _FF_FormSetFileInput
; _FF_GetContentXY
; _FF_GetCurrentURL
; _FF_GetStatus
; _FF_GetTitle
; _FF_MozRepl_Detect
; _FF_ResetTitle
; _FF_TabGetAllTitles
; _FF_TabGetAllURLs
; _FF_TabReloadAll

#EndRegion #CURRENT# ==============================================================
;===============================================================================
; calls a JavaScript function on the current page
; use "CW" as shortcut for "content.wrappedJSObject"
Func _FF_Call($sScript)
	If StringInStr($sScript, "CW.") Then
		$sScript = StringReplace($sScript, "CW.", "FFau3.tmp.")
		Return _FFCmd("FFau3.tmp=content.wrappedJSObject;" & $sScript)
	Else
		Return _FFCmd("content.wrappedJSObject." & $sScript)
	EndIf
EndFunc   ;==>_FF_Call
;===============================================================================
Func _FF_CookiesAllow($sURL)
	Return _FF_CookiesSetAccess($sURL, 1)
EndFunc   ;==>_FF_CookiesAllow
;===============================================================================
Func _FF_CookiesDeny($sURL)
	Return _FF_CookiesSetAccess($sURL, 2)
EndFunc   ;==>_FF_CookiesDeny
;===============================================================================
Func _FF_CookiesRemoveAll()
	_FFCmd('Components.classes["@mozilla.org/cookiemanager;1"].getService(Components.interfaces.nsICookieManager).removeAll();')
	If Not @error Then Return 1
	Return SetError(1, 0, 0)
EndFunc   ;==>_FF_CookiesRemoveAll

;===============================================================================
; https://developer.mozilla.org/en/nsICookiePermission
; $iAccess: 0 = ACCESS_DEFAULT
;           1 = ACCESS_ALLOW
;           2 = ACCESS_DENY
;           8 = ACCESS_SESSION
Func _FF_CookiesSetAccess($sURL, $iAccess)
	If __FFCheckURL($sURL) And ($iAccess = 0 Or $iAccess = 1 Or $iAccess = 2 Or $iAccess = 8) Then
		_FFCmd('Components.classes["@mozilla.org/cookie/permission;1"].getService(Components.interfaces.nsICookiePermission).setAccess(Components.classes["@mozilla.org/network/io-service;1"].getService(Components.interfaces.nsIIOService).newURI("' & $sURL & '", null, null),' & $iAccess & ');')
		If Not @error Then Return 1
	EndIf
	Return SetError(1, 0, 0)
EndFunc   ;==>_FF_CookiesSetAccess
;===============================================================================
Func _FF_EmptyCache()
	_FFCmd("Ci=Components.interfaces;Components.classes['@mozilla.org/network/cache-service;1'].getService(Ci.nsICacheService).evictEntries(Ci.nsICache.STORE_ANYWHERE);")
	If Not @error Then Return 1
	Return 0
EndFunc   ;==>_FF_EmptyCache
;===============================================================================
Func _FF_EmptyCookies()
	_FF_CookiesRemoveAll()
EndFunc   ;==>_FF_EmptyCookies
;===============================================================================
Func _FF_EmptyHistory()
	_FFCmd("Components.classes['@mozilla.org/browser/nav-history-service;1'].getService(Components.interfaces.nsIBrowserHistory).removeAllPages();")
	If Not @error Then Return 1
	Return 0
EndFunc   ;==>_FF_EmptyHistory
;===============================================================================
Func _FF_FormSetFileInput($sFile, $vInput = 0, $sInputMode = "index", $vForm = 0, $sFormMode = "index")
	Local $sInput, $sForm
	If Not FileExists($sFile) Then
		SetError(1)
		Return 0
	EndIf
	Switch $sInputMode
		Case "index"
			If Not IsInt($vInput) Then
				SetError(1)
				Return 0
			EndIf
			$sInput = $vInput + 1
		Case "id", "name"
			$sInput = StringFormat("@type='file' and @%s='%s'", $sInputMode, $vInput)
		Case Else
			SetError(1)
			Return 0
	EndSwitch
	Switch $sFormMode
		Case "index"
			If Not IsInt($vForm) Then
				SetError(1)
				Return 0
			EndIf
			$sForm = $vForm + 1
		Case "id", "name", "title"
			$sForm = StringFormat("@%s='%s'", $sFormMode, $vForm)
		Case Else
			SetError(1)
			Return 0
	EndSwitch
	_FFXpath(StringFormat("//form[%s]//input[%s]", $sForm, $sInput), StringFormat("value='%s'", $sFile), 9)
	If Not @error Then Return 1
	SetError(1, 0, 0)
EndFunc   ;==>_FF_FormSetFileInput
;===============================================================================
; Returns an array with x/y/width/height of the content area
Func _FF_GetContentXY()
	Return ControlGetPos(_FFCmd(".title"), "", "[CLASS:MozillaContentWindowClass]")
EndFunc   ;==>_FF_GetContentXY
;===============================================================================
Func _FF_GetCurrentURL()
	Return _FFCmd(".location.href")
EndFunc   ;==>_FF_GetCurrentURL
;===============================================================================
Func _FF_GetStatus()
	Return _FFCmd("XULBrowserWindow.statusTextField.label")
EndFunc   ;==>_FF_GetStatus
;===============================================================================
Func _FF_GetTitle()
	Return _FFCmd(".title")
EndFunc   ;==>_FF_GetTitle
; #FUNCTION# ===================================================================
; Name ..........: _FF_MozRepl_Detect
; Description ...: Checks a Firefox profile for the MozRepl extension and installes it if not available.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FF_MozRepl_Detect([$sProfil = "default"[, $bInstall = True[, $sXPI = "http://repo.hyperstruct.net/mozrepl/0.2/mozrepl.xpi"]]])
; Parameter(s): .: $sProfil     - Optional: (Default = "default") :
;                  $bInstall    - Optional: (Default = True) :
;                  $sXPI        - Optional: (Default = "http://repo.hyperstruct.net/mozrepl/0.2/mozrepl.xpi") :
; Return Value ..: Success      - 1
;                  Failure      - 0
; Author(s) .....: Thunder-man (Frank Michalski), Thorsten Willert
; Date ..........: Fri Jul 17 13:05:21 CEST 2009
; Version .......: 2.0
; Example .......: No
; V 1.0 ==> 15.09.2007
; V 1.1 ==> 02.08.2008, updated by Stilgar (Thorsten Willert)
; changed the path-macro to @AppDataDir
; changed the ""-profil to "default"
; V1.2 ==> 03.03.2009, updated by Stilgar (Thorsten Willert)
; changed MozLab to MozRepl
; V2.0 ==> 17.03.2009, added intall-option for MozRepl by Stilgar (Thorsten Willert)
; ==============================================================================
Func _FF_MozRepl_Detect($sProfile = "default", $bInstall = True, $sXPI = "http://repo.hyperstruct.net/mozrepl/1.0/mozrepl.xpi")
	If $sProfile = "" Then $sProfile = "default"
	Local $sIni_Path = @AppDataDir & "\Mozilla\Firefox\"
	Local $var = IniReadSectionNames($sIni_Path & "\profiles.ini")
	If @error Then
		MsgBox(4096, "", "Error occurred, probably no Firefox INI file.")
	Else
		For $i = 1 To $var[0]
			Local $Ini_ = IniRead($sIni_Path & "\profiles.ini", $var[$i], "Name", "Error")
			If $Ini_ = $sProfile Then
				Local $sPath_folder = IniRead($sIni_Path & "\profiles.ini", $var[$i], "Path", "Error") ;Profile dir
				ExitLoop
			EndIf
		Next
	EndIf
	If $bInstall Then
		Local $sHKLM = "HKEY_LOCAL_MACHINE\SOFTWARE\Mozilla\Mozilla Firefox"
		Local $sFFExe = RegRead($sHKLM & "\" & RegRead($sHKLM, "CurrentVersion") & "\Main", "PathToExe")
		Local $sCommand = StringFormat('"%s" "%s"', $sFFExe, $sXPI)
	EndIf
	If StringLeft($sPath_folder, 8) = "Profiles" Then
		If FileExists($sIni_Path & $sPath_folder & "\extensions\mozrepl@hyperstruct.net") Then
			Return 1
		Else
			If $bInstall Then Return Run($sCommand)
			Return 0
		EndIf
	Else
		If FileExists($sPath_folder & "\extensions\mozrepl@hyperstruct.net") Then
			Return 1
		Else
			If $bInstall Then Return Run($sCommand)
			Return 0
		EndIf
	EndIf
EndFunc   ;==>_FF_MozRepl_Detect
;===============================================================================
Func _FF_ResetTitle()
	Return _FFCmd(".title=FFau3.WCD.getElementsByTagName('title')[0].textContent")
EndFunc   ;==>_FF_ResetTitle
;===============================================================================
; Returns with an array the titles of all open tabs
Func _FF_TabGetAllTitles()
	Return StringSplit(_FFCmd("FFau3.tmp='';for(i=0;i<gBrowser.tabContainer.childNodes.length-1;i++){FFau3.tmp+=gBrowser.getBrowserAtIndex(i).contentDocument.title+'|'}FFau3.tmp+gBrowser.getBrowserAtIndex(i++).contentDocument.title;"), "|")
EndFunc   ;==>_FF_TabGetAllTitles
;===============================================================================
; Returns with an array the URLs of all open tabs
Func _FF_TabGetAllURLs()
	Return StringSplit(_FFCmd("FFau3.tmp='';for(i=0;i<gBrowser.tabContainer.childNodes.length-1;i++){FFau3.tmp+=gBrowser.getBrowserAtIndex(i).contentDocument.location.href+'|'}FFau3.tmp+gBrowser.getBrowserAtIndex(i++).contentDocument.location.href;"), "|")
EndFunc   ;==>_FF_TabGetAllURLs
;===============================================================================
; Reloads all open tabs
Func _FF_TabReloadAll()
	Return _FFCmd("for(i=0;i<gBrowser.tabContainer.childNodes.length;i++){gBrowser.getBrowserAtIndex(i).reload()}")
EndFunc   ;==>_FF_TabGetAllURLs
; #FUNCTION# ===================================================================
; Name ..........: _FFDispatchKeyEvent
; Description ...: Simulates a key-event on an element.
; Beschreibung ..: Simuliert ein Tastatur-Ereignis an einem Element.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFDisPatchKeyEvent($sObject, $iKeyCode[, $sEventType = "keydown"])
; Parameter(s): .: $sElement    - Element where the keyevent is fired
;                  $iKeyCode    - ASCII-KeyCode (decimal)
;                  $sEventType  - Optional: (Default = "keydown") :
;                               | keydown
;                               | keypress
;                               | keyup
; Return Value ..: Success      - 1
;                  Failure      - 0
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Fri Sep 25 11:30:47 CEST 2009 @438 /Internet Time/
; Link ..........: http://www.w3.org/TR/DOM-Level-2-Events/events.html
; Related .......: _FFDispatchEvent
; Example .......: Yes
; ==============================================================================
Func _FFDispatchKeyEvent($sElement, $iKeyCode, $sEventType = "keypress")
	Return _FFDispatchEvent($sElement, $sEventType, $iKeyCode = 13)
EndFunc   ;==>_FFDispatchKeyEvent
; #FUNCTION# ===================================================================
; Name ..........: _FFFormGetLength
; Description ...: Length of the forms
; Beschreibung ..: Gibt die Anzahl der Formulare zurück.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFFormGetLength()
; Parameter(s): .:
; Return Value ..: Success      - >0
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Date ..........: Mon Mar 23 23:15:23 CET 2009 @969 /Internet Time/
; Link ..........:
; Related .......: _FFGetLength
; Example .......: Yes
; ==============================================================================
Func _FFFormGetLength()
	Return _FFGetLength("forms")
EndFunc   ;==>_FFFormGetLength
; #FUNCTION# ===================================================================
; Name ..........: _FFGetValueById
; Description ...: Gets an value of an element by ID
; Beschreibung ..: Liefert ein Value anhand der Element-Id
; AutoIt Version : V3.3.0.0
; Syntax ........:  _FFGetValueById($sID[, $iFilter = 0])
; Parameter(s): .: $sID         - ID of the element
;                  $iFilter     - Optional: (Default = 0) : you can add them:
;                               | 0 = No filter
;                               | 1 = Remove all non ASCII
;                               | 2 = Remove all double withespaces
;                               | 4 = Remove all double linefeeds
;                               | 8 = Remove all HTML-tags
;                               | 16 = simple html-tag / entities convertor
; Return Value ..: Success      - Value
;                  Failure      - ""
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Mon Jun 12 21:48:13 CEST 2017 @866 /Internet-Zeit/
; Link ..........:
; Related .......: _FFGetValue, _FFGetValueByName, _FFSetValueById, _FFSetValueByName, _FFXPath
; Example .......: Yes
; ==============================================================================
Func _FFGetValueById($sID, $iFilter = 0)
	Return _FFGetValue($sID, "id", 0, $iFilter)
EndFunc   ;==>_FFGetValueById
; #FUNCTION# ===================================================================
; Name ..........: _FFGetValueByName
; Description ...: Gets a value of an element by name.
; Beschreibung ..: Liefert ein Value anhand des Element-Namens
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFGetValueByName($sName[, $iIndex = 0[, $iFilter = 0]])
; Parameter(s): .: $sName       - Name of the element
;                  $iIndex      - Optional: (Default = 0) : Index of the element (0-n)
;                  $iFilter     - Optional: (Default = 0) : you can add them:
;                               | 0 = No filter
;                               | 1 = Remove all non ASCII
;                               | 2 = Remove all double withespaces
;                               | 4 = Remove all double linefeeds
;                               | 8 = Remove all HTML-tags
;                               | 16 = simple html-tag / entities convertor
; Return Value ..: Success      - Value
;                  Failure      - ""
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Mon Jun 12 21:48:22 CEST 2017 @866 /Internet-Zeit/
; Link ..........:
; Related .......: _FFGetValue, _FFGetValueById, _FFSetValueById, _FFSetValueByName, _FFXPath
; Example .......: Yes
; ==============================================================================
Func _FFGetValueByName($sName, $iIndex = 0, $iFilter = 0)
	Return _FFGetValue($sName, "name", $iIndex, $iFilter)
EndFunc   ;==>_FFGetValueByName
; #FUNCTION# ===================================================================
; Name ..........: _FFSetValueById
; Description ...: Sets a value of an element by ID
; Beschreibung ..: Setzt einen Wert (value) anhand der Element-Id
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFSetValueById($sID[, $sValue = ""])
; Parameter(s): .: $sID         - ID of the element
;                  $sValue      - Optional: (Default = "") : Value to set
; Return Value ..: Success      - 1
;                  Failure      - 0
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Mon Jun 12 21:48:42 CEST 2017 @867 /Internet-Zeit/
; Link ..........:
; Related .......: _FFSetValueByName, _FFGetValueById, _FFGetValueByName, _FFXPath
; Example .......: Yes
; ==============================================================================
Func _FFSetValueById($sID, $sValue = "")
	Return _FFSetValue($sValue, $sID, "id")
EndFunc   ;==>_FFSetValueById
; #FUNCTION# ===================================================================
; Name ..........: _FFSetValueByName
; Description ...: Sets a value of an element by Name
; Beschreibung ..: Setzt einen Wert (value) anhand des Element-Namens.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFSetValueByName($sName[, $sValue = ""[, $iIndex = 0]])
; Parameter(s): .: $sName       - Name of the element
;                  $sValue      - Optional: (Default = "") : Value to set
;                  $iIndex      - Optional: (Default = 0) : Index of the element (0-n)
; Return Value ..: Success      - 1
;                  Failure      - 0
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........:Mon Jun 12 21:49:06 CEST 2017 @867 /Internet-Zeit/
; Link ..........:
; Related .......: _FFSetValueById, _FFGetValueById, _FFGetValueByName, _FFXPath
; Example .......: Yes
; ==============================================================================
Func _FFSetValueByName($sName, $sValue = "", $iIndex = 0)
	Return _FFSetValue($sValue, $sName, "name", $iIndex)
EndFunc   ;==>_FFSetValueByName
; #FUNCTION# ===================================================================
; Name ..........: _FFTabCloseAll
; Description ...: Closes all Tabs except the selected
; Beschreibung ..: Schließt alle Tabs, auÃer dem Aktiven.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFTabCloseAll()
; Parameter(s): .:
; Return Value ..: Success      - 1
;                  Failure      - 0
; Author(s) .....: Thorsten Willert
; Date ..........: Mon Mar 23 22:43:12 CET 2009 @946 /Internet Time/
; Link ..........: https://developer.mozilla.org/en/XUL/tabs
; Related .......:_FFTabAdd, _FFTabDuplicate, _FFTabClose, _FFTabExists, _FFTabGetLength, _FFTabSetSelected, _FFTabGetSelected
; Example .......: Yes
; ==============================================================================
Func _FFTabCloseAll()
	Return _FFTabClose("all", "key")
EndFunc   ;==>_FFTabCloseAll
; #FUNCTION# ===================================================================
; Name ..........: _FFTabGetLength
; Description ...: Length of the tabs
; Beschreibung ..: Liefert die Anzahl aller vorhandener Tabs.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFTabGetLength()
; Parameter(s): .:
; Return Value ..: Success      - Tab index 0-n
;                  Failure      - -1
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Mon Mar 23 22:39:15 CET 2009 @943 /Internet Time/
; Link ..........: https://developer.mozilla.org/en/XUL/tabs
; Related .......: _FFTabAdd, _FFTabDuplicate, _FFTabClose, _FFTabCloseAll, _FFTabExists, _FFTabSetSelected, _FFTabGetSelected
; Example .......: Yes
; ==============================================================================
Func _FFTabGetLength()
	Return _FFGetLength("tabs")
EndFunc   ;==>_FFTabGetLength
; #FUNCTION# ===================================================================
; Name ..........: _FFTableGetCell
; Description ...: Returns the content of a table cell.
; Beschreibung ..: Liefert den Inhalt einer Tabellenzelle.
; AutoIt Version : V3.3.0.0
; Syntax ........: _FFTableGetCell($vTable, $iColumn, $iRow[, $sMode = "index"[, $sReturnMode = "text"[, $iFilter = 1]]])
; Parameter(s): .: $vTable      - index (0-n), name or id
;                  $iColumn     - Column (0-n)
;                  $iRow        - Row (0-n)
;                  $sMode       - Optional: (Default = "index") :
;                               | index (0-n)
;                               | name
;                               | id
;                  $sReturnMode - Optional: (Default = "text") :
;                               | text
;                               | html
;                  $iFilter     - Optional: (Default = 1) : you can add them:
;                               | 0 = No filter
;                               | 1 = Remove all non ASCII
;                               | 2 = Remove all double withespaces
;                               | 4 = Remove all double linefeeds
;                               | 8 = Remove all HTML-tags
;                               | 16 = simple html-tag / entities convertor
; Return Value ..: Success      - Text or HTML
;                  Failure      - ""
;                  @ERROR       -
; Author(s) .....: Thorsten Willert
; Date ..........: Sat Apr 11 22:56:21 CEST 2009
; Link ..........:
; Related .......: _FFTableWriteToArray
; Example .......: Yes
; ==============================================================================
Func _FFTableGetCell($vTable, $iColumn, $iRow, $sMode = "index", $sReturnMode = "text", $iFilter = 1)
	Local Const $sFuncName = "_FFTableGetCell"
	If $sMode = Default Then $sMode = "index"
	If $sReturnMode = Default Then $sReturnMode = "text"
	If Not IsInt($vTable) And $sMode = "index" Then
		SetError(__FFError($sFuncName, $_FF_ERROR_InvalidDataType, "(int) $vTable: " & $vTable))
		Return ""
	EndIf
	If Not IsInt($iColumn) Then
		SetError(__FFError($sFuncName, $_FF_ERROR_InvalidDataType, "(int) $iColumn: " & $iColumn))
		Return ""
	EndIf
	If Not IsInt($iRow) Then
		SetError(__FFError($sFuncName, $_FF_ERROR_InvalidDataType, "(int) $iRow: " & $iRow))
		Return ""
	EndIf
	Switch StringLower($sReturnMode)
		Case "text"
			$sReturnMode = "textContent"
		Case "html"
			$sReturnMode = "innerHTML"
		Case Else
			SetError(__FFError($sFuncName, $_FF_ERROR_InvalidValue, "(text|html) $sReturnMode: " & $sReturnMode))
			Return ""
	EndSwitch
	Local $sObject = "content.document"
	Switch StringLower($sMode)
		Case "index"
			$sObject &= ".getElementsByTagName('tbody')[" & $vTable & "]"
		Case "name"
			ContinueCase
		Case "id"
			$sObject &= ".getElementsByTagName('tbody')['" & $vTable & "']"
		Case Else
			SetError(__FFError($sFuncName, $_FF_ERROR_InvalidValue, "(index|name|id) $sMode: " & $sMode))
			Return ""
	EndSwitch
	$sObject &= StringFormat(".getElementsByTagName('tr')[%i].getElementsByTagName('td')[%i]", $iRow, $iColumn)
	Local $sRetVal = _FFCmd($sObject & "." & $sReturnMode & ";")
	If Not @error And $sRetVal <> "_FFCmd_Err" Then
		If $iFilter > 0 Then __FFFilterString($sRetVal, $iFilter)
		Return $sRetVal
	Else
		SetError(__FFError($sFuncName, $_FF_ERROR_NoMatch, "Table/Column/Row: " & $vTable & "/" & $iColumn & "/" & $iRow))
		Return ""
	EndIf
EndFunc   ;==>_FFTableGetCell