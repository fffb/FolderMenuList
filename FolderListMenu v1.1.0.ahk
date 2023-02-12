
#SingleInstance Force

#HotIf WinActive("ahk_class #32770")	; 打开/保存对话框

^g::
{
	global WinID := WinExist("A")
	ContextMenu := Menu()

	;---------------资源管理器------------------------------------
	For openedwindows in ComObject("shell.Application").windows
	{
		This := openedwindows.Document.Folder.Self.Path
		ContextMenu.Add(This, MenuHandler)
		ContextMenu.SetIcon(This, "shell32.dll", 5)
	}
	openedwindows := ""	;清空变量

	;---------------Total Commander-------------------------------
	if WinExist("ahk_class TTOTAL_CMD")
	{
		TCPath := WinGetProcessPath("ahk_class TTOTAL_CMD")
		cm_CopySrcPathToClip := 2029	;Total Commander 内部代码
		cm_CopyTrgPathToClip := 2030
		ClipSaved := ClipboardAll()
		A_Clipboard := ""

	SendMessage(1075, cm_CopySrcPathToClip, 0, , "ahk_class TTOTAL_CMD")
		ContextMenu.Add
		ContextMenu.Add(A_Clipboard, MenuHandler)
		ContextMenu.SetIcon(A_Clipboard, TCPath, 1)

	SendMessage(1075, cm_CopyTrgPathToClip, 0, , "ahk_class TTOTAL_CMD")
		ContextMenu.Add(A_Clipboard, MenuHandler)
		ContextMenu.SetIcon(A_Clipboard, TCPath, 1)

	A_Clipboard := ClipSaved
		ClipSaved := ""
	}
	;--------------常用文件夹-------
	path1 := "F:\图片\Pics\墙纸\bing"
	ContextMenu.Add
	;ContextMenu.Add("常用路径", MenuHandler)
	;ContextMenu.Disable("常用路径")
	ContextMenu.Add(path1, MenuHandler)
	ContextMenu.SetIcon(path1, "shell32.dll", 44)
	;------------------------------
	ContextMenu.Show
	ContextMenu.Delete
}

#HotIf	;关闭上下文相关性
Return

MenuHandler(ItemName, ItemPos, MyMenu)
{
	WinActivate "ahk_id" WinID
	Send "!d"
	Sleep 50

	addressbar := ControlGetFocus("A")	; The control that's focused after Alt+D is thus the address bar
	ControlSetText(ItemName, addressbar, "A")
	ControlSend("{Enter}", addressbar, "A")
	ControlFocus("Edit1", "A")	; Return focus to filename field
	return
}