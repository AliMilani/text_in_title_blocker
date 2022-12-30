#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#Region ### START Koda GUI section ### Form=c:\users\zero\documents\text_blocker\form1.kxf

$words = FileReadToArray("words.txt")
$windowIsHide= True
HotKeySet("{ESC}", "Close")
HotKeySet("{F1}", "OpenSettings")

Func Close()
   Exit
EndFunc

Func _reloadListBoxItems($List1, $words)
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
	#EndRegion ### END Koda GUI section ###

	;~ set list items from $words array
	;~ GUICtrlSetData($List1, _ArrayToString($words, "|"))
	;~ _GUICtrlListBox_SetSel($List1)
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

			;~ Case $Button1
				

		EndSwitch

		Select
			Case $nMsg = $Button1
				;~ $selItems = _GUICtrlListBox_GetAnchorIndex($List1)
				;~ MsgBox(0, $selItems, "Item Selected: " & $words[$selItems]) ; $selItems[1] cooresponds to the the selected text value in this array
				
				;~ add item to list and save to words.txt
				$newWords = GUICtrlRead($Edit1)
				;~ apped to words.txt
				if $newWords <> "" Then
					FileWrite("words.txt", $newWords & @CRLF)
				EndIf
				;~ FileWrite("words.txt", $newWords & @CRLF)
				;~ reload list
				$words = FileReadToArray("words.txt")
				;~ clear list box
				;~ GUICtrlSetData($List1, "")
				;~ GUICtrlSetData($List1, _ArrayToString($words, "|"))
				;~ _GUICtrlListBox_SetSel($List1)
				_reloadListBoxItems($List1, $words)

				;~ clear edit box
				GUICtrlSetData($Edit1, "")
			Case $nMsg = $Button2
				;~ remove line from words.txt
				$selItems = _GUICtrlListBox_GetAnchorIndex($List1)
				;~ remove line from words array and write to words.txt
				_ArrayDelete($words, $selItems)
				;~ write to words.txt
				FileDelete("words.txt")
				FileWrite("words.txt", _ArrayToString($words, @CRLF))
				FileWrite("words.txt", @CRLF)
				;~ clear list
				;~ GUICtrlSetData($List1, "")
				;~ GUICtrlSetData($List1, _ArrayToString($words, "|"))
				;~ _GUICtrlListBox_SetSel($List1)
				_reloadListBoxItems($List1, $words)

		EndSelect

		If $windowIsHide Then
			ExitLoop
		EndIf
	WEnd
EndFunc


;~ #NoTrayIcon
;~ #RequireAdmin
Func checkWordInText($text)
	For $w = 0 To UBound($words) - 1
		If StringInStr($text, $words[$w]) Then
			; close the active window
			WinClose("[active]")
			Return $words[$w]
		EndIf
	Next
	Return False
EndFunc   ;==>checkWordInText

While True
	Sleep(1000)
;~ ConsoleWrite( WinGetTitle("[active]") & @CRLF)
;~   If checkWordInText(WinGetTitle("[active]")) Then
;~     ConsoleWrite("Found" & @CRLF)
;~   EndIf
	ConsoleWrite(checkWordInText(WinGetTitle("[active]")) & @CRLF)
WEnd



