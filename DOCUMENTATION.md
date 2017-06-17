# SkinUI Documentation

Several controls are predefined in this library, they can be most simply edited by finding the corresponding image file in the
themes folder and changing the graphics there.

More compilicated changes may require implementing an all-new control.  See SkinUI.lua to see how controls are registered with the
library.  Once they are registered there, they can be accessed from application code via ```skinui.ControlName:new()```, where
ControlName of course is the name of your custom control class.

### Window

Windows are the base elements onto which everything else is added.

Create windows and add them to the skinui library instance to get started.

#### New Control

```lua
function Window:new(id, x, y, theme)
```

#### Example

```lua
  local winMain = skinui.Window:new("winMain", 400, 300, skinui.theme.default)
  winMain:size(340, 300)
  skinui:add(winMain)
```

#### Notes

By default windows are resizable and moveable by the user and when the mouse hovers over the borders the cursor turns into the 
appropriate resizing direction cursor.

You can prevent this behaviour by setting the window's ```fixed``` property:

```lua
  winMain:set("fixed", true)
```

If you create love2d objects and add them to the window as a property, be sure to also overload the ```Window:onunload()``` function
to ensure they are deleted from the memory by setting them to nil.  SkinUI canvas and font objects will automatically be removed for
garbage collection however you are responsible for any you create yourself.

### Label

Labels are rectangular areas that display text on a window.

#### New Control

```lua
function Label:new(id, x, y, w, h, theme)
```

#### Example

```lua
local lblScore = skinui.Label:new("lblScore", 25, 20, 250, 45, skinui.theme.default)
lblScore:set("text", "High Scores")
lblScore:fontSize(30)
skinui:addChild("winMain", lblScore)
```

### Button

Buttons consist of two images: an up and a down state.

The two images are mapped in the theme under ```images.button_med``` and ```images.button_down_med```.  The control's area will
adjust to match the size of the image.

#### New Control

```lua
function Button:new(id, x, y, theme)
```

#### Example

```lua
local btnOK = skinui.Button:new("btnOK", 25, 20, skinui.theme.default)
btnOK:set("text", "OK")
skinui:addChild("winMain", btnOK)
```

### ButtonSmall

Buttons consist of two images: an up and a down state.

The two images are mapped in the theme under ```images.button_small``` and ```images.button_down_small```.  The control's area will
adjust to match the size of the image.

#### New Control

```lua
function ButtonSmall:new(id, x, y, theme)
```

#### Example

```lua
local btnOK = skinui.ButtonSmall:new("btnOK", 25, 20, skinui.theme.default)
btnOK:set("text", "OK")
skinui:addChild("winMain", btnOK)
```
### ButtonTiny

Buttons consist of two images: an up and a down state.

The two images are mapped in the theme under ```images.button_tiny``` and ```images.button_down_tiny```.  The control's area will
adjust to match the size of the image.

#### New Control

```lua
function ButtonTiny:new(id, x, y, theme)
```

#### Example

```lua
local btnOK = skinui.ButtonTiny:new("btnOK", 25, 20, skinui.theme.default)
btnOK:set("text", "OK")
skinui:addChild("winMain", btnOK)
```
### Image

Image controls display an image on the specified window.

Use the ```function Image:set(prop, val)``` function to specify the image
for the control.  If prop is "image" and val is a string, then it will attempt
to find the image at that file location.  If a Love2D Drawable is passed as val,
the Image control will use that instead.

#### New Control

```lua
function Image:new(id, x, y, theme)
```

#### Example

```lua
local imgIconDelete = skinui.Image:new("imgIconDelete", 50, 50, skinui.theme.default)
imgIconDelete:set("image", "images/icons_delete_15x15.png")
skinui:addChild("winMain", imgIconDelete)
```

### VScrollbar

The VScrollbar control displays a vertical scroll bar with up and down arrows and a carat
inbeween them showing the current scroll position.

#### New Control

```lua
function VScrollbar:new(id, x, y, h, theme)
```

#### Example

```lua
local vScroll = skinui.VScrollbar:new("vScroll", 50, 50, skinui.theme.default)
vScroll:set("scroll_max", 10)     -- Set the maximum scroll value.
vScroll:set("scroll", 5)          -- Set the scroll progress to half-way.
skinui:addChild("winMain", vScroll)
```

More controls yet to be documented.