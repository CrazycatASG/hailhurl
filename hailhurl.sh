!/bin/bash

# Simple check for if a package name is provided
if [ $# -eq 0 ]; then
	echo "No package provided"
    echo "Usage: $0 <package>"
    exit 1
fi
# Store the URL in a variable to make things easier down the line
PACKAGENAME="$1"

# Now we get to the fun stuff >:)

git clone "https://aur.archlinux.org/$PACKAGENAME.git"
APPFOLDER=$PACKAGENAME

cd $APPFOLDER
cat PKGBUILD
echo "WARNING: DO NOT, UNDER ANY CIRCUMSTANCES INSTALL A PACKAGE FROM THE AUR WITHOUT CHECKING THE PKGBUILD FIRST"
read -p "Are you certain you want to build and install this package? [y/n]" userconfirm

if [ "$userconfirm" = "y" ]; then
    yes | makepkg -si
else
    echo "Operation aborted by user"
    exit 1
fi
echo "Done!"


pkgname=$(grep '^pkgname=' PKGBUILD | cut -d= -f2)
pkgver=$(grep '^pkgver=' PKGBUILD | cut -d= -f2)
cd ..
echo -e "$pkgname $pkgver\n" > HAILHURLPACKAGES

read -p "Want the program to clean up? [y/n]" cleanup

if [ "$cleanup" = "y" ]; then
	rm -rf $APPFOLDER
fi
