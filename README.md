# vis-autopairs

## Ultra-minimal auto-pairing plugin for vis

vis-autopairs is a minimalistic plugin for the vis editor. It automatically 
inserts matching pairs for parentheses, brackets, quotes, and other characters,
and ensures smart behavior for skipping and deleting pairs.

It was mainly inspired by vim-autopairs by jianmiao: https://github.com/jiangmiao/auto-pairs

### Features

Auto-inserts matching pairs for:
- Parentheses: ()
- Braces: {}
- Brackets: []
- Quotes: ', "

Also:
- Skips over existing closing pairs when typing.
- Automatically deletes matching pairs when using backspace.

### Install

To install clone the repository into the plugins directory and then require it in your configuration file.

```lua
require("plugins/vis-autopairs")
```

Alternatively, you can try with my plugin manager: https://github.com/jpnt/vis-plugged or the more robust: https://github.com/erf/vis-plug

If you need more extensive functionality, consider using other vis plugins. However, for simple and effective auto-pairing, vis-autopairs works fine.

