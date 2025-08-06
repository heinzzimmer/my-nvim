## Neovim Setup Guide (macOS)
I’ll update the usage guide tonight.


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
</br>

### Optional
#### I use **Ghostty Terminal** for a sleek and minimal experience and starship for shell prompt. 
Download it here: [ghostty.org/download](https://ghostty.org/download)
</br>

```bash
brew install starship
```
Add the following line to ```~/.zshrc``` 
```bash
eval "$(starship init zsh)"
```
