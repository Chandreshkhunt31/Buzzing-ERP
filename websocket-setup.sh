#!/bin/bash

# Wait for database to be ready
echo "Waiting for database to be ready..."
while ! nc -z $DB_HOST $DB_PORT; do
  sleep 1
done
echo "Database is ready!"

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
while ! nc -z $REDIS_CACHE 6379; do
  sleep 1
done
echo "Redis is ready!"

# Configure Frappe
echo "Configuring Frappe..."
bench set-config -g db_host $DB_HOST
bench set-config -gp db_port $DB_PORT
bench set-config -g redis_cache "redis://$REDIS_CACHE:6379"
bench set-config -g redis_queue "redis://$REDIS_QUEUE:6379"
bench set-config -g redis_socketio "redis://$REDIS_QUEUE:6379"
bench set-config -gp socketio_port 9000

# Set site as default
SITE_NAME=${FRAPPE_SITE_NAME_HEADER:-${RENDER_EXTERNAL_HOSTNAME}}
bench use $SITE_NAME

# Start the WebSocket service
echo "Starting WebSocket service..."
node /home/frappe/frappe-bench/apps/frappe/socketio.js 