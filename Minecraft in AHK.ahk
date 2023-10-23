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
#MaxHotkeysPerInterval 99999999999999999999999999999999999
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode, Relative
;;;;;;;;;;;;;;;;;;;;;

; Set the Border dimensions and Block size
BorderHeight := 1050
BorderWidth := 1920
;testing
;~ BorderHeight := 400
;~ BorderWidth := 500
BlockWidth := 50
BlockHeight := 50
GroundHeight := 10
;~ Random, Ran1, 500, 1050
;~ Random, Ran2, 500, 1920
;~ Random, Ran3, 20, 150
;~ Random, Ran4, 20, 150

;~ BorderHeight := Ran1
;~ BorderWidth := Ran2
;~ BlockWidth := Ran3
;~ BlockHeight := Ran4

gameStarted := 0

; Calculate the total number of blocks
BlocksInHeight := BorderHeight // BlockHeight
BlocksInWidth := BorderWidth // BlockWidth
TotalBlocks := BlocksInHeight * BlocksInWidth

Row1 := GroundHeight
Row2 := Row1 + 1
BlocksInWidthRow3 := BlocksInWidth * Row1 + 1
BlocksInWidthRow4 := BlocksInWidth * Row2 + 1

RandomBlocksTopLayer := Floor(BlocksInWidth / 2)

;MsgBox, BlocksInWidthRow4 : %BlocksInWidthRow4%
;MsgBox, RandomBlocksTopLayer: %RandomBlocksTopLayer%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
N := BlocksInWidth
MIN := BlocksInWidthRow3
MAX := BlocksInWidthRow3 + BlocksInWidth
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
typeOfBlock%A_Index% := "air"
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


Gui, Font, s8
Gui, Add, Picture, x%PlayerX% y%PlayerY% w%PlayerW% h%PlayerH% vPlayer , Player.png
Gui, Font, s15
Gui, Show, w%BorderWidth% h%BorderHeight%, Minecraft AHK
WinName := "Minecraft AHK"




Loop, %TotalBlocks%
{
x := BlockXCoordinate%A_Index%
y := BlockYCoordinate%A_Index%
Gui, Add, Picture, x%x% y%y% w%BlockWidth% h%BlockHeight% vBlock%A_Index% , stone.png
GuiControl, Hide, Block%A_Index%
typeOfBlock%A_Index% := "air"
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
typeOfBlock%BlockNumber% := "stone"
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
typeOfBlock%BlockNumber% := "stone"
isBlock%BlockNumber% := 1
;Gui, Add, Button, x%x% y%y% w%BlockWidth% h%BlockHeight% ,
}



BlocksAtWidthRow1 := BlocksInWidth * Row1
BlocksAtWidthRow2 := BlocksInWidth * Row2

Loop, 2
{
if (A_Index = 1)
{
BlocksAtWidthRow := BlocksAtWidthRow1
}
else
{
BlocksAtWidthRow := BlocksAtWidthRow2
}
Loop, %BlocksInWidth%
{
BlocksAtWidthRow++
b := BlocksAtWidthRow - BlocksInWidth
if (isBlock%BlocksAtWidthRow% = 1) && (isBlock%b% = 0)
{
GuiControl, , Block%BlocksAtWidthRow%, grass.png
typeOfBlock%BlocksAtWidthRow% := "grass"
BlockUnder := BlocksAtWidthRow + BlocksInWidth
GuiControl, , Block%BlockUnder%, dirt.png
typeOfBlock%BlockUnder% := "dirt"
BlockUnder := BlocksAtWidthRow + BlocksInWidth + BlocksInWidth
GuiControl, , Block%BlockUnder%, dirt.png
typeOfBlock%BlockUnder% := "dirt"
}

}

} ; end of Loop, 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; adding trees
; Define the total number of blocks
totalBlocks := BlocksInWidth

; Find the middle point
middlePoint := Floor(totalBlocks / 2)

; Find the point between the middle and the beginning
betweenMiddleAndBeginning := Floor(middlePoint / 2)

; Find the point between the middle and the end
betweenMiddleAndEnd := middlePoint + Floor((totalBlocks - middlePoint) / 2)

; Display the results
;MsgBox Middle Point: %middlePoint%`nBetween Middle and Beginning: %betweenMiddleAndBeginning%`nBetween Middle and End: %betweenMiddleAndEnd%


Loop, 3
{
if (A_Index = 1)
{
point := betweenMiddleAndBeginning
}
if (A_Index = 2)
{
point := middlePoint
}
if (A_Index = 3)
{
point := betweenMiddleAndEnd
}

numOfIndex := BlocksInHeight
Loop, %BlocksInHeight%
{
targetBlock := numOfIndex * BlocksInWidth + point
if (isBlock%targetBlock% = 0)
{
break
}
numOfIndex--
}
targetBlock%A_Index% := targetBlock


} ; and of Loop, 3

;MsgBox, %targetBlock1% %targetBlock2% %targetBlock3%


Loop, 3
{
if (A_Index = 1)
{
targetBlock := targetBlock%A_Index%
}

if (A_Index = 2)
{
targetBlock := targetBlock%A_Index%
}

if (A_Index = 3)
{
targetBlock := targetBlock%A_Index%
}

num := 0
Random, ranTree, 3, 6
Loop, %ranTree%
{
if (A_Index = 1)
{
GuiControl, , Block%targetBlock%, log.png
GuiControl, Show, Block%targetBlock%
isBlock%targetBlock% := 1
typeOfBlock%targetBlock% := "log"
}
else
{
num++
LogBlock := targetBlock - (BlocksInWidth * num)

GuiControl, , Block%LogBlock%, log.png
GuiControl, Show, Block%LogBlock%
isBlock%LogBlock% := 1
typeOfBlock%LogBlock% := "log"

}


} ; end of Loop, %ranTree%

lastLog := LogBlock
posOfLeaf1 := lastLog - (BlocksInWidth * 1)
posOfLeaf2 := lastLog - (BlocksInWidth * 2)
posOfLeaf3 := posOfLeaf2 - 1
posOfLeaf4 := posOfLeaf2 + 1
posOfLeaf5 := posOfLeaf1 - 1
posOfLeaf6 := posOfLeaf1 - 2
posOfLeaf7 := posOfLeaf1 + 1
posOfLeaf8 := posOfLeaf1 + 2
posOfLeaf9 := lastLog + 1
posOfLeaf10 := lastLog + 2
posOfLeaf11 := lastLog - 1
posOfLeaf12 := lastLog - 2
Loop, 12
{
Leaf := posOfLeaf%A_Index%
GuiControl, , Block%Leaf%, leaf.png
GuiControl, Show, Block%Leaf%
isBlock%Leaf% := 1
typeOfBlock%Leaf% := "leaf"
}


} ; end of main Loop, 3

SelectedBlock := ""
stone := 0
grass := 0
dirt := 0
log := 0
leaf := 0
Gui, Show, w%BorderWidth% h%BorderHeight%, Minecraft AHK
WinName := "Minecraft AHK"
SetTimer, GameLoop, 1
SetTimer, airBlocksFix, 1
gameStarted := 1
CanPlaceBlocks := 1
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
else if (GetKeyState("Up", "P")) or (GetKeyState("W", "P"))
{
If (!FuncCollision())
{
Last := "U"
CanPlaceBlocks := 0
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
else if (GetKeyState("Down", "P")) or (GetKeyState("S", "P"))
{
If (!FuncCollision())
{
Last := "D"
CanPlaceBlocks := 0
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
else if (GetKeyState("Left", "P")) or (GetKeyState("A", "P"))
{
If (!FuncCollision())
{
Last := "L"
CanPlaceBlocks := 0
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
else if (GetKeyState("Right", "P")) or (GetKeyState("D", "P"))
{
If (!FuncCollision())
{
Last := "R"
CanPlaceBlocks := 0
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
CanPlaceBlocks := 1
GuiControl, , Player, player.png
}
}
}
Return

airBlocksFix:
Loop, %TotalBlocks%
{

if (typeOfBlock%A_Index% = "air")
{
isBlock%A_Index% := 0
}
}
Return













#If WinActive(WinName)
#If MouseIsOver(WinName)

W::
S::
A::
D::
Return

~LButton::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (gameStarted = 0)
{
return
}
if (GuiInventory = 1)
{
Return
}
;MsgBox, hi
MouseGetPos, xpos, ypos
XCoordinate := xpos - 5  ; Replace with the desired X coordinate
YCoordinate := ypos - 30  ; Replace with the desired Y coordinate

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col

;MsgBox, Block at X: %XCoordinate%, Y: %YCoordinate% is block number %BlockNumber% within the grid.


BlockUp := BlockNumber - BlocksInWidth
BlockDown := BlockNumber + BlocksInWidth
BlockLeft := BlockNumber - 1
BlockRight := BlockNumber + 1
;MsgBox, %BlockNumber%`n%BlockUp% %BlockDown% %BlockLeft% %BlockRight%

if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if !(BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1)
{
return
}
}

;;;;;;;;;;;;;;

if (BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if (!BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1)
{
return
}
}


if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1)
{
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

; Define the coordinates of the rectangle
x1 := PlayerX - 190
y1 := PlayerY - 190
x2 := PlayerX + PlayerW + 190
y2 := PlayerY + PlayerH + 190



; Check if the target coordinates are within the rectangle
if (XCoordinate >= x1 && XCoordinate <= x2 && YCoordinate >= y1 && YCoordinate <= y2)
{

}
else
{
;MsgBox, The target coordinates are outside the player's rectangle.
return
}






if (typeOfBlock%BlockNumber% != "air")
{
if (typeOfBlock%BlockNumber% = "stone")
{
stone++
typeOfBlock%BlockNumber% := "air"
GuiControl, Hide, Block%BlockNumber%
isBlock%BlockNumber% := 0
return
}
if (typeOfBlock%BlockNumber% = "grass")
{
grass++
typeOfBlock%BlockNumber% := "air"
GuiControl, Hide, Block%BlockNumber%
isBlock%BlockNumber% := 0
return
}
if (typeOfBlock%BlockNumber% = "dirt")
{
dirt++
typeOfBlock%BlockNumber% := "air"
GuiControl, Hide, Block%BlockNumber%
isBlock%BlockNumber% := 0
return
}
if (typeOfBlock%BlockNumber% = "leaf")
{
leaf++
typeOfBlock%BlockNumber% := "air"
GuiControl, Hide, Block%BlockNumber%
isBlock%BlockNumber% := 0
return
}
if (typeOfBlock%BlockNumber% = "log")
{
log++
typeOfBlock%BlockNumber% := "air"
GuiControl, Hide, Block%BlockNumber%
isBlock%BlockNumber% := 0
return
}
}
else
{
return
}
;GuiControl, , Inventory, Stone: %stone% Dirt: %dirt% Grass Block: %grass%


Return













#If WinActive(WinName)
#If MouseIsOver(WinName)
~RButton::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (CanPlaceBlocks = 0)
{
return
}
if (gameStarted = 0)
{
return
}
if (GuiInventory = 1)
{
Return
}

MouseGetPos, xpos, ypos
XCoordinate := xpos - 5  ; Replace with the desired X coordinate
YCoordinate := ypos - 30  ; Replace with the desired Y coordinate

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col

;MsgBox, Block at X: %XCoordinate%, Y: %YCoordinate% is block number %BlockNumber% within the grid.




BlockUp := BlockNumber - BlocksInWidth
BlockDown := BlockNumber + BlocksInWidth
BlockLeft := BlockNumber - 1
BlockRight := BlockNumber + 1
;MsgBox, %BlockNumber%`n%BlockUp% %BlockDown% %BlockLeft% %BlockRight%


if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if !(BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1)
{
return
}
}

;;;;;;;;;;;;;;

if (BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}

if (!BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1)
{
return
}
}


if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1)
{
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
return
}
}



; Define the coordinates of the rectangle
x1 := PlayerX - 50
y1 := PlayerY - 50
x2 := PlayerX + PlayerW + 50
y2 := PlayerY + PlayerH + 50



; Check if the target coordinates are within the rectangle
if (XCoordinate >= x1 && XCoordinate <= x2 && YCoordinate >= y1 && YCoordinate <= y2)
{
return
}
else
{
;MsgBox, The target coordinates are outside the player's rectangle.
}



; Define the coordinates of the rectangle
x1 := PlayerX - 190
y1 := PlayerY - 190
x2 := PlayerX + PlayerW + 190
y2 := PlayerY + PlayerH + 190



; Check if the target coordinates are within the rectangle
if (XCoordinate >= x1 && XCoordinate <= x2 && YCoordinate >= y1 && YCoordinate <= y2)
{

}
else
{
;MsgBox, The target coordinates are outside the player's rectangle.
return
}











;MsgBox, hi
if (SelectedBlock = "")
{
SelectedBlock := typeOfBlock%BlockNumber%
return
}
if (SelectedBlock <= 0)
{
return
}

if (typeOfBlock%BlockNumber% = "air")
{
if (SelectedBlock = "stone")
{
if (stone <= 0)
{
return
}
else
{
stone--
GuiControl, , Block%BlockNumber%, %SelectedBlock%.png
GuiControl, Show, Block%BlockNumber%
typeOfBlock%BlockNumber% := "stone"
isBlock%BlockNumber% := 1
return
}
}
if (SelectedBlock = "grass")
{
if (grass <= 0)
{
return
}
else
{
grass--
GuiControl, , Block%BlockNumber%, %SelectedBlock%.png
GuiControl, Show, Block%BlockNumber%
typeOfBlock%BlockNumber% := "grass"
isBlock%BlockNumber% := 1
return
}
}
if (SelectedBlock = "dirt")
{
if (dirt <= 0)
{
return
}
else
{
dirt--
GuiControl, , Block%BlockNumber%, %SelectedBlock%.png
GuiControl, Show, Block%BlockNumber%
typeOfBlock%BlockNumber% := "dirt"
isBlock%BlockNumber% := 1
return
}
}
if (SelectedBlock = "log")
{
if (log <= 0)
{
return
}
else
{
log--
GuiControl, , Block%BlockNumber%, %SelectedBlock%.png
GuiControl, Show, Block%BlockNumber%
typeOfBlock%BlockNumber% := "log"
isBlock%BlockNumber% := 1
return
}
}
if (SelectedBlock = "leaf")
{
if (leaf <= 0)
{
return
}
else
{
leaf--
GuiControl, , Block%BlockNumber%, %SelectedBlock%.png
GuiControl, Show, Block%BlockNumber%
typeOfBlock%BlockNumber% := "leaf"
isBlock%BlockNumber% := 1
return
}
}
}
else
{
SelectedBlock := typeOfBlock%BlockNumber%
return
}




;GuiControl, , Inventory, Stone: %stone% Dirt: %dirt% Grass Block: %grass%
;typeOfBlock%BlockNumber% := SelectedBlock

Return


#if

#If WinActive(WinName)
#If MouseIsOver(WinName)


1::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (gameStarted = 0)
{
return
}
SelectedBlock := "stone"
Return

2::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (gameStarted = 0)
{
return
}
SelectedBlock := "dirt"
Return

3::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (gameStarted = 0)
{
return
}
SelectedBlock := "grass"
Return

4::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (gameStarted = 0)
{
return
}
SelectedBlock := "log"
Return

5::
#If WinActive(WinName)
#If MouseIsOver(WinName)
if (gameStarted = 0)
{
return
}
SelectedBlock := "leaf"
Return

#if WinActive("Minecraft AHK") or WinActive("Inventory")
#If MouseIsOver("Minecraft AHK") or MouseIsOver("Inventory")
E::
#if WinActive("Minecraft AHK") or WinActive("Inventory")
#If MouseIsOver("Minecraft AHK") or MouseIsOver("Inventory")
if (gameStarted = 0)
{
return
}
if (GuiInventory = 1)
{
gosub GuiClose2
Return
}
GuiInventory := 1
Gui 2: new
Gui 2: Color, 121212
Gui 2: -DPIScale
Gui 2: +AlwaysOnTop
Gui 2: Font, s15
Gui 2: Add, Text, cWhite x10 y10 w200 h290 , Inventory`n`nStone: %stone%`nDirt: %dirt%`nGrass Block: %grass%`nLogs: %log%`nLeaves: %leaf%
Gui 2: Add, Text, cWhite x10 y350 w650 h300 , To select for placement`n`nStone: press 1`nDirt: press 2`nGrass Block: press 3`nLogs: press 4`nLeaves: press 5`nOr Right Click on any block in the world to select it
Gui 2: Show, w800 h600, Inventory
WinName := "Inventory"
Return

#If WinActive(WinName)
#If MouseIsOver(WinName)
Esc::
GuiCLose2:
WinName := "Minecraft AHK"
GuiInventory := 0
Gui 2: Destroy
Return


#if


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

x5 := PlayerX
y5 := PlayerY + (PlayerH // 2)

x6 := PlayerX + PlayerW
y6 := PlayerY + (PlayerH // 2)

Loop, 6
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





if (b1 = 1) or (b2 = 1) or (b3 = 1) or (b4 = 1) or (b5 = 1) or (b6 = 1)
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





}

MouseIsOver(vWinTitle:="", vWinText:="", vExcludeTitle:="", vExcludeText:="")
{
	MouseGetPos,,, hWnd
	return WinExist(vWinTitle (vWinTitle=""?"":" ") "ahk_id " hWnd, vWinText, vExcludeTitle, vExcludeText)
}


!L::
GuiClose:
MsgBox, 262212, , Are you sure you want exit?
IfMsgBox Yes
{
ExitApp
}
Return



