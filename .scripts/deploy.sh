#!/bin/bash
set -e

echo "Deployment started ..."

# Pull the latest version of the app
echo "Copying New changes...."
git pull origin main
echo "New changes copied to server !"

# Activate Virtual Env
#Syntax:- source virtual_env_name/bin/activate
source ~/project/venv/bin/activate
echo "Virtual env 'venv' Activated !"

echo "Skipping Clearing Cache..."
# python manage.py clean_pyc
# python manage.py clear_cache

echo "Installing Dependencies..."
pip install -r requirements.txt --no-input

# echo "Serving Static Files..."
# python manage.py collectstatic --noinput

echo "Running Database migration..."
python manage.py makemigrations
python manage.py migrate

echo "Starting Collect Startic files command"
python manage.py collectstatic --no-input
# Deactivate Virtual Env
deactivate
echo "Virtual env 'venv' Deactivated !"

echo "Reloading App..."

echo "***********       Restarting Gunicorn     ************* "
systemctl restart gunicorn
echo "***********       Restarting Nginx     ************* "
systemctl restart nginx

echo "Deployment Finished !"