#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

$words = FileReadToArray("words.txt")
$windowIsHide= True
HotKeySet("{ESC}", "Close")
HotKeySet("{F1}", "OpenSettings")

Func Close()
   Exit
EndFunc

Func _reloadListBoxItems($List1, $words)
	$words = FileReadToArray("words.txt")
	GUICtrlSetData($List1, "")
	GUICtrlSetData($List1, _ArrayToString($words, "|"))
	_GUICtrlListBox_SetSel($List1)
EndFunc

Func OpenSettings()
	$Form1_1 = GUICreate("Form1", 249, 335, 192, 124)
	$Button1 = GUICtrlCreateButton("add", 40, 288, 65, 25)
	$List1 = GUICtrlCreateList("", 24, 8, 201, 227,BitOR($WS_BORDER, $WS_VSCROLL))
	$Button2 = GUICtrlCreateButton("Remove", 136, 288, 65, 25)
	$Edit1 = GUICtrlCreateEdit("", 32, 256, 177, 25, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN))
	GUICtrlSetData(-1, "Edit1")
	GUISetState(@SW_SHOW)

	_reloadListBoxItems($List1, $words)

	$windowIsHide = False

	While 1
		Sleep(10)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				;~ Exit
				GUISetState(@SW_HIDE)
				$windowIsHide = True				

		EndSwitch

		Select
			Case $nMsg = $Button1
				$newWords = GUICtrlRead($Edit1)
				if $newWords <> "" Then
					FileWrite("words.txt", $newWords & @CRLF)
				EndIf
				_reloadListBoxItems($List1, $words)

				;~ clear edit box after add
				GUICtrlSetData($Edit1, "")
			Case $nMsg = $Button2
				;~ get selected item index in list box to remove
				$selItems = _GUICtrlListBox_GetAnchorIndex($List1)
				_ArrayDelete($words, $selItems)
				;~ write to new words.txt
				FileDelete("words.txt")
				FileWrite("words.txt", _ArrayToString($words, @CRLF))
				FileWrite("words.txt", @CRLF)

				_reloadListBoxItems($List1, $words)

		EndSelect

		If $windowIsHide Then
			ExitLoop
		EndIf
	WEnd
EndFunc


;~ #NoTrayIcon
;~ #RequireAdmin

;close the active window if contains the word
Func checkWordInText($text)
	For $w = 0 To UBound($words) - 1
		If StringInStr($text, $words[$w]) Then
			WinClose("[active]")
			Return $words[$w]
		EndIf
	Next
	Return False
EndFunc   ;==>checkWordInText

While True
	;~ loop every 1 second to check the active window title
	ConsoleWrite(checkWordInText(WinGetTitle("[active]")) & @CRLF)
	Sleep(1000)
WEnd



