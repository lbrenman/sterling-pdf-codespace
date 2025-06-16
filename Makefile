# Stirling PDF Management Commands

.PHONY: help start stop restart logs status clean setup backup restore update

# Default target
help: ## Show this help message
	@echo "Stirling PDF Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

setup: ## Initialize the environment and create directories
	@echo "🚀 Setting up Stirling PDF environment..."
	@mkdir -p data/{tessdata,configs,customFiles,logs,pipeline}
	@chmod -R 755 data/
	@echo "📁 Directories created"
	@echo "✅ Setup complete! Run 'make start' to begin."

start: ## Start Stirling PDF container
	@echo "🐳 Starting Stirling PDF..."
	@docker-compose up -d
	@echo "⏳ Waiting for service to be ready..."
	@sleep 10
	@echo "✅ Stirling PDF started! Access at http://localhost:8080"

stop: ## Stop Stirling PDF container
	@echo "⏹️  Stopping Stirling PDF..."
	@docker-compose down
	@echo "✅ Stirling PDF stopped"

restart: ## Restart Stirling PDF container
	@echo "🔄 Restarting Stirling PDF..."
	@docker-compose restart
	@echo "✅ Stirling PDF restarted"

logs: ## View container logs
	@echo "📋 Showing Stirling PDF logs (Ctrl+C to exit):"
	@docker-compose logs -f stirling-pdf

status: ## Show container status
	@echo "📊 Container Status:"
	@docker-compose ps
	@echo ""
	@echo "💾 Disk Usage:"
	@du -sh data/
	@echo ""
	@echo "🔗 Service Health:"
	@curl -s http://localhost:8080/api/v1/info/status 2>/dev/null | grep -q "UP" && echo "✅ Service is running" || echo "❌ Service is not responding"

clean: ## Remove containers and clean up (keeps data)
	@echo "🧹 Cleaning up containers..."
	@docker-compose down -v
	@docker system prune -f
	@echo "✅ Cleanup complete (data preserved)"

clean-all: ## Remove everything including data (DESTRUCTIVE)
	@echo "⚠️  WARNING: This will delete all data!"
	@read -p "Are you sure? Type 'yes' to continue: " confirm && [ "$$confirm" = "yes" ] || exit 1
	@docker-compose down -v
	@rm -rf data/
	@docker system prune -f
	@echo "💥 Everything removed"

backup: ## Create backup of persistent data
	@echo "💾 Creating backup..."
	@mkdir -p backups
	@tar -czf backups/stirling-pdf-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz data/
	@echo "✅ Backup created in backups/ directory"

restore: ## Restore from backup (provide BACKUP=filename)
	@if [ -z "$(BACKUP)" ]; then echo "❌ Please specify backup file: make restore BACKUP=filename.tar.gz"; exit 1; fi
	@echo "📂 Restoring from $(BACKUP)..."
	@docker-compose down
	@rm -rf data/
	@tar -xzf backups/$(BACKUP)
	@echo "✅ Restored from $(BACKUP)"

update: ## Update to latest Stirling PDF version
	@echo "🔄 Updating Stirling PDF..."
	@docker-compose down
	@docker-compose pull
	@docker-compose up -d
	@echo "✅ Update complete"

install-ocr: ## Download common OCR language files
	@echo "📚 Installing OCR language files..."
	@mkdir -p data/tessdata
	@cd data/tessdata && \
		echo "Downloading English..." && \
		wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/eng.traineddata && \
		echo "Downloading French..." && \
		wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/fra.traineddata && \
		echo "Downloading German..." && \
		wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/deu.traineddata && \
		echo "Downloading Spanish..." && \
		wget -q --show-progress https://github.com/tesseract-ocr/tessdata/raw/main/spa.traineddata
	@echo "✅ OCR languages installed. Restart container to use: make restart"

dev: ## Start in development mode with live logs
	@echo "🔧 Starting in development mode..."
	@docker-compose up

shell: ## Access container shell
	@echo "🐚 Accessing container shell..."
	@docker-compose exec stirling-pdf bash

config: ## Edit configuration file
	@echo "⚙️  Opening configuration file..."
	@${EDITOR:-nano} data/configs/settings.yml