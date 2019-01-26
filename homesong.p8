pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
	singing = false
	vollow = false
	songlist =
	{
 	{0,1,2,3},
 	{0,0,0,0}
	}
	match = nil

	player = {}
	world = {}
	player.x=64
	player.y=64
	player.spd=1

	play_inside(64)
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
 		sfx(0,3)
 	end
 	if btn(1) then
 		sfx(1,3)
 	end
 	if btn(2) then
 		sfx(2,3)
 	end
 	if btn(3) then
 		sfx(3,3)
 	end
 	
		songs()
	else
		singing = false
		notes = {}
		match = nil
		move_player()
	end
end

function move_player()
	player.vx = 0
	player.vy = 0
	if (btn(0)) player.vx = -player.spd
	if (btn(1)) player.vx = player.spd
	if (btn(2)) player.vy = -player.spd
	if (btn(3)) player.vy = player.spd

	player.x += player.vx
	player.y += player.vy
end

function _draw()
 cls()
 print ("matching song: ",0,40,10)
 print (match,60,40,10)
 for i = 1,#notes do
 	print(notes[i], 0, 40+10*i, 12)
 end

 --draw player
	spr(0,player.x,player.y)
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
 for s=4,7 do
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
 setvol(4,7)
 setvol(5,3)
 setvol(6,3)
 setvol(7,2)
 setvol(8,5)
 setvol(9,5)
 setvol(10,2)
 setvol(11,5)
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
244422222444222244444444444444440000000009999999999999900000000000000000f44444444444444400000000000000009fff99999999222200000000
244424442424244444444444444444449999999909000900009000900000000000000000ff4444444444444400000000000000009f9f9777a77f944400000000
244424242444242444444444444444449aaaaaa909000900009000900000000000000000fff444444444444400000000000000002fff97a7a77f942400000000
242424442444244444444444444444449999999909777770077777900000000000000000ffff444444444444000000000000000024ff9777a7af944400000000
244424442222244444444444444444449aaaaaa909767779977767900000000000000000fffff44444444444000000000000000022999777a77f944400000000
222224442444244444444444444444449aaaaaa90f77677ff77677f00000000000000000ffffff44444444440000000000000000244f9fff9999944400000000
24442424242424444444444444444444999999990ffffffffffffff00000000000000000fffffff444444444000000000000000024249fff9fff942400000000
24242444244424442222222244444444ffffffffff9ffffffffff9ff000000000000000099999999922222220000000000000000244424442424244400000000
2444222224442444000000000000000000000000f9ffffffffffff9f00000000000000004fffffff000000000000000000000000244424442444222200000000
2444244424442444000000000000000000000000ffffffffffffffff000000000000000044ffffff000000000000000000000000244424442444244400000000
2444244424442444000000000000000000000000ffffffffffffffff0000000000000000444fffff000000000000000000000000244424442444244400000000
2444242424442444552222555555555500000000ffffffffffffffff00000000000000004444ffff000000000000000000000000244424442444242400000000
2444244424442444542522444444444500000000ffffffffffffffff000000000000000044444fff000000000000000000000000244424442444244400000000
242424442424242454225244444544450000000009999999999999900000000000000000444444ff000000000000000000000000242424242424244400000000
2444242424442444542222444544444500000000090000000000009000000000000000004444444f000000000000000000000000244424442444242400000000
2222244422222444542fff4444424445000000009900000000000099000000000000000022222229000000000000000000000000222224442222244400000000
00000222220000005422224444444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00022222222220005444444444444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222eeeeeee22005555555555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022ee222222ee2205000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02ee22222222e2205000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02e222222222ee205000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22e2222222222e220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22e2222222222e220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22e2222222222e220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22e2222222222e220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
02ee222222222e220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
022e22222222e2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002eee22222ee2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00222eee22ee22000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000222eee2200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000022222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000101000000000000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000004343434443434343000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000045464259494a5253000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000555640404d4e6263000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000404150505d5e5051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004041404140414041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000005060615150515051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000004070714140414041000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000005051505150515051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010300000e0500e0500e0500e0500e0500e0500e0500e0500c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001105011050110501105011050110501105011050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001505015050150501505015050150501505015050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001705017050170501705017050170501705017050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0140000019770000001c770000001b77000000147700000019770000001c770000001e77000000187700000019770000001c770000001b77000000147700000019770000001c770000001e770000001877000000
014000000d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d0300d030
014000000000000000000000000000000000000000000000000000000000000000000000000000000000000025030250302503025030250302503025030250302503225032250322503225032250322503225032
014000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003102231022310223102231022310223102231022
01400000195301953020530205301e5301e53020530205301c5301b530195301b5301e5321e5321b5321b532195301953020530205301e5301e53020530205301c5301b530195301b53019530195301953019530
0140020019555010002055514000235552255520555140002355525555225551e555205550000000000000002355525555225551e555205551c55519555000001c5551e5551b5551755519555000000000000000
0140000019720197201c7201c7201b7201b720147201472019720197201c7201c7201b7201b720147201472019720197201c7201c7201b7201b720207202072019720197201c7201c7201b7201b7201472014720
0140000019555005001c555000001b55500000145550000019555005001c555000001b55500000145550000019555005001c555000001b55500000205550000019555005001c555000001b555000001455500000
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

