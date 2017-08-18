
local io = require("io")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local bat = { mt = {} }

function bat.batery_value()
	local handle = io.popen("acpi -b")
	local result = handle:read("*a")
	return string.match(result, "1*[0-9][0-9]%%")
end

function bat.update()
	local value = tonumber(string.match(bat.batery_value(), "1*[0-9][0-9]"))
	local markup = "<span font='10' bgcolor='" .. beautiful.bg_etiqueta_1 .. "' color="

	if(value >= 70) then
		markup = markup .. "'#00FF00'>" --verde

	elseif(value >= 30) then
		markup = markup .. "'#FF8C00'>" --naranja

	elseif(value >= 10) then
		markup = markup .. "'#FFD700'>" --amarillo
	else
		markup = markup .. "'#FF0000'>" --rojo

	end
	markup = markup .. value .. "%</span><span font='10' color='" .. beautiful.bg_etiqueta_1 .. "'></span>"
	bat.textbox.markup = markup 
end

function bat.new(args)
	args = args or {}

	bat.textbox= wibox.widget{
		--markup = "<span font='10' bgcolor='#595959' color='#00FF00'>" ..
		--	"valor% </span><span font='10' color='#595959'></span>",

		--markup = "<span font='10' bgcolor='" .. beautiful.bg_focus .. "' color='#00FF00'>" ..
		--	"valor% </span><span font='10' color='#595959'></span>",
		widget = wibox.widget.textbox
	}

	bat.timer = gears.timer{
		timeout = 10,
		autostart = true,
		callback = function()
			bat.update()
		end
	}

	bat.update()
	return bat.textbox
end

function bat.mt:__call(...)
	return bat.new(...)
end

return setmetatable(bat, bat.mt)
