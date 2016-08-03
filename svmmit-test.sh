#!/usr/bin/env roundup

describe "svmmit: expressive and minimal searches in svn."

svmmit="sh svmmit.sh"
branch="./.tests/working_copy"

it_displays_usage() {
	usage=$($svmmit)

	test $usage = "svmmit: lol"
}

it_displays_no_results() {
	mentioned=$($svmmit $branch /class\s+(NotHere)/)

	test $mentioned = "Mentioned in: none"
}

it_displays_findings() {
	mentioned=$($svmmit $branch /class\s+(a|b|c)/)

	test $mentioned = "Mentioned in: r1, r2, r3"
}
