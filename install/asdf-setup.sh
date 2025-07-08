#!/bin/bash

## Setup node
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest

asdf plugin add bun
asdf install bun latest
asdf global bun latest

npm install yarn --global
npm install turbo --global

## Setup Python
asdf plugin add python
asdf install python latest
asdf global python latest