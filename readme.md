## Crows Zeus Additions

Simple clientside mod which adds whatever functions I wanted as zeus modules. 

Currently including:

* **Scatter Teleport;** Allows Zeus to select players to teleport to position spread in a pattern. Useful for TPing into parachuting while ensuring players are seperated from eachother 
* **Inflict ACE Medical damage:** with selection of limb, damage-type and damage. (Useful for medic training of specific wounds. Logs dmg and target in RPT log files when used)
* **Remove trees:** Remove trees in an distance from position. Works globally and should work for JIP. Removes collision of removed objects
* **Restore trees:** Restores trees previously removed in an distance from the clicked position.
* **Animal Follower:** Spawns an animal that follows the selected player around
* **Delete All Spawned Animal Followers:** Deletes all animals spawned with **Animal Follower** module. For easy cleanup.
* **Set Numberplate:** Can set the numberplate of a vehicle
* **Delete All Dead Bodies:** A cleanup script that removes all dead bodies that is not inside a vehicle. As the command for deleteing bodies can cause "ghosts" if used on units inside a vehicle. Does not delete downed units that is not fully dead. Works over the entire map, so be careful not to use if you got corpses out for "scenery" or intel discoveries. 

**Requires Zeus Enhanced (ZEN)**  
**ACE Medical damage module requires ACE3 Medical**  

### Test Status
The code is written for MP and dedicated server usage. All functions have been tested on "MP" using the Eden editor and "play scenario in MP".    
The following has been tested on dedicated server:

- [X] Scatter Teleport
- [X] ACE Medical Damage
- [X] Remove Trees - Including collision
- [X] Restore Trees - Including collision
- [X] Animal Follower
- [X] Delete All Spawned Animals following 
- [X] Set Numberplate
- [X] Delete All Dead Bodies

