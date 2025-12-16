### My config for NvChad

#### Steps for install

1 If you haven't Neovim
https://neovim.io/doc/install/

If you haven't gopls
```bash
go install golang.org/x/tools/gopls@latest
gopls version
```

2 Download the repository in ~/.config/nvim and run
```bash
git clone git@github.com:slipynil/nvim.git ~/.config/nvim && nvim
```

3 Run commands in nvim
Run :MasonInstallAll command after lazy.nvim finishes downloading plugins
Run :LazySync for setting up gopls and TreeSeeter

4 (Optional) Delete .git folder if you want to create own git
```bash
rm -rf ~/.config/nvim/.git
git init
```

congatulations, enjoy your nvim!
