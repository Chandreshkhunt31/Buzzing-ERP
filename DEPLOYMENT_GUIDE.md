# ERPNext Render Deployment Guide

## Prerequisites

1. **External Database**: You'll need to set up external MariaDB/MySQL and Redis databases
2. **Render Account**: Free account with payment method (for verification)

## Step 1: Set Up External Databases

### Option A: Use Railway (Recommended for free tier)

1. Go to [Railway](https://railway.app)
2. Create a new project
3. Add two services:
   - **MySQL Database** (for ERPNext)
   - **Redis Database** (for caching and queues)
4. Note down the connection details

### Option B: Use PlanetScale

1. Go to [PlanetScale](https://planetscale.com)
2. Create a new database
3. Note down the connection details

### Option C: Use Supabase

1. Go to [Supabase](https://supabase.com)
2. Create a new project
3. Use the PostgreSQL database (with some configuration changes)

## Step 2: Deploy to Render

1. **Push your code** to GitHub:
   ```bash
   git add .
   git commit -m "Add Render deployment configuration"
   git push origin main
   ```

2. **Go to Render Dashboard**:
   - Visit [dashboard.render.com](https://dashboard.render.com)
   - Click "New +" → "Blueprint"

3. **Connect Repository**:
   - Connect your GitHub repository
   - Render will detect the `render.yaml` file

4. **Configure Environment Variables**:
   Before deploying, you need to set these environment variables in Render:
   
   - `DB_HOST`: Your external database host
   - `DB_PORT`: Your external database port (usually 3306 for MySQL)
   - `REDIS_HOST`: Your external Redis host
   - `DB_PASSWORD`: Your database password

5. **Deploy**:
   - Click "Apply" to create all services
   - Render will create 3 web services and 2 databases

## Step 3: Post-Deployment Setup

1. **Wait for all services to be healthy**
2. **Access your ERPNext instance** at the provided URL
3. **Default credentials**:
   - Username: `Administrator`
   - Password: Same as your `DB_PASSWORD`

## Services Created

- **erpnext-backend**: Main Frappe backend with integrated workers
- **erpnext-frontend**: Nginx frontend proxy
- **erpnext-websocket**: Socket.IO for real-time features
- **erpnext-db**: MariaDB database
- **erpnext-redis**: Redis database

## Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `DB_HOST` | Database host | `containers-us-west-1.railway.app` |
| `DB_PORT` | Database port | `3306` |
| `REDIS_HOST` | Redis host | `containers-us-west-1.railway.app` |
| `DB_PASSWORD` | Database password | `your-secure-password` |

## Important Notes

### Free Tier Limitations:
- **No separate worker services**: Background workers run in the main backend service
- **Services sleep after 15 minutes**: May cause delays when waking up
- **Limited resources**: May affect performance for heavy workloads

### Production Considerations:
- **Upgrade to paid plans** for better performance
- **Separate worker services** available in paid tiers
- **Better resource allocation** in paid plans

## Troubleshooting

### Common Issues:

1. **Database Connection Failed**:
   - Verify database credentials
   - Check if database is accessible from Render's IP ranges
   - Ensure database allows external connections

2. **Services Not Starting**:
   - Check service logs in Render dashboard
   - Verify all environment variables are set
   - Ensure Docker images are building correctly

3. **ERPNext Not Loading**:
   - Wait for all services to be healthy
   - Check if site was created properly
   - Verify database tables were created

4. **Background Jobs Not Processing**:
   - Check backend service logs for worker processes
   - Verify Redis connectivity
   - Ensure workers started successfully

### Logs to Check:

- **Backend logs**: Check `erpnext-backend` service logs for both API and worker processes
- **Database logs**: Check your external database provider
- **Frontend logs**: Check `erpnext-frontend` service logs

## Cost Optimization

- **Free Tier**: Services sleep after 15 minutes of inactivity
- **Upgrade**: Consider paid plans for production use
- **Database**: External databases may have their own costs

## Support

If you encounter issues:
1. Check Render service logs
2. Verify database connectivity
3. Review ERPNext documentation
4. Check Frappe Docker documentation 