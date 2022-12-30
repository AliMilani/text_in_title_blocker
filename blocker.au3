#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

$sWordsFileName = "words.txt"
$aWords = FileReadToArray($sWordsFileName)
$windowIsHide = True

HotKeySet("{ESC}", "Close")
HotKeySet("{F1}", "OpenSettings")

Func Close()
	Exit
EndFunc   ;==>Close

Func _ReloadListBoxItems($WordsList)
	$LISTBOX_SEPARATOR = "|"
	$aWords = FileReadToArray($sWordsFileName)
	GUICtrlSetData($WordsList, "")
	$sWordsList = _ArrayToString($aWords, $LISTBOX_SEPARATOR)
	GUICtrlSetData($WordsList, $sWordsList)
	_GUICtrlListBox_SetSel($WordsList)
EndFunc   ;==>_ReloadListBoxItems

Func _SaveWordsToFile($aWords = $aWords)
	FileDelete($sWordsFileName)
	FileWrite($sWordsFileName, _ArrayToString($aWords, @CRLF))
	FileWrite($sWordsFileName, @CRLF)
EndFunc   ;==>_SaveWordsToFile

Func _InsertWord($newWord, $aWords)
	FileWrite($sWordsFileName, $newWord & @CRLF)
EndFunc   ;==>_InsertWord

Func OpenSettings()
	$SettingsForm = GUICreate("Word In Title Blocker", 249, 335, 192, 124)
	$AddBtn = GUICtrlCreateButton("Add", 40, 288, 65, 25)
	$WordsList = GUICtrlCreateList("", 24, 8, 201, 227, BitOR($WS_BORDER, $WS_VSCROLL))
	$DeleteBtn = GUICtrlCreateButton("Remove", 136, 288, 65, 25)
	$WordTextBoxEdit = GUICtrlCreateEdit("", 32, 256, 177, 25, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetData($WordTextBoxEdit, "")
	GUISetState(@SW_SHOW)

	_ReloadListBoxItems($WordsList)

	$windowIsHide = False

	While 1
		Sleep(10)

		$nMsg = GUIGetMsg()

		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUISetState(@SW_HIDE)
				$windowIsHide = True

		EndSwitch

		Select
		
			Case $nMsg = $AddBtn
				$newWord = GUICtrlRead($WordTextBoxEdit)
				If $newWord <> "" Then
					_InsertWord($newWord, $aWords)
				EndIf
				_ReloadListBoxItems($WordsList)

				;~ clear edit box after add
				GUICtrlSetData($WordTextBoxEdit, "")

			Case $nMsg = $DeleteBtn
				;~ get selected item index in list box to remove
				$selItems = _GUICtrlListBox_GetAnchorIndex($WordsList)
				_ArrayDelete($aWords, $selItems)
				;~ write to new words.txt
				_SaveWordsToFile()

				_ReloadListBoxItems($WordsList)

		EndSelect

		If $windowIsHide Then
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>OpenSettings


;~ #NoTrayIcon
;~ #RequireAdmin

;close the active window if contains the word
Func _CheckWordInText($text)
	For $w = 0 To UBound($aWords) - 1
		If StringInStr($text, $aWords[$w]) Then
			Return $aWords[$w]
		EndIf
	Next
	Return False
EndFunc   ;==>_CheckWordInText

Func _CloseActiveWindow()
	WinClose("[active]")
EndFunc   ;==>_CloseActiveWindow

Func _GetActiveWindowTitle()
	Return WinGetTitle("[active]")
EndFunc   ;==>_GetActiveWindowTitle

Func Main()
	While True
		If _CheckWordInText(_GetActiveWindowTitle()) Then
			_CloseActiveWindow()
		EndIf

		ConsoleWrite("Active Window ===> " & _GetActiveWindowTitle() & @CRLF)
		Sleep(1000)
	WEnd
EndFunc   ;==>Main

Main()


