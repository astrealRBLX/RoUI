# Change Log
All notable changes to this project will be documented in this file.
 
## [1.3] - 2021-03-30
  
New version is available [here](https://www.roblox.com/library/6587140511/) like always.
Full documentation is available over at the [Wiki](https://github.com/impRBLX/RoUI/wiki/Documentation).
 
### Added

- Tween Color Method
  - `RoUIObject:TweenColor(string propName, Color3 newColor, number speed, Enum.EasingStyle easeStyle, Enum.EasingDirection easeDir)`
- Tween Transparency Method
  - `RoUIObject:TweenTransparency(number newTransparency, number speed, Enum.EasingStyle easeStyle, Enum.EasingDirection easeDir)`
- Built-In Shake Effect
  - Rotates an instance back and forth to create the appearance of it shaking.
- Built-In 360 Effect
  - Rotates an instance 360 degrees smoothly.
- Built-In Grow Effect
  - Grows an object by its current size a certain %.
- Built-In Shrink Effect
  - Shrinks an object by its current size a certain %.

### Changed
  
- Play Effect Method
  - The `RoUIObject:PlayEffect(RoUIEffect effect)` has been tweaked and will now return a tween (all built-in effects automatically do this, users can update theirs to do so too).
- Built-In Effect Changes
  - Built-In Effects now have a settings table that can be altered by users to make them fit your needs. Just open the module of the effect and change away!
