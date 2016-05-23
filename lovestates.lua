-- STATE SWITCHING
function switch_state(new_state)
	assert(states[new_state], "Did not find state " .. new_state)
	state = states[new_state]
	state.init()
end

function lovestate()
	return {
		init = function() end,
		draw = function() end,
		update = function( dt ) end,
		keypressed = function( key ) end,
		keyreleased = function ( key ) end
	}
end
