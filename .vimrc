set paste
syntax on

" prefix line with cp -p /home/..../ then add space and . to the end
" usage: go to start of the block and run: 20@q 
" It will add this to the 20lines 
let @q="\<Esc>^icp -p /home/tutenuser/malware/\<Esc>\<Esc>A .\<Esc>j"
