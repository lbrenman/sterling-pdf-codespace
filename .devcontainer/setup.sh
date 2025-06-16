#!/bin/bash

echo "🚀 Setting up Stirling PDF development environment..."

# Ensure we're in the workspace directory
cd /workspace

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

# Create sample configuration file
echo "⚙️ Creating sample configuration..."
cat > data/configs/settings.yml << 'EOF'
# Stirling PDF Configuration
security:
  enableLogin: false
  csrfDisabled: true

system:
  defaultLocale: en_US
  maxFileSize: 2000
  enableAnalytics: false
  
ui:
  appName: "Stirling PDF"
  homeDescription: "Your locally hosted PDF manipulation toolkit"
  appNameNavbar: "Stirling PDF"

features:
  enableUrlToPdf: false
  disableSanitize: false
EOF

echo "✅ Setup complete!"
echo ""
echo "🚀 To start Stirling PDF, run: ./start-stirling.sh"
echo ""