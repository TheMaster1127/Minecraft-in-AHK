;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Name:
; Minecraft in AHK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#singleinstance force
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;;;;;;;;;;;;;;;;;;;;;

; Set the Border dimensions and Block size
;~ BorderHeight := 1050
;~ BorderWidth := 1920
;testing
BorderHeight := 300
BorderWidth := 500
BlockWidth := 50
BlockHeight := 50

;~ Random, Ran1, 500, 1050
;~ Random, Ran2, 500, 1920
;~ Random, Ran3, 20, 150
;~ Random, Ran4, 20, 150

;~ BorderHeight := Ran1
;~ BorderWidth := Ran2
;~ BlockWidth := Ran3
;~ BlockHeight := Ran4



; Calculate the total number of blocks
BlocksInHeight := BorderHeight // BlockHeight
BlocksInWidth := BorderWidth // BlockWidth
TotalBlocks := BlocksInHeight * BlocksInWidth

Row := 3
Row4 := 4
BlocksInWidthRow := BlocksInWidth * Row + 1
BlocksInWidthRow4 := BlocksInWidth * Row4 + 1

RandomBlocksTopLayer := Floor(BlocksInWidth / 2)

;MsgBox, BlocksInWidthRow4 : %BlocksInWidthRow4%
;MsgBox, RandomBlocksTopLayer: %RandomBlocksTopLayer%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
N := BlocksInWidth
MIN := BlocksInWidthRow
MAX := BlocksInWidthRow + BlocksInWidth
name = RanTopLayer
Loop %N%
{
  i := A_Index
  loop
  {
    Random R, %MIN%, %MAX%     ; R = random number
    j := Index_%R%             ; get value from Indexes
    If j is number
      If j between 1 and % i - 1
        If (R_%j% = R)
          continue             ; repetition found, try again
    Index_%R% := i             ; store index
    R_%i% := R                 ; store in R_1, R_2...
    break                      ; different number
  }
}
nnn := 1
Loop, %N%
{
%name%%nnn% := R_%nnn%
nnn++
}
;MsgBox, %RanTopLayer1% %RanTopLayer2% %RanTopLayer3% ...

MsgboxVar := ""
Loop, %RandomBlocksTopLayer%
{
MsgboxVar .= RanTopLayer%A_Index% " "
}
;MsgBox, %MsgboxVar%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;MsgBox, BlockAfterWidth Row %Row%: %BlocksInWidthRow%
;MsgBox, BlocksInWidth: %BlocksInWidth%
;MsgBox, You can fit %TotalBlocks% blocks of size %BlockWidth%x%BlockHeight% within the given Border dimensions.

RestOfBlocksForGenNum := TotalBlocks - BlocksInWidthRow4 + 1
;MsgBox, RestOfBlocksForGenNum : %RestOfBlocksForGenNum%

Loop, %RandomBlocksTopLayer%
{


; Specify the position number for which you want to find the coordinates
PositionNumber := RanTopLayer%A_Index%  ; Change this to the desired position number

; Calculate the row and column of the specified block
BlocksInWidth := BorderWidth // BlockWidth
Row := Ceil(PositionNumber / BlocksInWidth)
Col := Mod(PositionNumber, BlocksInWidth)
if (Col = 0)
    Col := BlocksInWidth

; Calculate the X and Y coordinates of the specified block
XCoordinate := (Col - 1) * BlockWidth
YCoordinate := (Row - 1) * BlockHeight
;MsgBox, Block number %PositionNumber% is located at X: %XCoordinate%, Y: %YCoordinate% within the grid.
TopLayerXCoordinate%A_Index% := XCoordinate
TopLayerYCoordinate%A_Index% := YCoordinate

}

num := BlocksInWidthRow4
Loop, %RestOfBlocksForGenNum%
{
; Specify the position number for which you want to find the coordinates
PositionNumber := num  ; Change this to the desired position number
num++
; Calculate the row and column of the specified block
BlocksInWidth := BorderWidth // BlockWidth
Row := Ceil(PositionNumber / BlocksInWidth)
Col := Mod(PositionNumber, BlocksInWidth)
if (Col = 0)
    Col := BlocksInWidth

; Calculate the X and Y coordinates of the specified block
XCoordinate := (Col - 1) * BlockWidth
YCoordinate := (Row - 1) * BlockHeight
;MsgBox, Block number %PositionNumber% is located at X: %XCoordinate%, Y: %YCoordinate% within the grid.
OtherLayersXCoordinate%A_Index% := XCoordinate
OtherLayersYCoordinate%A_Index% := YCoordinate
}


Loop, %TotalBlocks%
{

; Specify the position number for which you want to find the coordinates
PositionNumber := A_Index  ; Change this to the desired position number
num++
; Calculate the row and column of the specified block
BlocksInWidth := BorderWidth // BlockWidth
Row := Ceil(PositionNumber / BlocksInWidth)
Col := Mod(PositionNumber, BlocksInWidth)
if (Col = 0)
    Col := BlocksInWidth

; Calculate the X and Y coordinates of the specified block
XCoordinate := (Col - 1) * BlockWidth
YCoordinate := (Row - 1) * BlockHeight
;MsgBox, Block number %PositionNumber% is located at X: %XCoordinate%, Y: %YCoordinate% within the grid.
BlockXCoordinate%A_Index% := XCoordinate
BlockYCoordinate%A_Index% := YCoordinate

}

; Display the results
;MsgBox, Block number %PositionNumber% is located at X: %XCoordinate%, Y: %YCoordinate% within the grid.



PlayerX := 50
PlayerY := 40
PlayerW := 40
PlayerH := 90

Speed := 1
MaxSpeed := 7

Gui, Color, 61c6dd
Gui -DPIScale
;Gui +AlwaysOnTop
Gui, Font, s15
Gui, Add, Text, x10 y10 w130 h30, Health 10

Gui, Font, s8
Gui, Add, Picture, x%PlayerX% y%PlayerY% w%PlayerW% h%PlayerH% vPlayer gPlayer, Player.png
Gui, Font, s15
Gui, Show, w%BorderWidth% h%BorderHeight%, Game Colition Idea AHK




Loop, %TotalBlocks%
{
x := BlockXCoordinate%A_Index%
y := BlockYCoordinate%A_Index%
Gui, Add, Picture, x%x% y%y% w%BlockWidth% h%BlockHeight% vBlock%A_Index% gBlock , Block.png
GuiControl, Hide, Block%A_Index%
isBlock%A_Index% := 0
}





Loop, %RandomBlocksTopLayer%
{
x := TopLayerXCoordinate%A_Index%
y := TopLayerYCoordinate%A_Index%

XCoordinate := x  ; Replace with the desired X coordinate
YCoordinate := y  ; Replace with the desired Y coordinate

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col

;MsgBox, Block at X: %XCoordinate%, Y: %YCoordinate% is block number %BlockNumber% within the grid.

GuiControl, Show, Block%BlockNumber%
isBlock%BlockNumber% := 1
;Gui, Add, Button, x%x% y%y% w%BlockWidth% h%BlockHeight% ,
}

Loop, %RestOfBlocksForGenNum%
{
x := OtherLayersXCoordinate%A_Index%
y := OtherLayersYCoordinate%A_Index%


XCoordinate := x  ; Replace with the desired X coordinate
YCoordinate := y  ; Replace with the desired Y coordinate

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col

;MsgBox, Block at X: %XCoordinate%, Y: %YCoordinate% is block number %BlockNumber% within the grid.

GuiControl, Show, Block%BlockNumber%
isBlock%BlockNumber% := 1
;Gui, Add, Button, x%x% y%y% w%BlockWidth% h%BlockHeight% ,
}
GuiControl, Show, Block8
isBlock8 := 1
GuiControl, Show, Block7
isBlock7 := 1
GuiControl, Show, Block6
isBlock6 := 1

Gui, Show, w%BorderWidth% h%BorderHeight%, Minecraft AHK
SetTimer, GameLoop, 1
Returnu

Player:
MsgBox, 262144,,  Hi its me player
Return

Block:

Return



GameLoop:
Loop, 1
{
IfWinActive Minecraft AHK
{
if (GetKeyState("Escape", "P"))
{
; Exit the script if the Escape key is pressed
MsgBox, 260, Pause, Do you wnat to exit the game?`n
IfMsgBox Yes
{
;Save()
ExitApp
}
}
else if (GetKeyState("Up", "P"))
{
If (!FuncCollision())
{
Last := "U"
; Perform actions for pressing the Up arrow key
PlayerX := PlayerX
PlayerY := PlayerY - Speed
Speed := Speed + 0.1
if (Speed >= MaxSpeed)
{
Speed := MaxSpeed
}
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
}
}
else if (GetKeyState("Down", "P"))
{
If (!FuncCollision())
{
Last := "D"
; Perform actions for pressing the Down arrow key
PlayerX := PlayerX
PlayerY := PlayerY + Speed
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
Speed := Speed + 0.1
if (Speed >= MaxSpeed)
{
Speed := MaxSpeed
}
}
}
else if (GetKeyState("Left", "P"))
{
If (!FuncCollision())
{
Last := "L"
; Perform actions for pressing the Left arrow key
PlayerX := PlayerX - Speed
PlayerY := PlayerY
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
Speed := Speed + 0.1
if (Speed >= MaxSpeed)
{
Speed := MaxSpeed
}
}
}
else if (GetKeyState("Right", "P"))
{
If (!FuncCollision())
{
Last := "R"
; Perform actions for pressing the Right arrow key
PlayerX := PlayerX + Speed
PlayerY := PlayerY
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
Speed := Speed + 0.1
if (Speed >= MaxSpeed)
{
Speed := MaxSpeed
}
}
}
else
{
; else
Speed := 1
}
}
}
Return






FuncCollision()
{
global



x1 := PlayerX
y1 := PlayerY

x2 := PlayerX + PlayerW
y2 := PlayerY

x3 := PlayerX
y3 := PlayerY + PlayerH - 1 ; so the player dsoent seem to float

x4 := PlayerX + PlayerW
y4 := PlayerY + PlayerH - 1 ; so the player dsoent seem to float

Loop, 4
{

XCoordinate := x%A_Index%  ; Replace with the desired X coordinate
YCoordinate := y%A_Index%  ; Replace with the desired Y coordinate

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col
BlockNumber := Round(BlockNumber)
BlockNumber := Abs(BlockNumber)
b%A_Index% := Round(isBlock%BlockNumber%)
}



    XCoordinate := PlayerX
    YCoordinate := PlayerY

    ; Check if the XCoordinate is outside the game border
    if (XCoordinate < 0 || XCoordinate > BorderWidth - PlayerW) {
        b1 := 1
    }

    ; Check if the YCoordinate is outside the game border
    if (YCoordinate < 0 || YCoordinate > BorderHeight - PlayerH) {
        b1 := 1
    }





if (b1 = 1) or (b2 = 1) or (b3 = 1) or (b4 = 1)
{
;MsgBox, %b1% %b2% %b3% %b4%
Speed := 1
if (Last = "U")
{
PlayerX := PlayerX
PlayerY := PlayerY + 1
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
}


if (Last = "D")
{
PlayerX := PlayerX
PlayerY := PlayerY - 1
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
}


if (Last = "L")
{
PlayerX := PlayerX + 1
PlayerY := PlayerY
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
}


if (Last = "R")
{
PlayerX := PlayerX - 1
PlayerY := PlayerY
GuiControl, Move, Player, x%PlayerX% y%PlayerY%
}

return true
}
else
{
return false
}

Return




}



!L::
GuiClose:
ExitApp
Return



