## Crows Zeus Additions

Simple clientside mod which adds whatever functions I wanted as zeus modules. 

Currently including:

* **Scatter Teleport:** Allows Zeus to select players to teleport to position spread in a pattern. Can include the vic players are inside. Useful for TPing into parachuting while ensuring players are seperated from eachother 
* **Center Camera on Unit:** Right click a unit and select this option, and the zeus camera will continously center on the unit even while moving. Is handy for following moving targets while finding the module or setting you need.
* **Inflict ACE Medical damage:** with selection of limb, damage-type and damage. (Useful for medic training of specific wounds. Logs dmg and target in RPT log files when used)
* **Remove trees:** Remove trees/bushes/stones in an distance from position. Works globally and should work for JIP. Removes collision of removed objects.
* **Restore trees:** Restores trees/bushes/stones previously removed in an distance from the clicked position.
* **Animal Follower:** Spawns an animal that follows the selected player around
* **Delete All Spawned Animal Followers:** Deletes all animals spawned with **Animal Follower** module. For easy cleanup.
* **Set Numberplate:** Can set the numberplate of a vehicle
* **Delete All Dead Bodies:** A cleanup script that removes all dead bodies that is not inside a vehicle.

**Requires Zeus Enhanced (ZEN)**  
**ACE Medical damage module requires ACE3 Medical**  

### Test Status
The code is written for MP and dedicated server usage. All functions have been tested on "MP" using the Eden editor and "play scenario in MP".    
The following has been tested on dedicated server:

- [X] Scatter Teleport - Spiral Pattern
- [X] Scatter Teleport - Line Pattern
- [X] Center Camera on Unit
- [X] ACE Medical Damage
- [X] Remove Trees - Including collision
- [X] Restore Trees - Including collision
- [X] Animal Follower
- [X] Delete All Spawned Animals following 
- [X] Set Numberplate
- [X] Delete All Dead Bodies

### Debugging
All logging made to the .RPT file will start with ``CrowsZA-module:`` where the module is whatever zeus module is writing the log.

### On todo-list
- [ ] color texture changer synced on JIP - Can make cars in fancy colours
- [ ] mass surrender - surrender all on a faction or a group with easy selection
- [ ] spawn arsenal - spawns our default boxes, and make it into an ACE arsenal automatically
- [ ] unit follow view - A further development on the unit-center function but always keep the camera relative to the unit while moving with the default options of rotating when holding right-click and zoom with scroll-wheel.
- [ ] Move instructions info from readme to wiki

### Contributors
Crowdedlight (Main Author)  
Windwalker  

### License
Crows Zeus Additions is licensed under the GPL-3.0 license.

## Instructions
This section provides a description with an image of each functionality. It can also explain how to use it, or what to be mindful of when using it.   
Windwalker has made some nice videos showing some of the functionality at: https://www.youtube.com/playlist?list=PLhmLsanXHDRBU_XAcYTBPyXzzsNTwY2b1 

### Scatter Teleport
A teleport function that teleport selected groups/sides/players to the selected position but in a pattern with a configurable distance between each unit and the possibility to set the height over terrain. This is useful for mass-teleport units into the air for "parachute insertion" while ensuring a safe distance between each unit and no collision happens. It includes the option to teleport vehicles aswell.   
If teleporting vehicles the crew gets teleported together with it.   
If not teleporting vehicles, it will not teleport any units selected that is inside a vehicle. As that can cause ghost/dsync behaviour. So make sure the infantry you want to teleport is not mounted in vehicles.   
**OBS: All selections in the three tabs counts not just the current one showing. That means that if you select side and a group or player, the group/player and all units belong to the said will be teleported. Remember to change selection between different teleports. The unselect all button is handy here**  

![image](https://user-images.githubusercontent.com/7889925/113602132-89de7e80-9642-11eb-9f88-95068547a6c0.png)  
![image](https://user-images.githubusercontent.com/7889925/113602158-91058c80-9642-11eb-82c1-688794e799b3.png)

### Follow Unit Camera
This action is added to the ZEN context menu appearing when right-clicking a unit. It centers the zeus camera on the unit selected and keeps it there until unit is deselected. The "wasd" keys and scroll-wheel can be used to move the camera relative to the unit. The camera will ensure the unit is always in center, but it will not follow at set distance. So if the unit is moving use "wasd" to keep the camera zoomed close to it.   
It can help in cases where you need to ensure you keep a moving unit within the zeus-view while finding a module or another setting to apply to said unit.  
**OBS: Sometimes deselecting the unit isn't enough to get normal zeus camera controls back. In that case select a unit again and deselect. Can also be done through the lefthand menu**   
![image](https://user-images.githubusercontent.com/7889925/113602114-80edad00-9642-11eb-8fcc-6425d1af258a.png)

### Inflict ACE Medical damage
A module that inflicts the configured damage to the selected units limb with the projectile type and damage set. Can be used to artificial apply specific damages to units for roleplay or as a tool for medic training. Every time a zeus uses this module the damage, projectile type, limb and unit it applies to is logged to the servers .RPT file in the format of: ``"CrowsZA-AceDamage: Zeus applying %1 dmg to %2 limb with type %3 on unit %4"``    
**OBS: It does not respect ``invincible`` status and still inflicts the damage.**    

![image](https://user-images.githubusercontent.com/7889925/113601958-513ea500-9642-11eb-8285-f3e6e9917680.png)  


### Remove trees
Removes trees, bushes and stones from the clicked position and in the set radius. It can toggle and mix freely between which of the three things to remove. It syncs the removal to all connected clients and automatically syns to new clients joining after the module has been used.   
The removal also removes the collision boxes.  
Be aware that sometimes the AI do not like pathfinding with vehicles through an forest that has been removed.  
**OBS: The radius on some maps also seem to apply to the threes height. So it won't remove a tree that is 10m high if placed next to it and radius set to 5m**  
![image](https://user-images.githubusercontent.com/7889925/113602097-792e0880-9642-11eb-9c47-580b07b6bd7d.png)  


### Restore trees
The reverse of the removal of trees, this module is identical and just shows the objects again. So can be used if the wrong thing was removed. 


### Animal Follower
Spawn simple AI animals that follow the unit they are spawned on. Multiple animals can be spawned in one go. They persists until they die. Due to simple AI pathfinding they can sometimes run abit around and not go direct to the player.   

![image](https://user-images.githubusercontent.com/7889925/113602201-9ebb1200-9642-11eb-804a-9d4e2f1d0c91.png) 

### Delete All Spawned Animal Followers
This function deletes all animals spawned with the "Animal Follower" module and can be used as a quick cleanup.   
**OBS: Applies to all animals on the entire map which is spawned with the "Animal Follower" module**

### Set Numberplate
Set the numberplate on a vehicle and syncronises it across users and adds it so new players joining the mission also see the set numberplate value.  
![image](https://user-images.githubusercontent.com/7889925/113602062-6ddadd00-9642-11eb-800e-1263b3ddf396.png)

### Delete All Dead Bodies
Cleanup script that removes all dead bodies on the entire map. A quick way for zeus to cleanup. It only removes dead bodies, and not downed units. It does not delete wrecks nor dead bodies inside vehicles. (As the command for deleteing bodies can cause "ghosts" if used on units inside a vehicle)  
**OBS: Works on all dead bodies on map. Be mindful if you have placed dead bodies for story or intel purposes**



