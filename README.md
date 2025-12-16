#### My config for NvChad

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

congatulations, enjoy your nvim!
