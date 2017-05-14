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

4. Add hooks to the remainder of the love input methods (IE: love.textinput, love.mousemoved, etc.  See example projects).

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

![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Textinput and OK button on a window.")


## License

This project is released under the MIT license. Please see LICENSE.md for details.