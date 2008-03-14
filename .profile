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

if which joe >/dev/null; then
  SVN_EDITOR=`which joe`
  SVN_EDITOR="$SVN_EDITOR -wordwrap"
  VISUAL=`which joe`
  EDITOR=`which joe`
elif which emacs >/dev/null; then
  VISUAL=`which emacs`
  EDITOR=`which emacs`
elif which xemacs >/dev/null; then
  VISUAL=`which xemacs
  EDITOR=`which xemacs
elif which vim >/dev/null; then
  VISUAL=`which vim`
  EDITOR=`which vim`
else
  VISUAL=`which vi`
  EDITOR=`which vi`
fi

export VISUAL
export EDITOR
export SVN_EDITOR

if which colordiff >/dev/null; then
  SVKDIFF=`which colordiff`
  SVKDIFF="$SVKDIFF -u" 
  export SVKDIFF
  alias diff=`which colordiff`
fi

AIRPORTCMD="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport"
if [ -x $AIRPORTCMD ]; then
  alias airport=$AIRPORTCMD
fi

