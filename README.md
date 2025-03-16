# Nvpunk Embedded (WIP)
```
                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡤⢄⡀⠀⠀⠀⠀⠀⠀⣀⣄⡀⣀⡠⣀⠀⠀⠀⠀⠀⠀⢀⡤⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢹⡏⠀⠀⠀⢠⡔⢤⡄⠙⡶⠉⠉⣶⠋⢠⡔⢢⡄⠀⠀⠀⢹⡏⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
                    ⠀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠈⣉⣉⢹⣆⣀⣸⣇⣀⣀⣯⣀⡀⣿⣀⣀⣸⣇⣀⣸⣍⣉⡈⠁⠀⠀⠀⠀⠀⠀⢀⣀⣀⠀
                    ⠈⠓⠒⠉⠉⠉⢹⣇⣀⣰⡏⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠈⢹⣆⣀⣸⠋⠉⠉⠙⠒⠊⠁
                    ⠀⠀⠀⠀⣴⣒⡦⠤⠤⢼⡇⠀⠀⠰⡏⠀⠀⠿⠤⠤⣤⠀⢀⣀⣀⣀⣀⠀⠀⢹⠀⠀⠀⢸⡧⠤⠤⢶⣒⡦⠀⠀⠀⠀
                    ⠀⠶⣩⠶⠒⠒⠒⠒⠒⢺⡇⠀⠀⢘⡇⠀⠀⠀⠀⠀⠹⠀⠀⠀⠀⠀⢸⣆⣠⣼⠁⠀⠀⢸⡗⠒⠒⠒⠒⠒⠶⣩⠖⠀
                    ⠀⠻⠥⠟⢒⣒⡒⠒⠒⢺⡇⠀⠀⢨⡇⠈⠸⣇⣀⣀⣀⠀⠀⣇⠀⠀⠀⠀⠀⢸⠄⠀⠀⢸⡓⠒⠒⢒⣒⡒⠻⠬⠛⠀
                    ⠀⠀⠀⠀⠛⠒⢋⣉⣉⣹⡇⠀⠀⠐⢧⣀⣀⣀⣀⣀⣀⣀⣀⣉⣉⣉⣿⣀⣀⡼⠀⠀⠀⢸⣏⣉⣉⠙⠒⠋⠀⠀⠀⠀
                    ⠠⣖⣒⡤⠤⠤⠼⠇⠀⠘⠧⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⠼⠃⠀⠸⠧⠤⠤⢴⣒⣢⠄
                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡤⠤⠼⠇⢀⡸⢇⡀⠀⣯⠀⠀⣿⠀⢀⡸⢇⡀⠸⠧⠤⢤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠼⢧⡀⠀⠀⠈⠑⠊⠁⣴⠳⣄⣤⠛⣦⠈⠑⠊⠁⠀⠀⢀⡼⠧⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀
                    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉
```

[Neovim](https://neovim.io) distribution for Embedded developers.

## Installation
Execute the following commands to set up this distribution.

```bash
mv ~/.config/nvim ~/.config/nvim.old # Backup your existing nvim configuration.
git clone https://github.com/ItsNayabSD/nvpunk-embedded.git ~/.config/nvim
# Supplementary lazy.nvim plugins. Optional
git clone https://github.com/ItsNayabSD/lazy-embedded-plugins.git ~/.config/nvpunk
```

Upon launching `nvim` for the first time, all plugins should automatically install. If they do not, manually install them using `nvim +NvpunkUpdate`.

Discover more about this distribution [here](https://nvpunk.gabmus.org/).

## Assistance
Post-installation, use `:h nvpunk` to access the help documentation within the editor.
