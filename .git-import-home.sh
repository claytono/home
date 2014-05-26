#!/bin/bash

function evil_git_dirty {
  [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
}

if evil_git_dirty; then
    echo "You have local changes, cannot import over them."
    echo
    git status --short --untracked-files=no
    exit 1
fi

rm -rf ~/.git
cd ~/
git init
git remote add origin https://github.com/dvorak/home.git
git fetch --all
git reset --hard origin/master

