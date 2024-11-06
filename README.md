# MagicMacros
Godot Addon for enhanced autocomplete and code snippets

# What does this do?
This addon integrates with the Script Editor in Godot. It will scan the currently edited line for a pattern that fits one of the loaded macros, and when it finds a match highlight the line in green. Pressing tab will execute the macro on the contents of the line.

Example:

![AAADADSA](https://github.com/user-attachments/assets/779b4cb5-f285-4489-a907-017e6e85bcb3)

# How do I make new macros?

Define macros in MagicMacros/Macros. New macros must extend MagicMacrosMacro type. Disable and reenable the plugin afterwards. You may have to do this twice for the new macros to load.

Made a macro? Consider contributing it!

# Installation

This repository is designed to be loaded as a GIT Submodule. How you add these depends on your client of choice.

[Refer to this if you're mad enough to use the command line :P](https://git-scm.com/book/en/v2/Git-Tools-Submodules)

Alternatively, download the zip from this page and unpack it into your addons folder under res://addons/MagicMacros

# Current Macros

* setget = creates a variable with specified name, type, value, if any, and setters and getters.
* init = creates the _init function.
* ready | rdy = creates the _ready function.
* fn | fnc = creates a function with specified name and return type if any.
* node = creates an @onready variable with specified name, type, value if any.

---

### Looking for more?

Check out Nylon! https://theduriel.itch.io/nylon

Nylon for Godot is a Deep Dialogue sequencing addon, perfect for making complex RPG dialogue, cutscenes, and more. It's easily modified and used over the network as well, and includes a template project that incldues **many many more** utility systems for quickly building up your own game. Including menu and game state management, option menus, save files, audio, and more.

### Support me!

I don't have a donation link. But instead of giving something for nothing, you can buy Nylon above! And get something in the process! :D

### Need support?

This repository is provided as is. However I will happily answer questions via twitter: https://twitter.com/the_duriel
