#
# Map of the basic adventure world:
#
#           Castle
#              |
# Entry -> Crossroads -> Lake
#              |
#           Village
#

def game

	### Define game environment ###

	$map = [
		[nil,      "castle",     nil   ],
		["forest", "crossroads", "lake"],
		[nil,      "village",    nil   ]
	]

	$startLocation = {
		"x" => 0,
		"y" => 1
	}

	$status = {
		"sword" => false,
		"armour" => false
	}
	
	### Navigation functions ###
	
	def initialiseLocation
		$currentLocation = {
			"x" => $startLocation["x"],
			"y" => $startLocation["y"],
			"name" => $map[$startLocation["y"]][$startLocation["x"]]
		}
		describe $currentLocation["name"]
	end

	def moveLocation moveX, moveY
		newX = $currentLocation["x"] + moveX
		newY = $currentLocation["y"] + moveY
		if newX >=0 && newY >=0 && newY < $map.length && location = $map[newY][newX]
			$currentLocation["x"] = newX
			$currentLocation["y"] = newY
			$currentLocation["name"] = location
			describe $currentLocation["name"]
		else
			puts "You can't go that way."
		end
	end

	### User-callable functions ###
	
	def check object
		case object
			when "map", "location"
				describe $currentLocation["name"]
			else
				take object
		end
	end
	
	def describe location
		viewpoint = (location == $currentLocation["name"]) ? "You are at " : "You can see "
		case location
			when "forest"
				puts viewpoint +"a dark forest. There is a path leading to the east."
			when "crossroads"
				puts viewpoint +"a crossroads. To the east you see the shores of a lake. You can hear the noise of a bustling village in the south. To the north, a magnificent castle towers over the trees of the forest."
			when "village"
				puts viewpoint +"the centre of a busy village."
				if $status["armour"] == false
					puts "The local smith has a magnificent set of armour on display but you do not have funds for it. Luckily, there are enough discarded pieces to form a complete set of armour that will fit you and the smith appears not to care if you take them."
				end
			when "lake"
				puts viewpoint +"a misty lake. It is silent, and the water is calm."
				if $status["sword"] == false
					puts "A mysterious hand has thrust itself up from the water, holding aloft a magnificent sword."
				end
			when "castle"
				puts viewpoint +"the approach to a grand castle. At the top of a tower, you see a unicorn jumping up and down to get your attention. The unicorn is in distress, and is clearly a prisoner who needs your help. A dragon guards the entrance to the castle... or is it a rabbit?"
			when "swallow"
				puts "What do you mean? An African or European swallow?"
			else
				puts "No, now go away or I shall taunt you a second time!"
		end
	end

	def go direction
		case direction
			when "north", "n", "up"
				moveLocation(0, -1)
			when "east", "e", "right"
				moveLocation(1, 0)
			when "south", "s", "down"
				moveLocation(0, 1)
			when "west", "w", "left"
				moveLocation(-1, 0)
			else
				puts "No, we've got to find the Holy Grail. Come on."
		end
	end

	def take artefact
		case artefact
			when "sword", "weapon"
				if $status["sword"] == true
					puts "You can't expect to wield supreme executive power just because some watery tart threw a sword at you!"
				elsif $currentLocation["name"] == "lake"
					puts "You take the sword. But listen, strange women lyin' in ponds distributin' swords is no basis for a system of government. Supreme executive power derives from a mandate from the masses, not from some farcical aquatic ceremony."
					$status["sword"] = true
				else
					missing artefact
				end
			when "armour", "armor", "shield"
				if $status["armour"] == true
					puts "You've already got one, you see? I blow my nose at you, so-called Arthur-king, you and all your silly English knnnniggets."
				elsif $currentLocation["name"] == "village"
					puts "You take the pieces of armour. To assemble them, please consult the Book of Armaments, chapter two, verses nine through twenty-one. Or is that hand grenades?"
					$status["armour"] = true
				else
					missing artefact
				end
			when "shrub", "shrubbery"
				puts "You're in luck: you meet a shrubber. His name is Roger the Shrubber. He arranges, designs, and sells shrubberies."
			else missing artefact
		end
	end

	def fight creature
		if $currentLocation["name"] == "castle"
			case creature
				when "rabbit", "bunny"
					puts "I warned you, but did you listen to me? Oh, no, you knew, didn't you? Oh, it's just a harmless little #{creature}, isn't it? He did you up a treat, mate!"
					exit
				when "dragon", "serpent", "monster"
					if $status["sword"] == true && $status["armour"] == true
						puts "win"
						# "You only killed the bride's father, you know... what, you didn't mean to? You put your sword right through his head!"
						exit
					else
						puts "die"
						# "He was not at all afraid to be killed in nasty ways, brave, brave, brave, brave Sir Robin!"
						exit
					end
				else
					if $status["sword"] == true && $status["armour"] == true
						puts "That's no ordinary #{creature}! Your arm's off, but you live to tell the tale. 'Tis but a scratch!"
					else
						puts "You can't kill the #{creature}, you stupid bastard, you've got no arms left! It's just a flesh wound, you say..."
						exit
					end
			end
		else
			puts "Oh, what sad times are these when passing ruffians can say 'ni' at will to an old #{creature}!"
		end
	end

	def retreat
		puts "Yes, brave Sir Robin turned about, and valiantly, he chickened out! Bravely taking to his feet, he beat a very brave retreat. A brave retreat by brave Sir Robin!"
		initialiseLocation
	end
	
	### Input control functions ###
	
	def input
		print "> "
		return gets.chomp.downcase
	end

	def missing artefact
		puts "Oh, wicked, bad, naughty Zoot! She has been setting a light to her beacon, which, I've just remembered, is #{artefact} shaped. It's not the first time we've had this problem. There's no #{artefact} here!"
	end
	
	def error
		puts "I don't understand that."
	end

	### Main loop ###
	
	initialiseLocation
	while true
		command = input.split(" ")
		action = command[0]
		target = command[1]
		case action
			when "check"
				check target
			when "describe"
				describe target
			when "go", "move", "walk"
				go target
			when "take", "find"
				take target
			when "fight", "attack", "kill"
				fight target
			when "retreat", "run"
				retreat
			when "exit", "quit"
				puts "On second thought, let's not go to Camelot. It is a silly place."
				exit
			else error
		end
	end
	
end

# game

### Shim for automatic testing

def forest x, y
	game
end

forest 0, 0