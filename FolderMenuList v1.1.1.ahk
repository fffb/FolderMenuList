#SingleInstance Force

#HotIf WinActive("ahk_class #32770")

^g::
{
	global WinID := WinExist("A")
	ContextMenu := Menu()

	;---------------资源管理器-------------------------
	For openedwindows in ComObject("shell.Application").windows
	{
		This := openedwindows.Document.Folder.Self.Path
		ContextMenu.Add(This, MenuHandler)
		ContextMenu.SetIcon(This, "shell32.dll", 5)
	}
	openedwindows := ""	;清空变量

	;---------------Total Commander-------------------
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
	ContextMenu.Add
	ContextMenu.Add("常用路径", MenuHandler)
	ContextMenu.Disable("常用路径")
	ContextMenu.Add("F:\图片\Pics\墙纸\bing", MenuHandler)	;如要添加自定义路径，可复制本行和下一行，只修改其中路径即可
	ContextMenu.SetIcon("F:\图片\Pics\墙纸\bing", "shell32.dll", 44)
	;ContextMenu.Add("%UserProfile%\", MenuHandler)	;用户文件夹
	;ContextMenu.SetIcon("%UserProfile%\", "shell32.dll", 44)
	;------------------------------
	ContextMenu.Show
	ContextMenu.Delete
}

#HotIf	;关闭上下文相关性

MenuHandler(ItemName, ItemPos, MyMenu)
{
	WinActivate "ahk_id" WinID

	try
	{
		if ControlGetEnabled("ToolbarWindow323", WinID) = 1 or ControlGetEnabled("ToolWindow324", WinID) = 1
		{
			Send "!d"
			Sleep 100	;等待获取焦点，如果设为 50 ,在 chrome 中另存为会出现焦点错误
			addressbar := ControlGetFocus("A")	; 按下 alt+D 之后的焦点为地址栏
			ControlSetText(ItemName, addressbar, "A")
			ControlSend("{Enter}", addressbar, "A")
			ControlFocus("Edit1", "A")	;焦点移回到 Edit1
		}
	}
	catch TargetError
	{
		FolderPath := ItemName
		OldText := ControlGetText("Edit1", "A")	;读取当前 Edit1 控件中的文件名
		ControlFocus "Edit1", "A"

		Loop 5
		{
			ControlSetText FolderPath, "Edit1", "ahk_id" WinID
			Sleep(50)
			CurControlText := ControlGetText("Edit1", "ahk_id" WinID)
			if (CurControlText = FolderPath)
				break
		}

		Sleep 50
		ControlSend "{Enter}", "Edit1", "A"
		Sleep 50

		If !OldText	;插入原始文件名
			return

		Loop 5
		{
			ControlSetText OldText, "Edit1", "A"
			Sleep 50
			CurControlText := ControlGetText("Edit1", "A")
			if (CurControlText = OldText)
				break
		}
	}
}