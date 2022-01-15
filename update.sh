echo "Update Start"
    git fetch --all || exit
    git reset --hard origin/master || exit
echo "Update Complete"
