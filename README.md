# Stirling PDF - GitHub Codespace

A ready-to-use GitHub Codespace setup for Stirling PDF, a powerful locally-hosted web-based PDF manipulation tool.

## 🚀 Quick Start

1. **Open in Codespace**: Click the green "Code" button and select "Create Codespace on main"
2. **Wait for Setup**: The environment will automatically configure
3. **Start Stirling PDF**: Run `chmod +x start-sterling.sh` and then `./start-sterling.sh` in the terminal
4. **Access the Application**: Visit http://localhost:8080 (or use the forwarded port)

## 📋 Features

- Split & Merge PDFs
- Convert documents to/from PDF
- OCR text extraction
- Compress and optimize PDFs
- Add passwords and watermarks
- Edit and annotate PDFs

## 🗂️ Data Persistence

All data persists in the `./data/` directory:
- `tessdata/` - OCR language files
- `configs/` - Application configuration
- `customFiles/` - Custom themes and files
- `logs/` - Application logs
- `pipeline/` - Processing pipelines

## 🔧 Commands

```bash
./start-stirling.sh    # Start Stirling PDF
docker-compose logs -f # View logs
docker-compose down    # Stop service
docker-compose restart # Restart service