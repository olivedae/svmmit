#!/bin/sh

function join() {
  delim=$1
  shift
  vals=("$@")
  str=""
  is_first=true

  for val in "${vals[@]}"
  do
    if [ $is_first == false ]; then
      str+="$delim"
    fi

    str+="$val"
    is_first=false
  done

  echo "$str"
}

function parse_commit() {
  diff=(svn diff -c -$1)
  if ! [ $file == false ]; then
    diff+=($file)
  fi

  diff=$(join " " "${diff[@]}")

  for diff in $($diff)
  do
    if [[ $diff =~ $pattern ]]; then
      revs+=($1)
    fi
  done
}

function echo_stats() {
  printf "Mentioned in: "

  count=${#revs[@]}

  if [ $count == 0 ]; then
    echo "none"
    exit
  fi

  join ", " "${revs[@]}"
}

function echo_usage() {
  echo "usage: svmmit [--help|-h] [--version|-v] [directory] [search]"
  exit
}

function echo_version() {
  echo "0.0.1"
  exit
}

if [[ $1 =~ ^(--version|-v)$ ]]; then
  echo_version
fi

if [[ ! $1 || $1 =~ ^(--help|-h)$ || ! $2 ]]; then
  echo_usage
fi

dir=$1
pattern=$2
revs=()
limit=false
file=false

while test $# -gt 0
do
  if [[ $1 =~ ^(--limit|-l)$ ]]; then
    shift
    $limit=$1
  fi

  if [[ $1 =~ ^(--file|-f)$ ]]; then
    shift
    $file=$1
  fi

  shift
done

logs=(svn log)

if ! [ $limit == false ]; then
  logs+=(--limit $limit)
fi

if ! [ $file == false ]; then
  logs+=($file)
fi

logs=$(join " " "${logs[@]}")

cd $dir

for commit in $($logs)
do
  if [[ $commit =~ ^r[(0-9)]+$ ]]; then
    parse_commit $commit
  fi
done

echo_stats
