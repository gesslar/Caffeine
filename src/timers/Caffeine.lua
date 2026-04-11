local TN_IAC = 255
local TN_NOP = 241
local telnetSequence = string.char(TN_IAC, TN_NOP)
sendSocket(telnetSequence)
