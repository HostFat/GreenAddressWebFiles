#!/bin/bash

MSG=$(git log --format=%B -n 1 $TRAVIS_COMMIT)
git config --global user.email "info@greenaddress.it"
git config --global user.name "GreenAddress"

tar -xf keys.tar

eval "$(ssh-agent -s)"
ssh-add crx

git clone git@github.com:greenaddress/WalletCrx.git
cp WalletCrx/static/wallet/config{,_regtest,_testnet}.js /tmp
python render_templates.py WalletCrx
rm -rf WalletCrx/static
cp -r static WalletCrx/static
mkdir -p WalletCrx/static/wallet >/dev/null
mv /tmp/config{,_regtest,_testnet}.js WalletCrx/static/wallet/

cd WalletCrx
git add --all .
git commit -m"$MSG"
git push
cd ..



ssh-agent -k
eval "$(ssh-agent -s)"
ssh-add cordova

git clone git@github.com:greenaddress/WalletCordova.git
cp WalletCordova/www/greenaddress.it/static/wallet/config.js /tmp/config.js
python render_templates.py -a WalletCordova/www/greenaddress.it
rm -rf WalletCordova/www/greenaddress.it/static
cp -r static WalletCordova/www/greenaddress.it/static
mkdir -p WalletCordova/www/greenaddress.it/static/wallet >/dev/null
mv /tmp/config.js WalletCordova/www/greenaddress.it/static/wallet/config.js

cd WalletCordova
git add --all .
git commit -m"$MSG"
git push