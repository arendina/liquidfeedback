#!/bin/bash

# From install file

set -e

# 1. Install necessary dependencies
apt-get update
apt-get -q -y install build-essential lua5.3 liblua5.3-dev libbsd-dev postgresql postgresql-server-dev-9.6 libpq-dev bmake imagemagick exim4 python-pip
pip install markdown2

# 2. Ensure that the user account of your webserver has access to the database
su postgres --command "createuser --no-superuser --createdb --no-createrole www-data"
