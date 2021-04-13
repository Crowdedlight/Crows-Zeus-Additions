## Crows Zeus Additions

Simple clientside mod which adds whatever functions I wanted as zeus modules.

**Wiki:** https://github.com/Crowdedlight/Crows-Zeus-Additions/wiki

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
* **Mass Surrender/Captive:** Can select entire sides or players/groups to toggle surrender or captive. 
* **Spawn Arsenal:** Spawns a NATO Supply Crate on the position clicked and makes it into an ACE arsenal in one go. 
* **Set Colour:** Sets the colour of the target. For vehicles with multiple textures you can select which texture. Also has a reset checkbox to reset to originally texture
* **Paste Loadout into Inventory:** When using the Zeus Enhanced "copy loadout" context menu, you get a new option when right-clicking a vehicle or box and under "inventory" you can select "paste loadout" which will paste that units loadout into the inventory if there is enough space. 

**Requires Zeus Enhanced (ZEN)**  
**ACE Medical damage module requires ACE3 Medical**  

### Test Status
The code is written for MP and dedicated server usage. All functions have been tested on "MP" using the Eden editor and "play scenario in MP".    
The following has been tested on dedicated server with default settings:

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
- [X] Mass Surrender/Captive
- [X] Spawn Arsenal
- [X] Set Colour
- [X] Paste Loadout into inventory

### Debugging
All logging made to the .RPT file will start with ``CrowsZA-module:`` where the module is whatever zeus module is writing the log.

### On todo-list
- [X] color texture changer synced on JIP - Can make cars in fancy colours
- [X] mass surrender - surrender all on a faction or a group with easy selection
- [X] spawn arsenal - spawns our default boxes, and make it into an ACE arsenal automatically
- [ ] unit follow view - A further development on the unit-center function but always keep the camera relative to the unit while moving with the default options of rotating when holding right-click and zoom with scroll-wheel.
- [X] Move instructions info from readme to wiki

### Contributors
Crowdedlight (Main Author)  
Windwalker  

### License
Crows Zeus Additions is licensed under the GPL-3.0 license.


