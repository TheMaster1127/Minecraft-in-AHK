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
;~ BorderHeight := 1000
;~ BorderWidth := 1920

; Retrieve the working area's bounding coordinates
SysGet, OutputVar, MonitorWorkArea, 1
; Display the coordinates in a MsgBox
;MsgBox, Monitor %N% Work Area:`nLeft: %OutputVarLeft%`nTop: %OutputVarTop%`nRight: %OutputVarRight%`nBottom: %OutputVarBottom%

RegRead, captionHeight, HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics, CaptionHeight
titleHeight := Round(captionHeight * A_ScreenDPI / -twipsPerInch := 1440)
;MsgBox, 64, Title height, %titleHeight%
SysGet, captionHeight, 31
;MsgBox, 64, Caption height, %captionHeight%
BorderHeight := OutputVarBottom - titleHeight
BorderWidth := OutputVarRight

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
DllCall( "AddFontResource", Str,"Assets\Fonts\Minecraft.ttf" )
SendMessage,  0x1D,,,, ahk_id 0xFFFF
TexturesFolder := "Assets/Textures/"
SoundsFolder := "Assets/Sounds/"





GuiInventory := 0
gameStarted := 0

; Calculate the total number of blocks
BlocksInHeight := BorderHeight // BlockHeight
BlocksInWidth := BorderWidth // BlockWidth
TotalBlocks := BlocksInHeight * BlocksInWidth
;MsgBox, % BlocksInHeight
Row1 := GroundHeight
Row2 := Row1 + 1
BlocksInWidthRow3 := BlocksInWidth * Row1 + 1
BlocksInWidthRow4 := BlocksInWidth * Row2 + 1

RandomBlocksTopLayer := Round(BlocksInWidth / 2)


;MsgBox, % BlocksInWidth
if (BlocksInWidth < 25)
{
MsgBox, 262160, ERROR, Your screen resolution in not supported!
ExitApp
}
;MsgBox, % BlocksInHeight
if (BlocksInHeight < 17)
{
MsgBox, 262160, ERROR, Your screen resolution in not supported!
ExitApp
}




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
Gui, Add, Picture, x%PlayerX% y%PlayerY% w%PlayerW% h%PlayerH% vPlayer , %TexturesFolder%Player.png
Gui, Font, s15
Gui, Show, w%BorderWidth% h%BorderHeight%, Minecraft AHK
WinName := "Minecraft AHK"




Loop, %TotalBlocks%
{
x := BlockXCoordinate%A_Index%
y := BlockYCoordinate%A_Index%
Gui, Add, Picture, x%x% y%y% w%BlockWidth% h%BlockHeight% vBlock%A_Index% ,
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

GuiControl, , Block%BlockNumber%, %TexturesFolder%stone.png
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
GuiControl, , Block%BlocksAtWidthRow%, %TexturesFolder%grass.png
typeOfBlock%BlocksAtWidthRow% := "grass"
BlockUnder := BlocksAtWidthRow + BlocksInWidth
GuiControl, , Block%BlockUnder%, %TexturesFolder%dirt.png
typeOfBlock%BlockUnder% := "dirt"
BlockUnder := BlocksAtWidthRow + BlocksInWidth + BlocksInWidth
GuiControl, , Block%BlockUnder%, %TexturesFolder%dirt.png
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
GuiControl, , Block%targetBlock%, %TexturesFolder%log.png
GuiControl, Show, Block%targetBlock%
isBlock%targetBlock% := 1
typeOfBlock%targetBlock% := "log"
}
else
{
num++
LogBlock := targetBlock - (BlocksInWidth * num)

GuiControl, , Block%LogBlock%, %TexturesFolder%log.png
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
GuiControl, , Block%Leaf%, %TexturesFolder%leaf.png
GuiControl, Show, Block%Leaf%
isBlock%Leaf% := 1
typeOfBlock%Leaf% := "leaf"
}


} ; end of main Loop, 3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; gen iron and diamonds


ironHeight1 := BlocksInHeight - 2
Random, layerIron1, 10, 15


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
N := BlocksInWidth
MIN := 1
MAX := BlocksInWidth
name = ironPos
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
;MsgBox, %hello1% %hello2% %hello3% %hello4% %hello5% %hello6% %hello7% %hello8% %hello9% %hello10%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Loop, %layerIron1%
{
ironHeight := 1
ironPos := ironPos%A_Index%
placeIronLoc := ironHeight%ironHeight% * BlocksInWidth + ironPos - BlocksInWidth

GuiControl, , Block%placeIronLoc%, %TexturesFolder%iron.png
GuiControl, Show, Block%placeIronLoc%
isBlock%placeIronLoc% := 1
typeOfBlock%placeIronLoc% := "iron"
}



diamondHeight1 := BlocksInHeight - 1
diamondHeight2 := BlocksInHeight


Random, layerDiamond1, 6, 7
Random, layerDiamond2, 8, 9


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
N := BlocksInWidth
MIN := 1
MAX := BlocksInWidth
name = diamondPos
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
;MsgBox, %hello1% %hello2% %hello3% %hello4% %hello5% %hello6% %hello7% %hello8% %hello9% %hello10%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
num := layerDiamond1
Loop, %layerDiamond1%
{
diamondHight := 1
diamondPos := diamondPos%num%
num--
placeDiamondLoc := diamondHeight%diamondHight% * BlocksInWidth + diamondPos - BlocksInWidth

GuiControl, , Block%placeDiamondLoc%, %TexturesFolder%diamond.png
GuiControl, Show, Block%placeDiamondLoc%
isBlock%placeDiamondLoc% := 1
typeOfBlock%placeDiamondLoc% := "diamond"
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
N := BlocksInWidth
MIN := 1
MAX := BlocksInWidth
name = diamondPos
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
;MsgBox, %hello1% %hello2% %hello3% %hello4% %hello5% %hello6% %hello7% %hello8% %hello9% %hello10%
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
num := layerDiamond2
Loop, %layerDiamond2%
{
diamondHight := 2
diamondPos := diamondPos%num%
num--
placeDiamondLoc := diamondHeight%diamondHight% * BlocksInWidth + diamondPos - BlocksInWidth

GuiControl, , Block%placeDiamondLoc%, %TexturesFolder%diamond.png
GuiControl, Show, Block%placeDiamondLoc%
isBlock%placeDiamondLoc% := 1
typeOfBlock%placeDiamondLoc% := "diamond"
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SelectedBlock := ""

availableBlocks := 18 ; blocks and items but items wont be able to be placed

stone := 0
grass := 0
dirt := 0
log := 0
leaf := 0
plank := 0
stick := 0
crafting_table := 0
wooden_pickaxe := 0
stone_pickaxe := 0
iron_pickaxe := 0
diamond_pickaxe := 0
wooden_shovel := 0
wooden_axe := 0
stone_axe := 0
iron := 0
diamond := 0
diamond_block := 0

availableBlock1 := stone
availableBlock2 := grass
availableBlock3 := dirt
availableBlock4 := log
availableBlock5 := leaf
availableBlock6 := plank
availableBlock7 := stick
availableBlock8 := crafting_table
availableBlock9 := wooden_pickaxe
availableBlock10 := stone_pickaxe
availableBlock11 := iron_pickaxe
availableBlock12 := diamond_pickaxe
availableBlock13 := wooden_shovel
availableBlock14 := wooden_axe
availableBlock15 := stone_axe
availableBlock16 := iron
availableBlock17 := diamond
availableBlock18 := diamond_block

availableBlockName1 := "stone"
availableBlockName2 := "grass"
availableBlockName3 := "dirt"
availableBlockName4 := "log"
availableBlockName5 := "leaf"
availableBlockName6 := "plank"
availableBlockName7 := "stick"
availableBlockName8 := "crafting_table"
availableBlockName9 := "wooden_pickaxe"
availableBlockName10 := "stone_pickaxe"
availableBlockName11 := "iron_pickaxe"
availableBlockName12 := "diamond_pickaxe"
availableBlockName13 := "wooden_shovel"
availableBlockName14 := "wooden_axe"
availableBlockName15 := "stone_axe"
availableBlockName16 := "iron"
availableBlockName17 := "diamond"
availableBlockName18 := "diamond_block"


Gui, Show, w%BorderWidth% h%BorderHeight%, Minecraft AHK
WinName := "Minecraft AHK"
SetTimer, GameLoop, 1
SetTimer, airBlocksFix, 1
gameStarted := 1
startTimerOnce := 0
YouWin := 0
youCanOnlyWinOnce := 0
isPlayerCanMine := 1
CanPlaceBlocks := 1
inCrafingTable := 0







Gui 2: new
Gui 2: Color, 121212
Gui 2: -DPIScale
Gui 2: +AlwaysOnTop
Gui 2: Font, s15, Minecraft
Gui 2: Add, Picture, x0 y0 w700 h656, %TexturesFolder%Inventory.png

item1 := "stone"
item2 := "grass"
item3 := "dirt"
item4 := "log"
item5 := "leaf"
item6 := "plank"
item7 := "stick"
item8 := "crafting_table"
item9 := "wooden_pickaxe"
item10 := "stone_pickaxe"
item11 := "iron_pickaxe"
item12 := "diamond_pickaxe"
item13 := "wooden_shovel"
item14 := "wooden_axe"
item15 := "stone_axe"
item16 := "iron"
item17 := "diamond"
item18 := "diamond_block"





itemInfo(1)
diffrence := 73
numIndex := 0
numIndex1 := 0
INVy1 := 565
INVy2 := 560

Loop, 18
{

if (numIndex = 0)
{
INVx1 := 35
INVx2 := 23
}
else
{
if (numIndex <= 8)
{
INVx1 := 35 + diffrence * numIndex - (numIndex * 2)
INVx2 := 23 + diffrence * numIndex - (numIndex * 2)
}
else
{
if (numIndex1 = 0)
{
INVy1 := 480
INVy2 := 475
INVx1 := 35
INVx2 := 23
}
else
{
INVx1 := 35 + diffrence * numIndex1 - (numIndex1 * 2)
INVx2 := 23 + diffrence * numIndex1 - (numIndex1 * 2)
}
numIndex1++

}
}
numIndex++
item := item%A_Index%
itemCount := itemCount%A_Index%

Gui 2: Add, Picture, x%INVx1% y%INVy1% w50 h50 vItem%A_Index% gItem, %TexturesFolder%%item%_item.png
Gui 2: Add, Text, x%INVx2% y%INVy2% w72 h30 BackGroundTrans vItemCount%A_Index%  Right, %itemCount%

}
num := 18
xInventoryCraft := 355
yInventoryCraft := 110
Loop, 5
{
num++
if (A_Index = 1)
{
Gui 2: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 2)
{
xInventoryCraft := xInventoryCraft + 69
Gui 2: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 3)
{
yInventoryCraft := yInventoryCraft + 69
Gui 2: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 4)
{
xInventoryCraft := 355
Gui 2: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 5)
{
Gui 2: Add, Picture, cWhite x580 y144 w50 h50 vItem%num% gItem, %TexturesFolder%inventory_crafting_slot.png
}
}

Gui 2: Add, Text, cWhite x10 y665 w650 h35 vTimerRunningInInventory, Time:
Gui 2: Show, w700 h700, Inventory Minecraft AHK
Gui 2: Hide



; crafing table ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



Gui 3: new
Gui 3: Color, 121212
Gui 3: -DPIScale
Gui 3: +AlwaysOnTop
Gui 3: Font, s15, Minecraft
Gui 3: Add, Picture, x0 y0 w700 h656, %TexturesFolder%crafting_tableGUI.png

item1 := "stone"
item2 := "grass"
item3 := "dirt"
item4 := "log"
item5 := "leaf"
item6 := "plank"
item7 := "stick"
item8 := "crafting_table"
item9 := "wooden_pickaxe"
item10 := "stone_pickaxe"
item11 := "iron_pickaxe"
item12 := "diamond_pickaxe"
item13 := "wooden_shovel"
item14 := "wooden_axe"
item15 := "stone_axe"
item16 := "iron"
item17 := "diamond"
item18 := "diamond_block"



itemInfo(1)
diffrence := 73
numIndex := 0
numIndex1 := 0
INVy1 := 565
INVy2 := 560

Loop, 18
{

if (numIndex = 0)
{
INVx1 := 35
INVx2 := 23
}
else
{
if (numIndex <= 8)
{
INVx1 := 35 + diffrence * numIndex - (numIndex * 2)
INVx2 := 23 + diffrence * numIndex - (numIndex * 2)
}
else
{
if (numIndex1 = 0)
{
INVy1 := 480
INVy2 := 475
INVx1 := 35
INVx2 := 23
}
else
{
INVx1 := 35 + diffrence * numIndex1 - (numIndex1 * 2)
INVx2 := 23 + diffrence * numIndex1 - (numIndex1 * 2)
}
numIndex1++

}
}
numIndex++
item := item%A_Index%
itemCount := itemCount%A_Index%

Gui 3: Add, Picture, x%INVx1% y%INVy1% w50 h50 vItem%A_Index% gCrafingTableItem, %TexturesFolder%%item%_item.png
Gui 3: Add, Text, x%INVx2% y%INVy2% w72 h30 BackGroundTrans vItemCount%A_Index%  Right, %itemCount%

}
num := 18
xInventoryCraft := 128
yInventoryCraft := 68
Loop, 10
{
num++
if (A_Index = 1)
{
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 2)
{
xInventoryCraft := xInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 3)
{
xInventoryCraft := xInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 4)
{
xInventoryCraft := 128
yInventoryCraft := 68
yInventoryCraft := yInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 5)
{
xInventoryCraft := xInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 6)
{
xInventoryCraft := xInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 7)
{
xInventoryCraft := 128
yInventoryCraft := 68
yInventoryCraft := yInventoryCraft + 73 * 2
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 8)
{
xInventoryCraft := xInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 9)
{
xInventoryCraft := xInventoryCraft + 73
Gui 3: Add, Picture, cWhite x%xInventoryCraft% y%yInventoryCraft% w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
if (A_Index = 10)
{
Gui 3: Add, Picture, cWhite x500 y144 w50 h50 vItem%num% gCrafingTableItem, %TexturesFolder%inventory_crafting_slot.png
}
}

Gui 3: Add, Text, cWhite x10 y665 w650 h35 vTimerRunningInCraftingTable, Time:
Gui 3: Show, w700 h700, Inventory Minecraft AHK
Gui 3: Hide



Return



funcGetBlockCount()
{
global

stone := availableBlock1
grass := availableBlock2
dirt := availableBlock3
log := availableBlock4
leaf := availableBlock5
plank := availableBlock6
stick := availableBlock7
crafting_table := availableBlock8
wooden_pickaxe := availableBlock9
stone_pickaxe := availableBlock10
iron_pickaxe := availableBlock11
diamond_pickaxe := availableBlock12
wooden_shovel := availableBlock13
wooden_axe := availableBlock14
stone_axe := availableBlock15
iron := availableBlock16
diamond := availableBlock17
diamond_block := availableBlock18


availableBlock1 := stone
availableBlock2 := grass
availableBlock3 := dirt
availableBlock4 := log
availableBlock5 := leaf
availableBlock6 := plank
availableBlock7 := stick
availableBlock8 := crafting_table
availableBlock9 := wooden_pickaxe
availableBlock10 := stone_pickaxe
availableBlock11 := iron_pickaxe
availableBlock12 := diamond_pickaxe
availableBlock13 := wooden_shovel
availableBlock14 := wooden_axe
availableBlock15 := stone_axe
availableBlock16 := iron
availableBlock17 := diamond
availableBlock18 := diamond_block
}
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

itemInfo(mode)
{
global
; if mode is 1 we will save item
; if mode is 2 we will retrive info about the items


if (mode = 1)
{
itemCount1 := stone
itemCount2 := grass
itemCount3 := dirt
itemCount4 := log
itemCount5 := leaf
itemCount6 := plank
itemCount7 := stick
itemCount8 := crafting_table
itemCount9 := wooden_pickaxe
itemCount10 := stone_pickaxe
itemCount11 := iron_pickaxe
itemCount12 := diamond_pickaxe
itemCount13 := wooden_shovel
itemCount14 := wooden_axe
itemCount15 := stone_axe
itemCount16 := iron
itemCount17 := diamond
itemCount18 := diamond_block
}


if (mode = 0)
{
itemCount1 := stone
itemCount2 := grass
itemCount3 := dirt
itemCount4 := log
itemCount5 := leaf
itemCount6 := plank
itemCount7 := stick
itemCount8 := crafting_table
itemCount9 := wooden_pickaxe
itemCount10 := stone_pickaxe
itemCount11 := iron_pickaxe
itemCount12 := diamond_pickaxe
itemCount13 := wooden_shovel
itemCount14 := wooden_axe
itemCount15 := stone_axe
itemCount16 := iron
itemCount17 := diamond
itemCount18 := diamond_block

}


} ; end of func itemInfo(mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GameLoop:
if (gameStarted = 1)
{
Loop, 1
{
IfWinActive Minecraft AHK
{
IfWinNotExist Inventory Minecraft AHK
{
if (GetKeyState("Escape", "P"))
{
; Exit the script if the Escape key is pressed
gameStarted := 0
MsgBox, 260, Pause, Do you wnat to exit the game?`n
gameStarted := 1
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
startTimerOnce++
if (startTimerOnce = 1)
{
StartTime := A_TickCount
}
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
startTimerOnce++
if (startTimerOnce = 1)
{
StartTime := A_TickCount
}
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
startTimerOnce++
if (startTimerOnce = 1)
{
StartTime := A_TickCount
}
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
startTimerOnce++
if (startTimerOnce = 1)
{
StartTime := A_TickCount
}
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
GuiControl, , Player, %TexturesFolder%Player.png
}
}
}
}
}
Return

airBlocksFix:
TotalBlocks := BlocksInHeight * BlocksInWidth

Loop, %TotalBlocks%
{

if (typeOfBlock%A_Index% = "air")
{
isBlock%A_Index% := 0
}
}

FixBugUnderStone := TotalBlocks

Loop, %BlocksInWidth%
{
FixBugUnderStone++

isBlock%FixBugUnderStone% := 1
}

if (YouWin != 1)
{
ElapsedTime := A_TickCount - StartTime


ms := ElapsedTime

; Calculate the components
hours := Floor(ms / 3600000)
ms := Mod(ms, 3600000)
minutes := Floor(ms / 60000)
ms := Mod(ms, 60000)
seconds := Floor(ms / 1000)
milliseconds := Mod(ms, 1000)

; Display the result
ElapsedTime123 := ""
ElapsedTime123 .= hours "h " minutes "m " seconds "s " milliseconds "ms"

GuiControl, 2:, TimerRunningInInventory, Time: %ElapsedTime123%
GuiControl, 3:, TimerRunningInCraftingTable, Time: %ElapsedTime123%
}

Return













#If WinActive(WinName)
#If MouseIsOver(WinName)

$W::
$S::
$A::
$D::
Return

~LButton::
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
if (isPlayerCanMine = 0)
{
return
}
if (GuiInventory = 1)
{
Return
}
gameStarted := 0
;MsgBox, hi
MouseGetPos, xpos, ypos
XCoordinate := xpos - 5  ; Replace with the desired X coordinate
YCoordinate := ypos - 30  ; Replace with the desired Y coordinate

MouseBorder := BlockWidth * BlocksInWidth

if (XCoordinate >= MouseBorder)
{
gameStarted := 1
return
}

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col
;MsgBox, Block at X: %XCoordinate%, Y: %YCoordinate% is block number %BlockNumber% within the grid.


BlockUp := Floor(BlockNumber - BlocksInWidth)
BlockDown := Floor(BlockNumber + BlocksInWidth)
BlockLeft := Floor(BlockNumber - 1)
BlockRight := Floor(BlockNumber + 1)
;MsgBox, %BlockNumber%`n%BlockUp% %BlockDown% %BlockLeft% %BlockRight%

if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
gameStarted := 1
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockDown% = 0)
{
gameStarted := 1
return
}
}

if !(BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockLeft% = 0)
{
gameStarted := 1
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 0)
{
gameStarted := 1
return
}
}

;;;;;;;;;;;;;;

if (BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockLeft% = 0)
{
gameStarted := 1
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockDown% = 0) && (isBlock%BlockLeft% = 0)
{
gameStarted := 1
return
}
}

if (!BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 0) && (isBlock%BlockDown% = 0)
{
gameStarted := 1
return
}
}


if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 0)
{
gameStarted := 1
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1)
{
gameStarted := 1
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
gameStarted := 1
return
}






if (typeOfBlock%BlockNumber% != "air")
{
didWeMineTheBlock := 0
Loop, %availableBlocks%
{


funcGetBlockCount()
itemInfo(0)



numForGivingBlock := 0
if (typeOfBlock%BlockNumber% = availableBlockName1) ; start STONE stone stone stone stone
{
if (SelectedBlock = "wooden_pickaxe") && (availableBlock9 >= 1)
{
isPlayerCanMine := 0
Sleep, 500
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_stone.png
Sleep, 500
didWeMineTheBlock++
numForGivingBlock := 1
isPlayerCanMine := 1
}
else if (SelectedBlock = "stone_pickaxe") && (availableBlock10 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_stone.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 1
isPlayerCanMine := 1
}
else if (SelectedBlock = "iron_pickaxe") && (availableBlock11 >= 1)
{
isPlayerCanMine := 0
Sleep, 100
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_stone.png
Sleep, 100
didWeMineTheBlock++
numForGivingBlock := 1
isPlayerCanMine := 1
}
else if (SelectedBlock = "diamond_pickaxe") && (availableBlock12 >= 1)
{
isPlayerCanMine := 0
Sleep, 10
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_stone.png
Sleep, 10
didWeMineTheBlock++
numForGivingBlock := 1
isPlayerCanMine := 1
}
else
{
gameStarted := 1
return
}
}
;;;;;;;;;; end of stone stone stone stone














if (typeOfBlock%BlockNumber% = availableBlockName16) ; start iron
{
if (SelectedBlock = "wooden_pickaxe") && (availableBlock9 >= 1)
{
gameStarted := 1
return
}
else if (SelectedBlock = "stone_pickaxe") && (availableBlock10 >= 1)
{
isPlayerCanMine := 0
Sleep, 350
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_iron.png
Sleep, 350
didWeMineTheBlock++
numForGivingBlock := 16
isPlayerCanMine := 1
}
else if (SelectedBlock = "iron_pickaxe") && (availableBlock11 >= 1)
{
isPlayerCanMine := 0
Sleep, 200
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_iron.png
Sleep, 200
didWeMineTheBlock++
numForGivingBlock := 16
isPlayerCanMine := 1
}
else if (SelectedBlock = "diamond_pickaxe") && (availableBlock12 >= 1)
{
isPlayerCanMine := 0
Sleep, 69
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_iron.png
Sleep, 69
didWeMineTheBlock++
numForGivingBlock := 16
isPlayerCanMine := 1
}
else
{
gameStarted := 1
return
}
}
;;;;;;;;;; end of iron













if (typeOfBlock%BlockNumber% = availableBlockName17) ; start diamond
{
if (SelectedBlock = "wooden_pickaxe") && (availableBlock9 >= 1)
{
gameStarted := 1
return
}
else if (SelectedBlock = "stone_pickaxe") && (availableBlock10 >= 1)
{
gameStarted := 1
return
}
else if (SelectedBlock = "iron_pickaxe") && (availableBlock11 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_diamond.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 17
isPlayerCanMine := 1
}
else if (SelectedBlock = "diamond_pickaxe") && (availableBlock12 >= 1)
{
isPlayerCanMine := 0
Sleep, 100
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_diamond.png
Sleep, 100
didWeMineTheBlock++
numForGivingBlock := 17
isPlayerCanMine := 1
}
else
{
gameStarted := 1
return
}
}
;;;;;;;;;; end of diamond












if (typeOfBlock%BlockNumber% = availableBlockName18) ; start diamond_block
{
if (SelectedBlock = "wooden_pickaxe") && (availableBlock9 >= 1)
{
gameStarted := 1
return
}
else if (SelectedBlock = "stone_pickaxe") && (availableBlock10 >= 1)
{
gameStarted := 1
return
}
else if (SelectedBlock = "iron_pickaxe") && (availableBlock11 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_diamond_block.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 18
isPlayerCanMine := 1
}
else if (SelectedBlock = "diamond_pickaxe") && (availableBlock12 >= 1)
{
isPlayerCanMine := 0
Sleep, 100
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_diamond_block.png
Sleep, 100
didWeMineTheBlock++
numForGivingBlock := 18
isPlayerCanMine := 1
}
else
{
gameStarted := 1
return
}
}
;;;;;;;;;; end of diamond_block
























if (typeOfBlock%BlockNumber% = availableBlockName2) ; start grass
{
if (SelectedBlock = "wooden_shovel") && (availableBlock13 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_grass.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 2
isPlayerCanMine := 1
}
else
{
isPlayerCanMine := 0
Sleep, 500
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_grass.png
Sleep, 500
didWeMineTheBlock++
numForGivingBlock := 2
isPlayerCanMine := 1
}
}
;;;;;;;;;; end of grass


if (typeOfBlock%BlockNumber% = availableBlockName3) ; start dirt
{
if (SelectedBlock = "wooden_shovel") && (availableBlock13 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_dirt.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 3
isPlayerCanMine := 1
}
else
{
isPlayerCanMine := 0
Sleep, 500
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_dirt.png
Sleep, 500
didWeMineTheBlock++
numForGivingBlock := 3
isPlayerCanMine := 1
}
}
;;;;;;;;;; end of dirt



if (typeOfBlock%BlockNumber% = availableBlockName4) ; start log
{
if (SelectedBlock = "wooden_axe") && (availableBlock14 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_log.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 4
isPlayerCanMine := 1
}
else if (SelectedBlock = "stone_axe") && (availableBlock15 >= 1)
{
isPlayerCanMine := 0
Sleep, 100
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_log.png
Sleep, 100
didWeMineTheBlock++
numForGivingBlock := 4
isPlayerCanMine := 1
}
else
{
isPlayerCanMine := 0
Sleep, 500
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_log.png
Sleep, 500
didWeMineTheBlock++
numForGivingBlock := 4
isPlayerCanMine := 1
}
}
;;;;;;;;;; end of log



if (typeOfBlock%BlockNumber% = availableBlockName6) ; start plank
{
if (SelectedBlock = "wooden_axe") && (availableBlock14 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_plank.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 6
isPlayerCanMine := 1
}
else if (SelectedBlock = "stone_axe") && (availableBlock15 >= 1)
{
isPlayerCanMine := 0
Sleep, 100
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_plank.png
Sleep, 100
didWeMineTheBlock++
numForGivingBlock := 6
isPlayerCanMine := 1
}
else
{
isPlayerCanMine := 0
Sleep, 500
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_plank.png
Sleep, 500
didWeMineTheBlock++
numForGivingBlock := 6
isPlayerCanMine := 1
}
}
;;;;;;;;;; end of plank



if (typeOfBlock%BlockNumber% = availableBlockName8) ; start crafing_table
{
if (SelectedBlock = "wooden_axe") && (availableBlock14 >= 1)
{
isPlayerCanMine := 0
Sleep, 250
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_crafting_table.png
Sleep, 250
didWeMineTheBlock++
numForGivingBlock := 8
isPlayerCanMine := 1
}
else if (SelectedBlock = "stone_axe") && (availableBlock15 >= 1)
{
isPlayerCanMine := 0
Sleep, 100
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_crafting_table.png
Sleep, 100
didWeMineTheBlock++
numForGivingBlock := 8
isPlayerCanMine := 1
}
else
{
isPlayerCanMine := 0
Sleep, 500
GuiControl, , Block%BlockNumber%, %TexturesFolder%breaking_crafting_table.png
Sleep, 500
didWeMineTheBlock++
numForGivingBlock := 8
isPlayerCanMine := 1
}
}
;;;;;;;;;; end of crafing_table


if (typeOfBlock%BlockNumber% = availableBlockName5) ; start leaf
{
isPlayerCanMine := 0
didWeMineTheBlock++
numForGivingBlock := 5
isPlayerCanMine := 1
}
;;;;;;;;;; end of leaf




typeOfBlock%BlockNumber% := "air"
funcGetBlockCount()
itemInfo(0)
isBlock%BlockNumber% := 0
funcGetBlockCount()
itemInfo(0)
GuiControl, Hide, Block%BlockNumber%
gameStarted := 1
if (didWeMineTheBlock >= 1)
{
availableBlock%numForGivingBlock%++
funcGetBlockCount()
itemInfo(0)
gameStarted := 1
return
}

} ; end of loop
gameStarted := 1
}
else
{
gameStarted := 1
return
}
gameStarted := 1
;GuiControl, , Inventory, Stone: %stone% Dirt: %dirt% Grass Block: %grass%

gameStarted := 1
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

MouseBorder := BlockWidth * BlocksInWidth

if (XCoordinate >= MouseBorder)
{
return
}

Col := (XCoordinate // BlockWidth) + 1
Row := (YCoordinate // BlockHeight) + 1

BlocksInWidth := BorderWidth // BlockWidth

BlockNumber := (Row - 1) * BlocksInWidth + Col
BlockNumber := Floor(BlockNumber)

;MsgBox, Block at X: %XCoordinate%, Y: %YCoordinate% is block number %BlockNumber% within the grid.




BlockUp := Floor(BlockNumber - BlocksInWidth)
BlockDown := Floor(BlockNumber + BlocksInWidth)
BlockLeft := Floor(BlockNumber - 1)
BlockRight := Floor(BlockNumber + 1)
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
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockDown% = 0)
{
return
}
}

if !(BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockLeft% = 0)
{
return
}
}


if !(BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 0)
{
return
}
}

;;;;;;;;;;;;;;

if (BlockUp <= 0) && !(BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockLeft% = 0)
{
return
}
}

if !(BlockUp <= 0) && (BlockDown <= 0) && (BlockLeft <= 0) && !(BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockRight% = 1) && (isBlock%BlockDown% = 0) && (isBlock%BlockLeft% = 0)
{
return
}
}

if (!BlockUp <= 0) && (BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockUp% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 0) && (isBlock%BlockDown% = 0)
{
return
}
}


if (BlockUp <= 0) && !(BlockDown <= 0) && !(BlockLeft <= 0) && (BlockRight <= 0)
{
if (isBlock%BlockDown% = 1) && (isBlock%BlockLeft% = 1) && (isBlock%BlockRight% = 0)
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
funcGetBlockCount()
Loop, %availableBlocks%
{


if (SelectedBlock = availableBlockName%A_Index%)
{
if (availableBlock%A_Index% <= 0)
{
return
}
else
{

; items cant be placed
;;;;;;;;;;;;;;;;;;;;;;;; start

; see here
; cant place those unless you wnat to go ahead and remove this condition

;~ 7 := stick
;~ 9 := wooden_pickaxe
;~ 10 := stone_pickaxe
;~ 11 := iron_pickaxe
;~ 12 := diamond_pickaxe
;~ 13 := wooden_shovel
;~ 14 := wooden_axe
;~ 15 := stone_axe
;~ 16 := iron
;~ 17 := diamond

; stick
if (A_Index = 7) ; cant place stick unless you wnat to go ahead and remove this condition
{
return
}
; 7 is the num for a stick


; wooden_pickaxe
if (A_Index = 9) ; cant place wooden_pickaxe unless you wnat to go ahead and remove this condition
{
return
}
; 9 is the num for a wooden_pickaxe

; stone_pickaxe
if (A_Index = 10) ; cant place stone_pickaxe unless you wnat to go ahead and remove this condition
{
return
}
; and so on
if (A_Index = 11)
{
return
}
if (A_Index = 12)
{
return
}
if (A_Index = 13)
{
return
}
if (A_Index = 14)
{
return
}
if (A_Index = 15)
{
return
}
if (A_Index = 16)
{
return
}
if (A_Index = 17)
{
return
}

;;;;;;;;;;;;;;;;;;;;;;;; end

itemInfo(0)
availableBlock%A_Index%--
itemInfo(0)
GuiControl, , Block%BlockNumber%, %TexturesFolder%%SelectedBlock%.png
GuiControl, Show, Block%BlockNumber%
typeOfBlock%BlockNumber% := availableBlockName%A_Index%
isBlock%BlockNumber% := 1
funcGetBlockCount()
itemInfo(0)
if (youCanOnlyWinOnce !>= 1)
{
if (A_Index = 18)
{
youCanOnlyWinOnce++
YouWin := 1
ElapsedTime := A_TickCount - StartTime


ms := ElapsedTime

; Calculate the components
hours := Floor(ms / 3600000)
ms := Mod(ms, 3600000)
minutes := Floor(ms / 60000)
ms := Mod(ms, 60000)
seconds := Floor(ms / 1000)
milliseconds := Mod(ms, 1000)

; Display the result
ElapsedTime123 := ""
ElapsedTime123 .= hours "h " minutes "m " seconds "s " milliseconds "ms"
GuiControl, 2:, TimerRunningInInventory, Time: %ElapsedTime123%
GuiControl, 3:, TimerRunningInCraftingTable, Time: %ElapsedTime123%
MsgBox, You Win!!!`nTime: %ElapsedTime123%
FileAppend, Time: %ElapsedTime123%`n, Your Times.txt
}
return
}


}

}

} ; end of loop


}
else
{
if (typeOfBlock%BlockNumber% = "crafting_table")
{
gosub CrafingTable
return
}
SelectedBlock := typeOfBlock%BlockNumber%
;MsgBox, % SelectedBlock
return
}




;GuiControl, , Inventory, Stone: %stone% Dirt: %dirt% Grass Block: %grass%
;typeOfBlock%BlockNumber% := SelectedBlock

Return


#if

#If WinActive(WinName)
#If MouseIsOver(WinName)



#if WinActive("Minecraft AHK") or WinActive("Inventory Minecraft AHK")
#If MouseIsOver("Minecraft AHK") or MouseIsOver("Inventory Minecraft AHK")
E::
if (inCrafingTable = 1)
{
gosub 3GuiClose
return
}
numOfPosInInventoryCrafingTable := 0
lastBugFixInCrafting := 0
OLDlastBugFixInCrafting := 0
firstTimeLastBugFixInCrafting := 0
weCanPlaceBlockInCraftingInventory := 0

forInInventoryCrafingTablePos1 := 0
forInInventoryCrafingTablePos2 := 0
forInInventoryCrafingTablePos3 := 0
forInInventoryCrafingTablePos4 := 0

forInInventoryCrafingTableName1 := ""
forInInventoryCrafingTableName2 := ""
forInInventoryCrafingTableName3 := ""
forInInventoryCrafingTableName4 := ""

if (gameStarted = 0)
{
return
}
if (GuiInventory = 1)
{
gosub 2GuiClose
Return
}
itemInfo(1)

Loop, 18
{
itemCount := itemCount%A_Index%
GuiControl, 2:, ItemCount%A_Index%, %itemCount%
}
GuiControl, 2:, Item19, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item20, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item21, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item22, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item23, %TexturesFolder%inventory_crafting_slot.png
GuiInventory := 1
Gui 2: Show

WinName := "Inventory Minecraft AHK"
Return

#If WinActive("Inventory Minecraft AHK")
#If MouseIsOver("Inventory Minecraft AHK")
2GuiCLose:
WinName := "Minecraft AHK"
GuiInventory := 0
Gui 2: Hide
Return

Item:
SoundPlay, Assets\Sounds\Item Selection Sound.mp3
Loop, 23
{
if (A_GuiControl = "item" . A_Index)
{
SelectedBlock := %A_GuiControl%
LastNumBlockInventory := A_Index
}
}


itemInfo(1)
funcGetBlockCount()
if (LastNumBlockInventory <= 18)
{
weCanPlaceBlockInCraftingInventory := 1 ; yeah you know
lastBlockInfoInventoryCraftName := availableBlockName%LastNumBlockInventory% ; mame of the block we selevted
lastBlockInfoInventoryCraftNumber := LastNumBlockInventory ; what slot we've clicked
}
else
{
if (weCanPlaceBlockInCraftingInventory = 1) && (LastNumBlockInventory >= 19)  && (LastNumBlockInventory <= 22)
{
GuiControl, , Item%LastNumBlockInventory%, Assets/Textures/%lastBlockInfoInventoryCraftName%_item.png

if (firstTimeLastBugFixInCrafting = 0)
{
lastBugFixInCrafting := LastNumBlockInventory
numOfPosInInventoryCrafingTable++
oldLastBugFixInCrafting := LastNumBlockInventory
firstTimeLastBugFixInCrafting++
}
else
{
lastBugFixInCrafting := LastNumBlockInventory
if (lastBugFixInCrafting != oldLastBugFixInCrafting)
{
numOfPosInInventoryCrafingTable++
}
oldLastBugFixInCrafting := LastNumBlockInventory
}

if (LastNumBlockInventory = 19)
{
posInInventoryCrafingTable := 1
}
if (LastNumBlockInventory = 20)
{
posInInventoryCrafingTable := 2
}
if (LastNumBlockInventory = 21)
{
posInInventoryCrafingTable := 3
}
if (LastNumBlockInventory = 22)
{
posInInventoryCrafingTable := 4
}

if (numOfPosInInventoryCrafingTable = 1)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 2)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 3)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 4)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; crafting recipe
inventoryCrafingRecipe1 := 0
inventoryCrafingRecipe2 := 0
inventoryCrafingRecipe3 := 0

;;;;;;;;;;;;;;;;;;;;;;;;;; 1
if (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTableName1 = "log") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "log") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "log") && (forInInventoryCrafingTableName4 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "log") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}
;;;;;;;;;;; 2
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "plank") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}


;;;;;;;;;;;;;;;; 3
if (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "plank") && (availableBlock6 >= 4)
{
inventoryCrafingRecipe3 := 1
}
;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;; Craft here
if (inventoryCrafingRecipe1 = 1)
{
weCraftedInTheInventory := "planks"
GuiControl, , Item23, Assets/Textures/plank_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe2 = 1)
{
weCraftedInTheInventory := "sticks"
GuiControl, , Item23, Assets/Textures/stick_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe3 = 1)
{
weCraftedInTheInventory := "crafting_table"
GuiControl, , Item23, Assets/Textures/crafting_table_item.png
getBlockFormDoneCraftingInInventory := 1
}
else
{
weCraftedInTheInventory := ""
GuiControl, , Item23, %TexturesFolder%inventory_crafting_slot.png
getBlockFormDoneCraftingInInventory := 0
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end of checing crafing recipes


}
else
{
if (getBlockFormDoneCraftingInInventory = 1)
{

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get craftet item form here
if (weCraftedInTheInventory = "planks")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock6 := availableBlock6 + 4 ; availableBlock6 is planks + 4
availableBlock4 := availableBlock4 - 1 ; availableBlock4 is log - 1
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "sticks")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock7 := availableBlock7 + 4 ; availableBlock7 is sticks + 4
availableBlock6 := availableBlock6 - 2 ; availableBlock6 is planks - 2
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "crafting_table")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock8 := availableBlock8 + 1 ; availableBlock8 is crafting_table + 4
availableBlock6 := availableBlock6 - 4 ; availableBlock6 is planks - 4
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Loop, 18
{
itemCount := itemCount%A_Index%
GuiControl, 2:, ItemCount%A_Index%, %itemCount%
}
GuiControl, 2:, Item19, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item20, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item21, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item22, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 2:, Item23, %TexturesFolder%inventory_crafting_slot.png

numOfPosInInventoryCrafingTable := 0
lastBugFixInCrafting := 0
OLDlastBugFixInCrafting := 0
firstTimeLastBugFixInCrafting := 0
forInInventoryCrafingTablePos1 := 0
forInInventoryCrafingTablePos2 := 0
forInInventoryCrafingTablePos3 := 0
forInInventoryCrafingTablePos4 := 0

forInInventoryCrafingTableName1 := ""
forInInventoryCrafingTableName2 := ""
forInInventoryCrafingTableName3 := ""
forInInventoryCrafingTableName4 := ""

}
}
}



Return



#if


#If WinActive(WinName)
#If MouseIsOver(WinName)



#if WinActive("Minecraft AHK") or WinActive("Inventory Minecraft AHK")
#If MouseIsOver("Minecraft AHK") or MouseIsOver("Inventory Minecraft AHK")
CrafingTable:
inCrafingTable := 1
numOfPosInInventoryCrafingTable := 0
lastBugFixInCrafting := 0
OLDlastBugFixInCrafting := 0
firstTimeLastBugFixInCrafting := 0
weCanPlaceBlockInCraftingInventory := 0

forInInventoryCrafingTablePos1 := 0
forInInventoryCrafingTablePos2 := 0
forInInventoryCrafingTablePos3 := 0
forInInventoryCrafingTablePos4 := 0
forInInventoryCrafingTablePos5 := 0
forInInventoryCrafingTablePos6 := 0
forInInventoryCrafingTablePos7 := 0
forInInventoryCrafingTablePos8 := 0
forInInventoryCrafingTablePos9 := 0

forInInventoryCrafingTableName1 := ""
forInInventoryCrafingTableName2 := ""
forInInventoryCrafingTableName3 := ""
forInInventoryCrafingTableName4 := ""
forInInventoryCrafingTableName5 := ""
forInInventoryCrafingTableName6 := ""
forInInventoryCrafingTableName7 := ""
forInInventoryCrafingTableName8 := ""
forInInventoryCrafingTableName9 := ""

if (gameStarted = 0)
{
return
}
if (GuiInventory = 1)
{
gosub 2GuiClose
Return
}
itemInfo(1)

Loop, 18
{
itemCount := itemCount%A_Index%
GuiControl, 3:, ItemCount%A_Index%, %itemCount%
}
GuiControl, 3:, Item19, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item20, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item21, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item22, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item23, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item24, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item25, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item26, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item27, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item28, %TexturesFolder%inventory_crafting_slot.png
; inventory_crafting_slot
GuiInventory := 1
Gui 3: Show

WinName := "Inventory Minecraft AHK"
Return

#If WinActive("Inventory Minecraft AHK")
#If MouseIsOver("Inventory Minecraft AHK")
3GuiCLose:
WinName := "Minecraft AHK"
GuiInventory := 0
inCrafingTable := 0
Gui 3: Hide
Return

CrafingTableItem:
SoundPlay, Assets\Sounds\Item Selection Sound.mp3
Loop, 28
{
if (A_GuiControl = "item" . A_Index)
{
SelectedBlock := %A_GuiControl%
LastNumBlockInventory := A_Index
}
}


itemInfo(1)
funcGetBlockCount()
if (LastNumBlockInventory <= 18)
{
weCanPlaceBlockInCraftingInventory := 1 ; yeah you know
lastBlockInfoInventoryCraftName := availableBlockName%LastNumBlockInventory% ; mame of the block we selevted
lastBlockInfoInventoryCraftNumber := LastNumBlockInventory ; what slot we've clicked
}
else
{
if (weCanPlaceBlockInCraftingInventory = 1) && (LastNumBlockInventory >= 19)  && (LastNumBlockInventory <= 27)
{
GuiControl, , Item%LastNumBlockInventory%, Assets/Textures/%lastBlockInfoInventoryCraftName%_item.png


if (firstTimeLastBugFixInCrafting = 0)
{
lastBugFixInCrafting := LastNumBlockInventory
numOfPosInInventoryCrafingTable++
oldLastBugFixInCrafting := LastNumBlockInventory
firstTimeLastBugFixInCrafting++
}
else
{
lastBugFixInCrafting := LastNumBlockInventory
if (lastBugFixInCrafting != oldLastBugFixInCrafting)
{
numOfPosInInventoryCrafingTable++
}
oldLastBugFixInCrafting := LastNumBlockInventory
}



if (LastNumBlockInventory = 19)
{
posInInventoryCrafingTable := 1
}
if (LastNumBlockInventory = 20)
{
posInInventoryCrafingTable := 2
}
if (LastNumBlockInventory = 21)
{
posInInventoryCrafingTable := 3
}
if (LastNumBlockInventory = 22)
{
posInInventoryCrafingTable := 4
}
if (LastNumBlockInventory = 23)
{
posInInventoryCrafingTable := 5
}
if (LastNumBlockInventory = 24)
{
posInInventoryCrafingTable := 6
}
if (LastNumBlockInventory = 25)
{
posInInventoryCrafingTable := 7
}
if (LastNumBlockInventory = 26)
{
posInInventoryCrafingTable := 8
}
if (LastNumBlockInventory = 27)
{
posInInventoryCrafingTable := 9
}

if (numOfPosInInventoryCrafingTable = 1)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 2)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 3)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 4)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 5)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 6)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 7)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 8)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}
if (numOfPosInInventoryCrafingTable = 9)
{
forInInventoryCrafingTablePos%posInInventoryCrafingTable% := 1
forInInventoryCrafingTableName%posInInventoryCrafingTable% := lastBlockInfoInventoryCraftName
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; crafting recipe
numOfCrafingRecipes := 11
Loop, %numOfCrafingRecipes%
{
inventoryCrafingRecipe%A_Index% := 0
}
;;;;;;;;;;;;;;;;;;;;;;;;;; 1
if (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "log") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "log") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "log") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "log") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "log") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "log") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "log") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "log") && (forInInventoryCrafingTableName9 = "") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}

if (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "log") && (availableBlock4 >= 1)
{
inventoryCrafingRecipe1 := 1
}


;;;;;;;;;;; 2
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "plank") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "plank") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "plank") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "plank") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "plank") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "plank") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "plank") && (availableBlock6 >= 2)
{
inventoryCrafingRecipe2 := 1
}


;;;;;;;;;;;;;;;; 3
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "plank") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 4)
{
inventoryCrafingRecipe3 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "plank") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 4)
{
inventoryCrafingRecipe3 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "plank") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "plank") && (forInInventoryCrafingTableName8 = "plank") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 4)
{
inventoryCrafingRecipe3 := 1
}

if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "plank") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "plank") && (forInInventoryCrafingTableName9 = "plank") && (availableBlock6 >= 4)
{
inventoryCrafingRecipe3 := 1
}
;;;;;;;;;;;;;; 4
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe4 := 1
}
;;;;;;;;;;;;;; 5
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "stone") && (forInInventoryCrafingTableName2 = "stone") && (forInInventoryCrafingTableName3 = "stone") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock1 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe5 := 1
}
;;;;;;;;;;;;;; 6
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "iron") && (forInInventoryCrafingTableName2 = "iron") && (forInInventoryCrafingTableName3 = "iron") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock16 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe6 := 1
}
;;;;;;;;;;;;;; 7
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "diamond") && (forInInventoryCrafingTableName2 = "diamond") && (forInInventoryCrafingTableName3 = "diamond") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock17 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe7 := 1
}
;;;;;;;;;;;;;; 8
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "stick") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "stick") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 1) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe8 := 1
}
if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 1) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe8 := 1
}
if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 0) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 0) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "") && (forInInventoryCrafingTableName6 = "stick") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "stick") && (availableBlock6 >= 1) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe8 := 1
}
;;;;;;;;;;;;;; 9
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "stick") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "stick") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe9 := 1
}
if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "plank") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe9 := 1
}
if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "plank") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "plank") && (forInInventoryCrafingTableName6 = "stick") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "stick") && (availableBlock6 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe9 := 1
}
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "plank") && (forInInventoryCrafingTableName2 = "plank") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "plank") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock6 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe9 := 1
}
;;;;;;;;;;;;;; 10
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "stone") && (forInInventoryCrafingTableName2 = "stone") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "stick") && (forInInventoryCrafingTableName5 = "stone") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "stick") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "") && (availableBlock1 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe10:= 1
}
if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "stone") && (forInInventoryCrafingTableName3 = "stone") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "stone") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock1 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe10 := 1
}
if  (forInInventoryCrafingTablePos1 = 0) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 0) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 0) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "") && (forInInventoryCrafingTableName2 = "stone") && (forInInventoryCrafingTableName3 = "stone") && (forInInventoryCrafingTableName4 = "") && (forInInventoryCrafingTableName5 = "stone") && (forInInventoryCrafingTableName6 = "stick") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "") && (forInInventoryCrafingTableName9 = "stick") && (availableBlock1 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe10 := 1
}
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 0) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 0) && (forInInventoryCrafingTablePos7 = 0) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 0) && (forInInventoryCrafingTableName1 = "stone") && (forInInventoryCrafingTableName2 = "stone") && (forInInventoryCrafingTableName3 = "") && (forInInventoryCrafingTableName4 = "stone") && (forInInventoryCrafingTableName5 = "stick") && (forInInventoryCrafingTableName6 = "") && (forInInventoryCrafingTableName7 = "") && (forInInventoryCrafingTableName8 = "stick") && (forInInventoryCrafingTableName9 = "") && (availableBlock1 >= 3) && (availableBlock7 >= 2)
{
inventoryCrafingRecipe10 := 1
}
;;;;;;;;;;;;;; 11
if  (forInInventoryCrafingTablePos1 = 1) && (forInInventoryCrafingTablePos2 = 1) && (forInInventoryCrafingTablePos3 = 1) && (forInInventoryCrafingTablePos4 = 1) && (forInInventoryCrafingTablePos5 = 1) && (forInInventoryCrafingTablePos6 = 1) && (forInInventoryCrafingTablePos7 = 1) && (forInInventoryCrafingTablePos8 = 1) && (forInInventoryCrafingTablePos9 = 1) && (forInInventoryCrafingTableName1 = "diamond") && (forInInventoryCrafingTableName2 = "diamond") && (forInInventoryCrafingTableName3 = "diamond") && (forInInventoryCrafingTableName4 = "diamond") && (forInInventoryCrafingTableName5 = "diamond") && (forInInventoryCrafingTableName6 = "diamond") && (forInInventoryCrafingTableName7 = "diamond") && (forInInventoryCrafingTableName8 = "diamond") && (forInInventoryCrafingTableName9 = "diamond") && (availableBlock17 >= 9)
{
inventoryCrafingRecipe11 := 1
}
;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;; Craft here
if (inventoryCrafingRecipe1 = 1)
{
weCraftedInTheInventory := "planks"
GuiControl, , Item28, Assets/Textures/plank_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe2 = 1)
{
weCraftedInTheInventory := "sticks"
GuiControl, , Item28, Assets/Textures/stick_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe3 = 1)
{
weCraftedInTheInventory := "crafting_table"
GuiControl, , Item28, Assets/Textures/crafting_table_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe4 = 1)
{
weCraftedInTheInventory := "wooden_pickaxe"
GuiControl, , Item28, Assets/Textures/wooden_pickaxe_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe5 = 1)
{
weCraftedInTheInventory := "stone_pickaxe"
GuiControl, , Item28, Assets/Textures/stone_pickaxe_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe6 = 1)
{
weCraftedInTheInventory := "iron_pickaxe"
GuiControl, , Item28, Assets/Textures/iron_pickaxe_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe7 = 1)
{
weCraftedInTheInventory := "diamond_pickaxe"
GuiControl, , Item28, Assets/Textures/diamond_pickaxe_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe8 = 1)
{
weCraftedInTheInventory := "wooden_shovel"
GuiControl, , Item28, Assets/Textures/wooden_shovel_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe9 = 1)
{
weCraftedInTheInventory := "wooden_axe"
GuiControl, , Item28, Assets/Textures/wooden_axe_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe10 = 1)
{
weCraftedInTheInventory := "stone_axe"
GuiControl, , Item28, Assets/Textures/stone_axe_item.png
getBlockFormDoneCraftingInInventory := 1
}
else if (inventoryCrafingRecipe11 = 1)
{
weCraftedInTheInventory := "diamond_block"
GuiControl, , Item28, Assets/Textures/diamond_block_item.png
getBlockFormDoneCraftingInInventory := 1
}
else
{
weCraftedInTheInventory := ""
GuiControl, , Item28, %TexturesFolder%inventory_crafting_slot.png
getBlockFormDoneCraftingInInventory := 0
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; end of checing crafing recipes


}
else
{
if (getBlockFormDoneCraftingInInventory = 1)
{

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get craftet item form here
if (weCraftedInTheInventory = "planks")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock6 := availableBlock6 + 4 ; availableBlock6 is planks + 4
availableBlock4 := availableBlock4 - 1 ; availableBlock4 is log - 1
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "sticks")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock7 := availableBlock7 + 4 ; availableBlock7 is sticks + 4
availableBlock6 := availableBlock6 - 2 ; availableBlock6 is planks - 2
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "crafting_table")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock8 := availableBlock8 + 1 ; availableBlock8 is crafting_table + 4
availableBlock6 := availableBlock6 - 4 ; availableBlock6 is planks - 4
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "wooden_pickaxe")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock9 := availableBlock9 + 1 ; availableBlock9 is wooden_pickaxe + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock6 := availableBlock6 - 3 ; availableBlock6 is planks - 3
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "stone_pickaxe")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock10 := availableBlock10 + 1 ; availableBlock10 is stone_pickaxe + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock1 := availableBlock1 - 3 ; availableBlock1 is stone - 3
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "iron_pickaxe")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock11 := availableBlock11 + 1 ; availableBlock11 is iron_pickaxe + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock16 := availableBlock16 - 3 ; availableBlock16 is iron - 3
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "diamond_pickaxe")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock12 := availableBlock12 + 1 ; availableBlock12 is diamond_pickaxe + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock17 := availableBlock17 - 3 ; availableBlock17 is diamond - 3
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "wooden_shovel")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock13 := availableBlock13 + 1 ; availableBlock13 is wooden_shovel + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock6 := availableBlock6 - 1 ; availableBlock6 is plnak - 1
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "wooden_axe")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock14 := availableBlock14 + 1 ; availableBlock14 is wooden_axe + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock6 := availableBlock6 - 3 ; availableBlock6 is plnak - 3
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "stone_axe")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock15 := availableBlock15 + 1 ; availableBlock14 is stone_axe + 1
availableBlock7 := availableBlock7 - 2 ; availableBlock7 is sticks - 2
availableBlock1 := availableBlock1 - 3 ; availableBlock1 is stone - 3
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}

if (weCraftedInTheInventory = "diamond_block")
{
getBlockFormDoneCraftingInInventory := 0
funcGetBlockCount()
itemInfo(1)
availableBlock18 := availableBlock18 + 1 ; availableBlock18 is diamond_block + 1
availableBlock17 := availableBlock17 - 9 ; availableBlock17 is diamond - 9
itemInfo(1)
funcGetBlockCount()
itemInfo(1)
weCanPlaceBlockInCraftingInventory := 0 ; and here is yeah you know
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Loop, 18
{
itemCount := itemCount%A_Index%
GuiControl, 3:, ItemCount%A_Index%, %itemCount%
}
GuiControl, 3:, Item19, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item20, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item21, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item22, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item23, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item24, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item25, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item26, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item27, %TexturesFolder%inventory_crafting_slot.png
GuiControl, 3:, Item28, %TexturesFolder%inventory_crafting_slot.png

numOfPosInInventoryCrafingTable := 0

lastBugFixInCrafting := 0
OLDlastBugFixInCrafting := 0
firstTimeLastBugFixInCrafting := 0
forInInventoryCrafingTablePos1 := 0
forInInventoryCrafingTablePos2 := 0
forInInventoryCrafingTablePos3 := 0
forInInventoryCrafingTablePos4 := 0
forInInventoryCrafingTablePos5 := 0
forInInventoryCrafingTablePos6 := 0
forInInventoryCrafingTablePos7 := 0
forInInventoryCrafingTablePos8 := 0
forInInventoryCrafingTablePos9 := 0

forInInventoryCrafingTableName1 := ""
forInInventoryCrafingTableName2 := ""
forInInventoryCrafingTableName3 := ""
forInInventoryCrafingTableName4 := ""
forInInventoryCrafingTableName5 := ""
forInInventoryCrafingTableName6 := ""
forInInventoryCrafingTableName7 := ""
forInInventoryCrafingTableName8 := ""
forInInventoryCrafingTableName9 := ""

}
}
}



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
BlockNumber := Floor(BlockNumber)
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


return
!L::
GuiClose:
MsgBox, 262212, , Are you sure you want exit?
IfMsgBox Yes
{
ExitApp
}
Return

