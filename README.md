# ERPNext Deployment on Render

This repository contains the configuration files needed to deploy ERPNext on Render.

## Prerequisites

- A Render account
- Git repository with this code

## Deployment Steps

### 1. Connect to Render

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click "New +" and select "Blueprint"
3. Connect your Git repository

### 2. Deploy with Blueprint

1. Render will automatically detect the `render.yaml` file
2. Click "Apply" to create all services
3. Render will create:
   - 1 Backend service (Frappe)
   - 1 Frontend service (Nginx)
   - 1 WebSocket service (Socket.IO)
   - 3 Worker services (Queue and Scheduler)
   - 2 Databases (MariaDB and Redis)

### 3. Configuration

The deployment will automatically:
- Create a new site with your Render domain
- Install ERPNext
- Configure database connections
- Set up Redis for caching and queues

### 4. Access Your Application

Once deployment is complete:
- Your ERPNext instance will be available at your Render URL
- Default admin credentials will be the same as your database password
- You can log in and start using ERPNext

## Environment Variables

The following environment variables are automatically configured:
- `ERPNEXT_VERSION`: v15.65.4
- `DB_HOST`, `DB_PORT`: MariaDB connection details
- `REDIS_CACHE`, `REDIS_QUEUE`: Redis connection details
- `FRAPPE_SITE_NAME_HEADER`: Your Render domain

## Services

- **erpnext-backend**: Frappe backend API
- **erpnext-frontend**: Nginx frontend proxy
- **erpnext-websocket**: Socket.IO for real-time features
- **erpnext-queue-short**: Short queue worker
- **erpnext-queue-long**: Long queue worker
- **erpnext-scheduler**: Background task scheduler

## Troubleshooting

1. Check service logs in Render dashboard
2. Ensure all services are running
3. Verify database connections
4. Check Redis connectivity

## Customization

To customize the deployment:
1. Modify `render.yaml` for service configuration
2. Update Dockerfiles for custom images
3. Modify setup scripts for custom initialization
4. Add custom environment variables as needed 