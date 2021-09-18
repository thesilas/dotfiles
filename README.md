$HOME in git via whitelisting. No symlinks, scripts, or dependencies, just git.

# Requirements

- git
- an `*` in [`~/.gitignore`](.gitignore)

# How it works
## Starting from scratch
```shell
~:$ git init
~:$ echo '*' > .gitignore

# now, you'll need to force-add files you want to track (-f force-adds ignored files)

~:$ git add -f .gitignore
~:$ git commit -m 'Ignore all via .gitignore'

~:$ git add -f .bashrc .tmux.conf .vimrc
~:$ git commit -m 'Add some dotfiles'
```


## Checking out dotfiles on a new system
```shell
~:$ git init
~:$ git remote add origin https://github.com/thesilas/dotfiles
~:$ git remote update
~:$ git checkout -t origin/master [-f]
```
