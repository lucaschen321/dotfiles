# Use GNU coreutils adnd GNU grep with 'g' prefix
gnubin="/usr/local/opt/grep/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/sbin"
PATH=$HOME/bin:$gnubin:$PATH

# Access man pages with normal names without 'g' prefix
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"


# Force color support
export CLICOLOR_FORCE=1
