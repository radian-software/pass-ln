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

Installing from upstream repositories:

* Ubuntu/Debian: (not available)
* Arch Linux: available on AUR as `pass-ln`
* Homebrew: available in custom tap as `raxod502/pass-ln/pass-ln`

Installing an official release:

* Ubuntu/Debian: `sudo apt install ./pass-extension-ln-x.y.z.deb`
* Arch Linux: `tar -xvf ./pass-ln-pkgbuild-x.y.z.tar.gz && cd
  pass-ln-pkgbuild-x.y.z && makepkg -si`
* Homebrew: `unzip ./pass-ln-homebrew-x.y.z.tar.gz && cd
  pass-ln-homebrew-x.y.z.tar.gz && brew install ./Formula/pass-ln.rb`
* Manual: `sudo tar -xvf ./pass-ln-x.y.z.tar.gz --strip-components=1 -C /usr`

Installing from source (in `packaging` directory):

* Ubuntu/Debian: `make deb-install`
* Arch Linux: `make pkgbuild-install`
* Homebrew: `make homebrew-install`
* Manual: `make tar` will generate `pass-ln-x.y.z.tar.gz` but will not
  install it automatically since installing software outside a package
  manager is not generally recommended
