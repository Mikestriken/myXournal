#Requires AutoHotkey v2.0

; Include the Interception library
; #Include <AutoHotInterception>
#SingleInstance force
Persistent
#include Lib\AutoHotInterception.ahk

; Initialize the Interception object
; interception := new Interception()
; interception := AutoHotInterception()

; Device ID for the specific mouse
; deviceId := interception.GetMouseId("HID\HID&Col03")

; Subscribe to the right mouse button (RButton) for the specific device
; interception.SubscribeMouse(deviceId, "RButton", MouseRightClick)

; Define the callback function
; MouseRightClick(state) {
;     if state = 1 ; Right button pressed
;     {
;         Send("A") ; Simulate pressing the 'A' key
;     }
; }

; Clean up resources on exit
; OnExit(*) {
;     interception.Free()
; }

AHI := AutoHotInterception()

MouseId := AHI.GetMouseId(0x0000, 0x0000)

; SubscribeMouseButton(<deviceId>, <button>, <block>, <callback>, <concurrent>)
AHI.SubscribeMouseButton(MouseId    , 1    , true      , KeyEvent)


global isDoubleClick := false

return

KeyEvent(state){
	; ToolTip("State: " state)
	; Send("+#b")

	if (state) {
		global isDoubleClick
		static lastClick := 0
		static doubleClickTime := 200  ; Time window for double-click detection
		
		if (A_TickCount - lastClick < doubleClickTime)
		{
			isDoubleClick := true
			return
		}
		
		lastClick := A_TickCount
		
		; Wait briefly to check for a double click
		SetTimer(CheckClick, -doubleClickTime)
	}
}

^Esc::
{
	ExitApp
}
	
CheckClick()
{
	global isDoubleClick
    ; static lastClick := 0
    if (isDoubleClick)
    {
		isDoubleClick := false
        Send("+#b")  ; Send 'Win + Shift + B' on single click
    }
    else doStateMachineClickLogic()

}

doStateMachineClickLogic() {
	static state := 0

	Switch state
	{
		Case 0:
			Send("^+e")  ; Send 'a' on double click
			state++
			
		Case 1:
			Send("^+p")  ; Send 'a' on double click
			state := 0
			
		; Case 2:
		; 	Send("1")  ; Send 'a' on double click
		; 	state := 0
	}
}