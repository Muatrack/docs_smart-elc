#!/bin/bash

if [ -d .env ]; then
	echo "exit venv"
	deactivate
	echo "entry venv"
	source .env/bin/activate
else
	echo "No python venv exists"
	exit
fi

ps aux | grep 'sphinx-autobuild' | grep -v 'color=auto' | awk '{print $2}' | xargs kill -9 2>&1 > /dev/null

make clean
make html
sphinx-autobuild --host 0.0.0.0 --port 8080 source build/html &
