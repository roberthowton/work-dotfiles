# dotfiles

## contents

- custom oh my posh config: `./oh_my_posh/.rfh_emodipt.omp.json`
- vscode config: `./vscode/settings.json`

## `.zshrc`

```bash
eval "$(direnv hook zsh)"
eval "$(oh-my-posh init zsh --config ~/.rfh_emodipt.omp.json)"

alias diemcafee="sudo /usr/local/McAfee/Mcp/bin/uninstall.sh"
alias ll="ls -alF --color=auto"
```
