#!/bin/bash

# Supabase Container Reinitialization Script
# This script completely reinitializes the Supabase development environment

set -e  # Exit on any error

echo "🔄 Supabase Container Reinitialization"
echo "========================================="

# Step 1: Stop containers and remove orphan images
echo "1️⃣  Stopping containers and removing orphan images..."
docker compose down --remove-orphans --rmi local || true

# Step 2: Delete persistent volumes
echo "2️⃣  Removing persistent volumes..."
echo "   - Removing Postgres data volume..."
docker volume rm project_supabase_db_data || true
echo "   - Removing storage data volume..."
docker volume rm project_supabase_storage_data || true
echo "   - Removing database config volume..."
docker volume rm project_db-config || true

# List any remaining volumes for reference
echo "   - Remaining project volumes:"
docker volume ls --filter name=project_ --format "table {{.Name}}\t{{.Driver}}" || true

# Step 4: Start containers
echo "4️⃣  Starting containers..."
docker compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to start..."
sleep 10

# Check service status
echo "📊 Service Status:"
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# Verify database buckets
echo ""
echo "🪣 Checking storage buckets..."
if docker exec -i supabase-db psql -U postgres -d postgres -c "SELECT id,name,public FROM storage.buckets ORDER BY name;" 2>/dev/null; then
    echo "✅ Storage buckets verified"
else
    echo "❌ Storage bucket check failed"
fi

echo ""
echo "🎉 Reinitialization complete!"
echo ""
echo "Available services:"
echo "  - Supabase Studio: http://localhost:3000"
echo "  - Kong Gateway: http://localhost:8000"
echo ""