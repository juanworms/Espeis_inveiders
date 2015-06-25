--License
--"Espeis Inveiders" a hipotetical game for Love framework
--Copyright (C) 2015  Juan Benitez

--This program is free software; you can redistribute it and/or
--modify it under the terms of the GNU General Public License
--as published by the Free Software Foundation; either version 2
--of the License, or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.

--You should have received a copy of the GNU General Public License
--along with this program; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

--Espeis Inveiders version 0.1, Copyright (C) 2015 Juan Benitez
--Espeis Inveiders comes with ABSOLUTELY NO WARRANTY

--This is free software, and you are welcome
--to redistribute it under certain conditions
-- 1) modify or not and distribute
-- 2) give a little of credit of me
-- 3) if you use the same resources, plz give credit of the originals autors

debug = true
--Variables globales
stillalive = true
initial_status = true
drawable = true
canshoot = true
line = 0		
orientation_right = false
orientation_left = true
canshootimermax = 0.2
canshootimer = canshootimermax
canresetimermax = 2
osciladormax = 2
oscilador = osciladormax
canreset = true
canresetimer = canresetimermax
initial_enemy_position = {x=0, y=0}
initial_enemy_position.x = (love.graphics.getWidth() / 16)
initial_enemy_position.y = (love.graphics.getHeight() / 16)
positionador_matrix = {x=initial_enemy_position.x, y= initial_enemy_position.y}
enemies = {} -- X , Y , IMG
messages = {'puntaje', 'Enemigos restantes', 'vidas', 'Bien hecho, preciona r para reiniciar' , 'Perdiste piojo', 'presione r para reiniciar'}
player = {x= (love.graphics.getWidth() * (0.5)), y= (love.graphics.getHeight() * (0.8)), speed=200, img=nil}
bullets = {} -- X, Y, IMG
enemybullets = {} -- X, Y, IMG, SPEED
enemyshootimermax = 1
enemyshootimer = enemyshootimermax
enemycanshoot = false
enemyrandom=1
osciladometro = 0
-- debug variables
cambio = 1
orientacionI = 1
number = 0
states= {'Menu','Game','Highscore'}
game_status = 'Menu'

-- Funciones propias
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

enemyshooter = function ()
	if #enemies > 0 and stillalive then
		enemyrandom = math.random(1, #enemies)
		newenemybullet= {x = (enemies[enemyrandom].x) + (alienimg:getWidth()/2), y= enemies[enemyrandom].y + alienimg:getWidth(), img= alienbulletimg, speed = math.random(1, (100 / #enemies))}
		table.insert(enemybullets, newenemybullet)
	end
end

draw_initial_state = function (drawable, line) -- verifica si es el estado inicial del juego
	
	while drawable  and  line < 4 do
		print("dibujando estado inicial")
		newEnemy = { x = positionador_matrix.x, y = positionador_matrix.y, img = alienimg }
		table.insert(enemies, newEnemy)
		if ((positionador_matrix.x)+(alienimg:getWidth()*3) > love.graphics.getWidth()) then 
			positionador_matrix.y = (positionador_matrix.y) + (alienimg:getHeight()*2)
			line = line + 1
			positionador_matrix.x = initial_enemy_position.x - (alienimg:getWidth()*2)
		end
		positionador_matrix.x = positionador_matrix.x + alienimg:getWidth()*2
	end
end

checkbounds = function (enemies, dt, orientation_right, orientation_left)
	
	for k, enemy in ipairs(enemies) do
		if (enemy.x == 0) then
			orientation_left = false
			cambio = 0
			
		end
		if (enemy.x == love.graphics.getWidth()) then
			orientation_left = true
			cambio = 0
			--orientation_right = false
		end
	end 
end


-- Funcion que hace mover a los aliens, chequea que los aliens toquen los laterales solamente mientras
-- estas vivo
alien_run = function (enemies, stillalive, dt, orientation_right)

	if stillalive then 
		--checkbounds(enemies, dt, orientation_right, orientation_left)
		if (orientation_left == true) then
			for i, enemy in ipairs(enemies) do
				enemy.x = enemy.x - (50 * dt)
				cambio = 8
							if (enemy.x < 0) or (enemy == 0) then
							orientation_left = false
								
								for j, enemy in ipairs(enemies) do
								enemy.y = enemy.y + (5)
								
								end--orientation_right = true
							end
			end
			
		end
		if (orientation_left == false) then
			
			for j, enemy in ipairs(enemies) do
				enemy.x = enemy.x + (50*dt)
				cambio = 1
					if ((enemy.x + alienimg:getWidth()) > love.graphics.getWidth()) then
						orientation_left = true
								for j, enemy in ipairs(enemies) do
								enemy.y = enemy.y + (5)
								
								end
						--orientation_right = false
						end
			end
		end
		
	end
end

-- Funcion de Cargado de Love
function love.load(arg)
	alienimg = love.graphics.newImage('aliensprite.jpg')
	player.img = love.graphics.newImage("shuttle2_0.png")
	alienbulletimg = love.graphics.newImage('alienbullet.png')
	bulletsound = love.audio.newSource('gun-sound.wav')
	bulletimg = love.graphics.newImage('bullet.png')
	--music = love.audio.newSource('music.mp3')
	--love.audio.play(music)
end

function love.update(dt)
require("lovebird").update() -- module to debug
	if game_status == 'Menu' then -- Begin of Menu state
		if love.keyboard.isDown('h') then
			print("juego iniciado")
			game_status = 'Game'
		end
		if love.keyboard.isDown('escape') then
			print("ESC presionado")
			love.event.push('quit')
		end
	end
	-- End of Menu state

	if game_status == 'Game' then --start of Game frame
		
		--escape the game
		if love.keyboard.isDown('escape') then
			print("ESC presionado")
			love.event.push('quit')
		end
		--keyboard events related to player
		if love.keyboard.isDown('left','a') and stillalive then
			if player.x > 0 then -- binds us to the map
				player.x = player.x - (player.speed*dt)
			end
		elseif love.keyboard.isDown('right','d') and stillalive then
			if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
				player.x = player.x + (player.speed*dt)
			end
		end
		if love.keyboard.isDown('lshift') then
			player.speed = 500
		end
		if not love.keyboard.isDown ('lshift') then 
			player.speed = 200
		end
		if love.keyboard.isDown(' ') and canshoot and stillalive then 
			newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletimg }
			table.insert(bullets, newBullet)
			canshoot = false
			canshootimer = canshootimermax
			bulletsound:play()
		end
		if love.keyboard.isDown('r') and canreset then
			print("R presionado")
			enemies = {}
			bullets = {}
			enemybullets = {}
			positionador_matrix = {x=initial_enemy_position.x, y= initial_enemy_position.y}
			player.x= (love.graphics.getWidth() * (0.5))
			player.y= (love.graphics.getHeight() * (0.8)) -- 
			drawable = true
			line = 0
			stillalive= true
		end
		--update events
		for i, bullets in ipairs(bullets) do
			bullets.y = bullets.y - (1000 * dt)

			if bullets.y < 0 then -- remove bullets when they pass off the screen
				table.remove(bullets, i)
			end
		end
		-- contadores dentro del juego
		canshootimer = canshootimer - (1 * dt)
		canresetimer = canresetimer - (1 * dt)
		enemyshootimer = enemyshootimer - (1 * dt)
		oscilador = oscilador - (0.5 * dt)
		if canshootimer < 0 then
			canshoot = true
		end
		if canresetimer < 0 then
			canreset = true
		end
	
		if oscilador < 0 then
			oscilador = osciladormax
		end
		osciladometro  =  math.sin(math.pi * oscilador)
		--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
		alien_run(enemies, stillalive, dt, orientation_right)
		if orientaion_left then
			orientacionI = 1
		end
		if not orientation_left then
			orientacion = 0
		end
		-- check initial state

		if drawable then
			for i, enemy in ipairs(enemies) do
				table.remove(enemies,i)
			end		
			line = 0
			canreset = false
			canresetimer = canresetimermax
			print("inicio de dibujo")
			draw_initial_state (drawable, line)
			drawable = false
			print("drawable en falso")
		
		end		
		-- Ultima funcion
		for i, enemy in ipairs(enemies) do
				for j, bullet in ipairs(bullets) do
					if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
						table.remove(bullets, j)
						table.remove(enemies, i)
					end
				end
					if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) -- colision de enemigo con nave
					and stillalive then
						stillalive = false
					end
					if (enemy.y > love.graphics.getHeight()) then
						stillalive = false
					end

		end
			--enemyshoot
		if enemyshootimer > 0 then
			enemycanshoot = false
		end
		if enemyshootimer < 0 then
				enemycanshoot = true
				enemyshootimer = enemyshootimermax
				enemyshooter()
		end
		--RNG
		number = math.random(1,#enemies)
		-- update enemybullets
		if (#enemybullets > 0) and stillalive then
			for i, bullets in ipairs(enemybullets) do
				bullets.y = bullets.y + (bullets.speed)
				bullets.x = bullets.x + (math.random(0,10)*(love.graphics.getWidth()/ 640) *math.sin(math.pi * oscilador))

				if (bullets.y > love.graphics.getHeight()) then -- remove bullets when they pass off the screen
					table.remove(bullets, i)
				end
				if CheckCollision(bullets.x, bullets.y, bullets.img:getWidth(), bullets.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) then
					stillalive = false
				--------------------------
				end
			end
		end
		if #enemies == 0 then
			enemybullets = {}
		end
	end
	-- End of game state
end
function love.draw(dt)
	--menu 	
	if game_status == 'Menu' then
		love.graphics.print("splash Screen", 300, 300)
	end
	if debug and game_status == 'Game' then
		love.graphics.print("veracidad de cambio".. cambio,9,330)
		love.graphics.print("veracidad de izquirda".. orientacionI, 9, 375)
		love.graphics.print(canresetimer, 400, 300)
		numberstring = tostring(number)
		love.graphics.print("Numero Aleatorio:"..numberstring, 100, 350)
		love.graphics.print("enemyshotimer:"..enemyshootimer, 300,400)
		love.graphics.print("enemigos restantes:"..#enemies, 100,450)
		love.graphics.print("oscilador:"..osciladometro,100,425)
	end
	fps = tostring(love.timer.getFPS())
	love.graphics.print("Current FPS: "..fps, 9, 30)

	if game_status == 'Game' then
		if stillalive == false then
			love.graphics.print(messages[5],9,50)
			love.graphics.print(messages[6],9,60)
		end
		
		love.graphics.draw(player.img, player.x, player.y)
		--for i, enemy in ipairs(enemies) do
		for i, bullets in ipairs(bullets) do
			love.graphics.draw(bullets.img, bullets.x, bullets.y)
		end
		if #enemies == 0 then
			love.graphics.print(messages[4], 200, 200)
		end
		for i, bullets in ipairs(enemybullets) do
			love.graphics.draw(bullets.img, bullets.x, bullets.y)
		end
		for i, enemies in ipairs(enemies) do
			love.graphics.draw(enemies.img, enemies.x, enemies.y)
		end
	end
end
