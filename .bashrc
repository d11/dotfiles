function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)] /"
}
function parse_job {
	echo "{${JOB} ${SCENE}/${SHOTNAME}} " | sed -e 's/{ \/} //' | sed -e 's/ \/}/}/' 
}
PS1='\[\033[01;36m\]\u@\h\[\033[01;33m\] $(parse_job)\[\033[01;34m\]\w \[\033[01;36m\]$(parse_git_branch)$ \[\033[00m\]'
PROMPT_COMMAND='echo -ne "\033]0;${PWD}\007"'

#'echo -ne "\033]0;$cwd\007"'
#echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"

export GREP_COLOR="1;33"
alias grep='grep --color=auto'
alias ls='ls --color=auto'

alias gst='git status'
alias gca='git commit -a'
alias gco='git checkout'
alias ga='git add'
alias gka='gitk --all'
alias gdn='git diff --name-status'

alias red='echo -e "\033]11;"darkred"\033\\"'
#alias codereview='echo "cd /usr/people/daniel-ho/git/$@ ; git difftool -t meld -y origin/master ; cd -"'

#function codereview {
#	REVIEW_DIR=$1
#	if [ -n $REVIEW_DIR ] ; then
#		REVIEW_DIR=`pwd | xargs basename`
#	fi
#	echo "cd /usr/people/daniel-ho/git/$REVIEW_DIR ; git difftool -t meld -y origin/master ; cd -"
#}

function glog {
	REVIEW_DIR=$1
	LOGCOUNT=$2
	if [ ! $LOGCOUNT ]; then
		LOGCOUNT=10
	fi
	git --work-tree=/usr/people/daniel-ho/git/$REVIEW_DIR --git-dir=/usr/people/daniel-ho/git/$REVIEW_DIR/.git lg -n $LOGCOUNT
}

#source ~/tools/linux/z.sh

PATH="/usr/people/daniel-ho/install/bin:$PATH"

function gvimMagic {
  str1="`dcop kwin KWinInterface currentDesktop`"
  str1="DESKTOP$str1"
  str1="${str1%\\n}";
  gvim --servername $str1 --remote-send "<Esc>:split<CR>"
  if (( $? != 0 )) ; then
	  gvim --servername $str1 $*;
  else
	  gvim --servername $str1 --remote-silent $*
  fi

}

function gvimOne {
  str1="MAINVIM"
  if ( /software/mpc/scripts/gvim --serverlist | grep $str1 > /dev/null ) ; then
	  if [ -n "$*" ] ; then
		  gvim --servername $str1 --remote-silent $* ;
	  else 
		  gvim --servername $str1 --remote-send "<Esc>:enew<CR>" ;
	  fi
 else
	 gvim --servername $str1 $*
 fi
 wmctrl -a $str1
}

function viewLog {
	gvim -R -u ~/config/logvimrc $*
}
export MPC="/software/mpc"
export CONFIG="/software/mpc/config"
export PATH="/software/mpc/scripts/:$PATH"
alias gvim='gvimOne '
alias g='gvimOne '
export VIM_VERSION=7.3
#alias maya='maya -style plastique'
alias maya='maya -style cleanlooks'

#export JPY=/usr/people/daniel-ho/install/lib/j2/j.py
#. ~/install/lib/j2/j.sh

 export PERL5LIB="/usr/people/$user/perl/share/perl/5.8.8/:/usr/people/$user/perl/lib/perl/5.8.8/";
