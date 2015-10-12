## Trouble

When building guix from source I got errors such as

    make
    <snip>
    /gnu/store/8vfapbzsy3rwh73xi8mhk633pvw5cv5k-sqlite-3.8.4.3/lib/libsqlite3.so: undefined reference to memcpy@GLIBC_2.14

Changing the AM_CXXFLAGS line in the Makefile into

    AM_CXXFLAGS = -Wall -std=c++0x -Wl,--verbose
    
and running make again showes that I am trying to link non-Guix libraries

    -lgcrypt (/lib/x86_64-linux-gnu/libgcrypt.so)
    -lstdc++ (/usr/lib/gcc/x86_64-linux-gnu/4.7/libstdc++.so)
    -lbz2 (/usr/lib/gcc/x86_64-linux-gnu/4.7/../../../x86_64-linux-gnu/libbz2.so)

and a few more. 

The cause is mixing GNU Guix tools with local Debian build tools. Ascertain
the path only points to 

export PATH=$HOME/.guix-profile/bin
export PKG_CONFIG_PATH="/root/.guix-profile/lib/pkgconfig"
export ACLOCAL_PATH="/root/.guix-profile/share/aclocal"
export CPATH="/root/.guix-profile/include"
export LIBRARY_PATH="/root/.guix-profile/lib"




