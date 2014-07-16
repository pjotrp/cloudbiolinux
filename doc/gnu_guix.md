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

## Run guix using the latest git packages

Checkout the git repository, e.g.,

```sh
git clone git://git.sv.gnu.org/guix.git
cd guix
```

And prepare the build environment (note we have guix now!)

```sh
guix package -i gettext guile automake autoconf pkg-config m4 libtool libgcrypt
export ACLOCAL_PATH=~/.guix-profile/share/aclocal
./bootstrap
./configure PKG_CONFIG=true SQLITE3_LIBS="-lsqlite3" --with-libgcrypt-prefix=/gnu/store/cdw0wjgj1111zz1j0451v97cvy53fy6j-libgcrypt-1.6.1
```

Do not run make, but install a new version of guix via pre-inst-env guix(!)

Now you can build a package in the source tree with, for example (nya)

```sh
./pre-inst-env guix build hello --keep-failed
```
