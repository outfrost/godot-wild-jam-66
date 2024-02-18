## BIG THINGS

* [~] BT1: NPC behaviour - chase logic **6h** @lyall
	* [ ] SIDE QUEST: make perception fade with distance @outfrost
	* [ ] SIDE QUEST: employee walking animation? @lyall
* [ ] BT2: factory details @lyall
	* [ ] filler junk **6h**
	* [ ] NPC placement and paths **1h**
	* [ ] SIDE QUEST: one of the following **1h**
		* medium-size heavy factory machine
		* additional model (1 or 2) of shelf filler junk, like a bucket of small parts
		* hand trolley
* [~] BT3: transitions, settings menu, menu polish **4h** @outfrost
* [~] BT4: attach and test audio events and parameters **2h** @outfrost
* [~] BT5: set up each playable prop and place it in the factory **2h**
	* [x] prop scenes
	* [ ] placement
* [ ] BT6: PLAYTEST **8h+8h** @everyone
* [x] BT7: attempt to make a factory building that isn't just kenney greybox textures **3h** @outfrost

## the whole list

* [x] movement, camera control @outfrost
* [x] outer loop - spawning, finishing a level, progressing @outfrost
* [x] overall building layout @outfrost
* [ ] refined map design @lyall
* [~] NPC navigation @lyall
	* [x] Navmesh Gen
	* [x] actual gravity on it
	* [x] change model to raycast boys
	* [x] rotate boys in velocity direction
	* [x] create scene patrol points manager
	* [x] add looping version to manager
* [ ] NPC behaviour
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
* [ ] employee walking animation
* [~] transitions (game start, level failed, next level (next prop), game finished)
* [ ] domestic pineapple juice @outfrost
* [~] menu style and background @outfrost
* [ ] settings menu @outfrost
* [ ] keyboard menu navigation @outfrost
* [ ] gamepad controls?
* audio @grimma
	* [x] Godot: integrate FMOD
	* [~] Godot: set up PARAMETER_SCENE @outfrost
	* [ ] Godot: set up PARAMETER_DETECTION @outfrost
	* [ ] Godot: set up parameter LEVELCOMPLETE @outfrost
	* [~] Godot: attach events @outfrost
		* [x] `SFX_JUMP`
		* [~] `SFX_FALL`
		* [~] NPC
			* [ ] `ALERT_NOTICED`?
		* [~] ROOM
		* [ ] make sure the UI click sfx isn't gonna fall over
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
