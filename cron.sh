zsh ubuntu-generate-list.sh
logger "Bluetack Blacklist: New blacklist generated"
git add blacklist
git add blacklist-domains
git commit -am "Updated blocklist"
git push https://$gituser:$gittoken@github.com/actuallymentor/bluetack-ip-blacklist-generator.git --all
logger "Bluetack Blacklist: Pushed to github"
