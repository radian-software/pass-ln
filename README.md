# pass-ln

This repository has a [Pass](https://www.passwordstore.org/) extension
providing the `pass ln` subcommand, which creates symbolic links
within your password store.

## Motivation

Consider a website like [Stack Exchange](https://stackexchange.com/),
where you have a single account and set of login credentials, but you
use it to log into a number of different domains, including
`stackoverflow.com`, `askubuntu.com`, `mathoverflow.com`, and others.
One way to represent this in the password store is using symbolic
links:

```
% pass insert stackexchange.com/you@example.com
% ln -s stackexchange.com ~/.password-store/stackoverflow.com
% ln -s stackexchange.com ~/.password-store/askubuntu.com
% ln -s stackexchange.com ~/.password-store/mathoverflow.com
```

The advantage: your shared credentials are automatically available for
autofill on all the individual websites, without the need for further
configuration; meanwhile, there is only one underlying password file,
so there is no fear of things getting out of sync.

## Usage

This extension adds a simple subcommand to replace the commands above
like so:

```
% pass insert stackexchange.com/you@example.com
% pass ln stackexchange.com stackoverflow.com
% pass ln stackexchange.com askubuntu.com
% pass ln stackexchange.com mathoverflow.com
```

It does the same thing, but with more friendly semantics: both
arguments are taken as entries relative to the root of your password
store, and have proper autocompletion. The subcommand automatically
determines the right relative path to set as the target of the
symbolic link, so you don't have to worry about accidentally
hardcoding the path to your password store directory.

## Installation

You can download the latest release from GitHub Releases, or install
from source.

Installing from distro repositories:

* Ubuntu/Debian: (not available)
* Red Hat/Fedora: (not available)
* Arch Linux: [available on AUR as
  `pass-ln`](https://aur.archlinux.org/packages/pass-ln)
* Homebrew: [available in custom tap as
  `raxod502/pass-ln/pass-ln`](https://github.com/raxod502/homebrew-pass-ln)

Installing an official release:

* Ubuntu/Debian: `sudo apt install ./pass-extension-ln-x.y.z.deb`
* Red Hat/Fedora: `sudo yum install ./pass-ln-x.y.z.rpm`
* Arch Linux: `tar -xvf ./pass-ln-pkgbuild-x.y.z.tar.gz && cd
  pass-ln-pkgbuild-x.y.z && makepkg -si`
* Homebrew: `unzip ./pass-ln-homebrew-x.y.z.tar.gz && cd
  pass-ln-homebrew-x.y.z.tar.gz && brew install ./Formula/pass-ln.rb`
* Manual: `sudo tar -xvf ./pass-ln-x.y.z.tar.gz --strip-components=1
  -C /usr`, and install `pass` and `coreutils`

Installing from source (in `packaging` directory):

* Ubuntu/Debian: `make deb-install`
* Red Hat/Fedora: `make rpm-install`
* Arch Linux: `make pkgbuild-install`
* Homebrew: `make homebrew-install`
* Manual: `make tar` will generate `pass-ln-x.y.z.tar.gz` but will not
  install it automatically since installing software outside a package
  manager is not generally recommended

Running from source without installing:

* Add `export PASSWORD_STORE_ENABLE_EXTENSIONS=true` to your shell
  profile.
* Create `~/.password-store/.extensions` if it does not already exist
  (substitute the value of `PASSWORD_STORE_EXTENSIONS_DIR` if set).
* Create a symbolic link, `ln -s "$PWD/pass-ln.bash"
  ~/.password-store/.extensions/ln.bash`.

## Reference documentation

If you have installed `pass-ln`, you can access full documentation in
its man page by running `man pass-ln`. The same information is
reproduced here for convenience.

The full command-line syntax for `pass ln`, creating a symbolic link
named `LINK_NAME` pointing at `TARGET`:

```
% pass ln TARGET LINK_NAME
```

`TARGET` and `LINK_NAME` are both relative to the password store root
in all cases (i.e., they would be suitable as arguments to other
subcommands such as `pass generate` and `pass edit`). The symbolic
link will always be relative, and `TARGET` is rewritten using the
appropriate relative path given the parent directory of `LINK_NAME`.
Note that `TARGET` can be either a file or directory.

`LINK_NAME` must not already exist. There is no option to overwrite an
existing file or directory with a symbolic link. To do this, first
`pass rm` the existing file or directory, then create the symbolic
link with `pass ln`.

Any needed parent directories will be created automatically, like
`pass` does normally.

If `LINK_NAME` has a trailing slash, it will be automatically suffixed
with the basename of `TARGET`, like in `mv` and `cp`. This behavior is
restricted to when `LINK_NAME` explicitly has a trailing slash, to
minimize confusion.

## Known issues

* You cannot use `pass insert` to insert an entry into a directory
  through a symlink (e.g. if `foo` is a symlink pointing to directory
  `bar`, then `pass insert foo/quux` will fail even though `pass
  insert bar/quux` is fine). The error is `fatal: pathspec
  '/home/yourname/.password-store/foo/quux.gpg' is beyond a symbolic
  link`. This is a bug in Pass and cannot be fixed in pass-ln.
  Unfortunately, Pass does not have a bug tracker, so there is no
  upstream reference for the bug.
* The output of `pass ls` may be unexpected in the face of symbolic
  links. In particular, you may see the text `[recursive, not
  followed]` after a symbolic link. This is normal, and indicates that
  the contents of the directory that the symlink is pointing to have
  already been displayed in the current output, and `tree` is
  refraining from showing the same information a second time.
* Autocompletion for `pass ln` does not work in Fish. Unfortunately,
  this is due to a bug in Pass which causes it to ignore Pass
  extensions when generating autocompletions, and there is no way to
  fix this in pass-ln.
