# If you come from bash you might have to change your $PATH.
homebrew="$(brew --prefix coreutils)"/libexec/gnubin:usr/local/bin:/usr/local/sbin
PATH=$HOME/bin:$homebrew:$PATH
MANPATH="/usr/local/opt/coreutils/libexec/gnuman"
