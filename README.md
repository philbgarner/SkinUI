SkinUI
=========

A simple, customizable UI library for Love2d.

By Phil Garner
Alpha Version - May 2017

## Purpose

I was frustrated by the options for building user interfaces in Love2d and decided to build my own: a library that was easy to add to my projects, quick to build useful dialogs and sprite-based to allow fine control over the look of the finished product.

## Look and Feel

The windows and controls are completely skinnable, so that any esthetic changes are done with a bitmap editor and the mapping between ui control in code and the bitmap itself is controlled through themes.  This will allow users to easily extend the default options with their own theme-appropriate resources.

Text entry supports moving the cursor back through the text with the left/right keys and also jumping between words with ctrl+left/right, along with end/home and delete/backspace to make data entry more comfortable.  Future state I am planning to allow text selection and perhaps even copy/paste.

## Getting Started

1. Clone or extract the lib folder in this repository to the same folder as your main.lua file.

2. Include the library in your project by adding this line to your main.lua file ('lib' folder in the repository):

```lua

skinui = require "lib.SkinUI"

```

3. Initialize the library in your `love.load()` function:

```lua

function love.load()
  
  skinui:load()

end

```

4. Add hooks to the remainder of the love input methods (IE: love.textinput, love.mousemoved, etc.  See projects in the examples folder).

5. Start adding windows and controls!  As a general rule, windows are added to the root node (skinui library itself) while controls are added to the window as a child.  The exception will be container type objects which allow scrolling, etc (future state).

## Sample Code

A simple text input dialog, created in the love.load() function:

```lua

function love.load()
  
  -- Load the library and initialize themes (preload images).
  skinui:load()
  
  -- Add a new window named 'win1' to the root node.
  skinui:add(skinui.Window:new("win1", 25, 25, skinui.theme))
  
  -- Create a text input control and an OK button.
  local text1 = skinui.Textinput:new("text1", 25, 25, skinui.theme)
  skinui:addChild("win1", text1)
  
  local btnOK = skinui.Button:new("btnOK", 25, 70, skinui.theme)
  -- Overload the default onclick function with our own custom code.
  function btnOK:onclick()
    text1:set("text", "OK button was clicked!")
  end
  btnOK:set("text", "OK")
  -- Attach control to the 'win1' window.
  skinui:addChild("win1", btnOK)

  -- Resize the window.
  skinui:get("win1"):size(725, 150)
end

```

Gives us this result:

![alt text](https://github.com/philbgarner/SkinUI/blob/master/SkinUI-SampleScreenshot.png "Textinput and OK button on a window.")

Windows are the base control onto which you can add other controls using the ```lua skinui:add(window_object)``` method.  Register
controls with their parent window using the ```lua skinui:addChild(windowName, control_object)``` method.

## Controls

Several controls are predefined in this library, they can be most simply edited by finding the corresponding image file in the
themes folder and changing the graphics there.

More compilicated changes may require implementing an all-new control.  See SkinUI.lua to see how to register controls.

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

The two images are mapped in the theme under ```lua images.button_med``` and ```lua images.button_down_med```.  The control's area will
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

The two images are mapped in the theme under ```lua images.button_small``` and ```lua images.button_down_small```.  The control's area will
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

The two images are mapped in the theme under ```lua images.button_tiny``` and ```lua images.button_down_tiny```.  The control's area will
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

Use the ``lua function Image:set(prop, val)``` function to specify the image
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

More controls yet to be documented.

## License

This project is released under the MIT license. Please see LICENSE.md for details.