git checkout master
git add --all
git status
git commit -m "NSA tools exploit"

git rm pull.sh
git rm push.sh

git fetch origin master
git rebase origin/master
git push origin master

read -p "Press Enter to continue..."
