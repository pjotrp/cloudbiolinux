# GNU Guix for CloudBioLinux

GNU Guix is the versatile package manager for the GNU project and 
allows for very robust dependency management.

To pull in Guix support run the guix flavor, e.g.

    fab  -H biolinux -f ./test/../fabfile.py -c ./test/../contrib/flavor/guix/fabricrc_debian.txt install_biolinux:flavor=./test/../contrib/flavor/guix


