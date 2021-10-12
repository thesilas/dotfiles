# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Use fish as default shell
if [ -t 1 ]; then
exec fish
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
