local lovr = require 'lovr'

function lovr.load()
end

function lovr.draw(pass)
	pass:cube(0, 1.7, -1, .5, lovr.headset.getTime(), 0, 1, 0, 'line')
end

function lovr.keypressed(key)
	if key == 'escape' then
		lovr.event.quit()
	end
end
