#### My config for NvChad

<img width="300" height="70" alt="image" src="https://github.com/user-attachments/assets/25b883f0-a978-4766-b30c-514212369ea2" />


**Steps for install**

If you haven't Neovim
https://neovim.io/doc/install/

If you haven't gopls
```bash
go install golang.org/x/tools/gopls@latest
gopls version
```

**Download the repository in ~/.config/nvim and run**
```bash
git clone git@github.com:slipynil/nvim.git ~/.config/nvim && nvim
```

**Run commands in nvim**  
Run :MasonInstallAll command after lazy.nvim finishes downloading plugins  
Run :LazySync for setting up gopls and TreeSeeter  

**(Optional) Delete .git folder if you want to create own git**
```bash
rm -rf ~/.config/nvim/.git
git init
```

congratulations, enjoy your nvim!
<img width="5000" height="360" alt="image" src="https://github.com/user-attachments/assets/6a5db98d-2d7a-43e6-b112-bdad01940b66" />
