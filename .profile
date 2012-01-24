if [ `uname` = 'Darwin' ]; then
  test -r /sw/bin/init.sh && . /sw/bin/init.sh
fi

# prepend
for i in $HOME/bin; do
  echo $PATH | grep -q -s $i
  if [ $? -eq 1 ] ; then
    PATH="$i:$PATH"
  fi
done

if [ `uname` = "Darwin" ]; then
  PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  alias top="top -u"
fi 

export PATH

for i in /opt/local/man /usr/local/man; do
  if [ -d $i ]; then 
    MANPATH="$i:$MANPATH"
    export MANPATH
  fi
done

if type -p joe >/dev/null; then
  SVN_EDITOR=`type -p joe`
  SVN_EDITOR="$SVN_EDITOR -wordwrap +1 -syntax diff"
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

if grep -V 2>&1 | grep GNU >/dev/null 2>&1; then
  alias grep="grep --color=auto"
fi

if [[ -x /opt/local/bin ]]; then
  alias port="sudo port"
fi

[[ -s "/Users/coneill/.rvm/scripts/rvm" ]] && source "/Users/coneill/.rvm/scripts/rvm"
