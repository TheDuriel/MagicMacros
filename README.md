# MagicMacros
Godot Addon for enhanced autocomplete and code snippets

# What does this do?
This addon integrates with the Script Editor in Godot. It will scan the currently edited line for a pattern that fits one of the loaded macros, and when it finds a match highlight the line in green. Pressing tab will execute the macro on the contents of the line.

Example:

```GDScript
setget

becomes

var NONAME: Variant = NONE:
    set(value):
        NONAME = value
    get:
        return NONAME
```

```GDScript
setget myvar mytype myvalue

becomes

var myvar: mytype = myvalue:
    set(value):
        myvar = value
    get:
        return myvar
```

# How do I make new macros?

Define macros in MagicMacros/Macros. New macros must extend MagicMacrosMacro type. Disable and reenable the plugin afterwards. You may have to do this twice for the new macros to load.

Made a macro? Consider contributing it!
