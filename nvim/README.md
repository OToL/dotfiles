# SETUP

- Install Git: https://git-scm.com/
- Install neovim by either ...
    - Downloading binaries (https://github.com/neovim/neovim/releases)
    - Using OS package manager (e.g. brew on MacOS)
- Install Nerd Fonts
    - https://github.com/ryanoasis/nerd-fonts
    - https://www.geekbits.io/how-to-setup-nerd-fonts-in-windows/
- Deploy dotfiles to neovim user folder ...
    - Windows: ~/AppData/Local/nvim
    - MacOS: ~/.config/nvim
- Launch neovim at least twice in a raw because some plugins are compiling/downloading utilities (e.g. treesitter, lsp, etc.) the first time it is executed

# TODO

- Setup C++ dev environment ...
    - Use built-in exrc feature (https://neovim.io/doc/user/options.html#'exrc') instead of a Plugin
    - CMake preset file
    - Async "Build" (configure?) command
    - Shortcut to launch ... how to launch in separate terminal?
    - Setup Vscode to debug the same project
    - Investigate how to use latest clang
- Clean-up list of installed plugin + rename plugins-setup.lua to plugins-install.lua
- Use init.lua in sub-directories (core & plugins)
- Try harpoon
- Check available NvChad plugins
- Learn about tags
- Learn about registers e.g. consider using vim-ReplaceWithRegister
- Learn about quick and location list
- Learn efficient git workflow/plugins
- Move to lazy vim
- Try using tmux
- Consider getting rid of lsp-zero

