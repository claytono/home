if [ `uname` = 'Darwin' ]; then
  test -r /sw/bin/init.sh && . /sw/bin/init.sh
fi

# prepend
for i in /opt/local/bin /opt/local/sbin $HOME/bin; do 
  echo $PATH | grep -q -s $i
  if [ $? -eq 1 ] ; then
    PATH="$i:$PATH"
  fi
done

# append
APPEND=""
if [ `uname` = "Darwin" ]; then
  APPEND="/usr/local/bin"
fi 

for i in $APPEND; do 
  echo $PATH | grep -q -s $i
  if [ $? -eq 1 ] ; then
    PATH="$PATH:$i"
  fi
done

export PATH

if [ -d /opt/local/man ]; then 
  MANPATH="/opt/local/man:$MANPATH"
  export MANPATH
fi

if type -p joe >/dev/null; then
  SVN_EDITOR=`type -p joe`
  SVN_EDITOR="$SVN_EDITOR -wordwrap"
  GIT_EDITOR=$SVN_EDITOR
  VISUAL=`type -p joe`
  EDITOR=`type -p joe`
elif type -p emacs >/dev/null; then
  VISUAL=`type -p emacs`
  EDITOR=`type -p emacs`
elif type -p xemacs >/dev/null; then
  VISUAL=`type -p xemacs
  EDITOR=`type -p xemacs
elif type -p vim >/dev/null; then
  VISUAL=`type -p vim`
  EDITOR=`type -p vim`
else
  VISUAL=`type -p vi`
  EDITOR=`type -p vi`
fi

export VISUAL
export EDITOR
export SVN_EDITOR
export GIT_EDITOR

if type -p colordiff >/dev/null; then
  SVKDIFF=`type -p colordiff`
  SVKDIFF="$SVKDIFF -u" 
  export SVKDIFF
  alias diff=`type -p colordiff`
fi

AIRPORTCMD="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport"
if [ -x $AIRPORTCMD ]; then
  alias airport=$AIRPORTCMD
fi

if type -p w >/dev/null; then
  w
fi

LS=`type -p ls`
if type -p gls >/dev/null; then
  LS=`type -p gls`
fi

if $LS --version 2>/dev/null|grep GNU >/dev/null 2>&1; then
  alias ls="$LS --color=auto -F --dereference-command-line-symlink-to-dir"
fi

if [ -n "$BASH" ]; then
  shopt -s checkwinsize checkhash histappend mailwarn
  HISTFILESIZE=5000
fi

