bin_path := ./scripts/bin

all: build test clean lint

build:
	@echo "Building the project..."
	swift build

test:
	@echo "Running tests..."
	swift test

clean:
	@echo "Cleaning the project..."
	swift package clean
	rm -rf .build/

lint:
	@echo "Linting the code..."
	$(bin_path)/swiftlint --format --quiet --config ./.swiftlint.yml