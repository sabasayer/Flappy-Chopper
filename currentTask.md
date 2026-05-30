# Current Task: Difficulty Manager

Difficulty manager will be responsible of handling the difficulty of the game by holding the related configuration and providing the values to the requested parties. 

The spawner scene will use the DifficultyManager. Spawners responsibilty is to spawn the scenes in to the level, the DifficultyManagers responsibilty is to decide what, where and when to spawn. Such as the obstacle type, the frequency, type of enemies and their placements. This will be decided by players score for now but later it will be decided by more complicated factors.

As first task we will move the configurations from spawner to difficulty manager.
From there we will keep improving.

First improvement will be instead of hard coded values that jumps we will use lerp to soften the difficulty change
Also we will apply some rules to make the game fair. For example the hard pipe and enemy combo shouldn't be spawned sequencly in early game