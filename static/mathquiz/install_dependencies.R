# Install Required R Packages for MathQuiz Application
# Run this script once before using the app

cat("========================================\n")
cat("MathQuiz - Dependency Installation\n")
cat("========================================\n\n")

# List of required packages
required_packages <- c(
  "shiny",        # Web application framework
  "bslib",        # Bootstrap theming
  "shinyjs",      # JavaScript operations in Shiny
  "yaml",         # Configuration file parsing
  "stringr",      # String manipulation
  "stringdist"    # Fuzzy string matching
)

# Function to check and install packages
install_if_missing <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    cat("Installing", package, "...\n")
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
    cat("✓", package, "installed successfully\n\n")
  } else {
    cat("✓", package, "already installed\n")
  }
}

# Install all required packages
cat("Checking and installing required packages...\n\n")
for (pkg in required_packages) {
  install_if_missing(pkg)
}

cat("\n========================================\n")
cat("Installation complete!\n")
cat("========================================\n\n")

cat("Next steps:\n")
cat("1. Run 'source(\"build_question_bank.R\")' to generate questions\n")
cat("2. Run 'shiny::runApp(\"app.R\")' to launch the app\n\n")

cat("For help, see README.md\n")
