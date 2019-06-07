Console.Color = {
    Black = 0,
    DarkBlue = 1,
    DarkGreen = 2,
    DarkCyan = 3,
    DarkRed = 4,
    DarkMagenta = 5,
    DarkYellow = 6,
    Gray = 7,
    DarkGray = 8,
    Blue = 9,
    Green = 10,
    Cyan = 11,
    Red = 12,
    Magenta = 13,
    Yellow = 14,
    White = 15,
    Default = 16
}

function LogBegin()
	Console.Write("[LUA]", Console.Color.Green)
	Console.Write(" ")	
end

function LogContinue(Text, Color)
	Console.Write(tostring(Text), Color or Console.Color.Default)
end

function LogEnd()
	Console.WriteLine("")
end

function Log(Text, Color)
	LogBegin()
	LogContinue(Text, Color)
	LogEnd()
end