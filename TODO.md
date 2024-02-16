* [x] movement, camera control @outfrost
* [x] outer loop - spawning, finishing a level, progressing @outfrost
* [x] overall building layout @outfrost
* [~] NPC navigation @lyall
	* [x] Navmesh Gen
	* [x] actual gravity on it
	* [x] change model to raycast boys
	* [x] rotate boys in velocity direction
	* [x] create scene patrol points manager
* [ ] NPC navigation
	* [ ] State machine
	* [ ] chase
	* [ ] patrol
* [~] NPC perception @outfrost
	* [x] see motion
	* [ ] see environment mismatch
	* [ ] see better when closer
* [x] test a build
	* [x] linux build works
	* [x] attempt to unfuck mac build
	* [x] crawl up a wall
	* [x] it's still fucked
	* [x] crawl back down
	* [x] cry
	* [x] yep, still fucked
	* [x] get help
		* [x] thank linux gods for strace
	* [x] fuck apple fuck apple fuck apple fuck apple fuck apple fuck apple fuck apple fuck apple fu
	* [x] windows build???
* props
	* [x] fluid tank @lyall
	* [x] cardboard box @lyall
	* [x] forklift @lyall
	* [x] shelving unit X2 @lyall
	* [x] manager's coffee mug
	* [x] tools
		* [x] bucket
		* [x] Hammer
		* [x] pipe wrench
		* [x] wrench
		* [x] screwdriver
	* [ ] something being fabricated
	* [ ] toolbox @lyall
	* [ ] re:placement props @outfrost
* environment
	* [x] fire exit @lyall
	* [x] conveyor?
	* [x] large shelf rescale @lyall
	* [x] clean table @lyall
	* [x] clean small table @lyall
	* [x] box: both sizes @lyall
	* [ ] another big machine @lyall
	* [ ] some more shit to put on shelves and tables
		* [ ] buckets of small parts (literally could be small cylinders in an open box)
	* [ ] hand trolley
	* [~] work devices™
* [ ] transitions (game start, level failed, next level (next prop), game finished)
* [ ] domestic pineapple juice @outfrost
* [~] menu style and background @outfrost
* [ ] settings menu @outfrost
* [ ] keyboard menu navigation @outfrost
* [ ] gamepad controls?
* audio @grimma
	* [~] Godot: integrate FMOD
		* seems like we got it?
	* [~] Godot: set up PARAMETER_SCENE
	* [ ] Godot: set up PARAMETER_DETECTION
	* [~] FMOD: EVENT_MUSIC: MUSIC_menus/MUSIC_sneaky/MUSIC_noticed/MUSIC_spotted/ONESHOT_MGS-style-chase-alert
	* [~] FMOD: PARAMETER_SCENE in EVENT_1: MUSIC_menus vs MUSIC_sneaky
	* [~] FMOD: PARAMETER_DETECTION in EVENT_1: MUSIC_sneaky vs MUSIC_noticed vs MUSIC_spotted
	* [ ] FMOD: PARAMETER_DETECTION in EVENT_AMBIENCE_voiceover
	* [ ] FMOD: set up sidechain between MUSIC_noticed and MUSIC_spotted, and AMBIENCE_warehouse
	* [ ] FMOD: EVENT_AMBIENCE_warehouse: AMBIENCE_warehouse
	* [ ] FMOD: EVENT_AMBIENCE_voiceover: AMBIENCE_voiceover (note to self: scatterer?)
	* [ ] MUSIC_menus
	* [ ] MUSIC_sneaky
	* [ ] MUSIC_noticed
	* [ ] MUSIC_spotted
	* [ ] AMBIENCE_warehouse
	* [ ] AMBIENCE_voiceover
	* [ ] ONESHOT_jump
	* [ ] ONESHOT_UI hover
	* [ ] ONESHOT_UI accept
	* [ ] ONESHOT_mission-complete
	* [ ] ONESHOT_mission-failed
