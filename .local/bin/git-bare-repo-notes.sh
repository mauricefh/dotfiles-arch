git clone --bare https://github.com/mauricefh/notes.git $HOME/.notes
function config {
   /usr/bin/git --git-dir=$HOME/.notes/ --work-tree=$HOME $@
}
mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing notes.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .notes-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no
