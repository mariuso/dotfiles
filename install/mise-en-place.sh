#!/bin/bash

# Install mise-en-place version manager
/bin/bash -c "$(curl -fsSL https://mise.run)"
bash ~/.local/bin/mise --version

mise plugin i yarn

mise plugin up yarn