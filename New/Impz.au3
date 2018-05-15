#Include <MetroGUI_UDF.au3>
#Include <GUIConstantsEx.au3>
#include <GDIPlus.au3>

HotKeySet("{ESC}",EndProgram)

Global $name = "Impz"
Global $Text = ""
Global $window_width = 1200
Global $window_height = 675
Global $directory = @ScriptDir & "\"

$Form = _Metro_CreateGUI($name,$window_width,$window_height,-1,-1,True)
$Input = GUICtrlCreateInput("",8,$window_height-24,$window_width-16,20)
_SetTheme("DarkBlue")
GUISetState()

_GDIPlus_StartUp()
$hImage = _GDIPlus_ImageLoadFromFile($directory & "Image.png")
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($Form)
_GDIPlus_GraphicsDrawImage($hGraphic,$hImage,($window_width/2)-300,($window_height/2)-250)

While(1)
    sleep(50)
WEnd

Func EndProgram()
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_ShutDown()
    _Metro_GUIDelete($Form)
    Exit
EndFunc