#Requires AutoHotkey v2.0

; ctrl + alt + c
^!c::CenterActiveWindow()

CenterActiveWindow() {
    WinId := WinExist("A")
    if (WinId and WinId != WinActive("ahk_class WorkerW ahk_exe explorer.exe")) {
        WinGetPos(,, &WinWidth, &WinHeight, WinId)
        WinMonitorInfo := GetActiveWindowMonitorInfo(WinId)
        WinMove(
            WinMonitorInfo.Left + WinMonitorInfo.Width // 2 - WinWidth // 2,
            WinMonitorInfo.Top + WinMonitorInfo.Height // 2 - WinHeight // 2,
            ,,
            WinId
        )
    }
}

GetActiveWindowMonitorInfo(WinId) {
    WinMonitorId := DllCall("user32\MonitorFromWindow", "ptr", WinId, "uint", 2, "ptr")

    ; Set 104 as the size of the structure to return, which is MONITORINFO.
    ; https://learn.microsoft.com/en-us/windows/win32/api/winuser/ns-winuser-monitorinfo
    WinMonitorInfo := Buffer(104)
    NumPut("uint", 104, WinMonitorInfo)

    if (DllCall("user32\GetMonitorInfo", "ptr", WinMonitorId, "ptr", WinMonitorInfo)) {
        Left := NumGet(WinMonitorInfo, 20, "int")
        Top := NumGet(WinMonitorInfo, 24, "int")
        Right := NumGet(WinMonitorInfo, 28, "int")
        Bottom := NumGet(WinMonitorInfo, 32, "int")
        Return {
            Left : Left,
            Top : Top,
            Width : Right - Left,
            Height : Bottom - Top
        }
    } else {
        throw Error("GetActiveWindowMonitorInfo: " A_LastError, -1)
    }
}
