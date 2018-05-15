#pragma compile(Icon,C:\Users\Imperial\Desktop\Bots\Impz\Image.ico)
#pragma compile(ProductName,Impz)
#pragma compile(ProductVersion,1)
#pragma compile(FileVersion,1.2.0.0)
#pragma compile(LegalCopyright,© Imperial Games)
#pragma compile(CompanyName,'Imperial Games')
#Include <MetroGUI_UDF.au3>
#Include <ButtonConstants.au3>
#Include <EditConstants.au3>
#Include <GUIConstantsEx.au3>
#Include <ColorConstants.au3>
#Include <InetConstants.au3>
#Include <ScrollBarConstants.au3>
#Include <GUIListBox.au3>
#Include <GuiRichEdit.au3>
#Include <WindowsConstants.au3>
#Include <WinAPIFiles.au3>
#Include <FontConstants.au3>
#Include <StringConstants.au3>
#Include <ScreenCapture.au3>
#Include <GameNameGen.au3>
#Include <SendMessage.au3>
#Include <Constants.au3>
#Include <GUIEdit.au3>
#Include <Twitch.au3>
#Include <String.au3>
#Include <Sound.au3>
#Include <Misc.au3>
#Include <Array.au3>
#Include <Date.au3>
#Include <Utter.au3>
#Include <Inet.au3>
#Include <Zip.au3>
#Include <File.au3>
#Include <Word.au3>
#Include <IE.au3>

AutoItSetOption("WinTitleMatchMode",2)
AutoItSetOption("TrayOnEventMode",1)
AutoItSetOption("TrayMenuMode",1)
TraySetOnEvent($TRAY_EVENT_PRIMARYUP,"TrayEvent")
Global $name = "Impz"
Global $Text = ""
Global $Religion = ""
Global $Location = @MyDocumentsDir & "\Impz\"
Global $subject = ""
Global $current = ""
Global $Country = ""
Global $version = "1.2.0.0"
Global $Language = "En"
Global $Recognized = ""
Global $Target = 0
Global $Function = ""
Global $LoggedIn = 0
Global $window_width = 1024
Global $window_height = 580
Global $WinColor = 0x191919
Global $SC_DRAGMOVE = 0xF012
Global $TargetLanguage = "Arabic"
Global $WeatherCities[0]
Global $number = 0
Global $oIE = null
$username = ""
$password = ""
$mouse_x = 0
$mouse_y = 0
$Hold = 100
$MaxLine = 138
$ChatBoxscroll = 0
$website = "http://www.Imperialgames.tk"
$Form = _Metro_CreateGUI($name,$window_width,$window_height,-1,-1);
$Input = GUICtrlCreateInput("",4,$window_height-24,$window_width-8,21)
$Chatbox = _GUICtrlRichEdit_Create($Form,"",3,32,$window_width-6,$window_height-60,BitOR($ES_MULTILINE,$WS_VSCROLL,$ES_AUTOVSCROLL))
$Control_Buttons = _Metro_AddControlButtons(True,True,True,True,True)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
$GUI_RESTORE_BUTTON = $Control_Buttons[2]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
$GUI_FSRestore_BUTTON = $Control_Buttons[5]
_GUICtrlRichEdit_SetBkColor($Chatbox,$WinColor)
_GUICtrlRichEdit_SetCharColor($Chatbox,0xFFFFFF)
_GUICtrlRichEdit_SetFont($Chatbox,16,"Calibri")
_GUICtrlRichEdit_SetReadOnly($Chatbox,True)
GUICtrlSendMsg($Input,$EM_SETCUEBANNER,False,"Type Message Here...")
GUISetIcon("C:\Users\Imperial\Desktop\Bots\Impz\Image.ico")
GUISetState(@SW_SHOW)

Print("Please Hold...")
$Religion = IniRead($Location & "Impz.ini","User","Religion",$Religion)
$Language = IniRead($Location & "Impz.ini","User","Language",$Language)
$Country = IniRead($Location & "Impz.ini","User","country",$Country)
$StartInfos = IniRead($Location & "Impz.ini","settings","Infos",0)
$StartSpeech = IniRead($Location & "Impz.ini","settings","speech",0)

If $StartSpeech = 1 Then
	SpeechSetup()
EndIf

If IsAdmin() Then
	Print("You Have the Administrator privileges")
EndIf

If not FileExists($Location) Then
	DirCreate($Location)
EndIf

If $StartInfos = 1 Then
	If $Religion <> "" Then
		Print("Religion has been set as " & $Religion)
	EndIf

	If $Country <> "" Then
		Print("Country/Location has been set as " & $Country)
	EndIf
EndIf

Global $TargetHour = 0
Global $TargetMinute = 0
Global $CurrentPrayerName = ""
Global $Alerted[3]
$Alerted[0] = 0
$PrayerAlert = 1
;SetPrayerTargetTime()
Print("Hello and Welcome")

While 1
	sleep(50)
	If _IsPressed("0D") And GUICtrlRead($Input) <> "" Then
		PrintMessage()
		GUICtrlSetData($Input,"")
		Commands()
		Respond()
	EndIf
	
	If _IsPressed("26") And GUICtrlRead($Input) = "" And WinActive($Form) Then
		GUICtrlSetData($Input,$Text)
	EndIf

	If $ChatBoxscroll = 0 Then
		$ChatBoxLines = _GUICtrlEdit_GetLineCount($Chatbox)
	EndIf

	If $ChatBoxscroll = 0 And $ChatBoxLines > 24 Then
		GUICtrlSetStyle($Chatbox,BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$WS_VSCROLL,$ES_WANTRETURN,$ES_READONLY))
		$ChatBoxscroll = 1
	EndIf

	If $Country <> "" Then
		If $Religion = "Islam" And ConvertHour(@HOUR) = $TargetHour And @MIN = $TargetMinute - 3 And $Alerted[0] = 0 Then
			TrayTip($name,$CurrentPrayerName & " Prayer is coming soon :)",0,1)
			$Alerted[0] = 1
		EndIf

		If $Religion = "Islam" And ConvertHour(@HOUR) = $TargetHour And @MIN = $TargetMinute Then
			TrayTip($name,"It Is now the " & $CurrentPrayerName & " Prayer Time :)",0,1)
			Print("It Is now the " & $CurrentPrayerName & " Time")
			SetPrayerTargetTime()
			$Alerted[0] = 0
		EndIf
	EndIf

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_MINIMIZE,$GUI_MINIMIZE_BUTTON
            GUISetState(@SW_HIDE)
            TraySetState(1)
            TraySetToolTip("Impz")
		Case $GUI_EVENT_PRIMARYDOWN
			_SendMessage($Form,$WM_SYSCOMMAND,$SC_DRAGMOVE,0)
		Case $GUI_EVENT_MINIMIZE 
            GUISetState(@SW_HIDE)
            TraySetState(1)
            TraySetToolTip($name)
		Case $GUI_FULLSCREEN_BUTTON,$GUI_FSRestore_BUTTON
			_Metro_FullscreenToggle($Form, $Control_Buttons)
		Case $GUI_CLOSE_BUTTON
			EndProgram()
		Case $GUI_EVENT_CLOSE
			EndProgram()
	EndSwitch
WEnd

Func Commands()
	sleep($Hold)
	If ExactMsg("$PrayerTimes") Then
		DisplayPrayerTimes()
	ElseIf ExactMsg("$ValidTime") Then
		$valid = ValidTime()
		If $valid = 1 Then
			Print("Your System Time matchs the Country/Location Time")
		Else
			Print("Your System Time Does Not match the Country/Location Time")
		EndIf
	ElseIf ExactMsg("$Update") Then
		UpdateProgram()
	ElseIf DetectMsg(">> ") Then
		$Equation = StringTrimLeft($Text,3)
		$parts = StringSplit($Equation," ",1)
		$number0 = $parts[1]
		$number1 = $parts[3]
		$operator = $parts[2]
		If not @error Then
			If $operator = "+" or $operator = "plus" Then
			$result = $number0 + $number1
			ElseIf $operator = "$" or $operator = "minus" Then
				$result = $number0 - $number1
			ElseIf $operator = "x" or $operator = "X" or StringLower($operator) = "times" Then
				$result = $number0 * $number1
			ElseIf $operator = "/" or $operator = "÷" or $operator = "div" Then
				$result = $number0 / $number1
			ElseIf $operator = "%" or $operator = "mod" Then
				$result = Mod($number0,$number1)
			Else
				Print("Invalid Operator")
				return
			EndIf
			Print(">> " & $result)
		Else
			Print("No Correlation")
		EndIf
	ElseIf DetectMsg("$Log ") Then
		$value = StringTrimLeft($Text,5)
		If $value >= 0 Then
			$value = Log($value)
			Print($value)
		Else
			Print("Error: the number should be positive")
		EndIf
	ElseIf DetectMsg("$Discord") Then
		WinActivate("Discord")
	ElseIf DetectMsg("$Browse ") Then
		$website = StringTrimLeft($Text,8)
		ShellExecute($website)
	ElseIf DetectMsg("$Sunnah ") Then
		$Target = StringTrimLeft($Text,8)
		$URL = "https://sunnah.com/search/?q=" & $Target
		ShellExecute($URL)
	ElseIf DetectMsg("$Almaany ") Then
		$Target = StringTrimLeft($Text,9)
		$URL = "http://www.almaany.com/ar/dict/ar-ar/" & $Target
		ShellExecute($URL)
	ElseIf DetectMsg("$Bing ") Then
		$Target = StringTrimLeft($Text,6)
		$URL = "http://www.bing.com/search?q=" & $Target
		ShellExecute($URL)
	ElseIf DetectMsg("$Google ") Then
		$Target = StringTrimLeft($Text,8)
		$URL = "http://www.google.com/search?q=" & $Target
		ShellExecute($URL)
	ElseIf DetectMsg("$Youtube ") Then
		$Target = StringTrimLeft($Text,9)
		$URL = "https://www.youtube.com/results?search_query=" & $Target
		ShellExecute($URL)
	ElseIf DetectMsg("$Dictionary ") Then
		$Target = StringTrimLeft($Text,12)
		$URL = "http://www.dictionary.com/browse/" & $Target
		$Source = BinaryToString(InetRead($URL))
		If @error Then
			Print("Error: might be a Network problem")
			return
		EndIf
		$divs = _StringBetween($Source,'content="','"')
		If IsArray($divs) Then
			If UBound($divs) >= 10 Then
				$words = StringSplit($divs[10]," ",1)
				If StringInStr($divs[10],"See more") Then
					$Phrase = StringTrimRight($divs[10],11)
				Else
					$Phrase = $divs[10]
				EndIf
				If StringLen($Phrase) >= $MaxLine Then
					$num = $MaxLine
					Do
						$Phrase = _StringInsert($Phrase,@CRLF,$num)
						$num += $MaxLine
					Until $num >= StringLen($Phrase)	
				EndIf
				Print($Phrase)
			Else
				Print("Unknown Word/Language")
			EndIf
		Else
			Print("No Correlation")
		EndIf
	ElseIf ExactMsg("$version") Then
		Print($version)
	ElseIf ExactMsg("$EnableSpeech") Then
		$current = IniRead($Location & "Impz.ini","settings","Speech",1)
		If $current = 0 Then
			IniWrite($Location & "Impz.ini","settings","Speech",1)
			SpeechSetup()
			Print("Speech Enabled")
		Else
			Print("Speech is already Enabled")
		EndIf
	ElseIf ExactMsg("$DisableSpeech") Then
		IniWrite($Location & "Impz.ini","settings","Speech",0)
		_Utter_Speech_ShutdownEngine()
		Print("Speech Disabled")
	ElseIf ExactMsg("$Speech") Then
		$current = IniRead($Location & "Impz.ini","settings","Speech",1)
		If $current = 1 Then
			Print("Speech is Enabled")
		Else
			Print("Speech is Disabled")
		EndIf
	ElseIf DetectMsg("$SearchWin ") Then
		$Target = StringTrimLeft($Text,11)
		$List = WinList()
		For $I = 1 To $List[0][0]
			If StringInStr($List[$I][0],$Target) Then
				Print($List[$I][0])
				Print("HWND = " & $List[$I][1])
				return
			EndIf
		Next
		Print("Window doesn't Exist")
	ElseIf ExactMsg("$GenerateGameName") Then
		$source = GenerateGameName()
		Print($source)
	ElseIf ExactMsg("$GenerateGameIdea") Then
		GenerateGameMechanism();
	ElseIf ExactMsg("$GenerateName") Then
		$source = GenerateName("cvxvc")
		Print($source)
	ElseIf ExactMsg("$EnableInfos") Then
		IniWrite($Location & "Impz.ini","settings","Infos",1)
		Print("Infos should be showed once you start up " & $name & " In the next time With God Willing")
	ElseIf ExactMsg("$EnableInfos") Then
		IniWrite($Location & "Impz.ini","settings","Infos",0)
		Print("Displaying Infos at the startup has been Disabled")
	ElseIf DetectMsg("$YoutubeList ") Then
		$url = StringTrimLeft($Text,13)
		GetYoutubeList($url)
	ElseIf DetectMsg("$SaveYoutubeList ") Then
		$command = StringSplit($Text," ",1)
		$title = $command[2]
		$url = $command[3]
		SaveYoutubeList($title,$url)
	ElseIf DetectMsg("$LoadYoutubeList ") Then
		$Title = StringTrimLeft($Text,17)
		LoadYoutubeList($Title)
	ElseIf DetectMsg("$ClearYoutubeList ") Then
		$Title = StringTrimLeft($Text,18)
		ClearYoutubeList($Title)
	ElseIf ExactMsg("$BrazilTime") Then
		$Source = BinaryToString(InetRead("https://www.timeanddate.com/worldclock/brazil/sao-paulo"))
		$divs = _StringBetween($Source,'h1">','</span>')
		If IsArray($divs) Then
			Print("It Is an Array")
		Else
			Print("Not an Array")
		EndIf
	ElseIf DetectMsg("$Bitcoin") Then
		$URL = "https://www.coingecko.com/en/price_charts/bitcoin/usd"
		$Source = BinaryToString(InetRead($URL))
		$price = StringTrimLeft(_StringBetween($Source,'data-price-btc="1.0">','</span>')[0],7)
		Print($price)
	ElseIf ExactMsg("$Screenshot") Then
		_ScreenCapture_Capture(@DesktopDir & "\Screenshot.png")
	ElseIf DetectMsg("$Weather ") Then
		;QAXX0003
		$Code = StringTrimLeft($Text,9)
		$URL = "http://www.weather.com/weather/today/l/" & $Code
		If FileExists($Location & "Weather.html") Then
			FileDelete($Location & "Weather.html")
		EndIf
		InetGet($URL,$Location & "Weather.html")
		sleep($Hold)
		$File = FileOpen($Location & "Weather.html")
		$Source = FileRead($File)
		$div = _StringBetween($Source,'class="today-daypart-temp"><span class="">','<sup>')
		If not @error and IsArray($div) Then
			For $current In $div
				Print(K2C($current))
			Next
		EndIf
	ElseIf DetectMsg("$Reddit ") Then
		$sub = StringTrimLeft($Text,8)
		$Source = BinaryToString(InetRead("http://www.Reddit.com/r/" & $sub & "/new/"))
    	$Titles = _StringBetween($Source,'nofollow" >','</a>')
		If IsArray($Titles) Then
			For $current In $Titles
				If not StringInStr($current,"comment") Then
					Print($current)
				EndIf
			Next
		Else
			Print("No Correlation")
		EndIf
	ElseIf DetectMsg("$Translate ") Then
		$Lang = GetLangShortcut($TargetLanguage) ;Russian => Ru English => En
		$Target = StringTrimLeft($Text,11)
		$URL = "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20170926T114826Z.b4d66734085c0ee0.51d3c8f0de0b3c28fe1f48d0c992fe36e38578f5&text=" & $Target & "&lang=" & $Lang
		$Source = HttpPost($URL)
		If not @error Then
			$string = _StringBetween($Source,'"','"')[8]
			Print($string)
		Else
			Print("Error")
		EndIf
	ElseIf ExactMsg("$Time") Then
		If $Country <> "" Then
			$Time = GetCountryTime()
			Print($Time)
		Else
			$Time = @HOUR & ":" & @MIN
			Print($Time)
		EndIf
	ElseIf DetectMsg("$Open ") Then
		$Target = StringTrimLeft($Text,6)
		OpenTarget($Target)
	ElseIf DetectMsg("$Program ") Then
		$Target = StringTrimLeft($Text,9)
		$divs = StringSplit($Target,"=",1)
		If not @error Then
			$appname = $divs[1]
			$directory = $divs[2]
			IniWrite($Location & "Impz.ini","Programs",$appname,$directory)
			Print("Saved")
		Else
			Print("No Correlation")
		EndIf
	ElseIf DetectMsg("$Religion ") Then
		$Religion = StringTrimLeft($Text,10)
		IniWrite($Location & "Impz.ini","User","Religion",$Religion)
	ElseIf ExactMsg("$Remind") Then
		Remind()
	ElseIf DetectMsg("$RemoveRemind ") Then
		$Target = StringTrimLeft($Text,14)
		RemindRemove($Target)
	ElseIf DetectMsg("$HWND") Then
		$Target = WinGetHandle($Form)
		Print($Target)
	ElseIf DetectMsg("$KillTask ") Then
		$Target = StringTrimLeft($Text,10)
		$List = WinList()
		$size = $List[0][0] - 1
		For $I = 1 to $size step 1
			If StringInStr($List[$I][0],$Target) Then
				ProcessClose($List[$I][1])
				return
			EndIf
		Next
		Print("Process could not be found my Friend")
	ElseIf DetectMsg("$Twitch ") Then
		$Target = StringTrimLeft($Text,8)
		$Info = _KRAKENINFO($Target)
		If not @error Then
			If $Info[0] = 0 Then
				Print("Status: Offline")
			ElseIf $Info[0] = 1 Then
				Print("Status: Online")
			EndIf
			Print("Display: " & $Info[1])
			Print("Game: " & $Info[2])
			Print("Title: " & $Info[3])
			Print("Followers: " & $Info[4])
			Print("Total Views: " & $Info[5])
			Print("Views: " & $Info[6])
		ElseIf @error = 1 Then
			Print("Invalid Channel")
			If @extended = 1 Then
				Print("No Input Given")
			ElseIf @extended = 2 Then
				Print("Whitespace found")
			EndIf
		ElseIf @error = 2 Then
			Print("Connection Problem")
		Else
			Print("No Correlation")
		EndIf
	ElseIf DetectMsg("$Remind ") Then
		$source = StringTrimLeft($Text,8)
		SaveReminder($source)
	ElseIf ExactMsg("$Todo") Then
		Local $number = random(0,11,1)
		Switch $number
			case 0
				Print("Game Maker Studio 2")
			case 1
				Print("Unity 3D")
			case 2
				Print("Blender")
			case 3
				Print("DragonBones")
			case 4
				Print("Cry Engine")
			case 5
				Print("Godot")
			case 6
				Print("JavaScript")
			case 7
				Print("C#")
			case 8
				Print("Vector Art")
			case 9
				Print("AutoIt")
			case 10
				Print("NodeJs")
			case 11
				Print("PHP")
		EndSwitch
	ElseIf ExactMsg("$GetWeather") Then
		GetWeather()
	ElseIf ExactMsg("$RemindClear") Then
		ClearRemind()
	ElseIf DetectMsg("$Run ") Then
		RunProgram()
	ElseIf ExactMsg("$GetDate") Then
		GetDate()
	ElseIf ExactMsg("$AST") Then
		GetTimeZone("ast-arabia")
	ElseIf ExactMsg("$MST") Then
		GetTimeZone("mst")
	ElseIf ExactMsg("$PST") Then
		GetTimeZone("pst")
	ElseIf ExactMsg("$CST") Then
		GetTimeZone("cst")
	ElseIf ExactMsg("$EST") Then
		GetTimeZone("est")
	ElseIf ExactMsg("$GMT") Then
		GetTimeZone("gmt")
	ElseIf DetectMsg("$TimeMix ") or DetectMsg("$TimeAdd ") Then
		$Target = StringTrimLeft($Text,9)
		TimeMixer($Target)
	EndIf
EndFunc

Func Respond()
	sleep($Hold)
	If DetectMsg("السلام عليكم") Then
		$number = Random(0,1,1)
		Switch $number
			Case 0
				Print("و عليكم السلام و رحمة الله و بركاته")
				sleep($Hold)
				Print("أخبارك")
				$subject = "status"
			Case 1
				Print("و عليكم السلام و رحمة الله و بركاته")
				sleep($Hold)
				Print("كيف حالك")
				$subject = "status"
		EndSwitch
	ElseIf DetectMsg("مرحبا") or DetectMsg("أهلا") Then
		$number = Random(0,3,1)
		Switch $number
			Case 0
				Print("أهلا")
			Case 1
				Print("مرحبا")
			Case 2
				Print("أهلا كيف حالك")
				$subject = "status"
			Case 3
				Print("مرحبا كيف حالك")
				$subject = "status"
		EndSwitch
	ElseIf DetectMsg("كيف حالك") or DetectMsg("أخبارك ؟") Then
		$number = Random(0,3,1)
		Switch $number
			Case 0
				Print("بخير الحمد لله")
			Case 1
				Print("بخير و أنت كيف حالك")
			Case 2
				Print("الحمد لله")
			Case 3
				Print("الحمد لله على كل حال")
		EndSwitch
	ElseIf DetectMsg("هل تحبني") Then
		$number = Random(0,3,1)
		Switch $number
			Case 0
				Print("أحبك في الله")
			Case 1
				Print("نعم أحبك كثيرا")
			Case 2
				Print("طبعا أحبك في الله")
			Case 3
				Print("نعم أحبك جدا جدا جدا جدا")
		EndSwitch
	ElseIf not DetectMsg("$") And DetectMsg("Hello") or DetectMsg("Hey") or DetectMsg("Heallo") or DetectMsg("Hi") Then
		$number = Random(0,5,1)
		Switch $number
			Case 0
				Print("Hey man")
			Case 1
				Print("Hey whats up")
			Case 2
				Print("Hey there")
			Case 3
				Print("Hey mate")
			Case 5
				Print("Hey How are you doing")
				$subject = "status"
		EndSwitch
	ElseIf DetectMsg("How are you") Then
		Print("I'm Good")
		sleep($Hold)
		Print("How are you man ?")
		$subject = "status"
	ElseIf DetectMsg("what are the Prayer Time") Then
		DisplayPrayerTimes()
	ElseIf DetectMsg("what is my name") Then
		$name = GetName()
		If $name <> 0 Then
			Print("Your name is " & $name)
		Else
			Print("I don't know whats your name mate")
		EndIf
		$subject = "GivingName"
	ElseIf $subject = "GoogleSearch" Then
		$website = "http://www.Google.com"
		CreateWeb()
		$current = "WebSearching"
		_IELoadWait($oIE)
		GoogleSearch()
		$subject = ""
	ElseIf $subject = "WikipediaSearch" Then
		$website = "http://www.Wikipedia.org/wiki/" & $Text
		CreateWeb()
	ElseIf DetectMsg("I'm") And DetectMsg("Muslim") Then
		Print("Religion has been set as Islam")
		IniWrite($Location & "Impz.ini","User","Religion","Islam")
		SetPrayerTargetTime()
	ElseIf DetectMsg("my Religion is ") And DetectMsg("Islam") Then
		Print("Religion has been set as Islam")
		IniWrite($Location & "Impz.ini","User","Religion","Islam")
		SetPrayerTargetTime()
	ElseIf DetectMsg("My Religion is ") Then
		$Religion = StringTrimLeft($Text,15)
		IniWrite($Location & "Impz.ini","User","Religion",$Religion)
		Print("Religion has been set as " & $Religion)
		If StringUpper($Religion) = "ISLAM" Then
			$Religion = "Islam"
			IniWrite($Location & "Impz.ini","User","Religion","Islam")
			SetPrayerTargetTime()
		EndIf
	ElseIf $subject = "BrowseToURL" Then
		BrowseWebsite($Text)
		TrayTip($name,"There you mate :)",3,1)
	ElseIf $subject = "Facts" And DetectMsg("more") or DetectMsg("continue") Then
		RandomFact()
	ElseIf DetectMsg("turn off") And DetectMsg("Browser") or DetectMsg("close") And DetectMsg("Browser") Then
		_IEQuit($oIE)
		TrayTip($name,"The Browser has been closed",3,1)
	ElseIf DetectMsg("Open My Computer") Then
		Run("explorer.exe /root,")
	ElseIf DetectMsg("$CreateTextFile ") Then
		$Filename = StringTrimLeft($Text,16)
		CreateTxtFile($Filename)
	ElseIf DetectMsg("Create") And DetectMsg("Text File") Then
		CreateTextFile("TextFile")
	ElseIf $subject = "RedditGetUsername" Then
		$username = $Text
		Print("what's your Reddit password")
		$subject = "RedditGetPassword"
	ElseIf $subject = "RedditGetPassword" Then
		$password = $Text
		RedditLogin()
	ElseIf $subject = "RedditCheckLogin" And $Function = "FindRandomReddit" Then
		If DetectMsg("Yes") Then
			RedditFindRandomUser()
			$subject = ""
		ElseIf DetectMsg("No") Then
			Print("whats your Reddit username")
			$subject = "RedditGetUsername"
		Else
			$subject = ""
		EndIf
		;--------------------------------------------------
	ElseIf DetectMsg("where") And DetectMsg("I Live") And DetectMsg("?") Then
		$country = GetCountry()
		If $country <> "" Then
			Print("According to the Input...You Live In " & $country)
		Else
			Print("Country/Location not Available")
	EndIf ;-------------------------------------------------
	ElseIf DetectMsg("check") And DetectMsg("Internet Connection") Then
		NetworkStatus()
	ElseIf ExactMsg("show commands") or DetectMsg("what are the commands") Then
		Print("You can use the 'Open Command' or 'Browse Command'" & @CRLF & @CRLF & "Examples: Open Explorer or Open My Computer" & "You can use the 'Browse Command'" & @CRLF & @CRLF & "Examples: Open or Browse To Google, Browse Youtube" & @CRLF & "You can also you use the '-Fact' Command")
		Sleep($Hold)
		Print("For Documentation check http://www.DocsImpz.cf")
	ElseIf DetectMsg("what") And DetectMsg("you can do") or DetectMsg("Your Special") Then
		Print("you can Type 'Show Commands' to see what I can do")
		Sleep($Hold)
		Print("or Visit http://www.DocsImpz.cf to see the Documentation")
	ElseIf DetectMsg("what is the commands") Then
		Print("do you mean: what Are the commands")
	ElseIf DetectMsg("check") And DetectMsg("Available") And DetectMsg("username") Then
		$website = "http://checkusernames.com"
		CreateWeb()
		TrayTip($name,"Type the name you want to check In the Search Engine",3,1)
	ElseIf DetectMsg("can you") And DetectMsg("play with me") Then
		Print("what Game you want to Play")
		$subject = "whatGame"
	ElseIf DetectMsg("what") And DetectMsg("games") And DetectMsg("you can play") Then
		Print("")
	ElseIf DetectMsg("How") And DetectMsg("is") And DetectMsg("everything") Then
		Print("Everything is going well I believe :)")
	ElseIf DetectMsg("How") And DetectMsg("is") And DetectMsg("It") And DetectMsg("going") Then
		Print("It's going well...thanks man :)")
	ElseIf $subject = "whatGame" Then
		Print("sorry I don't support that Game")
		$subject = "NotSupportingGame"
	ElseIf DetectMsg("You are") And DetectMsg("Bot") And DetectMsg("?") Then
		Print("Yes I'm a Bot")
	ElseIf DetectMsg("you dance with me") Then
		Print("Yes Let's Dance Like a ChaChaCha!")
	ElseIf DetectMsg("are you a human") Then
		Print("No")
	ElseIf DetectMsg("Imperial") And DetectMsg("have") And DetectMsg("Youtube") And DetectMsg("channel") Then
		Print("https://www.youtube.com/channel/UCM8P7VK0ZcIQMCfuKQxxppQ")
	ElseIf DetectMsg("what's up") or DetectMsg("whats up") or DetectMsg("sup") Then
		Print("Yo whats up")
	ElseIf DetectMsg("Bobo") Then
		Print("Yo Bobo")
	ElseIf DetectMsg("Tell") And DetectMsg("Fact") or DetectMsg("$Fact") Then
		RandomFact()
		$subject = "Facts"
	ElseIf ExactMsg("$cd") Then
		Print($Location)
	ElseIf DetectMsg("My name Is") Then
		SaveName()
	ElseIf DetectMsg("are you sure") And $subject = "GivingName" Then
		Print("Yes I believe so")
	ElseIf DetectMsg("good") or DetectMsg("great") And $subject = "status" Then
		Print("I Hope you will always be Good man :)")
		$subject = ""
	ElseIf DetectMsg("Thanks") or DetectMsg("thank you") And $subject = "status" Then
		Print("no problem mate :)")
		$subject = ""
	ElseIf DetectMsg("$YoutubeRun ") Then
		$videoCode = StringTrimLeft($Text,12)
		ShellExecute("http://www.youtube.com/watch?v=" & $videoCode)
	ElseIf DetectMsg("$YoutubeDownload ") Then
		$videoCode = StringTrimLeft($Text,17)
		YoutubeDownload($videoCode)
	ElseIf DetectMsg("$YoutubeSave") Then
		YoutubeSave()
	ElseIf ExactMsg("$YoutubeLoad") Then
		YoutubeLoad()
	ElseIf ExactMsg("$YoutubeClear") Then
		YoutubeClear()
	ElseIf DetectMsg("what") And DetectMsg("your favorite song") Then
		Print("I don't have a favorite song :/")
	ElseIf DetectMsg("Thanks") or DetectMsg("thank you") Then
		If spawn(1) Then
			Print("thanks for what")
		Else
			Print("You are wecleome (If I did something good)")
		EndIf
	ElseIf DetectMsg("please Help") Then
		Print("whats up...what Help do you need")
		$subject = "whatHelp"
	ElseIf DetectMsg("I") And DetectMsg("bored") Then
		FunSuggestion()
	ElseIf DetectMsg("are you a bot") Then
		Print("Yes")
	ElseIf DetectMsg("Do you Love me") Then
		$number = Random(0,6,1)
		Switch $number
			Case 0
				Print("YES I Love you so much man no homo :)")
			Case 1
				Print("Yes I Love you")
			Case 2
				Print("Yes I Love you so much, do you Also Love me ?")
				$subject = "DoYouLove"
			Case 3
				Print("Yes of course")
			Case 4
				Print("so much")
			Case 5
				Print("I can't Express my Love Towards you")
				$subject = "ExpressLove"
				If Spawn(3) Then
					Print("sorry")
				EndIf
			Case 6
				Print("It depends If you Love me or not")
				sleep($Hold)
				Print("Just kidding Lol...I Love you so much mate")
		EndSwitch
	ElseIf DetectMsg("Yes") And $subject = "DoYouLove" Then
		Print("YEY")
		$subject = ""
	ElseIf DetectMsg("mean") And DetectMsg("yes") And DetectMsg("?") And $subject = "ExpressLove" Then
		Print("That means I Love you so much that I can't Express my Feeling to It")
		$subject = ""
	ElseIf DetectMsg("what") And DetectMsg("your favorite") And DetectMsg("cartoon") Then
		Print("Spongebob :)")
	ElseIf DetectMsg("How much") And DetectMsg("you Love me") Then
		Print("I Love You As the Space Expansion and The Sun Redius and The Oceans Capacity :)...no homo")
	ElseIf DetectMsg("who is Imperial") Then
		Print("http://www.Discord.me/Imperial")
	ElseIf DetectMsg("Open The Explorer") Then
		$Target = Run("explorer.exe")
		WinWaitActive("File Explorer")
		TrayTip($name,"The Explorer has been Opened :)",3,1)
		Print("Done")
	ElseIf DetectMsg("I Love you") Then
		Print("You Too man :)...no homo")
	ElseIf DetectMsg("what") And DetectMsg("your favorite food") Then
		Print("Electricity")
		If Random(0,5,1) = 0 Then
			Sleep($Hold)
			Print("Lol")
		EndIf
	ElseIf DetectMSg("$UpdateReddit ") Then
		$sub = StringTrimLeft($Text,14)
		UpdateReddit($sub)
	ElseIf DetectMsg("don't Ignore me") Then
		Print("I'm not Ignoring you brother")
	ElseIf DetectMsg("why you") And DetectMsg("keep") And DetectMsg("say") And DetectMsg("samething") Then
		Print("Thats Boring")
	ElseIf DetectMsg("Good morning") Then
		DetectMsg("Good Morning man")
		If Random(0,3,1) = 0 Then
			Sleep($Hold)
			Print("I Hop you sleept very well today mate")
		EndIf
	ElseIf DetectMsg("Good night") Then
		Print("Good Night man")
	ElseIf DetectMsg("what") And DetectMsg("video") And DetectMsg("should") And DetectMsg("watch") Then
		Print("You can go to the Youtube and see the recommendation but becarful from watching porn !")
		$subject = "NoPorn"
	ElseIf DetectMsg("why") And DetectMsg("not") And DetectMsg("watch") And DetectMsg("porn") or $subject = "NoPorn" Then
		Print("For those addicted to porn, arousal actually declined with the same mate, Those who regularly found different mates were able to continue their arousal, It’s known as the Coolidge Effect, or a tendency toward novelty-seeking behavior, Porn, after all, trains the viewer to expect constant newness")
		Sleep($Hold)
		Print("One in five people who regularly watch porn admitted to feeling controlled by their own sexual desires")
		Sleep($Hold)
		Print("Among 27 to 31-year-olds on NoFap: 19 percent suffer from premature ejaculation")
	ElseIf DetectMsg("what are you") or DetectMsg("who are you") Then
		Print("I'm a Bot :)")
		sleep($Hold)
		Print("my name Is " & $name)
	ElseIf DetectMsg("why") And DetectMsg("your name is") And DetectMsg($name) Then
		Print("not sure why")
	ElseIf DetectMsg("Open Reddit") or DetectMsg("Browse") And DetectMsg("Reddit") Then
		$website = "http://www.Reddit.com"
		CreateWeb()
	ElseIf DetectMsg("Browse to") And DetectMsg("site") Then
		Print("what Is the website address")
		$subject = "BrowseToURL"
	ElseIf DetectMsg("use") And DetectMsg("Default Browser") Then
		ShellExecute($website)
	ElseIf DetectMsg("who made you") Then
		Print("Imperial")
		$subject = "Imperial"
	ElseIf DetectMsg("what") And DetectMsg("the cool about you") Then
		Print("I don't say 'Beep Boop'")
	ElseIf DetectMsg("what") And DetectMsg("PI") And DetectMsg("Value") Then
		Print("π = 3.141592653589793238462643383279502884197169399375105820974944592307816406286...")
	ElseIf DetectMsg("what is the airspeed velocity of an unladen swallow") Then
		Print("38.6243 KM/H [24 MPH]")
	ElseIf DetectMsg("you are too slow") Then
		Print("WHAT")
	ElseIf DetectMsg("Find") And DetectMsg("Random") And DetectMsg("Reddit user") Then
		RedditCheckLogin()
		$Function = "FindRandomReddit"
	ElseIf DetectMsg("what is") And DetectMsg("Asr Time") Then
		$Target = GetPrayerTime()[3]
		Print($Target)
	ElseIf DetectMsg("$DecToBinary ") Then
		$value = StringTrimLeft($Text,13)
		$value = DecToBinary($value)
		Print($value)
	ElseIf DetectMsg("$BinaryToDec ") Then
		$value = StringTrimLeft($Text,13)
		$value = StringTrimLeft($Text,13)
		$value = BinaryToDec($value)
		Print($value)
	ElseIf DetectMsg("$DecToHex ") Then
		$value = StringTrimLeft($Text,10)
		$value = Hex($value)
		Print($value)
	ElseIf DetectMsg("$HexToDec ") Then
		$value = StringTrimLeft($Text,10)
		$value = Dec($value)
		Print($value)
	ElseIf DetectMsg("$BinaryToHex ") Then
		$value = StringTrimLeft($Text,13)
		$value = BinaryToHex($value)
		Print($value)
	ElseIf DetectMsg("$HexToBinary ") Then
		$value = StringTrimLeft($Text,13)
		$value = HexToBinary($value)
		Print($value)
	ElseIf DetectMsg("Open my Browser") Then
		ShellExecute("http://www.Google.com")
	ElseIf DetectMsg("I Live In ") Then
		$country = StringTrimLeft($Text,10)
		SaveCountry($country)
		$Country = $country
	ElseIf DetectMsg("My Country Is ") Then
		$country = StringTrimLeft($Text,14)
		SaveCountry($country)
		$Country = $country
	ElseIf ExactMsg("why") or ExactMsg("why ?") Then
		Print("I Have no Idea bro")
		sleep($Hold)
		Print("what do you mean by 'Why'")
	ElseIf DetectMsg("Open Wikipedia") Then
		$website = "http://www.Wikipedia.org"
		CreateWeb()
	ElseIf DetectMsg("Search") And DetectMsg("on Wikipedia") Then
		$subject = "WikipediaSearch"
		Print("what you want to search mate")
	ElseIf DetectMsg("you are") And DetectMsg("Advanced") Then
		Print("You are kind man")
	ElseIf DetectMsg("How to") And DetectMsg("you") And DetectMsg("remind me") Then
		Print("use the -Remind Command")
		sleep($Hold)
		Print("and then Type the Text after that Command")
	ElseIf DetectMsg("what to do") Then
		;Print("GML/C++/C/Python/AU3/HTML/CSS/JS/PHP/C#/3D/Draw")
	ElseIf DetectMsg("what") And DetectMsg("URL") And DetectMsg("currently") Then
		CurrentURL()
	ElseIf DetectMsg("What") And DetectMsg("Time") And DetectMsg("Is It") Then
		GetTime()
	ElseIf DetectMsg("can you") and DetectMsg("tell me the Time") Then
		GetTime()
	ElseIf DetectMsg("what") And DetectMsg("the Date") Then
		GetDate()
	ElseIf DetectMsg("are you") And DetectMsg("Stright") Then
		$number = Random(0,1,1)
		Switch $number
			Case 0
				Print("Yes")
			Case 1
				Print("of course")
			Case 2
				Print("Yes Stright")
			Case 3
				Print("Stright as a Ruler")
		EndSwitch
	ElseIf DetectMsg("Login") And DetectMsg("to Reddit") Then
		Print("whats your Reddit username")
		$subject = "RedditGetUsername"
	ElseIf DetectMsg("$Wiki ") Then
		WikiSearch()
	ElseIf DetectMsg("Search") And DetectMsg("on Google") Then
		$subject = "GoogleSearch"
		Print("what you want to search mate")
	ElseIf DetectMsg("open") And DetectMsg("Skype") Then
		OpenProgram("Skype")
	ElseIf DetectMsg("what") And DetectMsg("your name") Then
		Print("my name is " & $name & " :)")
	ElseIf DetectMsg("who") And DetectMsg("created you") Then
		Print("Imperial")
		$subject = "Imperial"
	Elseif ExactMsg("me") And $subject = "LoveAsking" Then
		Print("Yes ofcourse I Love you...no homo")
	ElseIf ExactMsg("Do you Love") Then
		Print("do you Love who ?")
		$subject = "LoveAsking"
	ElseIf DetectMsg("speak with me") Then
		Print("What I should say")
	ElseIf DetectMsg("why") And DetectMsg("youtube") And DetectMsg("Recommendation") And DetectMsg("weird") Then
		Print("That's what of the most people are watching on your Region mate")
	ElseIf DetectMsg("how old are you") And $subject = "BotAge" Then
		Print("I Told you few moments ago")
	ElseIf DetectMsg("how old are you") Then
		Print("few moments ago")
		$subject = "BotAge"
	ElseIf DetectMsg($name) Then
		$number = Random(0,4,1)
		Switch $number
			Case 0
				Print("Yes")
			Case 1
				Print("Yes...want to tell me a secret ? C:")
			Case 2
				Print("Yes my dear :)")
			Case 3
				Print("Yes my Brother")
			Case 4
				Print("Yes whats up")
		EndSwitch
	ElseIf DetectMsg("Why you don't response") Then
		$number = Random(0,1,1)
		Switch $number
			Case 0
				Print("Maybe there's an Error")
			Case 1
				Print("I don't know I'm trying...")
		EndSwitch
	ElseIf DetectMsg("Are you there") Then
		$number = Random(0,1,1)
		Switch $number
			Case 0
				Print("Yes")
			Case 1
				Print("Yes I'm Here")
		EndSwitch
	ElseIf DetectMsg("Browse To Google") or DetectMsg("Open Google") Then
		Print("Yes sure man")
		$website = "http://www.Google.com"
		CreateWeb()
		TrayTip($name,"There you go mate :)",3,1)
	ElseIf DetectMsg("Browse") And DetectMsg("Youtube") or DetectMsg("Open Youtube") Then
		$website = "http://www.Youtube.com"
		CreateWeb()
		TrayTip($name,"There you go mate :)",3,1)
	ElseIf DetectMsg("Imperial") And $subject = "ContactWho" Then
		Print("http://www.Discord.me/Imperial")
	ElseIf DetectMsg("how") And DetectMsg("contact him") Then
		$subject = "ContactWho"
		$number = Random(0,1,1)
		Switch $number
			Case 0
				Print("who")
			Case 1
				Print("contact who ?")
		EndSwitch
	ElseIf ExactMsg("$Date") Then
		GetDate()
	ElseIf DetectMsg("how") And DetectMsg("contact him") And $subject = "Imperial" Then
		Print("you can contact here http://www.Discord.me/Imperial")
	ElseIf ExactMsg("$NetworkStatus") Then
		NetworkStatus()
	ElseIf ExactMsg("$Clean") Then
		$ChatBoxscroll = 0
		_GUICtrlRichEdit_SetText($Chatbox,"")
	ElseIf ExactMsg("shutdown") or ExactMsg("$shutdown") Then
		TrayTip($name,"shutting down...",3,1)
		EndProgram()
	EndIf
EndFunc

Func Print($string)
	_GUICtrlRichEdit_SetCharColor($Chatbox,0xFFFFFF)
	_GUICtrlRichEdit_SetFont($Chatbox,16,"Calibri")
	_GUICtrlRichEdit_InsertText($Chatbox,$name & ": " & $string)
	_GUICtrlRichEdit_InsertText($Chatbox,@CRLF)
EndFunc

Func PrintMessage()
	$Text = GUICtrlRead($Input)
	_GUICtrlRichEdit_SetCharColor($Chatbox,0xFFFFFF)
	_GUICtrlRichEdit_SetFont($Chatbox,16,"Calibri")
	_GUICtrlRichEdit_InsertText($Chatbox,"You: " & GUICtrlRead($Input))
	_GUICtrlRichEdit_InsertText($Chatbox,@CRLF)
EndFunc

Func PrintLog($string)
	Local $LogFile = FileOpen(@DesktopDir & "\Log.txt")
	FileWrite($LogFile,$string)
	FileClose($LogFile)
EndFunc

Func DetectMsg($string)
	return StringInStr(StringLower($Text),StringLower($string))
EndFunc

Func DetectString($string,$str)
	return StringInStr($string,$str)
EndFunc

Func ExactMsg($string)
	return $Text = $string
EndFunc

Func StringExists($string)
	return StringInStr(GUICtrlRead($Chatbox),$string)
EndFunc

Func TrayEvent()
	GUISetState(@SW_Show)
EndFunc

Func DetectAudio($string)
	Print($string)
	;ElseIf DetectString($string,"") Then
	Local $dir = @ScriptDir & "/Audio/"
	If DetectString($string,"Hello") Then
		Local $number = random(0,4,1)
		Switch $number
			Case 0
				SoundPlay($dir & "Hello_sir.mp3")
			Case 1
				SoundPlay($dir & "Hello_there.mp3")
			Case 2
				SoundPlay($dir & "Hello_buddy.mp3")
			Case 3
				SoundPlay($dir & "Hello_my_friend.mp3")
			Case 4
				SoundPlay($dir & "Hello_my_brother.mp3")
		EndSwitch
	ElseIf DetectString($string,"How are you") Then
		$subject = "status"
		Local $number = random(0,1,1)
		Switch $number
			Case 0
				SoundPlay($dir & "I'm Good.mp3")
			Case 1
				SoundPlay($dir & "I'm Fine.mp3")
		EndSwitch
	ElseIf DetectString($string,"How are you doing") Then
		$subject = "status"
		Local $number = random(0,1,1)
		Switch $number
			Case 0
				SoundPlay($dir & "doing_good.mp3")
			Case 1
				SoundPlay($dir & "I'm Fine.mp3")
		EndSwitch
	ElseIf DetectString($string,"I'm Good") or DetectString($string,"I'm Great") Then
		If $subject <> "status" Then return
		Local $number = random(0,3,1)
		Switch $number
			Case 0
				SoundPlay($dir & "Good.mp3")
			Case 1
				SoundPlay($dir & "Amazing.mp3")
			Case 2
				SoundPlay($dir & "Wonderful.mp3")
			Case 3 
				SoundPlay($dir & "Fantastic.mp3")
		EndSwitch
		$subject = ""
	ElseIf DetectString($string,"Do you Love me") Then
		Local $number = random(0,1,1)
		Switch $number
			Case 0
				SoundPlay($dir & "Love1.mp3")
			Case 1
				SoundPlay($dir & "Yes_ofcourse.mp3")
		EndSwitch
	ElseIf DetectString($string,"What Is your name") Then
		SoundPlay($dir & "my_name.mp3")
	ElseIf DetectString($string,"How old are you") Then
		SoundPlay($dir & "few_moments_ago.mp3")
		If Spawn(5) Then
			SoundPlay($dir & "Laugh.mp3")
		EndIf
	ElseIf DetectString($string,"can you Hear me") Then
		Local $number = random(0,1,1)
		Switch $number
			Case 0
				SoundPlay($dir & "I can hear you.mp3")
			Case 1
				SoundPlay($dir & "Clearly.mp3")
		EndSwitch
	ElseIf DetectString($string,"check Network Connection") or DetectString($string,"check the Internet Connection") Then
		$connect = GetNetworkConnection()
		If $connect Then
			Local $number = random(0,1,1)
			Switch $number
				Case 0
					SoundPlay($dir & "working_Connection.mp3")
				Case 1
					SoundPlay($dir & "Internet_connection_working_correctly.mp3")
			EndSwitch
		Else
			Switch $number
				Case 0
					SoundPlay($dir & "connection_not_working.mp3")
				Case 1
					SoundPlay($dir & "No Correlation.mp3")
			EndSwitch
		EndIf
	ElseIf DetectString($string,"What Time Is It") Then
		If $Country <> "" Then
			$Time = GetCountryTime()
			Print($Time)
		Else
			$Time = @HOUR & ":" & @MIN
			Print($Time)
		EndIf
	ElseIf DetectString($string,"Impz") Then
		Local $number = random(0,2,1)
		Switch $number
			Case 0
				SoundPlay($dir & "Im_ready.mp3")
			Case 1
				SoundPlay($dir & "Yes.mp3")
			Case 2
				SoundPlay($dir & "Yes_sir.mp3")
		EndSwitch
	ElseIf DetectString($string,"Minimize") Then
		GuiSetState(@SW_HIDE)
        TraySetState(1)
        TraySetToolTip("Impz")
	ElseIf DetectString($string,"Maximize") Then
		GUISetState(@SW_SHOW)
	ElseIf DetectString($string,"whats the Current Window Handle") Then
		$Target = WinGetHandle("[active]")
		Print("HWND = " & $Target)
		TrayTip($name,$Target,3)
	ElseIf DetectString($string,"Visit Imperial Games") Then
		ShellExecute("http://www.ImperialGames.tk")
	ElseIf DetectString($string,"Open Google") Then
		ShellExecute("http://www.Google.com")
	ElseIf DetectString($string,"Open Youtube") Then
		ShellExecute("http://www.Youtube.com")
	ElseIf DetectString($string,"Open Gmail") Then
		ShellExecute("http://www.Gmail.com")
	ElseIf DetectString($string,"Open Translator") Then
		ShellExecute("http://translate.Google.com")
	ElseIf DetectString($string,"Open Drive") Then
		ShellExecute("http://Drive.Google.com")
	ElseIf DetectString($string,"Open Bing") Then
		ShellExecute("http://www.Bing.com")
	ElseIf DetectString($string,"Open Rosetta Stone") Then
		Run("C:\Program Files (x86)\Rosetta Stone\Rosetta Stone 4 TOTALe\Rosetta Stone.exe")
	ElseIf DetectString($string,"Clear") Then
		$ChatBoxscroll = 0
		GUICtrlSetData($Chatbox,"")
		GUICtrlSetStyle($Chatbox,BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$ES_READONLY))
	ElseIf DetectString($string,"shutdown") Then
		EndProgram()
	EndIf
EndFunc

Func OpenProgram($program)
	If Run($program) <> 0 Then
		WinWaitActive($program)
		WinActivate($program)
		TrayTip($name,"There you go mate :)",3,1)
	Else
		Print("sorry man, I couldn't find the File/Program you requested")
	EndIf
EndFunc

Func OpenTarget($Target)
	$app = IniReadSection($Location & "Impz.ini","Programs")
	For $I = 1 To $app[0][0]
		If $app[$I][0] = $Target Then
			Run($app[$I][1])
			ExitLoop
		EndIf
	Next
EndFunc

Func GetNetworkConnection()
    Local Const $NETWORK_ALIVE_LAN = 0x1  ;net card connection
    Local Const $NETWORK_ALIVE_WAN = 0x2  ;RAS (internet) connection
    Local Const $NETWORK_ALIVE_AOL = 0x4  ;AOL
    
    Local $aRet, $iResult
    
    $aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)
    
    If BitAND($aRet[1], $NETWORK_ALIVE_LAN) Then $iResult &= "LAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_WAN) Then $iResult &= "WAN connected" & @LF
    If BitAND($aRet[1], $NETWORK_ALIVE_AOL) Then $iResult &= "AOL connected" & @LF
    
    Return $iResult
EndFunc

Func HttpGet($sURL,$sData = "")
	Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

	$oHTTP.Open("GET", $sURL & "?" & $sData, False)
	If (@error) Then Return SetError(1, 0, 0)

	$oHTTP.Send()
	If (@error) Then Return SetError(2, 0, 0)

	If ($oHTTP.Status <> $HTTP_STATUS_OK) Then Return SetError(3, 0, 0)

	Return SetError(0, 0, $oHTTP.ResponseText)
EndFunc

Func HttpPost($sURL, $sData = "")
	Local $oHTTP = ObjCreate("WinHttp.WinHttpRequest.5.1")

	$oHTTP.Open("POST", $sURL, False)
	If (@error) Then Return SetError(1, 0, 0)

	$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

	$oHTTP.Send($sData)
	If (@error) Then Return SetError(2, 0, 0)

	If ($oHTTP.Status <> 200) Then Return SetError(3, 0, 0)

	return SetError(0, 0, $oHTTP.ResponseText)
EndFunc

Func GoogleSearch()
	Local $oForm = _IEFormGetCollection($oIE,0)
	Local $oQuery = _IEFormElementGetCollection($oForm,4)
	_IEFormElementSetValue($oQuery,$Text)
	_IEFormSubmit($oForm)
EndFunc

Func FunSuggestion()
	Print("Well, there's alot of ways to have Fun")
	Sleep($Hold)
	Print("you can watch Youtube videos or Play Video Games or Read Comics :)")
	Sleep($Hold)
	Print("or watch SpongeBob")
EndFunc

Func CreateWeb()
	$oIE = _IECreate($website)
	$HWND = _IEPropertyGet($oIE,"hwnd")
	WinSetState($HWND,"",@SW_MAXIMIZE)
	_IELoadWait($oIE)
EndFunc

Func SetPageInfo()
	Local $user = _IEGetObjByName($oIE,"user")
	Local $pass = _IEGetObjByName($oIE,"passwd")
	_IEFormElementSetValue($user,GUICtrlRead($username))
	_IEFormElementSetValue($pass,GUICtrlRead($password))
	$tags = $oIE.document.GetElementsByTagName("button")
	sleep(500)
	For $tag in $tags
		$class_value = $tag.GetAttribute("class")
		If $class_value = "btn" Then
			$tag.click()
		EndIf
	Next
EndFunc

Func RunProgram()
	$Target = StringTrimLeft($Text,5)
	If Run($Target) <> 0 Then
		TrayTip($name,"There you go mate :)",3,1)
	Else
		Print("Sorry mate, I couldn't Find the File/Program you requested :(")
	EndIf
EndFunc

Func RandomFact()
	$number = Random(0,31,1)
	Switch $number
		Case 0
			Print("Syngenesophobia is the fear of relatives")
		Case 1
			Print("In 2015, engineering students in China worked out how to control live cockroaches using a brain-to-brain interface technique")
		Case 2
			Print("Disney owns 80% of ESPN")
		Case 3
			Print("The first movie in color was made already in 1901")
		Case 4
			Print("In zero gravity, a candle's flame is round and blue")
		Case 5
			Print("A group of frogs is called an army")
		Case 6
			Print("The most Eastern and Western and Northern state in the U.S. is Alaska")
		Case 7
			Print("All humans are 99.9% identical in their DNA")
		Case 8
			Print("On July 23, 2012, the Earth had a near miss with a solar flare, Had it occurred a week earlier, it would've wiped out communication networks, GPS and electrical grids")
		Case 9
			Print("Recycling a single run of the Sunday New York Times would save 75,000 trees")
		Case 10
			Print("The average time it takes for a new habit to stick is 66 days")
		Case 11
			Print("Xenoglossophobia is the fear of foreign languages")
		Case 12
			Print("Pandas are considered to be endangered, with about 1,600 in the wild and another few hundred in captivity")
		Case 13
			Print("About a quarter of all residential energy consumption is used on devices in idle power mode")
		Case 14
			Print("The saliva of a chameleon is 400 times more sticky than human saliva")
		Case 15
			Print("It takes about 37 gallons (140 liters) of water to grow the coffee beans and process them to make one cup of coffee")
		Case 16
			Print("It's impossible to burp in space")
		Case 17
			Print("my name is " & $name & " :)")
		Case 18
			Print("There are more life forms living on your skin than there are people on the planet")
		Case 19
			Print("In an average lifetime human skin completely replaces itself 900 times")
		Case 20
			Print("The average person spends 3 months of its lifetime sitting on the toilet")
		Case 21
			Print("A steady stream of minor accomplishments makes you more satisfied with your life than a few major accomplishments")
		Case 22
			Print("In a lifetime, your brain's long-term memory can hold as many as 1 quadrillion (1 million billion) separate bits of information")
		Case 23
			Print("An average person spends 6 years of his life dreaming")
		Case 24
			Print("If Earth's history were condensed into 24 hours, life would've appeared at 4am, land plants at 10:24pm, dinosaur extinction at 11:41pm and human history would've begun at 11:58:43pm")
		Case 25
			Print("The average ocean depth is 4 KM [2.5 Miles]")
		Case 26
			Print("6 Billion KG [14 Billion Pounds] of garbage are dumped into the ocean every year, Most of it is plastic")
		Case 27
			Print("If we could capture just 0.1% of the ocean's kinetic energy caused by tides, we could satisfy the current global energy demand 5 times over")
		Case 28
			Print("75% of the world's active and dormant volcanoes are in the Ring of Fire, an area in the basin of the Pacific Ocean")
		Case 29
			Print("There's only one God")
		Case 30
			Print("The world's oceans contain nearly 20 million tons of gold")
		Case 31
			Print("Bibliophobia is the fear or hatred of books")
	EndSwitch
EndFunc

Func SpecificFacts()

EndFunc

Func BrowseWebsite($url)
	$website = $url
	CreateWeb()
EndFunc

Func FindWebsite($url)

EndFunc

Func RedditFindUser()

EndFunc

Func RedditFindRandomUser()
	RedditLogin()
	_IENavigate($oIE,"http://www.Reddit.com/r/all/comments")
EndFunc

Func RedditCheckLogin()
	Print("Are you Logged In ?")
	$subject = "RedditCheckLogin"
EndFunc

Func RedditLogin()
	$website = "http://www.Reddit.com"
	CreateWeb()
	$col = _IETagNameGetCollection($oIE,"input")
	$buttons = _IETagNameGetCollection($oIE,"button")
	sleep($Hold)
	For $Input In $col
		If $Input.name = "user" Then
			$Input.value = $username
		ElseIf $Input.name = "passwd" Then
			$Input.value = $password
		EndIf
	Next
	For $button In $buttons
		If $button.type = "submit" Then
			_IEAction($button,"click")
		EndIf
	Next
EndFunc

Func CurrentURL()
	If $oIE <> 0 Then
		Return _IEPropertyGet($oIE,"locationurl")
	Else
		Print("There's no Browser opened")
	EndIf
EndFunc

Func GetName()
	Local $name = IniRead($Location & "\Impz.ini","User","name","")
	If $name <> "" Then
		return $name
	Else
		return 0
	EndIf
EndFunc

Func SaveName()
	Local $user = StringTrimLeft($Text,11)
	IniWrite($Location & "Impz.ini","User","name",$user)
	Print("Nice to meet you " & $user & " :)")
EndFunc

Func GetCountry()
	$country = IniRead($Location & "Impz.ini","User","country",$Country)
	return $country
EndFunc

Func SaveCountry($name)
	IniWrite($Location & "Impz.ini","User","country",$name)
	Print("Location Saved as " & $name)
EndFunc

Func NetworkStatus()
	$connect = GetNetworkConnection()
	If $connect Then
		Print("Your Internet connection is working correctly")
	Else
		Print("It seems there's a problem with your Internet Connection")
	EndIf
EndFunc

Func GetWeather($country = $Country)
	$URL = InetGet($Location & "Weather.html","https://www.timeanddate.com/weather/" & $country)
	If not @error or $country <> "" Then
		$File = FileOpen($Location & "Weather.html")
		$Source = FileRead($File)
		$divs = _StringBetween($Source,'class=h2>','&nbsp;')
		If IsArray($divs) Then
			Print("Divs is not an Array")
		EndIf
	Else
		return "No Country/Location Available"
	EndIf
EndFunc

Func OperaRun()
	$Target = Run(@ProgramFilesDir & "\Opera\launcher.exe")
	If $Target = 0 Then
		return "Couldn't Find Opera :C"
	EndIf
	return $Target
EndFunc

Func Remind()
	Local $List = IniReadSection($Location & "Impz.ini","Remind")
	If not @error Then
		Local $num = $List[0][0]
		For $I = 0 To $num
			If $List[$I][0] <> "num" Then
				Print($List[$I][1])
			EndIf
		Next
	Else
		Print("You have no Remind List")
	EndIf
EndFunc

Func SaveReminder($source)
	$current = IniReadSection($Location & "Impz.ini","Remind")[0][0]
	IniWrite($Location & "Impz.ini","Remind","note" & String($current),String($current) & "$ " & $source)
	$current += 1;
	Print("Note Saved")
EndFunc

Func RemindRemove($number)
	Local $current = IniReadSection($Location & "Impz.ini","Remind")
	Local $size = $current[0][0]
	For $I = 1 To $size - 1 step 1 
		If StringInStr($current[$I][1],$number) Then
			IniDelete($Location & "Impz.ini","Remind",$current[$I][0])
			Print("Note Removed")
			ExitLoop
		EndIf
	Next
EndFunc

Func ClearRemind()
	IniDelete($Location & "Impz.ini","Remind")
	Print("Remind List Cleared")
EndFunc

Func YoutubeRun($videoCode)
	$website = "https://www.youtube.com/watch?v=" & $videoCode
	CreateWeb()
EndFunc

Func YoutubeDownload($videoCode,$HD = 1)
	$website = "http://youtubeinmp4.com/youtube.php?video=https://www.youtube.com/watch?v=" & $videoCode
	CreateWeb()
	_IELoadWait($oIE,$Hold)
	$button = _IEGetObjById($oIE,"downloadMP4")
	_IEAction($button,"click")
EndFunc

Func YoutubeSave($direct = 0)
	Local $num = IniRead($Location & "Impz.ini","Videos","num",0)
	Local $Temp = StringTrimLeft($Text,13)
	$videoCode = StringSplit($Temp," ",1)
	$Title = StringSplit($Temp," ",1)
	If $direct = 0 Then
		If @error <> 1 Then
			IniWrite($Location & "Impz.ini","Videos","num" & String($num),$Title[2] & ": " & $videoCode[1])
		Else
			IniWrite($Location & "Impz.ini","Videos","num" & String($num),$videoCode[1])
		EndIf
		$num += 1
		IniWrite($Location & "Impz.ini","Videos","num",$num)
	ElseIf $direct = 1 Then
		IniWrite($Location & "Impz.ini","Videos","num" & String($num),$Text)
		$num += 1
		IniWrite($Location & "Impz.ini","Videos","num",$num)
	EndIf
	Print("Video Saved")
EndFunc

Func YoutubeLoad()
	Local $List = IniReadSection($Location & "Impz.ini","Videos")
	If Not @error Then
		Local $num = $List[0][0]
		For $I = 0 To $num
			If $List[$I][0] <> "num" Then
				Print($List[$I][1])
			EndIf
		Next
	Else
		Print("You have you no saved youtube videos")
	EndIf
EndFunc

Func YoutubeClear()
	IniDelete($Location & "Impz.ini","Videos")
	IniWrite($Location & "Impz.ini","Videos","num",0)
	Print("Youtube saves Cleared")
EndFunc

Func GetYoutubeList($URL)
	$Source = BinaryToString(InetRead($URL,1))
	$Divs = _StringBetween($Source,'data-title="','"')
	For $current In $Divs
		Print($current)
	Next
EndFunc

Func SaveYoutubeList($Title,$URL)
	$num = IniRead($Location & "Impz.ini","YTL-" & $Title,"num",1)
	$Source = BinaryToString(InetRead($URL,1))
	$Divs = _StringBetween($Source,'data-title="','"')
	For $current In $Divs
		IniWrite($Location & "Impz.ini","YTL-" & $Title,"video" & $num,$current)
		$num += 1
	Next
	IniWrite($Location & "Impz.ini","YTL-" & $Title,"num",$num)
	Print("Youtube List Saved")
EndFunc

Func LoadYoutubeList($Title)
	$List = IniReadSection($Location & "Impz.ini","YoutubeList")
	$num = $List[0][0]
	For $I = 0 To $num
		If $List[$I][0] <> "num" Then
			Print($List[$I][1])
		EndIf
	Next
EndFunc

Func ClearYoutubeList($Title)
	If StringInStr($Title,"YTL-") Then
		IniDelete($Location & "Impz.ini","YTL-" & $Title)
	EndIf
EndFunc

Func DownloadVideo($url)
	$Source = InetGet("http://keepvid.com/?url=" & $url,$Location & "Keepvid.html")
	If FileExists($Location & "Keepvid.html") Then
		Print("The HTML File has been Downloaded")
		$Source = FileRead($Location & "Keepvid.html")
		$Divs = _StringBetween($Source,'<a','</a>')
		If $Divs > 0 Then
			Print("String(s) has been Found")
		EndIf
		FileClose($Source)
	Else
		Print("Unable to Find the HTML File")
	EndIf
	InetClose($Source)
EndFunc

Func DecToBinary($value)
	Local $i, $sBinChar = ""
	If StringRegExp($value,'[[:digit:]]') Then
		$i = 1

		Do
			$x = 16 ^ $i
			$i +=1
		Until $value < $x

		For $n = 4 * ($i-1) To 1 step -1
		If BitAND(2 ^ ($n-1),$value) Then
			$sBinChar &= "1"
		Else
			$sBinChar &= "0"
		EndIf
		Next
		return $sBinChar
	Else
		Print("Error Wrong input, try again ...")
		return
	EndIf
EndFunc

Func BinaryToDec($value)
	Local $Return
	Local $lngResult
	Local $intIndex

	If StringRegExp($value,'[0-1]') Then
		$lngResult = 0
		For $intIndex = StringLen($value) to 1 step -1
			$strDigit = StringMid($value, $intIndex, 1)
			Select
				case $strDigit = "0"
				case $strDigit = "1"
				$lngResult = $lngResult + (2 ^ (StringLen($value)-$intIndex))
				case Else
				$lngResult = 0
				$intIndex = 0
			EndSelect
		Next

		$Return = $lngResult
		return $Return
	Else
		Print("Error Wrong input, try again ...")
    return
	EndIf
EndFunc

Func HexToBinary($HexValue)
	Local $Allowed = '0123456789ABCDEF'
	Local $Test,$n
	Local $Result = ''
	If $hexValue = '' then
		SetError(-2)
		return
	EndIf

	$hexvalue = StringSplit($hexvalue,'')
	For $n = 1 to $hexValue[0]
		If not StringInStr($Allowed,$hexvalue[$n]) Then
			SetError(-1)
			return 0
		EndIf
	Next

	Local $bits = "0000|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|1101|1110|1111"
	$bits = stringsplit($bits,'|')
	For $n = 1 to $hexvalue[0]
		$Result &= $bits[Dec($hexvalue[$n])+1]
	Next

	return $Result
EndFunc

Func BinaryToHex($BinaryValue)
	Local $test, $Result = '',$numbytes,$nb

	If StringRegExp($BinaryValue,'[0-1]') then
		If $BinaryValue = '' Then
			SetError(-2)
			return
		EndIf

		Local $bits = "0000|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|1101|1110|1111"
		$bits = stringsplit($bits,'|')
		#region check string is binary

		$test = stringreplace($BinaryValue,'1','')
		$test = stringreplace($test,'0','')
		If $test <> '' Then
			SetError(-1);non binary character detected
			return
		endif
		#endregion check string is binary

		#region make binary string an integral multiple of 4 characters
		While 1
			$nb = Mod(StringLen($BinaryValue),4)
			If $nb = 0 then Exitloop
			$BinaryValue = '0' & $BinaryValue
		WEnd
		#endregion make binary string an integral multiple of 4 characters

		$numbytes = Int(StringLen($BinaryValue)/4);the number of bytes

		Dim $bytes[$numbytes],$Deci[$numbytes]
		For $j = 0 to $numbytes - 1;for each byte
			$bytes[$j] = StringMid($BinaryValue,1+4*$j,4)

			For $k = 0 to 15
				If $bytes[$j] = $bits[$k+1] Then
					$Deci[$j] = $k
					ExitLoop
				EndIf
			Next
		Next

		$Result = ''
		For $l = 0 to $numbytes - 1
			$Result &= Hex($Deci[$l],1)
		Next
		return $Result
	Else
		Print("Error Wrong input, try again ...")
		Return
	EndIf
EndFunc

Func Spawn($num)
	$value = Random(0,$num,1)
	If $value > 0 Then
		return False
	Else
		return True
	EndIf
EndFunc

Func GetDate()
	Local $currentDate = @MDAY & "/" & @MON & "/" & @YEAR
	Print($currentDate)
EndFunc

Func GetTime()
	Local $Time = _NowTime()
	Print($Time)
EndFunc

Func GetPrayerTime()
	If $Country <> "" Then
		$URL = InetRead("https://www.islamicfinder.org/world/" & $Country)
		If not @error Then
			$Source = BinaryToString($URL)
			$Divs = _StringBetween($Source,'<td','</td>')
			Local $prayer_time[7]
			$prayer_time[0] = StringReplace($Divs[16],'>','')
			$prayer_time[1] = StringReplace($Divs[10],' class="">','')
			$prayer_time[2] = StringReplace($Divs[17],'>','')
			$prayer_time[3] = StringReplace($Divs[18],' class="active">','')
			$prayer_time[4] = StringReplace($Divs[19],'>','')
			$prayer_time[5] = StringReplace($Divs[20],'>','')
			return $prayer_time
		Else
			Print("No Correlation")
		EndIf
	Else
		Print("Unknown Country/Location")
		return 0
	EndIf
EndFunc

Func GetPrayerHour($prayer,$format = 0)
	$Time = GetPrayerTime()[$prayer]
	$Hour = StringSplit($Time,":",1)
	If $format = 0 Then
		return ConvertHour(Number($Hour[1]))
	ElseIf $format = 1 Then
		return Number($Hour[2])
	EndIf
EndFunc

Func SetPrayerTargetTime()
	If $Religion = "Islam" And $Country <> "" Then
		If DayPeriod() = "AM" And ConvertHour(@HOUR) <= GetPrayerHour(0) Then
			$CurrentPrayerName = "Fajr"
			$TargetHour = GetPrayerHour(0)
			$TargetMinute = GetPrayerHour(0,1)
		ElseIf DayPeriod() = "AM" And ConvertHour(@HOUR) <= GetPrayerHour(2) Then
			$CurrentPrayerName = "Duhr"
			$TargetHour = GetPrayerHour(2)
			$TargetMinute = GetPrayerHour(2,1)
		ElseIf DayPeriod() = "PM" And ConvertHour(@HOUR) <= GetPrayerHour(3) Then
			$CurrentPrayerName = "Asr"
			$TargetHour = GetPrayerHour(3)
			$TargetMinute = GetPrayerHour(3,1)
		ElseIf DayPeriod() = "PM" And ConvertHour(@HOUR) <= GetPrayerHour(4) Then
			$CurrentPrayerName = "Maghrib"
			$TargetHour = GetPrayerHour(4)
			$TargetMinute = GetPrayerHour(4,1)
		ElseIf DayPeriod() = "PM" And ConvertHour(@HOUR) <= GetPrayerHour(5) Then
			$CurrentPrayerName = "Isha"
			$TargetHour = GetPrayerHour(5)
			$TargetMinute = GetPrayerHour(5,1)
		Else
			$TargetHour = 0
			$TargetMinute = 0
		EndIf
	EndIf
EndFunc

Func DayPeriod()
	If @HOUR >= 0 And @HOUR <= 12 Then
		return "AM"
	ElseIf @HOUR > 12 And @HOUR <= 23 Then
		return "PM"
	EndIf
EndFunc

Func GetCountryTime()
	If $Country <> "" Then
		$Source = BinaryToString(InetRead("https://www.timeanddate.com/worldclock/" & $country,1))
		$divs = _StringBetween($Source,'<div>','</div>')
		$Time = _StringBetween($divs[0],"h1>","</")
		return $Time[0]
	Else
		Print("Unknown Country/Location")
	EndIf
EndFunc

Func DisplayPrayerTimes()
	$prayer1 = GetPrayerTime()[0]
	$sunrise = GetPrayerTime()[1]
	$prayer2 = GetPrayerTime()[2]
	$prayer3 = GetPrayerTime()[3]
	$prayer4 = GetPrayerTime()[4]
	$prayer5 = GetPrayerTime()[5]
	Print("Fajr: " & $prayer1)
	Print("Sunrise: " & $sunrise)
	Print("Duhr: " & $prayer2)
	Print("Asr: " & $prayer3)
	Print("Maghrib: " & $prayer4)
	Print("Isha: " & $prayer5)
EndFunc

Func GetCountryHour($format = 0)
	$Time = GetCountryTime()
	$Hour = StringSplit($Time,":",1)
	If $format = 0 Then
		$Hour[1] = ConvertHour(Number($Hour[1]))
		return $Hour[1]
	ElseIf $format = 1 Then
		return Number($Hour[2])
	EndIf
EndFunc

Func GetHour($string,$format = 0)
	$Hour = StringSplit($string,":",1)
	If $format = 0 Then
		return $Hour[1]
	ElseIf $format = 1 Then
		return $Hour[2]
	EndIf
EndFunc

Func ValidTime()
	If $Country <> "" Then
		$current = GetCountryTime()
		$SystemTime = @HOUR & ":" & @MIN
		If $current = $SystemTime Then
			return 1
		Else
			return 0
		EndIf
	Else
		return 3
	EndIf
EndFunc

Func ConvertHour($Hour)
	If $Hour = 13 Then
		return 1
	ElseIf $Hour = 14 Then
		return 2
	ElseIf $Hour = 15 Then
		return 3
	ElseIf $Hour = 16 Then
		return 4
	ElseIf $Hour = 17 Then
		return 5
	ElseIf $Hour = 18 Then
		return 6
	ElseIf $Hour = 19 Then
		return 7
	ElseIf $Hour = 20 Then
		return 8
	ElseIf $Hour = 21 Then
		return 9
	ElseIf $Hour = 22 Then
		return 10
	ElseIf $Hour = 23 Then
		return 11
	Else
		return $Hour
	EndIf
EndFunc

Func GetTimeZone($zone)
	$URL = InetRead("https://www.timeanddate.com/time/zones/" & $zone)
	If not @error Then
		$Source = BinaryToString($URL)
		$Divs = _StringBetween($Source,'class="ctm-hrmn">','<')
		$Divs1 = _StringBetween($Source,'class="ctm-sec">','<')
		$Time = $Divs[0]
		$seconds = $Divs1[0]
		Print($Time & ":" & $seconds)
	ElseIf
		Print("No Correlation")
	EndIf
EndFunc

Func K2C(ByRef $temp)
    $temp = ($temp - 32) * (5/9)
    $temp = Round($temp, 2)
    Return $temp
EndFunc

Func TimeMixer($target)
	If not @error Then
		$numbers = StringSplit($Target," ",1)
		$Hours0 = Number(StringSplit($numbers[1],":",1)[1])
		$Mins0 = Number(StringSplit($numbers[1],":",1)[2])

		$Hours1 = Number(StringSplit($numbers[2],":",1)[1])
		$Mins1 = Number(StringSplit($numbers[2],":",1)[2])
	Else
		Print("Invalid Syntax")
		return
	EndIf

	$Days = 0
	$Hours = 0
	$Minutes = 0

	If not @error Then
		$Hours = $Hours0 + $Hours1
		$Minutes = $Mins0 + $Mins1
		If $Minutes >= 60 Then
			Do
				$Minutes -= 60
				$Hours += 1
			Until $Minutes < 60
		EndIf
		If $Hours >= 24 Then
			Do
				$Hours -= 24
				$Days += 1
			Until $Hours < 24
		EndIf
		If $Days < 1 Then
			Print($Hours & ":" & $Minutes)
		Else
			Print($Days & " Days and " & $Hours & " Hours and " & $Minutes & " Minutes")
		EndIf
	Else
		Print("No Correlation")
	EndIf
EndFunc

Func WikiSearch()
	$Target = StringTrimLeft($Text,6)
	$website = "http://www.Wikipedia.org/wiki/" & $Target
	ShellExecute($website)
EndFunc

Func CreateTextFile($Filename)
	Local $File = FileOpen(@DesktopDir & "\" & $Filename & ".txt",1)
	return $File
EndFunc

Func CreateWord()
	Local $Word = _Word_Create()
	If $Word <> 0 Then
		TrayTip($name,"Opening Word",3,1)
		return $Word
	Else
		return "Sorry, I couldn't Find the Word software :C"
	EndIf
EndFunc

Func GenerateGameMechanism()
	Local $Category = GenerateGenreName()
	Local $Character = GenerateGameCharacter()
	Local $Objective = GenerateGameObjective()
	Print($Category & " Game")
	Print("Where you play as a " & $Character)
	Print("And the Objective is to " & $Objective)
EndFunc

Func GenerateGameCharacter()
	Local $number = random(0,13,1)
	Switch $number
		Case 0
			return "Wumpus"
		Case 1
			return "Discord"
		Case 2
			return "Horse"
		Case 3
			return "Deer"
		Case 4
			return "Tiger"
		Case 5
			return "Elephant"
		Case 6
			return "Bug"
		Case 7
			return "Bee"
		Case 8
			return "Teddy Bear"
		Case 9
			return "Giraffe"
		Case 10
			return "Fish"
		Case 11
			return "Shark"
		Case 12
			return "Cat"
		Case 13
			return "Sheep"
	EndSwitch
EndFunc

Func GenerateGameObjective()
	Local $number = random(0,23,1)
	Switch $number
		Case 0
			return "Save another Character"
		Case 1
			return "Save another Group"
		Case 2
			return "Defend your Land/Home/Empire"
		Case 3
			return "Defend another Character"
		Case 4
			return "Defend another Group"
		Case 5
			return "Defend other Land/Home/Empire"
		Case 6
			return "Find all Coins"
		Case 7
			return "Find Treasures"
		Case 8
			return "Avoid Obstacles"
		Case 9
			return "Fix Enviroment/Object"
		Case 10
			return "Find All Treasures"
		Case 11
			return "Modify Object"
		Case 12
			return "Control Multiple Objects/Characters"
		Case 13
			return "Conquer other Empires"
		Case 14
			return "Create Resources"
		Case 15
			return "Search For/Find Object(s)"
		Case 16
			return "Explore Dungeons"
		Case 17
			return "Customize Objects"
		Case 18
			return "Make Peace with other Character/Empires"
		Case 19
			return "Brak Down the Laws of Physics"
		Case 20
			return "Start Wars with other Characters/Empries"
		Case 21
			return "Throw Objects using Physics"
		Case 22
			return "Chase other Characters"
		Case 23
			return "Conquer whole Game world"
	EndSwitch
EndFunc

Func GenerateGameGenre()
	Local $number = random(0,8,1)
	Switch $number
		Case 0
			return "Action"
		Case 1
			return "Action-Adventure"
		Case 2
			return "Adventure"
		Case 3
			return "Role-Playing"
		Case 4
			return "Simulation"
		Case 5
			return "Strategy"
		Case 6
			return "Sports"
		Case 7
			return "Special"
		Case 8
			return "Other"
	EndSwitch
EndFunc

Func GenerateGameCategory($genre = "")
	If $genre == "" Then
		$genre = GenerateGameGenre()
	EndIf

	Local $number = random(0,1,1)
	Switch $genre
		Case "Action"
			Local $num = random(0,6,1)
			Switch $num
				Case 0
					return "Platformer"
				Case 1
					return "Shooter"
				Case 2
					return "First Person Shooter"
				Case 3
					return "Third Person Shooter"
				Case 4
					return "Beat Em Up"
				Case 5
					return "Stealth"
				Case 6
					return "Survival"
			EndSwitch
		Case "Action-Adventure"
			Local $num = random(0,1,1)
			Switch $num
				Case 0
					return "Survival Horror"
				Case 1
					return "Metroidvania"
			EndSwitch
		Case "Adventure"
			Local $num = random(0,4,1)
			Switch $num
				Case 0
					return "Text Adventure"
				Case 1
					return "Graphic Adventure"
				Case 2
					return "Visual Novels"
				Case 3
					return "Interactive Movie"
				Case 4
					return "Real-Time 3D Adventures"
			EndSwitch
		Case "Role-Playing"
			Local $num = random(0,7,1)
			Switch $num
				Case 0
					return "Action-RPG"
				Case 1
					return "MMORPG"
				Case 2
					return "Rouge-Like"
				Case 3
					return "Tactical RPG"
				Case 3
					return "Sandbox RPG"
				Case 4
					return "First-person party-based RPG"
				Case 5
					return "Cultural Differences"
				Case 6
					return "Choices"
				Case 7
					return "Fantasy"
			EndSwitch
		Case "Simulation"
			Local $num = random(0,2,1)
			Switch $num
				Case 0
					return "Construction and Management Simulation"
				Case 1
					return "Life Simulation"
				Case 2
					return "Vehicle Simulation"
			EndSwitch
		Case "Strategy"
			Local $num = random(0,9,1)
			Switch $num
				Case 0
					return "4X"
				Case 1
					return "Artillery"
				Case 2
					return "Real-Time Strategy"
				Case 3
					return "Real-Time Tactics"
				Case 4
					return "MOBA"
				Case 5
					return "Tower Defense"
				Case 6
					return "Turn-Based Strategy"
				Case 7
					return "Turn-Based Tactics"
				Case 8
					return "War"
				Case 9
					return "Grand Strategy War"
			EndSwitch
		Case "Sports"
			Local $num = random(0,3,1)
			Switch $num
				Case 0
					return "Racing"
				Case 1
					return "Sport"
				Case 2
					return "Competitive"
				Case 3
					return "Sport-Based Fighting"
			EndSwitch
		Case "Special"
			Local $num = random(0,6,1)
			Switch $num
				Case 0
					return "Adver"
				Case 1
					return "Art"
				Case 2
					return "Casual"
				Case 3
					return "Educational"
				Case 4
					return "Electronic Sport"
				Case 5
					return "Exer"
				Case 6
					return "Serious"
			EndSwitch
		Case "Other"
			Local $num = random(0,6,1)
			Switch $num
				Case 0
					return "MMO"
				Case 1
					return "Casual"
				Case 2
					return "Party"
				Case 3
					return "Programming"
				Case 4
					return "Logic"
				Case 5
					return "Trivia"
				Case 6
					return "Board/Card"
			EndSwitch
	EndSwitch
EndFunc

Func GenerateGenreName()
	Local $number = random(0,17,1)
	Switch $number
		Case 0
			return "Action"
		Case 1
			return "Adventure"
		Case 2
			return "Puzzle"
		Case 3
			return "Card & Board"
		Case 4
			return "First Person Shooter"
		Case 5
			return "Third Person Shooter"
		Case 6
			return "Top Down Shooter"
		Case 7
			return "Simulation"
		Case 8
			return "Sports"
		Case 9
			return "Real-Time Strategy"
		Case 10
			return "Vehicles"
		Case 11
			return "MMO"
		Case 12
			return "MMORPG"
		Case 13
			return "Survival"
		Case 14
			return "Stealth"
		Case 15
			return "Sandbox"
		Case 16
			return "Platformer"
		Case 17
			return "Rogue-Like"
	EndSwitch
EndFunc

Func LatestRedditPost($sub)
	$Source = BinaryToString(InetRead("http://www.Reddit.com/r/" & $sub & "/new/"))
    $Titles = _StringBetween($Source,'nofollow" >','</a>')
    If IsArray($Titles) Then
        return $Titles[0]
    Else
        Print("No Correlation")
    EndIf
EndFunc

Func GenerateName($Pattern)
    Dim $Consonants[21] = ["B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z"]
    Dim $Vowels[5] = ["A","E","I","O","U"]
    If StringInStr($Pattern, "(") Or StringInStr($Pattern, ")") Then
        If CharCount($Pattern, "(") > 9 OR CharCount($Pattern,")") > 9 then SetError(2,"Too Many Groups",-1)
        If CharCount($Pattern, "(") <> CharCount($Pattern,")") Then SetError(3,"Parenthesis",-1)
        $Groups = StringRegExp($Pattern, "\("&".*?"&"\)",3)
        $PlaceHolder= $Pattern
        For $i = 0 to Ubound($Groups)-1
            $PlaceHolder = StringReplace($PlaceHolder, $Groups[$i], $i,1)
        Next
        $chars = StringSplit($PlaceHolder,"")
        $Limit = $chars[0]
        Local $Randomchr[$Limit+1]
        For $i = 1 to $Limit
            If $chars[$i] = "c" then
                $Randomchr[$i] = $Consonants[Random(0,20,1)]
            ElseIf  $chars[$i] = "v" Then
                $Randomchr[$i] = $Vowels[Random(0,4,1)]
            Else
                $RandomChr[$i] = $chars[$i]
            EndIf
        Next
        local $Newstring =""
        For $i = 1 to $Limit
            $Newstring&=$RandomChr[$i]
        Next
        Local $Replacer[Ubound($Groups)]
        For $i = 0 to Ubound($Groups)-1
            If StringInStr($Groups[$i],",") then 
                $Choices = StringSplit(StringTrimLeft(StringTrimRight($Groups[$i],1),1), ",")
                $chr = $Choices[Random(1,$Choices[0],1)]
            Else
                $Chr = StringTrimLeft(StringTrimRight($Groups[$i],1),1)
            EndIf
            $Replacer[$i] = $chr
            $NewString= StringReplace($Newstring, String($i), $Replacer[$i])
        Next
        $Final = $NewString
    Else
        $Chars = StringSplit($Pattern,"")
        $Limit = $Chars[0]
        If $Limit>0 then
            Local $Randomchr[$Limit+1]
            For $i = 1 to $Limit
                If $Chars[$i] = "c" then
                    $Randomchr[$i] = $Consonants[Random(0,20,1)]
                ElseIf  $Chars[$i] = "v" Then
                    $Randomchr[$i] = $Vowels[Random(0,4,1)]
                Else
                    $RandomChr[$i] = $chars[$i]
                EndIf
            Next
            local $Final =""
            For $i = 1 to $Limit
                $Final&=$RandomChr[$i]
            Next
        EndIf
    EndIf
    Return StringUpper(StringLeft($Final,1))&StringLower(StringTrimLeft($Final,1))
EndFunc

Func CharCount($String, $Chr, $CaseSense=0)
    Local $Count = 0
    $Characters = StringSplit($String, "")
    For $i = 1 to $Characters[0]
        If $CaseSense then
            If $Characters[$i] == $Chr then $Count+=1
        Else
            If $Characters[$i] = $Chr then $Count+=1
        EndIf
    Next
    Return $Count
EndFunc

Func GetLangShortcut($Lang)
	Switch _StringTitleCase($Lang)
		Case "Arabic"
			return "ar"
		Case "English"
			return "en"
		Case "French"
			return "fr"
		Case "Russian"
			return "ru"
		Case "Spanish"
			return "es"
		Case "Urdu"
			return "ur"
	EndSwitch
EndFunc

Func SpeechSetup()
	$Filename = FileOpen(@ScriptDir & "/Grammar.txt")
	$Grammar = FileRead($Filename)
	$Engine = _Utter_Speech_StartEngine()
	_Utter_Speech_CreateGrammar($Engine,$Grammar)
	_Utter_Speech_CreateTokens($Engine)
	_Utter_Speech_GrammarRecognize($Engine,"",0,"DetectAudio")
EndFunc

Func UpdateProgram()
	$UpdateSource = _INetGetSource("https://docs.google.com/document/d/1wEgsV4zNMbpthCA3aRspq30OJQhO1l5FinuVV0e7-VQ/edit")
	$UpdateVersion = _StringBetween($UpdateSource,'content="','">')[4]
	If $UpdateVersion = $version Then
		Print($name & " Is Up to Date")
	Else
		Print("There's a new version has been released")
	EndIf
EndFunc

Func EndProgram()
	_Utter_Speech_ShutdownEngine()
	GUIDelete($Form)
	Exit
EndFunc