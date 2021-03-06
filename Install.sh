#!/bin/bash

# 3. Install and configure LiquidFeedback-Core

mkdir -v /root/build
cd /root/build

tar xvf /vagrant/archive/liquid_feedback_core-v3.2.2.tar.gz
cd liquid_feedback_core-v3.2.2/
make
mkdir -v /opt/liquid_feedback_core
cp -v core.sql lf_update lf_update_issue_order lf_update_suggestion_order /opt/liquid_feedback_core

cd /opt/liquid_feedback_core
su www-data --command "createdb liquid_feedback"
# During the test I had this error:
# createlang: language "plpgsql" is already installed in database "liquid_feedback"
# I leave the line unconmmented to avoid weird errors in different versions of postgres.
su www-data --command "createlang plpgsql liquid_feedback"  # command may be omitted, depending on PostgreSQL version
su www-data --command "psql -v ON_ERROR_STOP=1 -f core.sql liquid_feedback"
su www-data --command "psql -v ON_ERROR_STOP=1 -f /vagrant/archive/simple-configuration.sql liquid_feedback"

# 4. Install Moonbridge
cd /root/build
tar xvf /vagrant/archive/moonbridge-v1.1.1.tar.gz
cd moonbridge-v1.1.1
bmake MOONBR_LUA_PATH=/opt/moonbridge/?.lua
mkdir -v /opt/moonbridge
cp -v moonbridge /opt/moonbridge/
cp -v moonbridge_http.lua /opt/moonbridge/

# 5. Install WebMCP
cd /root/build
tar xvf /vagrant/archive/webmcp-v2.2.0.tar.gz
cd webmcp-v2.2.0
sed -i 's/LUA_BIN = lua/LUA_BIN = lua5.3/' Makefile.options
sed -i 's/LUAC_BIN = luac/LUAC_BIN = luac5.3/' Makefile.options
make
mkdir -v /opt/webmcp
cp -vRL framework/* /opt/webmcp/

# 6. Install the LiquidFeedback-Frontend
cd /root/build
tar xvf /vagrant/archive/liquid_feedback_frontend-v3.2.1.tar.gz -C /opt/
mv -v /opt/liquid_feedback_frontend-v3.2.1 /opt/liquid_feedback_frontend
chown -v www-data /opt/liquid_feedback_frontend/tmp

# 7. Configure mail system
# Not done

# 8. Configure the LiquidFeedback-Frontend
cd /opt/liquid_feedback_frontend/config
cp -v example.lua myconfig.lua

