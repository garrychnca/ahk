#Requires AutoHotkey v2.0

; alt + `
!`::SwitchWindowOfSameProgram()

SwitchWindowOfSameProgram() {
    SetTitleMatchMode(2)
    DetectHiddenWindows(false)

    WinId := WinExist("A")
    if (WinId and WinId != WinActive("ahk_class WorkerW ahk_exe explorer.exe")) {
        WinIdCriteria := "ahk_id " WinId
        WinClass := WinGetClass(WinIdCriteria)
        WinProcessName := WinGetProcessName(WinIdCriteria)
        WinProcessCriteria := "ahk_class " WinClass " ahk_exe " WinProcessName
        If (WinGetCount(WinProcessCriteria) > 1) {
            WinMoveBottom(WinIdCriteria)
            WinActivate(WinProcessCriteria)
        }
    }
}
