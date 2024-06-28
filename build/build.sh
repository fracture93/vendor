#!/bin/bash
# Builds retail and classic, and then junctions the resulting files from .release to the respective wow folders.
# Paths to the junction tool and WoW folder specified in .env

# Process command-line options
usage() {
	echo "Usage: build.sh [-d]" >&2
	echo "  -c               Builds classic only and junctions into classic wow." >&2
	echo "  -d               Enable Dev mode. Doesn't build, junctions directly to retail." >&2
}

exit_code=0
while getopts ":cd" opt; do
	case $opt in
	c)
		clean="true"
		;;
	d)
		devmode="true"
		;;
	\?)
		if [ "$OPTARG" != "?" ] && [ "$OPTARG" != "h" ]; then
			echo "Unknown option \"-$OPTARG\"." >&2
		fi
		usage
		exit 1
		;;
	esac
done

if [ $clean ]; then
    (cd build; ./clean.sh)
    echo
    echo "All junctions removed."
    exit $exit_code
fi

if [ $devmode ]; then
    (cd build; ./devmode.sh)
    echo
    echo "Dev mode enabled."
else
	if [ $classicOnly ]; then
		(cd build; ./build_classic.sh)
	else
		(cd build; ./build_retail.sh)
		#(cd build; ./build_classic.sh)
	fi
    echo
    echo "Build complete."
fi

exit $exit_code