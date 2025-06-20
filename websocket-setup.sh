#!/bin/bash

# Function to check if a port is open using /dev/tcp
check_port() {
    local host=$1
    local port=$2
    local timeout=5
    
    # Try to connect using /dev/tcp
    timeout $timeout bash -c "</dev/tcp/$host/$port" 2>/dev/null
    return $?
}

# Wait for database to be ready
echo "Waiting for database to be ready..."
while ! check_port $DB_HOST $DB_PORT; do
  echo "Database not ready yet, waiting..."
  sleep 5
done
echo "Database is ready!"

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
while ! check_port $REDIS_CACHE 6379; do
  echo "Redis not ready yet, waiting..."
  sleep 5
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