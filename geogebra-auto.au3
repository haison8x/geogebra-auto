#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include "helper.au3"

; Create and show the main form
Func CreateMainForm()
    ; Create the GUI
    Local $hGUI = GUICreate("GeoGebra Auto", 600, 400)

    ; Create the text area (Edit control)
    Local $hEdit = GUICtrlCreateEdit("", 10, 10, 580, 340)

    ; Create the Auto Fill button
    Local $hButton = GUICtrlCreateButton("Auto Fill", 250, 360, 100, 30)

    ; Set default text for the edit control
    GUICtrlSetData($hEdit, "# Enter your commands here" & @CRLF & _
                          "# Each command on a new line" & @CRLF & _
                          "# Lines starting with # are comments")

    ; Show the GUI
    GUISetState(@SW_SHOW, $hGUI)

	; Message loop
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $hButton
                ; Get the text from the edit control
                Local $sText = GUICtrlRead($hEdit)

                ; Process the commands using ExtractCommand function
                Local $aCommands = ExtractCommand($sText)

                ; Check if we have any commands to process
                If UBound($aCommands) = 0 Then
                    MsgBox($MB_ICONWARNING, "Warning", "No valid commands found!")
                    ContinueLoop
                EndIf

                ; Wait for any window containing GeoGebra to be active
                Local $hGeoGebra = 0
                Local $sTitle = ""
                While 1
                    $sTitle = WinGetTitle("[ACTIVE]")
                    If StringInStr($sTitle, "GeoGebra") > 0 Then
                        $hGeoGebra = WinGetHandle("[ACTIVE]")
                        ExitLoop
                    EndIf
                    Sleep(100)
                WEnd

                If Not $hGeoGebra Then
                    MsgBox($MB_ICONERROR, "Error", "Could not find GeoGebra window!")
                    ContinueLoop
                EndIf

                ; Wait 3 seconds
                Sleep(5000)

                ; Process each command
                For $i = 0 To UBound($aCommands) - 1
                    ; Send the command
					ClipPut($aCommands[$i]) ; Copy vào clipboard
					Send("^v")              ; Dán (Ctrl+V)
                    ; Send Enter key
                    Send("{ENTER}")
                    ; Small delay between commands
                    Sleep(200)
                Next

                MsgBox($MB_OK, "Success", "Processed " & UBound($aCommands) & " commands!")
        EndSwitch
    WEnd

    ; Clean up
    GUIDelete($hGUI)
EndFunc

; Start the application
CreateMainForm()
