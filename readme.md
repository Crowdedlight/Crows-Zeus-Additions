## Crows Zeus Additions

Simple clientside mod which adds whatever functions I wanted as zeus modules.

**Wiki:** https://github.com/Crowdedlight/Crows-Zeus-Additions/wiki

**Requires Zeus Enhanced (ZEN)**  

Features that is not base-features are only available if the mod required is detected as Loaded. 

Features:   
* **Scatter Teleport:** Allows Zeus to select players to teleport to position spread in a pattern. Can include the vic players are inside. Useful for TPing into parachuting while ensuring players are seperated from eachother 
* **Teleport To Squadmember:** Allows Zeus to select a unit and get a promt of squadmembers to teleport said unit to. Makes it easy to teleport lost players to their squad without finding them first.
* **Center Camera on Unit:** Right click a unit and select this option, and the zeus camera will continously center on the unit even while moving. Is handy for following moving targets while finding the module or setting you need.
* **Remove trees:** Remove trees/bushes/stones in an distance from position. Works globally and should work for JIP. Removes collision of removed objects.
* **Restore trees:** Restores trees/bushes/stones previously removed in an distance from the clicked position.
* **Animal Follower:** Spawns an animal that follows the selected player around. Can be petted with ace-interaction.
* **Delete All Spawned Animal Followers:** Deletes all animals spawned with **Animal Follower** module. For easy cleanup.
* **Set Numberplate:** Can set the numberplate of a vehicle
* **Delete All Dead:** A cleanup script that removes all dead bodies/wrecks.
* **Set Colour:** Sets the colour of the target. For vehicles with multiple textures you can select which texture. Also has a reset checkbox to reset to originally texture
* **Paste Loadout into Inventory:** When using the Zeus Enhanced "copy loadout" context menu, you get a new option when right-clicking a vehicle or box and under "inventory" you can select "paste loadout" which will paste that units loadout into the inventory if there is enough space. 
* **Spawn Arsenal:** Spawns a NATO Supply Crate on the position clicked and makes it into an arsenal in one go. If ACE is loaded it will be an ACE arsenal, otherwise a base-game arsenal.    
* **Unit Loadout Viewer:** Quickly See Loadout of Unit without going into full arsenal. A right-click menu to see unit loadout without loading a full arsenal.  
* **Draw Build:** Select the type of object to build, and start building by simply clicking the straight lines you want. Quick way to make hesco or sandbag walls without having to manually place each wall segment.     
* **Fire Support:** Call in fire support without having to set up vehicles that might run out of ammuntion. Supports 82mm Mortar, 155mm Artillery and 230mm Rockets (Other ammunition also possible via the Custom Type (ex.) field by entering the CfgAmmo name. Each ammo needs individual testing). Sliders for radius, amount of salvos (leave 0 for infinite), seconds between the salvos, delay after placing and amount of "guns" firing. Move object to change center of radius, reapply module to change settings and delete to end prematurly.

Features Requireing ACE:   
* **Set Rearm Vehicle:** Set an object or vehicle as an ACE rearm vehicle
* **Capture Player:** Easily capture the unit it is used on. It does a full zeus heal on the unit, set them captive, and removes weapons and radio and place it inside a box next to them.
* **Radius Heal:** Heals all units in a sphere radius around the clicked position. Makes it easy to heal all units if a vehicle is arma'ed or otherwise need to pick all up. 
* **Mass Surrender/Captive:** Can select entire sides or players/groups to toggle surrender or captive. 
* **Mass Unconscious:** Can select entire sides or players/groups to toggle ACE unconscious on. 
* **Inflict ACE Medical damage:** with selection of limb, damage-type and damage. (Useful for medic training of specific wounds. Logs dmg and target in RPT log files when used)

Features Requiring TFAR:  
* **Set Vehicle Radio Side:** Set the radio side on the selected vehicle. Makes it possible to swap the vehicle radios to the wanted side.  

### Test Status
The code is written for MP and dedicated server usage. All functions have been tested on "MP" using the Eden editor and "play scenario in MP".    
The following has been tested on dedicated server with default settings:

- [X] Scatter Teleport - Spiral Pattern
- [X] Scatter Teleport - Line Pattern
- [X] Scatter Teleport - P Pattern
- [X] Teleport To Squadmember
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
- [X] Quickly See Load of unit without going into arsenal 
- [X] Capture Player  
- [X] Mass Unconscious
- [X] Radius Heal
- [X] Rearm Vehicle
- [X] DrawBuild
- [X] Set TFAR vehicle side
- [X] Fire Support

### Debugging
All logging made to the .RPT file will start with ``CrowsZA-module:`` where the module is whatever zeus module is writing the entry.

### On todo-list
- [X] color texture changer synced on JIP - Can make cars in fancy colours
- [X] mass surrender - surrender all on a faction or a group with easy selection
- [X] spawn arsenal - spawns our default boxes, and make it into an ACE arsenal automatically
- [ ] unit follow view - A further development on the unit-center function but always keep the camera relative to the unit while moving with the default options of rotating when holding right-click and zoom with scroll-wheel.
- [X] Move instructions info from readme to wiki

### Contributors
Crowdedlight (Main Author)  
Windwalker  
MrPepsiMax 
Radkewolf

### License
Crows Zeus Additions is licensed under the GPL-3.0 license.


