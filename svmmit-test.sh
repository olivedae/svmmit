#!/usr/bin/env roundup

describe "svmmit: expressive and minimal searches in svn."

svmmit="sh svmmit.sh"
branch=".tests/working_copy"

it_displays_usage() {
  usage=$($svmmit)

  test "$usage" "=" "usage: svmmit [--help|-h] [--version|-v] [directory] [search]"
}

it_displays_no_findings() {
  mentioned=$($svmmit $branch "class\s+[NotHere]")

  test "$mentioned" "=" "Mentioned in: none"
}

it_displays_simple_findings() {
  mentioned=$($svmmit $branch class)

  test "$mentioned" "=" "Mentioned in: r5, r4, r3, r2"
}

it_correctly_sets_limits() {
  mentioned=$($svmmit $branch --limit 2 "class\s+[a|b|c]")

  test "$mentioned" "=" "Mentioned in: r4"
}

it_correctly_sets_file() {
  mentioned=$($svmmit $branch --file a.php "class\s+[a|b|c]")

  test "$mentioned" "=" "Mentioned in: r2"
}
