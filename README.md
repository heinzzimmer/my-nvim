## Neovim Setup Guide
I’ll update the usage guide tonight.

I use **Ghostty Terminal** for a sleek and minimal experience.  
Download it here: [ghostty.org/download](https://ghostty.org/download)

### Step 1: Install Neovim  
For macOS users, run:  
```bash
brew install neovim
```
### Step 2: Configure Neovim

Create the config directory if it doesn’t exist:  
```bash
mkdir -p ~/.config
```
Clone my Neovim config repo
```bash
git clone https://github.com/heinzzimmer/my-nvim.git ~/.config/nvim
```
Then, navigate to the config folder and open the config file:
```bash
cd ~/.config/nvim
nvim init.lua
```
