# Deploy to Render

This guide shows how to deploy the Inventory Management System to Render.com.

## Prerequisites

- A Render account (free tier available)
- GitHub repository with this project code
- MySQL or PostgreSQL database (Render provides free tier)

## Quick Deploy (Recommended)

### 1. Push your code to GitHub

```bash
cd "E:\Laravel Copy\Inventory_Management_System"
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git push -u origin main
```

### 2. Connect Render to your GitHub repo

1. Go to [render.com](https://render.com)
2. Sign in or create a free account
3. Click "New +" → "Web Service"
4. Select "Deploy an existing repository"
5. Connect your GitHub account and authorize Render
6. Select your Inventory_Management_System repository
7. Choose the repository branch (main)

### 3. Configure the web service

| Field | Value |
|-------|-------|
| **Name** | inventory-management-system |
| **Environment** | Docker |
| **Region** | Choose nearest to you |
| **Plan** | Free (or Starter if you need better performance) |

### 4. Set environment variables

In the Render dashboard under "Environment":

```
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-render-url.onrender.com
LOG_CHANNEL=stderr
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
DB_CONNECTION=mysql
DB_HOST=your-mysql-host
DB_PORT=3306
DB_DATABASE=your_database
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

### 5. (Optional) Attach a database

If using render.yaml (auto-deploy):
- Render will provision PostgreSQL and Redis automatically
- Edit `.env` to match the Render database values

If manual setup:
1. Create a MySQL database elsewhere (AWS RDS, PlanetScale, etc.)
2. Add credentials to Render environment variables

### 6. Deploy

1. Click "Create Web Service"
2. Render will build the Docker image and deploy
3. Check the "Logs" tab to monitor the build and startup
4. Once "Live", click the service URL to access your app

## Manual Docker Build (for testing locally)

```bash
docker build -t inventory-management-system .
docker run -p 8000:8000 inventory-management-system
```

Then open [http://localhost:8000](http://localhost:8000)

## File Breakdown

- **Dockerfile**: Defines the container image with PHP 8.2, Node.js, and Laravel setup
- **render.yaml**: Infrastructure-as-code configuration (optional but recommended)
- **.dockerignore**: Excludes unnecessary files from the build

## Render Free Tier Limitations

- 0.5 GB RAM
- No persistent storage (data lost on redeploy)
- 15-minute auto-spin-down after inactivity
- No background jobs (for production use, upgrade to Starter Plan)

For production, upgrade to a Starter or higher plan ($7+/month).

## Troubleshooting

### Build fails with "Docker build timeout"
- Increase Node.js install timeout or use prebuilt image
- Split dependencies into separate build stages

### Application key not set
- Render runs `php artisan key:generate` in the Dockerfile
- Ensure .env.example exists in repo

### Database connection error
- Verify DB credentials in Render environment variables
- Check if database is accessible from Render's network
- Use PlanetScale or AWS RDS for managed MySQL

### Static assets not loading
- Run `npm run production` in Dockerfile (already included)
- Check `public/mix-manifest.json` exists

## Automatic Deploys

Once connected, any push to your main branch will trigger a new deploy automatically.

To disable auto-deploy: In Render dashboard → Web Service Settings → disable "Auto Deploy"

## Render Documentation

- [Render Docker Deployment](https://render.com/docs/docker)
- [Render Environment Variables](https://render.com/docs/environment-variables)
- [Render render.yaml Reference](https://render.com/docs/render-yaml)
