;================================================================================
; RAM Labels & Assertions
;--------------------------------------------------------------------------------
pushpc
org 0
;--------------------------------------------------------------------------------
; Labels for values in WRAM and assertions that ensure they're correct and
; at the expected addresses. All values larger than one byte are little endian.
;--------------------------------------------------------------------------------
; Placeholder and for compass item max count allocations, still WIP
;--------------------------------------------------------------------------------

base $7F5000
RedrawFlag: skip 1                 ;
skip 2                             ; Unused
HexToDecDigit1: skip 1             ; Space for storing the result of hex to decimal conversion.
HexToDecDigit2: skip 1             ; Digits are stored from high to low.
HexToDecDigit3: skip 1             ;
HexToDecDigit4: skip 1             ;
HexToDecDigit5: skip 1             ;

base $7F5410
CompassTotalsWRAM: skip $10

;================================================================================
; RAM Assertions
;--------------------------------------------------------------------------------
macro assertRAM(label, address)
  assert <label> = <address>, "<label> labeled at incorrect address."
endmacro

%assertRAM(RedrawFlag, $7F5000)
%assertRAM(HexToDecDigit1, $7F5003)
%assertRAM(HexToDecDigit2, $7F5004)
%assertRAM(HexToDecDigit3, $7F5005)
%assertRAM(HexToDecDigit4, $7F5006)
%assertRAM(HexToDecDigit5, $7F5007)
%assertRAM(CompassTotalsWRAM, $7F5410)

pullpc
