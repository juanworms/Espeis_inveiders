-- Configuration
function love.conf(t)
	t.window = t.window or t.screen -- compatibility with older versions
	
	
	t.title = "Espeis inveiders V1.0" -- The title of the window the game is in (string)
	t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
	t.window.width = 1024    -- 
	t.window.height = 768
	t.window.fullscreen = true  -- For better experience, i need to put it as true
	 t.window.minwidth = 640              -- Minimum window width if the window is resizable (number)
    t.window.minheight = 480             -- Minimum window height if the window is resizable (number)
	
	t.window.resizable = true
	-- For Windows debugging
	t.console = false
end
