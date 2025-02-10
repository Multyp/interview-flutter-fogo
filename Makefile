# ---- Flutter & Dart Binaries ----
# Paths to Flutter and Dart binaries
FLUTTER_BIN := flutter
DART_BIN := dart

# Main Dart entry point for APK
APK_TARGET := lib/main.dart


# ---- Flutter Application Tasks ----
# Run the Flutter application on a connected device or emulator
# Optionally filter excessive logs from Android 13 (gralloc4)
.PHONY: run
run:
	@echo "Running Flutter application..."
	@if [ "$(FILTER_GRALLOC_LOGS)" = "true" ]; then \
		$(FLUTTER_BIN) run -t $(APK_TARGET) | grep -v "E/gralloc4"; \
	else \
		$(FLUTTER_BIN) run -t $(APK_TARGET); \
	fi

# Run the Flutter application in release mode
.PHONY: run-release
run-release:
	@echo "Running Flutter application in release mode..."
	$(FLUTTER_BIN) run -t $(APK_TARGET) --release

# ---- APK Build Tasks ----
# Build APK with ABI splits and generate app icons
.PHONY: build-apk
build-apk: prebuild gen-icons
	@echo "Building APK with ABI splits..."
	$(FLUTTER_BIN) build apk --split-per-abi

# Clean Flutter build artifacts
.PHONY: clean
clean:
	@echo "Cleaning Flutter build artifacts..."
	$(FLUTTER_BIN) clean

# ---- Code Analysis ----
# Analyze Dart code for errors and warnings
.PHONY: analyze
analyze:
	@echo "Analyzing Dart code..."
	$(FLUTTER_BIN) analyze

# ---- Testing ----
# Run Flutter tests
.PHONY: test
test:
	@echo "Running Flutter tests..."
	$(FLUTTER_BIN) test

# ---- Help ----
# Display available Makefile targets
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make run           	- Run Flutter application on a connected device or emulator"
	@echo "  make run-release   	- Run Flutter application on a connected device or emulator in release mode"
	@echo "  make build-apk     	- Build APK with ABI splits (includes icon generation)"
	@echo "  make clean         	- Remove Flutter build artifacts"
	@echo "  make analyze       	- Analyze Dart code for errors and warnings"
	@echo "  make test          	- Run Flutter tests"
	@echo "  make help          	- Display this help message"
