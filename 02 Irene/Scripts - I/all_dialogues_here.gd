extends Node


# INTERACTIONS ONE
var all_interaction_dialogue_sets = {
	# done
	"computer_amanda": {
		"start": {
			"lines": [
				"Oh. A Stranger!",
				"Got any questions?"
			],
			"options": [
				"I might need some help, O Mighty Amanda.",
				"Just a lil' troublemaker traversing around. Got some tips?",
				"AH! Talking computer!"
			],
			"next_states": ["help_me_o_mighty_one", "tippy_tricks", "ah_talking_computer"]
		},

		# help me o mighty one!
		"help_me_o_mighty_one": {
			"lines": [
				"Help of what kind, exactly?"
			],
			"options": [
				"What is my purpose here?",
				"Do you have any tips for me?"
			],
			"next_states": ["purpose_what_purpose", "tippy_tricks"]
		},

		# purpose? what purpose?
		"purpose_what_purpose": {
			"lines": [
				"To save this world and its inhabitants-",
				"Hold on, were you not informed?"
			],
			"options": [
				"I kinda just jumped in.",
				"I was, it's just that I'm still confused."
			],
			"next_states": ["the_chosen_one", "the_chosen_one"]
		},
		"the_chosen_one": {
			"lines": [
				"In that case, like I said before,\n\nYOU were chosen to save the person whose body you possess.",
				"Though only the higher powers can answer WHY you were chosen,\n\nI'd say that you're not a really bad choice."
			],
			"options": [
				"What about you, then?",
				"That's... surprisingly nice to hear."
			],
			"next_states": ["i_am_good_how_about_you", "nice_to_hear"]
		},
		"i_am_good_how_about_you": {
			"lines": ["Me?"],
			"options": ["Yeah. Why are you here?"],
			"next_states": ["why_you_here"]
		},
		"nice_to_hear": {
			"lines": ["Haha! Glad I can be of help."],
			# immediately goes to next line (the next state)
			"next_states": ["see_you_ending"]
		},

		# the trickster path
		"tippy_tricks": {
			"lines": ["Hmm. Have you tried picking up those spilled bottles over there?"],
			"options": ["Yes", "No"],
			"next_states": ["tried_the_bottles", "no_try_bottles"]
		},
		"tried_the_bottles": {
			"lines": ["That's good!"],
			# immediately goes to next line (the next state)
			"next_states": ["no_try_bottles"]
		},
		"no_try_bottles": {
			"lines": ["What about the tables? They may just contain the key out of this room."],
			"options": [
				"No, but I will.",
				"Have you got any other tips?"
			],
			"next_states": ["see_you_ending", "other_tips"]
		},
		"other_tips": {
			"lines": [
				"My school was once filled with students and teachers.",
				"Now all that's left are... hollow shells of our former selves.",
				"I beg you to never forget their past.",
				"They aren't just the monsters you may think they are..."
			],
			"options": ["Of course. You have my word."],
			"next_states": ["see_you_ending"]
		},

		# AH! TALKING COMPUTER?!
		"ah_talking_computer": {
			"lines": [
				"Oho, never seen one before? Worry not,\n\nI’m not just a talking computer,
				\n\nI’m an intelligent talking computer."
			],
			"options": [
				"Where did you even come from?!",
				"Oh, okay then... You got any tips?"
			],
			"next_states": ["why_you_here", "tippy_tricks"]
		},
		"why_you_here": {
			"lines": [
				"Technology. My life's tethered to this place.
				\n\nBut... without the people maintaining me, I'm as good as\n\ndead."
			],
			"options": [
				"Is there... any way for me to help you?",
				"But who are 'the people'? Is it-Oh, the zombies?"
			],
			"next_states": ["to_help_you", "the_people"]
		},
		"the_people": {
			"lines": ["Yes. Be careful of what you do with them. They were once human, after all."],
			"options":[
				"Ah, of course.",
				"Might you have any other tips?",
				"But would there be any way I can be of any help to you?"
			],
			"next_states": ["see_you_ending", "tippy_tricks", "to_help_you"]
		},
		"to_help_you": {
			"lines": ["Help... me?", "You truly want to... help me?"],
			"options": [
				"Yeah, of course!",
				"Pfft- You fell for that? Sorry, but inanimate objects don't have feelings!"
			],
			"next_states": ["really_help", "cruel_ending"]
		},
		"really_help": {
			"lines": [
				"Well that's very nice of you.",
				"The only way would be to... give me half of your life to set my soul free."
			],
			"options": [
				"I- Right. Equivalent exchange. Large price for a large wish. I... will.",
				"What? No!"
			],
			"next_states": ["great_ending", "cruel_ending"]
		},

		# endings
		"see_you_ending": {
			"lines": ["Then I shall see you around, Player."]
		},
		"great_ending": {
			# AAAND the player loses 1/2 health. Literally. But mora points + 20, a guaranteed entry to the 'good ending' in level 2.
			"lines": [
				"Thank you, Player. I will never forget this.",
				"Here's a tip for you. Think twice when choosing the right path.",
				"Goodbye now. May you find a way out of this hellhole."
			]
		},
		"cruel_ending": {
			"lines": [
				"There's always a steep price behind every choice.",
				"You are cruel, Player. I regret ever putting my hopes on you.",
				"Goodbye."
				]
			# AAAND the player loses 1/2 health, not the literal kind, unfortunately. Also -5 moral points.
		}
	},


#---------------------------------------------------------------------------------------------------
	# naked_statue
	"naked_statue_evil_enough": {
		"evil_enough": {
			"lines": [
				"Well well well.",
				"Look who we have here...\n\nA villain wannabe.",
				"Did you not heed any warnings, child?\n\nLives should not be wasted so easily."
			]
		},
		"know_nothing": {
			"lines": [
				"Tch. Too pure indeed.",
				"Only a true human knows how to navigate a cruel world.",
				"You clearly are too good for this world..."
			]
		},
		"little_statue": {
			"lines": [
				"Excuse me?! WELL NOW YOU'VE DONE IT!",
				"GET LOST, PLAYER!"
			]
		}
	},
	
	"naked_statue_just_enough": {
		"good_enough": {
			"lines": ["Hmm. I approve. You may enter."],
			"options": ["There's no... tests or tricks?"],
			"next_states": ["would_you_want_one"]
		},
		"would_you_want_one": {
			"lines": ["What? Do you want one?"],
			"options": ["Forget I ever asked", "Why not."],
			"next_states": ["never_mind", "why_not"]
		},
		"why_not": {
			"lines": ["You're an odd one. I'll pretend I didn't hear anything...\n\nJust go in, won't you?"],
			"options": ["Go in where?", "Ugh, fine."],
			"next_states": ["where", "never_mind"]
		},
		"where": {
			"lines": ["The door next to me! Are you blind?"],
			"options": ["No..."],
			"next_states": ["never_mind"]
		},
		"never_mind": {
			"lines": [
				"That's what I thought. You may enter now.",
				"I wish you... the best luck I can ever give."
			]
		}
	},
	
	"naked_statue_too_good": {
		"too_good":{
			"lines": [
				"Oh goodness me!",
				"What are you, God's favourite human?",
				"Good God, you're too pure for this world..."
			],
			"options": [
				"Do I look like I know what I'm doing?",
				"And you're just a little statue! What do you know about the world?"
			],
			"next_states": ["know_nothing", "little_statue"]
		},
	},
	
	"naked_statue_meh": {
		"meh": {
			"lines": [
				"What.",
				"Come back when you're useful."
			],
			"options": [
				"What? Have I not done enough?"
			],
			"next_states": ["not_done_enough"]
		},
		"not_done_enough": {
			"lines": [
				"Clearly not.",
				"Now shoo!"
			]
		},
	},


# finished
#---------------------------------------------------------------------------------------------------
	"skeleton_statue_good_enough_yay": {
		"good_enough": {
			"lines": ["WOW!\n\nWhat an exemplary player!"],
			"options": ["Oh, thank... you?", "I know, I'm the best!"],
			"next_states": ["thanks", "i_am_the_best"]
		},
		"thanks": {
			"lines": [
				"You're very much welcome.",
				"We always reward those who are dilligent and compassionate.",
				"We hope you find what you need inside, Player."
			]
		},
		"i_am_the_best": {
			"lines": [
				"You are quite confident, are you?",
				"We think confidence is great, Player.",
				"However...",
				"Too much of it may lead to grievous consequences.\n\n
				We recommend you to try some humility to balance it out.",
				"Other than that,\n\nGood luck on your journey, Player.",
				"We hope you can find what you need inside."
			]
		}
	},
	
	"skeleton_statue_too_bad": {
		"too_bad": {
			"lines": [
				"OH MY!\n\nMy apologies, Player, but you have too much blood on your hands.",
				"We're afraid you may not enter,\n\nthe tiles have been pristine since the day this world was created."
			],
			"options": ["Aw, come on!", "I've barely killed anyone!", "It's unfair!"],
			"next_states": ["come_on", "barely_killed_anyone", "unfair"]
		},
		"come_on": {
			"lines": [
				"Rules are rules, Player. You should've heeded the warning.",
				"These people may look green and gross on the outside, but they are human, still.",
				"It's quite unfortunate, oh! Quite unfortunate indeed."
			],
			"options": ["I'm suing you!", "You're the one who brought me here in the first place."],
			"next_states": ["sue", "who_brought_me_here"]
		},
		# make a second one where it's 'too many' instead of 'one too many' for if bad moral points >= 3
		"barely_killed_anyone": {
			"lines": [
				"Is that right?",
				"Still, you've killed one too many.",
				"We do not appreciate those who killed one of us.",
			],
			"options": ["That's not fair!", "I've come too far... I can go further."],
			"next_states": ["unfair", "go_further"]
		},
		"unfair": {
			"lines": ["Life rarely is fair...", "Now,\n\nI think it's best if you leave, Player."]
			# END
		},
		"sue": {
			"lines": [
				"Well now you've gone and done it...",
				"[A menacing aura starts to surrorund you.]",
				"Get lost, Player! You are most unwelcome here."
			]
			# END
		},
		"who_brought_me_here": {
			"lines": ["That's a rather illogical argument, is it not?\n\nOr was it not you who agreed to come?"],
			"options": ["But you still picked me!"],
			"next_states": ["picked_me_still"]
		},
		"picked_me_still": {
			"lines": [
				"...And that's something we wonder to this day...",
				"I believe it's best for you to leave, now."
			]
			# END
		},
		"go_further": {
			"lines": [
				"What do you mean, Player?",
				"[The statue let out a hearty laugh]",
				"Surely you're not insinuating that you'll KILL me as you killed our brethren, are you,\n\nPlayer?"
			],
			"options": [
				"And what if I am...?",
				"Of course not.\n\n[A terrible glem appears in your eyes]",
				"Tch. This won't be the last you'll see of me!"
			],
			"next_states": ["yeah_for_sure", "still_will_kill_you", "give_up"]
		},
		"yeah_for_sure": {
			"lines": [
				"You wouldn't dare.",
				"You simply- AUGH!"
			],
			"options": ["Didn't see that coming, did you?"], # Age of Ultron reference whoopsies
			"next_states": ["still_will_kill_you"]
		},
		"still_will_kill_you": {
			"lines": [
				"[You twist the knife deeper into the statue]",
				# sorry! no animation, haha, just ✨imagination✨
				"ACK! You little...!",
				"[You can hear distinct coughing somewhere.]",
				"You... will regret this...",
				"[You have successfully killed the statue.]",
				"[Consequences has been rewarded for this.]",
				"[Karma... never forgets.]"
			]
			# END!
		},
		"give_up": {
			"lines": ["Of course, of course.", "And this shan't be the last you see of us either."]
		}
	},


#---------------------------------------------------------------------------------------------------
	"not_yet_door_statue": {
		"start": {
			"lines": [
				"Have you placed all the required items?"
			],
			"options": [
				"What items?",
				"I've placed items on the tables!",
				"What are you even talking about?"
			],
			"next_states": ["confusion_what_items", "already_placed_items", "what_are_you_on_about"]
		},
		
		"confusion_what_items": {
			"lines": [
				"Look around you!",
				"Go and explore\n\nWho knows, there might be some sneaky ones hiding beehind some things..."
			]
		},
		
		"already_placed_items": {
			"lines": [
				"Oh, is that so?\n\nTry to change up their order, then.",
				"You know, maybe try to place a special one in the middle."
			],
			"options": [
				"I guess I will.",
				"I did! Can I leave now?",
				"Why am I even doing this anyway?!"
			],
			"next_states": ["best_of_luck", "can_i_not_leave", "what_are_you_on_about"]
		},
		"can_i_not_leave": {
			"lines": [
				"Hmm... Let us check...",
				"[Checking...]",
				"Oh nope!\n\n It's still a bit wrong, sorry."
			],
			"options": ["WHAT?!", "Then can I get some tips, please?"],
			"next_states": ["wuttt", "tips_please"]
		},
		"wutt": {
			"lines": ["Sorry!\n\n:D"],
			"next_states": ["best_of_luck"]
		},
		"tips_please": {
			"lines": ["Ah, of course!", "...For the right price, that is."],
			"options": ["What is this, a cashgrab?", "Definitely not!", "Alright, how much?"],
			"next_states": ["well_suit_yourself_then", "well_suit_yourself_then", "how_much"]
		},
		"how_much": {
			"lines": [
				"Oh? But I was joking...",
				"Ah, ah!\n\nBefore you protest, how 'bout I offer you a deal:",
				"5 health for a clue,\n\n10 for a pointer,\n\nor 20 for a full guide.\n\nWhat say you, Player?"
			],
			"options": [
				"I'll pay 5.",
				"I want the 10.",
				"I'm rich enough for 20.",
				"What?! That's not money! Never mind then."
			],
			"next_states": ["the_five", "the_ten", "the_twenty", "well_suit_yourself_then"]
		},
		"the_five": {
			"lines": ["Okay.\n\nDon't waste your water."],
			"next_states": ["best_of_luck"]
		},
		"the_ten": {
			"lines": ["Right.\n\nThe proportions of the objects on the tables should be 2 : 1."],
			"next_states": ["best_of_luck"]
		},
		"the_twenty": {
			"lines": [
				"Aha! Yes.\n\nWhat a long and healthy life you have, Player!",
				"Have your price's worth:\n\nJust find and give us the key!"
			],
			"options": ["That's... it?", "Okay. Thank you for all your help.", "What key? Where?!"],
			"next_states": ["that_should_not_be_it", "thanks_for_all", "key_what_where"]
		},
		"that_should_not_be_it": {
			"lines": ["If you don't like it, you shouldn't have taken it, then!"],
			"next_states": ["best_of_luck"]
		},
		"thanks_for_all": {
			"lines": ["No, thank YOU, Player."],
			"next_states": ["best_of_luck"]
		},
		"key_what_where": {
			"lines": ["Keep your eyes peeled. Maybe you just missed it.",],
			"options": ["I couldn't have missed it though!"],
			"next_states": ["could_not_have_missed_it"]
		},
		"could_not_have_missed_it": {
			"lines": [
				"Well we don't know! We've never found the key either!",
				"You don't have to put anything on the table, actually."
			],
			"options": ["WHAT! Trickery!"],
			"next_states": ["i_was_tricked"]
		},
		"i_was_tricked": {
			"lines": ["Whoops, but what can we do? Apologize for trying to save this world?"],
			"options": ["But- That's-", "Is there no other way of saving this world?"],
			"next_states": ["butt_that", "there_are_other_ways_of_persuasion"]
			# sorry, couldn't resist the EPIC reference ehe
		},
		"butt_that": {
			"lines": ["Well, regardless!"],
			"next_states": ["best_of_luck"]
		},
		"there_are_other_ways_of_persuasion": {
			"lines": ["Hmm, there is... A way.", "Don't think you'll like it, though."],
			"options": ["spill"],
			"next_states": ["spill_please"]
		},
		"spill_please": {
			"lines": [
				"Well alright!\n\nYou can try to solve the puzzle to save this world, yes...",
				"But a true sacrifice can ALSO right the wrongs of this world.",
				"It's been much too long since we last spoke with someone.\n\nLonger than a Gin being stuck in their wish-bottles",
				"That's why we're so eager to talk to you!",
				"Ah, apologies, Player. We've rambled too far..."
			],
			"options": [
				"Oh, uh.\n\nI think I've had my share of sacrifices, thank you.",
				"I see...\n\nIf that's so, then I want to help.."
			],
			"next_states": ["well_suit_yourself_then", "i_will_help"]
		},
		"i_will_help": {
			"lines": ["Are you absolutely sure?", "This is your life we're talking about here, Player."],
			"options": ["Yes!", "No..."],
			"next_states": ["yes_absolutely", "nope_sorry_i_value_life"]
		},
		"yes_absolutely": {
			"lines": [
				"Wow, I-\n\nWe are forever grateful for your sacrifice, Player.",
				"You are a kind soul. Kinder than every other we've never seen thus far.",
				"Thank you for-"
			],
			"options": ["Wait- Other? What do you mean by that?!"],
			"next_states": ["others_le_gasp"]
		},
		"others_le_gasp": {
			"lines": ["Ah. I misspoke."],
			"options": ["You've got to tell me now!"],
			"next_states": ["tell_me_now"]
		},
		"tell_me_now": {
			"lines": [
				"Do you think-?",
				"[You can hear two people arguing in the distance]",
				"Very well. We shall tell you.",
				"You were not the first who traveled here.\n\nNot the first we've summoned.",
				"Yet I believe that you are indeed, the best of your kind.\n\nNo, WE know so. You are the kindest to us."
			],
			"options": ["That's really nice of you to say!"],
			"next_states": ["real_nice_of_you"]
		},
		"real_nice_of_you": {
			"lines": [
				"Anything for our saviour.",
				"Now...",
				"[There's... crying? Someone's crying in the distance!]",
				"Best of luck on your next journey, Player. We will never forget this."
			]
		},
		"nope_sorry_i_value_life": {
			"lines": ["That's alright."],
			"next_states": ["best_of_luck"]
		},
		
		"what_are_you_on_about": {
			"lines": [
				"One cannot leave the room without a token.",
				"Have you checked that you can put items on the tables?"
			],
			"options": [
				"What items?",
				"Yes, but it's still not working...",
				"No, that's not what I meant!"
			],
			"next_states": [
				"confusion_what_items",
				"already_place_items",
				"if_not_then_what"
			]
		},
		"if_not_then_what": {
			"lines": ["What did you mean, then?"],
			"options": ["Why am I here?"],
			"next_states": ["why_am_i_here"]
		},
		"why_am_i_here" :{
			"lines": [
				"Did you not listen when you entered this world?",
				"Or did you not talk to the Amanda Computer?"
			],
			"options": [
				"I talked to the Amanda Computer, but this is the first time\n\nI've ever heard of something like this!",
				"Nope, and who?",
				"But still! Why was I chosen? Why not someone else?"
			],
			"next_states": ["regardless", "regardless", "still_why_me"]
		},
		"regardless": {
			"lines": ["Well, regardless.\n\nYou were chosen here because you were something extraordinary."],
			"next_states": ["we_thought"]
		},
		"still_why_me": {
			"lines": ["You're something extraordinary, that's for sure."],
			"next_states": ["we_thought"]
		},
		"we_thought": {
			"lines": [
				"We thought...\n\nWe thought that you could've saved the person\n\nwhose body you are possessing now.",
				"We hope you'll succeed, Player."
			],
			"options": [
				"I hope so too...",
				"I won't let you down.",
				"I just want to go back home!",
				"And some tips, maybe?"
			],
			"next_states": ["only_hope", "never_gonna_let_you_down", "just_wanna_go_home", "tips_please"]
			# Sorry! I'm a terrible sucker for memes... ehe
		},
		"only_hope": {
			"lines": ["Don't be like that, Player!\n\nYou're the Amazing Player, after all!", "And, um..."],
			"next_states": ["never_gonna_let_you_down"]
		},
		"just_wanna_go_home": {
			"lines": ["And you will. That choice is yours to decide."],
			"next_states": ["never_gonna_let_you_down"]
		},
		"never_gonna_let_you_down": {
			"lines": ["Thank you."],
			"next_states": ["best_of_luck"]
		},
		
		"sacrificial_option": {
			"lines": [
				"placeholder here"
			]
		},
		
		# THE ENDINGS
		"well_suit_yourself_then": {
			"lines": ["Well, suit yourself then."],
			"next_states": ["best_of_luck"]
		},
		"best_of_luck": {
			"lines": ["Best of luck, Player.\n\nCome back once you're done."]
		},
	},
	
	"key_found_door_statue": {
		"start": {
			"lines": [
				"Thank you for the key, Player.",
				"Would you like to leave now, or would you like to save this world, before that?"
			],
			"options": ["Eh? Giving you the key won't save the world?", "I'd like to leave, please."],
			"next_states": ["key_no_save_question_mark", "a_ticket_to_leave_please"],
		},
		
		"key_no_save_question_mark": {
			"lines": [ # when I say this one has a lot, I meant: A LOOOOOOOT
				"Of course not! There's extra steps for that.",
				"See here, this world was once like yours, you see.\n\nSo bright and full of life.",
				"But one day, when a class' chemical experiment gone wrong...",
				"And a disease started to spread, infecting just about the whole world.",
				"So we call you here, to save our last, dying survivor.",
				"We get miserable and lonely too, you know...\n\nIt's not easy, watching everything you've ever created slowly die.",
				"Yeah, well. Enough sad stuff, let's get to the fun stuff!"
				# cutting it here and continuing in a new state
			],
			"next_states": ["to_save_this_world"]
		},
		"to_save_this_world": {
			"lines": [
				"To save this world,\n\nyou would have to place three certain things on those tables in front of us.",
				"And don't ask where the tables are.\n\nWe've got enough of your attitude, Player.",
				"Now go, and good luck. The choice is in your hands."
			]
			# ENDS
		},
		
		"a_ticket_to_leave_please": {
			"lines": ["Very well, Player. Thank you for saving this person's life."],
			"options": ["I... did?", "Anytime!\n\nThat's what players do, after all."],
			"next_states": ["did_what_now", "anytime"]
		},
		"did_what_now": {
			"lines": [
				"It was written at the start! Did you not see?",
				"Oh, never mind that!\n\nYour mission, from the start, was to save this person's life;
				\n\nwhose body you are possessing right now.",
				"A strong survivor, that one.",
				" I'll let you know, that body's owner fought like no other survivor.\n\nQuite admirable, I'd say.",
				"And quite a shame that the room\n\nbarely had enough oxygen to preserve their dying life force...",
				"Ahem.",
				"Now that that's all cleared, would you like some clues to save this world?",
			],
			"options": ["Yes please.", "Now just wait a minute; what do you mean by 'possess'?!", "I think I'm good."],
			"next_states": ["to_save_this_world", "le_gasp_possess", "very_well_then"]
		},
		"le_gasp_possess": {
			"lines": [
				"Yes. Soul possession.\n\nThere wouldn't have been any other way for you to enter this world.",
				"Try not to think of the theory behind it too much, Player.\n\nAll you have to know is that it's done.",
				"Ok, so. Would you stil like to save this world?"
			],
			"options": ["Yes, but I would like some directions, please.", "I want to return."],
			"next_states": ["to_save_this_world", "very_well_then"]
		},
		"very_well_then": {
			"lines": ["Very well, then."]
			# ENDS
		},
		"anytime": {
			"lines": ["Hahaha!\n\nWe wish you luck on your next journey, Player."]
		}
	},
	
	"solved_puzzle_door_statue": {
		"start": {
			"lines": [
				"You're amazing, Player, you've done it!",
				"You've saved this world!\n\nWe are forever grateful for your help.",
				"Thank you for everything, Player, and we hope to see you soon!"
			],
			"options": ["Wait! Is that it"],
			"next_states": ["that_it"]
		},
		"that_it": {
			"lines": ["Hmm?"],
			"options": ["I've done it all? Is this... the end of the journey?"],
			"next_states": ["is_this_the_end"]
		},
		"is_this_the_end": {
			"lines": ["Hohoho, were you hoping for more?", "If that's so...", ":D"]
		}
	}
	# other item interactions can be stored here :D
}



# ENDING DIALOGUES - note, this will be significantly shorter!
# why not. it'll complain otherwise...
enum Speakers {
	H,
	I
}

var all_endings_dialogues_set = {
	# GOOD ENDING
	"good_ending": {
		"start": {
			"lines": [
				{"speakers": Speakers.H, "line": "And that's a wrap! Oh, what a roller coaster of a ride!"},
				{"speakers": Speakers.I, "line": "Couldn't agree with you more. I loved this one."},
				{"speakers": Speakers.H, "line": "Quite unfortunate that their adventure had ended..."},
				{"speakers": Speakers.I, "line": "Yes, quite."},
				{"speakers": Speakers.I, "line": "There are so much left to explore!"},
				{"speakers": Speakers.I, "line": "I want the Player to experience them all!"},
				{"speakers": Speakers.H, "line": "The thirst for more exists in everyone, it seemed."},
				{"speakers": Speakers.I, "line": "Everyone but the Player, you mean.\n\nThis one's hasn't experienced it all!"},
			
			]
		},
		
		# just so i can copy paste easily
		"spare": {
			"lines": [
				{"speakers": Speakers.H, "line": ""},
				{"speakers": Speakers.I, "line": ""},
			]
		}
	},
	
	# BAD ENDING
	"bad_ending": {
		"start:": {
			"lines": [
				{"speaker": Speakers.H, "line": "So... the Player succeeded."},
				{"speaker": Speakers.I, "line": "Quite an unexpected result, indeed.\n\nWhatever did we do wrong?"},
				{"speaker": Speakers.H, "line": "Maybe we should've added more enemies!\n\nThe more the merrier!"},
				{"speaker": Speakers.I, "line": "Certainly wouldn't have hurt."}
			],
			"options": ["What are you-?", "Hey, I'm here too, you know!"],
			"next_states": ["indignant", "i_am_here"]
		},

		"indignant": {
			"lines": [
				{"speaker": Speakers.H, "line": "Hmm... Did you hear anything?"},
				{"speaker": Speakers.I, "line": "Nope.\n\nMust've been the wind."},
				{"speaker": Speakers.I, "line": "Anywho. I think we should redo this."},
				{"speaker": Speakers.H, "line": "Most definitely, I don't think it's-"},
			],
			"options": [
				"But I didn't do anything wrong!",
				"You're the one who summoned me here.\n\nIt's not my fault I'm not up to your standards.",
				"HEY! LISTEN TO ME YOU DEAF IDIOTS!"
			],
			"next_states": ["nothing_wrong", "totally_your_fault", "you_fool"]
		},
		"nothing_wrong": {
			"lines": [
				{"speakers": Speakers.I, "line": "Are you for real?"},
				{"speakers": Speakers.H, "line": "You don't remember ever killing anybody?!"},
			],
			"options": [
				"I have always been courteous.",
				"Just a couple of monsters!",
				"I had to do what I did to survive.\n\nThus was my mission."
			],
			"next_states": ["always_courteous_that_is_questionable", "monsters_what_monsters", "mission_is_it"]
		},
		"always_courteous_that_is_questionable": {
			"lines": [
				{"speakers": Speakers.I, "line": "Do we... trust that?"},
				{"speakers": Speakers.H, "line": "Most definitely not."},
				{"speakers": Speakers.I, "line": "So..."},
				{"speakers": Speakers.I, "line": "Extermination time?"},
				{"speakers": Speakers.H, "line": "YES!"},
				{"speakers": Speakers.I, "line": "Let's just get this over and done with."},
			],
			"options": [
				"No, WAIT-",
				"-I'M NOT READY TO-"
			],
			"next_states": ["secret_ending_bad_ending", "secret_ending_bad_ending"]
		},
		"monsters_what_monsters": {
			"lines": [
				
			]
		},
		# when I said happy-ish ending, this is the one ⬇️
		"mission_is_it": {
			"lines": [
				
			]
		},
		"totally_your_fault": {
			"lines": [
				{"speakers": Speakers.H, "line": "I'm sorry..."},
				{"speakers": Speakers.I, "line": "But [i]you're[/i] the one who [i]chose[/i] to entered this world."},
				{"speakers": Speakers.H, "line": "Your argument does not have any merit, I'm afraid."},
				{"speakers": Speakers.I, "line": "It means it's quite stupid, and that you're a doofus."},
				{"speakers": Speakers.H, "line": "Hey! We speak corteously to humans."},
				{"speakers": Speakers.I, "line": "Not evil ones, though,"},
				{"speakers": Speakers.H, "line": "You make a good point..."},
				{"speakers": Speakers.H, "line": "I will too, then!"},
				{"speakers": Speakers.I, "line": "Ah, wait, no-"},
				{"speakers": Speakers.H, "line": "(This one takes a deep breath, and then-) YOU LITTLE ******"},
				{"speakers": Speakers.I, "line": "I'm afraid we have to stop this here, Player."},
				{"speakers": Speakers.H, "line": "-LITTLE ***** *** ************* **** **"},
				{"speakers": Speakers.I, "line": "Now, begone!"},
				{"speakers": Speakers.I, "line": "I hope you reflect on your actions here. Remember, Karma-"},
				{"speakers": Speakers.H, "line": "*stops the tirade for a moment\n\n-NEVER FORGETS-*continues the tirade"},
			]
			# END
		},

		"i_am_here": { # OH LOOK! Another reference, ehe. To an anime this time :)
			"lines": [
				{"speakers": Speakers.H, "line": "Who-"},
				{"speakers": Speakers.I, "line": "Pssh, look, over there!"},
				{"speakers": Speakers.H, "line": "What the?! Who invited [i]that[/i] bum?"},
				{"speakers": Speakers.I, "line": "I'm guessing it's no one."},
				{"speakers": Speakers.I, "line": "Now, don't you know eavesdropping is bad, little Player?"},
				{"speakers": Speakers.H, "line": "How horrible!\n\nnThey've been destorying our world and killing our little creations;
				\n\nand now, tresprassing to our [i][color=red]sacred place[/color][/i]?!"},
				{"speakers": Speakers.I, "line": "Destructive [b]AND[/b] disrespectful."},
				{"speakers": Speakers.I, "line": "I propose we get rid of them\n\n
				before they accidentally hear a secret of this world..."},
				{"speakers": Speakers.H, "line": "Yes, most definitely."},
				{"speakers": Speakers.H, "line": "Nighty-night, Player!"},
			],
			"options": [
				"No, WAIT-",
				"-I'M NOT READY TO-"
			],
			"next_states": ["secret_ending_bad_ending", "secret_ending_bad_ending"]
		},

		"you_fool": {
			"lines": [
				{"speaker": Speakers.H, "line": "Deaf..."},
				{"speaker": Speakers.I, "line": "...idiots?"},
				{"speaker": Speakers.H, "line": "This little...dares to-"},
				{"speaker": Speakers.I, "line": "Oho! You're getting it [i]now[/i]."},
				{"speaker": Speakers.H,
				 "line": "[font_size=32]WE ARE THIS WORLD'S CREATORS!\n\nHOW DARE YOU, A PUNY HUMAN, INSULT US?![/font_size]"},
				{"speaker": Speakers.I,
				 "line": "[color=red]An insult to us is an insult to this world.\n\nI cannot let such an offense slide.[/color]"},
				{"speaker": Speakers.H,
				 "line": "WE BANISH YOU TO THE OBLIVION, PLAYER!\n\nTHE PRIVILEGRE OF CHOOSING YOUR AFTERLIFE
					\n\nSHALL [i]NEVER[/i] BE GIVEN TO YOUOU!"},
				{"speaker": Speakers.I, "line": "[color=red]Goodbye.[/color]"},
				{"speaker": Speakers.H, "line": "KARMA-"},
				{"speaker": Speakers.I, "line": "-[i]Never[/i] forgets."}
			],
			"options": [
				"No, WAIT-",
				"-I'M NOT READY TO-"
			],
			"next_states": ["secret_ending_bad_ending", "secret_ending_bad_ending"]
		},

		# All road leads to ROME; and var ROME = this below ⬇️
		# ...I might just make one lead to a 'happy ish' ending, I suppose.
		"secret_ending_bad_ending": {
			"lines": [
				{"speaker": Speakers.H, "line": "Good riddance."},
				{"speaker": Speakers.I, "line": "Yeah, for sure.\n\nI hope the next one would be better..."},
				{"speakers": Speakers.H, "line": "We cannot afford another failure."},
				{"speakers": Speakers.I, "line": "Agreed. We must be more careful in our next choice..."}
			]
			# END
			# no nice 'do you wanna restart' button, sorry not sorry.
		},
	}
}
