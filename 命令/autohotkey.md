
# auto hotkey

## 特殊按键

|key | exp
|-- | --
|Ctrl   | ^
|Shift  | +
|Alt    | !
|Super  | #
|Enter  | {Enter}

## 生效条件

```txt
#HotIf WinActive("ahk_class Notepad")
^a::MsgBox "You pressed Ctrl-A while Notepad is active. Pressing Ctrl-A in any other window will pass the Ctrl-A keystroke to that window."
#c::MsgBox "You pressed Win-C while Notepad is active."

#HotIf
#c::MsgBox "You pressed Win-C while any window except Notepad is active."
```

### 组合按键

```txt
#HotIf GetKeyState("Ctrl")
Space & CapsLock::
CapsLock & Space::MsgBox "Success!"
```

## 示例

在窗口的 class 为指定值时按 Ctrl+1 自动输入密码

```txt
; 注释
^1::{
    if WinActive("ahk_class HtxMainWindow") {
        SendText "6+0"              ; + 是普通字符
        Send "+Ti+X+Z+D"            ; + 代表 shift
        Sleep 500                   ; 睡眠 500 ms
        Send "{Enter}"              ; 回车
    }
}
```
