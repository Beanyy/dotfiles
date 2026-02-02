```
git clone --bare https://github.com/Beanyy/dotfiles.git $HOME/.dotfiles
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout
$HOME/setup.sh
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout .
```
