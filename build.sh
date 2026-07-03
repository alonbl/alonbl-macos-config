#!/bin/sh
SCRIPTDIR="$(dirname "${0}")"

for x in \
	~/.config \
	~/.gitconfig \
	~/.vim \
	~/.vimrc \
	~/.zprofile \
	~/.zshrc \
       ; do
	cp -r "${x}" "${SCRIPTDIR}"/home/
done
