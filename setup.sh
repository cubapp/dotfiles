#!/bin/bash
# Script for setting up aliases and tmux config. 
# Do not run this script unless you know ... 
# You have been warned! :-) 


echo "Setting up aliases and tmux.config. Please review both files as well as this script. Trust no one :-)"
echo "-------------------------------------------------------------------------------------------------"

if ! [ -f ~/.aliases ]; then
  echo "Copying .aliases to HOME dir"
  cp aliases ~/.aliases || echo "Error: Aliases files not copied"
fi


if ! [ -f ~/.tmux.conf ]; then
  echo "Copying .tmux.conf to HOME dir"
  cp .tmux.conf ~/.tmux.conf || echo "Error: tmux config not copied"
fi


echo "Setting up aliases in .bashrc or .zshrc"

if  [ -f ~/.bashrc ] ; then
  echo "There is .bashrc in your HOME dir. Adding the .aliases to sources"
  echo "[ -f ~/.aliases ] && source ~/.aliases "  >> ~/.bashrc || echo "Error: unable to add .aliases into .bashrc"
else
  echo "There is no .bashrc in your HOME dir. Hmms. Adding the .aliases to sources in .zshrc"
  echo "[ -f ~/.aliases ] && source ~/.aliases "  >> ~/.zshrc  || echo "Error: unable to add .aliases into .zshrc"
fi
