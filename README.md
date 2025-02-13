# dotfiles
My dotfiles. Need tmux and my aliases. especially tm, lt and mkcd :-)

## .screenrc and .tmux.conf

My old screenrc opens three bash shells (current user) plus adds hardline with important information:
* hostname
* each screen name 
* date
* time
* nickname "c++" ;-)

## aliases 

Aliases and functions to use lt, ..., odd :
* ls -alt (first the newest files)
* ... for cd ../.. 
* odd for better looking od 
* lsofi for better network lsof 

```
git clone https://github.com/cubapp/dotfiles
cd dotfiles
sh ./setup.sh
```
or, if you are concerned:
```
cp aliases ~/.aliases
cp .tmux.conf ~/
echo "[ -f ~/.aliases ] && source ~/.aliases " >> ~/.bashrc

```

Either copy or link the aliases into your ~/.alias file and call it from .bashrc or .zshrc:
```
[ -f ~/.aliases ] && source ~/.aliases
```
 
## resolv.conf

Free and usable DNS servers 


