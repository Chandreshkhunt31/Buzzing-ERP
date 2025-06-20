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

# Debug: Print environment variables
echo "=== Environment Variables ==="
echo "DB_HOST: ${DB_HOST:-'NOT SET'}"
echo "DB_PORT: ${DB_PORT:-'NOT SET'}"
echo "REDIS_CACHE: ${REDIS_CACHE:-'NOT SET'}"
echo "REDIS_QUEUE: ${REDIS_QUEUE:-'NOT SET'}"
echo "FRAPPE_SITE_NAME_HEADER: ${FRAPPE_SITE_NAME_HEADER:-'NOT SET'}"
echo "RENDER_EXTERNAL_HOSTNAME: ${RENDER_EXTERNAL_HOSTNAME:-'NOT SET'}"
echo "================================"

# Configure Frappe
echo "Configuring Frappe..."
bench set-config -g db_host $DB_HOST
bench set-config -gp db_port $DB_PORT
bench set-config -g redis_cache "redis://$REDIS_CACHE:6379"
bench set-config -g redis_queue "redis://$REDIS_QUEUE:6379"
bench set-config -g redis_socketio "redis://$REDIS_QUEUE:6379"

# Create site if it doesn't exist
SITE_NAME=${FRAPPE_SITE_NAME_HEADER:-${RENDER_EXTERNAL_HOSTNAME}}
echo "Using site name: $SITE_NAME"

if [ ! -d "/home/frappe/frappe-bench/sites/$SITE_NAME" ]; then
    echo "Creating site: $SITE_NAME"
    bench new-site $SITE_NAME \
        --db-host $DB_HOST \
        --db-port $DB_PORT \
        --db-name erpnext \
        --db-user erpnext \
        --db-password $DB_PASSWORD \
        --admin-password $DB_PASSWORD \
        --install-app erpnext \
        --force
else
    echo "Site $SITE_NAME already exists"
fi

# Set site as default
bench use $SITE_NAME

# Start background workers in the background
echo "Starting background workers..."
bench worker --queue short,default &
bench worker --queue long,default,short &
bench schedule &

# Start the backend service
echo "Starting Frappe backend..."
bench start --port 8000 