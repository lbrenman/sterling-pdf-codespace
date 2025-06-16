.PHONY: help start stop restart logs status clean

help: ## Show this help message
	@echo "Stirling PDF Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

start: ## Start Stirling PDF
	@./start-stirling.sh

stop: ## Stop Stirling PDF
	@docker-compose down

restart: ## Restart Stirling PDF
	@docker-compose restart

logs: ## View logs
	@docker-compose logs -f

status: ## Show status
	@docker-compose ps