#!/bin/bash

echo "🚀 Starting Stirling PDF..."

# Create directories if they don't exist
mkdir -p data/{tessdata,configs,customFiles,logs,pipeline}

# Set permissions
chmod -R 755 data/

# Download English OCR data if not present
if [ ! -f "data/tessdata/eng.traineddata" ]; then
    echo "📚 Downloading English OCR data..."
    wget -q -O data/tessdata/eng.traineddata https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata || echo "⚠️ Failed to download OCR data"
fi

# Start Stirling PDF with Docker Compose
echo "🐳 Starting Stirling PDF container..."
docker-compose up -d

# Wait for service to be ready
echo "⏳ Waiting for Stirling PDF to start..."
timeout=60
counter=0
while [ $counter -lt $timeout ]; do
  if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Stirling PDF is ready at http://localhost:8080"
    break
  fi
  echo "   Still waiting... ($counter/$timeout seconds)"
  sleep 3
  counter=$((counter + 3))
done

if [ $counter -ge $timeout ]; then
  echo "⚠️ Stirling PDF took longer than expected to start."
  echo "   Check logs with: docker-compose logs"
else
  echo ""
  echo "🎉 Stirling PDF is now running!"
  echo "   📱 Access the web interface: http://localhost:8080"
  echo "   📋 View logs: docker-compose logs -f"
  echo "   ⏹️ Stop service: docker-compose down"
fi