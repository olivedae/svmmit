#!/bin/sh

cd $1

file=$2

diff_pattern=$3

function parse_commit {
  for diff in $(svn diff -c -$1 $file)
  do
    if [[ $diff =~ $diff_pattern ]]; then
      echo "Mentioned in: " $1
    fi
  done
}

for commit in $(svn log --limit 1000 $file)
do
  if [[ $commit =~ ^r[(0-9)]+$ ]]; then
    parse_commit $commit
  fi
done

cd -
