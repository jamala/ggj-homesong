pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

function _init()
	singing = false
	songlist =
	{
 	{0,1,2,3},
 	{0,0,0,0}
	}
	match = nil
end

function _update()
	
 if btn(4) then
 	singing = true
 	
 	if btn(0) then
 		sfx(0,0)
 	end
 	if btn(1) then
 		sfx(1,1)
 	end
 	if btn(2) then
 		sfx(2,2)
 	end
 	if btn(3) then
 		sfx(3,3)
 	end
		songs()
	else
		singing = false
		notes = {}
		match = nil
	end
end

function _draw()
 cls()
 print ("matching song: ",0,40,10)
 print (match,60,40,10)
 for i = 1,#notes do
 	print(notes[i], 0, 40+10*i, 12)
 end
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


__sfx__
010300000e0500e0500e0500e0500e0500e0500e0500e0500c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001105011050110501105011050110501105011050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001505015050150501505015050150501505015050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010300001705017050170501705017050170501705017050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
