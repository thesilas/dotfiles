#!/bin/sh
# dotfiles installation script

# installation of prerequisites
echo "[*] Installing xclip"
sudo dnf install xclip

echo "[*] Installing zsh"
sudo dnf install zsh

# oh my zsh 
echo "[*] installing oh-my-zsh."
curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
sh install.sh --unattended
rm install.sh

# make zsh default shell
echo "Set zsh as default shell"
echo "" >> $HOME/.bashrc
echo "# Use zsh as default shell" >> $HOME/.bashrc
echo "if [ -t 1 ]; then" >> $HOME/.bashrc
echo "exec zsh" >> $HOME/.bashrc
echo "fi" >> $HOME/.bashrc

# setup dotfiles and backup existing ones
echo "[*] getting the dotfiles"
git clone --bare https://github.com/thesilas/dotfiles $HOME/dotfiles
function config {
	   /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
   }
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
	  echo "[*] Checked out config.";
	    else
		        echo "[*] Backing up pre-existing dot files.";
			    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I {} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no
echo "[*] setup complete"
