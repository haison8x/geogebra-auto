; Helper functions for GeoGebra Auto
; Function to extract commands from a string, handling comments and empty lines
; Parameters:
;   $sInput - Input string containing commands
; Returns:
;   Array of processed command lines
Func ExtractCommand($sInput)
    ; Split input into lines
    Local $aLines = StringSplit($sInput, @CRLF, $STR_ENTIRESPLIT)
    Local $aResult[0]
    Local $iResultIndex = 0
    
    ; Process each line
    For $i = 1 To $aLines[0]
        ; Trim the line
        Local $sLine = StringStripWS($aLines[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
        
        ; Skip empty lines
        If $sLine = "" Then ContinueLoop
        
        ; Skip lines starting with #
        If StringLeft($sLine, 1) = "#" Then ContinueLoop
        
        ; Remove comments (text after #)
        Local $iCommentPos = StringInStr($sLine, "#")
        If $iCommentPos > 0 Then
            $sLine = StringLeft($sLine, $iCommentPos - 1)
            $sLine = StringStripWS($sLine, $STR_STRIPLEADING + $STR_STRIPTRAILING)
        EndIf
        
        ; Add non-empty processed line to result
        If $sLine <> "" Then
            ReDim $aResult[$iResultIndex + 1]
            $aResult[$iResultIndex] = $sLine
            $iResultIndex += 1
        EndIf
    Next
    
    Return $aResult
EndFunc 