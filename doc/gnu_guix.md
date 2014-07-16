# GNU Guix for CloudBioLinux

GNU Guix is the versatile and ultimate package manager for the GNU project and
allows for very robust dependency management.

Note that the locale in the VM needs to be UTF8

```sh
export LC_ALL=en_US.UTF-8
```

## Install GNU Guix

Install GNU Guix on a running Ubuntu/Debian VM, or your own machine

```sh
apt-get install guile-2.0 libgcrypt-dev libsqlite3-dev libbz2-dev sqlite3
mkdir guix && cd guix
wget http://alpha.gnu.org/gnu/guix/guix-0.6.tar.gz
./configure PKG_CONFIG=true SQLITE3_LIBS="-lsqlite3"
make
make install
```

Now set up the users and dirs

```sh
useradd guix-builder
useradd -g guix-builder -G guix-builder -d /var/empty -s `which nologin` -c "Guix build user" --system guix-builder
mkdir -p /gnu/store
chown guix-builder.guix-builder /gnu/store
```

and start the daemon

```sh
guix-daemon --build-users-group guix-builder &
```

## Run GNU Guix

By default Guix pulls package (binaries) from the GNU source. First it
needs a public key (which is in the source)

```sh
guix archive --authorize < hydra.gnu.org.pub
```

To have install the hello package:

```sh
guix package -i hello
```

Note that you can interrupt the installation at any time (e.g. ctrl-C)
without doing any damage.

Now you can run 

```sh
root@debian:/home/biolinux/tmp/guix-0.6# /gnu/store/5k0dr40p8404sgjx9w7vbb9vdcp6kzsl-hello-2.9/bin/hello 
Hello, world!
```

You can also run 'guix package -i' as a normal user(!) as long as a two
directories are writable

```sh
mkdir /usr/local/var/guix/profiles/per-user/biolinux
chown biolinux /usr/local/var/guix/profiles/per-user/biolinux
```

Now an install will create the symlinks so that the user can run

```sh
~/.guix-profile/bin/hello
```

and add that to the PATH with

```sh
export PATH=$HOME/.guix-profile/bin:$PATH
```

To list installable packages

```sh
guix package -A
```

All software is installed under the /gnu/store. Moving from one image/VM/hard disk
to another, you can copy the whole directory '''as is''', provided the Linux 
kernel is compatible. It important to realise that GNU Guix is self contained.

## Run guix using the latest git packages

Checkout the git repository, e.g.,

```sh
git clone git://git.sv.gnu.org/guix.git
cd guix
```

And prepare the build environment (note we have guix now!)

```sh
export PATH=$HOME/.guix-profile/bin
export PKG_CONFIG_PATH="/root/.guix-profile/lib/pkgconfig"
export ACLOCAL_PATH="/root/.guix-profile/share/aclocal"
export CPATH="/root/.guix-profile/include"
export LIBRARY_PATH="/root/.guix-profile/lib"

guix package -i gettext guile automake autoconf \
  pkg-config m4 libtool libgcrypt sqlite libgcrypt \
  bintools gcc make linux-libre-headers glibc-bootstrap \
  bootstrap-binaries git

./bootstrap
./configure
make clean
make
```

Note that the PATH only allows Guix tools to be run during the build.

Do not run 'make install', but install a new version of guix via pre-inst-env guix
to get rid of non-guix dependencies(!)

Now you can build a package in the source tree with, for example (nya)

```sh
./pre-inst-env guix build hello --keep-failed
```

