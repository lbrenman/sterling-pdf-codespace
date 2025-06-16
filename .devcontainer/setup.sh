#!/bin/bash

echo "🚀 Setting up Stirling PDF development environment..."

# Create necessary directories for persistent data
echo "📁 Creating data directories..."
mkdir -p data/tessdata
mkdir -p data/configs  
mkdir -p data/customFiles
mkdir -p data/logs
mkdir -p data/pipeline

# Set proper permissions
echo "🔒 Setting permissions..."
chmod -R 755 data/

# Download common OCR language files for better functionality
echo "📚 Downloading common OCR language files..."
cd data/tessdata

# Download English language files (essential)
wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata || echo "⚠️  Failed to download English OCR data"

# Download other common language files (optional, commented out to save space)
# Uncomment the ones you need:
# wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/fra.traineddata  # French
# wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/deu.traineddata  # German  
# wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/spa.traineddata  # Spanish
# wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/chi_sim.traineddata  # Chinese Simplified

cd /workspace

# Create a sample configuration file
echo "⚙️  Creating sample configuration..."
cat > data/configs/settings.yml << 'EOF'
# Stirling PDF Configuration
# This file allows you to customize various settings

security:
  enableLogin: false  # Set to true to enable user authentication
  csrfDisabled: true  # Disable CSRF for development (not recommended for production)

system:
  defaultLocale: en_US
  maxFileSize: 2000  # Maximum file size in MB
  enableAnalytics: false  # Disable analytics for privacy
  
ui:
  appName: "Stirling PDF"
  homeDescription: "Your locally hosted PDF manipulation toolkit"
  appNameNavbar: "Stirling PDF"

# Enable/disable specific features
features:
  enableUrlToPdf: false  # Security risk - keep disabled
  disableSanitize: false  # Keep HTML sanitization enabled
EOF

# Wait for Docker Compose to be ready
echo "⏳ Waiting for Docker Compose to be available..."
sleep 5

# Start the services
echo "🐳 Starting Stirling PDF container..."
docker-compose up -d

# Wait for the service to be ready
echo "⏳ Waiting for Stirling PDF to start..."
timeout=60
counter=0
while [ $counter -lt $timeout ]; do
  if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ Stirling PDF is ready!"
    break
  fi
  echo "   Still waiting... ($counter/$timeout seconds)"
  sleep 5
  counter=$((counter + 5))
done

if [ $counter -ge $timeout ]; then
  echo "⚠️  Stirling PDF took longer than expected to start. Check with 'docker-compose logs'"
else
  echo ""
  echo "🎉 Setup complete!"  
  echo ""
  echo "📋 Quick Start Guide:"
  echo "   • Access Stirling PDF: http://localhost:8080"
  echo "   • View logs: docker-compose logs -f"
  echo "   • Stop service: docker-compose down"  
  echo "   • Restart service: docker-compose restart"
  echo ""
  echo "📁 Data Persistence:"
  echo "   • OCR languages: ./data/tessdata/"
  echo "   • Configuration: ./data/configs/"
  echo "   • Custom files: ./data/customFiles/"
  echo "   • Logs: ./data/logs/"
  echo ""
  echo "🔧 Configuration:"
  echo "   • Edit settings: ./data/configs/settings.yml"
  echo "   • Add OCR languages: Place .traineddata files in ./data/tessdata/"
  echo ""
fi