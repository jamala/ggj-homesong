pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
max_stress=3040

function _init()
 inside = true
	singing = false
	vollow = false
	stress = 0
	songlist =
	{
 	{0,1,2,3},
 	{0,0,0,0}
	}
	match = nil


	world = {}
	maplocked = true
	debug = {}
	
	go_inside()
	player.x=40
	player.y=40
end

function _update()
	if singing and not vollow then
		musiclow()
		vollow=true
	elseif not singing and vollow then
		musichigh()
		vollow=false
	end
	
	if btn(4) then
 	singing = true
 	
 	if btn(0) then
 		sfx(1,3)
 	end
 	if btn(1) then
 		sfx(2,3)
 	end
 	if btn(2) then
 		sfx(3,3)
 	end
 	if btn(3) then
 		sfx(0,3)
 	end
 	
		songs()
		playerspr.frame = 1
	else
		singing = false
		notes = {}
		match = nil
		move_player()
	end
	
	if inside then
	 stress = max(0, stress-10)
	else
	 stress += 1
	 if stress == (max_stress/2) then
	  play_outside(46)
	 end
	end
end

function move_player()
	player.vx = 0
	player.vy = 0
	local m = false
	if (btn(0)) then
		 player.vx = -player.spd
		 playerspr.direction = left
		 playerspr.faceleft = true
		 m = true
	end
	if (btn(1)) then
		player.vx = player.spd
		playerspr.direction = right
		playerspr.faceleft = false
		m = true
	end
	if (btn(2)) then
		player.vy = -player.spd
		playerspr.direction = up
		
		m = true
	end
	if (btn(3)) then
		player.vy = player.spd
		playerspr.direction = down
		m = true
	end
	
	player.x += player.vx
	player.y += player.vy
	if (m) then
	playerspr:update()
	else playerspr.frame = 1 end
	
	
 if inside then
  tileflag=fget(mget(player.x/8,player.y/8))
  if tileflag == 64 then go_outside() end
 else
  tileflag=fget(mget(player.x/8+16,player.y/8+1))
  if tileflag == 128 then go_inside() end
 end
end

function _draw()
 cls()
 camera()

 if inside then
  map(0,0,0,0,14,14)
 else
  camera(player.x-64,player.y-64)
  map(16,1,0,0,100,100)
 end
 
 camera()
 
 rectfill(80,0,126,4,2)
 rectfill(80,0,(80+((stress/max_stress)*(126-80))),4,12)
 rect(80,0,126,4,12)
 
 -- this is jank, sorry -ng
 if not inside then
  camera(player.x-64,player.y-64)
 end
 
 
 
 print ("matching song: ",0,40,10)
 print (match,60,40,10)
 for i = 1,#notes do
 	print(notes[i], 0, 40+10*i, 12)
 end
 --draw player
 
	//spr(0,player.x,player.y)
	
	playerspr:draw()
	drawdebug()
end


function drawdebug()
 
 for i = 1, #debug do
 
 
 print(debug[i],player.x,player.y-40,10)
 end
 debug = {}

end

function go_inside()
 inside=true
	play_inside(64)
 player.x=10
 player.y=90
end

function go_outside()
 inside=false 
 play_outside(64)
 player.x=405
 player.y=245
end
-->8

btnd_arr = 
{
false,
false,
false,
false,
false,
false}

function btnd(id)
// checks if a button was
// just pressed down
 local b = btn(id)
 if b then
  			if not btnd_arr[id+1] then
 				 btnd_arr[id+1] = true
 					return true
 				end
 else
 	btnd_arr[id+1] = false
 end
	return false
end
-->8

function songs()
	//compile list of notes
	for i = 0, 3 do
		if btnd(i) then
			add(notes,i)
		end
	end
	
	//compare to songs
	// (matching song id
	//  stored in 'match')
	for i = 1, #songlist do 
		local m = true
		local c = 0
		if #notes > 0 then
  	for j = 1, #notes do
  	 c+=1
  		if notes[j] != songlist[i][j] then
  			m = false
  		end 
 	 end
		if m and c == #songlist[i] then 
			match = i
		end
		end
	end
end

function get_speed(sfx)
  return peek(0x3200 + 68*sfx + 65)
end

function set_speed(sfx, speed)
  poke(0x3200 + 68*sfx + 65, speed)
end

function setvol(sfx, vol)
  local addr = 0x3200 + 68*sfx
  for offset=0,31 do
  	note_addr=addr+(offset*2+1)
  	note=peek(note_addr)
  	if note>0 then
    note_altered=bor(band(note,241),shl(vol,1))
    poke(note_addr,note_altered)
  	end
  end
end

function play_outside(speed)
 music(-1)
 for s=4,8 do
 	set_speed(s,speed)
 end
 music(0)
end

function play_inside(speed)
 music(-1)
 for s=9,11 do
 	set_speed(s,speed)
 end
 music(3)
end

function musiclow()
 setvol(4,1)
 setvol(5,1)
 setvol(6,0)
 setvol(7,0)
 setvol(8,1)
 setvol(9,1)
 setvol(10,0)
 setvol(11,1)
end

function musichigh()
 setvol(4,4)
 setvol(5,3)
 setvol(6,3)
 setvol(7,2)
 setvol(8,5)
 setvol(9,5)
 setvol(10,2)
 setvol(11,5)
end

-->8
 up = 1
 down = 2
 left = 3
 right = 4	
 
 playerspr = 
 {
  sprites =
  {
  	{107,108,107,109	}, //u
  	{104,105,104,106}, //d
 		{77,78,77,79},	
  	{77,78,77,79}
  },
  direction = down,
  frame = 1,
  faceleft = false,
  lastupdated = 0,
  updatefreq = 0.2
 }
	player =
	{
		x = 0,
		y = 0,
	//	s = playerspr,
		spd = 1
	}
	

	
function playerspr:update()

	if self.lastupdated < 
	(time() - self.updatefreq) then
		self.frame+=1
 	if self.frame 
		> #self.sprites[self.direction]
		then
			self.frame = 1
		end
		self.lastupdated = time()
	end
end

function playerspr:draw()
	spr(
					self.sprites[self.direction][self.frame],
					player.x, 
					player.y,
					1,
					2,
					self.faceleft)
end
-->8


function musicnote()
	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00877800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00877800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111133111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111113331111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111311
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111311111311311
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111311111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111311133111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003311311113113311
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111113111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111133113311311
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111113111311
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001133111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001131111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111131111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111111111111
24442222244422224444444444444444000000000999999999999990000000004545545455555555f44444449fff999999992222000ddd000000000000000000
24442444242424444444444444444444999999990900090000900090000000005454454554444445ff4444449f9f9777a77f944400ddddd0000ddd00000ddd00
244424242444242444444444444444449aaaaaa90900090000900090000000005555555554444445fff444442fff97a7a77f942400dd45d000ddddd000ddddd0
24242444244424444444444444444444999999990977777007777790000000005454454554444445ffff444424ff9777a7af944400dd460000dd45d000dd45d0
244424442222244444444444444444449aaaaaa90976777997776790000000005454454554444445fffff44422999777a77f944400d4440000dd460000dd4600
222224442444244444444444444444449aaaaaa90f77677ff77677f0000000005555555554444445ffffff44244f9fff999994440ddd440000d4440000d44400
24442424242424444444444444444444999999990ffffffffffffff0555555555454454555555555fffffff424249fff9fff9424000d41000ddd44000ddd4400
24242444244424442222222244444444ffffffffff9ffffffffff9ff55555555454554545555555599999999244424442424244400061600000d4100000d4100
2444222224442444000000000000000044444444f9ffffffffffff9f5555555555000000555555954fffffff2444244424442222000616000006110000061600
2444244424442444000000000000000044444444ffffffffffffffff55555555550000005555559544ffffff2444244424442444000616000016611000011640
2444244424442444000000000000000044444444ffffffffffffffff000000555500000054444445444fffff2444244424442444000616000406661000416600
2444242424442444552222555555555544444444ffffffffffffffff0000005555000000544444454444ffff2444244424442424000646000006660400066600
2444244424442444542522444444444544444444ffffffffffffffff00000055550000005444444544444fff24442444244424440006660000dd660000566600
24242444242424245422524444454445444444440999999999999990000000555500000054444445444444ff24242424242424440006660000d0060000506600
244424242444244454222244454444454444444409000000000000900000005555000000544444454444444f24442444244424240000d0000000050000000d00
2222244422222444542fff44444244459222222299000000000000990000005555000000555555552222222922222444222224440000dd000000055000000dd0
00000222220000005422224444444445ffffffffffffffff4455dd55d5555554000ddd000000000000000000000ddd0000000000000000000000011111000000
00022222222220005444444444444445ffffffffffffffff4555dd55ddd5555400d44dd0000ddd00000ddd0000ddddd0000ddd00000ddd000000111111110000
00222eeeeeee22005555555555555555ffffffffffffffff4555dd5dddd5555400d545d000d44dd000d44dd000ddddd000ddddd000ddddd00001111111111000
022ee222222ee220500000000000000599999999999999994dd5dd55555d55540006460000d545d000d545d000dddd0000ddddd000ddddd00011111221111000
02ee22222222e220500000000000000594552ff441152f294ddddd55555ddddd00d44400000646000006460000ddddd0000ddd00000ddd000111144444111110
02e222222222ee20500000000000000594552ff441152f294ddddd5555500ddd0dd4440000d4440000d44400000d4ddd000dddd0000dddd01111444444441111
22e2222222222e22000000000000000094552ff441152f2945550000000055d4006141600dd444000dd4440000044400000d4ddd000d4ddd1112222222222111
22e2222222222e220000000000000000999999999999999945550000000055540016161000614160006141600066666000644460006444601144444444444420
22e2222222222e2245550000000055549ff452125524411945550000000055540016161000161610001616100016661000166610001666100244444444444420
22e2222222222e22ddd00000000005549ff4521255244119ddd00000000005540016661000166604040666100016661000166604040666100222222222222220
02ee222222222e22ddd0004000000dd49ff4521255244119ddd0004000000dd40046664000166600000666400046664000166600000666400244555544444420
022e22222222e2204d50044404440ddd99999999999999994d50044404440ddd0006660000466600000666000006660000466600000666000244555544444420
002eee22222ee22055514444144415549241552242f54129555144441444155400066600000566000006650000066600000d660000066d000222555922222220
00222eee22ee220055512241114215549241552242f54129555122411142155400066600000506000006050000066600000d060000060d000244555544444420
0000222eee220000dd51221111221dd49241552242f54129dd51221111221dd4000d0d0000000d00000d00000005050000000500000500000244555544444420
0000002222200000ddd1111111111ddd9999999999999999ddd1111111111ddd000d0d0000000d00000d00000005050000000500000500000222555522222220
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3f3e3f3f3
e3f3e2f2e3f300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2f2e2f2e2
f3e2f2e2f2e200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3f3e3f3f2
f2e3f3e3f3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e2f2e2f2e2
f2e2f2e2f2e200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e3f3e3f3e3
f3e3f3e3f3e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000101004000000000000000000000000001010000000000000000000000000000000000000000000000808000000000000000000000000000008080
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
4747474700474747474747474747470000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434358434344434343434443430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
424546435864655a4a5452535a4a540000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
50555650497475404b4c6263414b4c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4060614159505150404140415150510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5070715141505140415150514140410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4747474747404147474747474747470000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343505143434343666743430000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6464654242404142424242767742420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7474755150505151404150606140410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041404140414041505140707150510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5051505150514041505150515051500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4041404140415051404140414040410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0048480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002e2f2f2e2f2e2f2e2f2f2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e3f2e3e3f3e3f3e3f3e3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002e2f2f2e2f3f2f6e6f2e2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003e3f2e3e3f2f3f7e7f3e3f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002e2f2e2f2f2e2f3f2f2e2f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300002576225762257622576225762257622576225762257002570025700257002570025700257002570000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300002976229762297622976229762297622976229762297002970029700297002970029700297002970024002000000000000000000000000000000000000000000000000000000000000000000000000000
010300002a7622a7622a7622a7622a7622a7622a7622a7622a7002a7002a7002a7002a7002a7002a7002a70000002000000000000000000000000000000000000000000000000000000000000000000000000000
010300002c7622c7622c7622c7622c7622c7622c7622c7622c7002c7002c7002c7002c7002c7002c7002c70000000000000000000000000000000000000000000000000000000000000000000000000000000000
0140000019330000001c330002001b33000200143300020019330002001c330002001e33000300183300030019330003001c330003001b33000300143300030019330003001c330003001e330003001833000000
014000000d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d2300d230
014000000000000000000000000000000000000000000000000000000000000000000000000000000000000025230252302523025230252302523025230252302523225232252322523225232252322523225232
014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003122231222312223122231222312223122231222
01400000195301953020530205301e5301e53020530205301c5301b530195301b5301e5321e5321b5321b532195301953020530205301e5301e53020530205301c5301b530195301b53019530195301953019530
0140020019555010002055514000235552255520555140002355525555225551e555205550000000000000002355525555225551e555205551c55519555000001c5551e5551b5551755519555000000000000000
0140000019720197201c7201c7201b7201b720147201472019720197201c7201c7201b7201b720147201472019720197201c7201c7201b7201b720207202072019720197201c7201c7201b7201b7201472014720
0140000019575005001c575000001b57500000145750000019575005001c575000001b57500000145750000019575005001c575000001b57500000205750000019575005001c575000001b575000001457500000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800000000000000000000000000000000000000000000000000000035450000003f45000000000000000000000164501b45022450284503545000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 04414040
00 04050607
02 04060708
01 0b494748
01 0a094040
02 0b0a4040
00 00000000
00 00000000
00 00004000
00 00000000
00 00000000
02 04060708
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000
00 00000000

