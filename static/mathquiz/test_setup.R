# Quick Test Script for MathQuiz Setup
# Run this to verify everything is working before building the question bank

cat("========================================\n")
cat("MathQuiz - Setup Verification\n")
cat("========================================\n\n")

# 1. Check R version
cat("1. Checking R version...\n")
r_version <- R.version.string
cat("   ", r_version, "\n")
if (as.numeric(R.Version()$major) < 4) {
  cat("   ⚠ Warning: R 4.0+ recommended\n")
} else {
  cat("   ✓ R version OK\n")
}
cat("\n")

# 2. Check required packages
cat("2. Checking required packages...\n")
required_packages <- c("shiny", "bslib", "shinyjs", "yaml", "stringr", "stringdist")
missing_packages <- character(0)

for (pkg in required_packages) {
  if (require(pkg, character.only = TRUE, quietly = TRUE)) {
    cat("   ✓", pkg, "\n")
  } else {
    cat("   ✗", pkg, "(MISSING)\n")
    missing_packages <- c(missing_packages, pkg)
  }
}

if (length(missing_packages) > 0) {
  cat("\n   ⚠ Missing packages detected!\n")
  cat("   Run: source('install_dependencies.R')\n")
} else {
  cat("   ✓ All packages installed\n")
}
cat("\n")

# 3. Check file structure
cat("3. Checking file structure...\n")
required_files <- c(
  "app.R",
  "config.yaml",
  "build_question_bank.R",
  "utils/latex_parser.R",
  "utils/question_generator.R",
  "utils/answer_validator.R",
  "assets/custom.css"
)

for (file in required_files) {
  if (file.exists(file)) {
    cat("   ✓", file, "\n")
  } else {
    cat("   ✗", file, "(MISSING)\n")
  }
}
cat("\n")

# 4. Check maths repository path
cat("4. Checking maths repository...\n")
config <- yaml::read_yaml("config.yaml")
maths_path <- normalizePath(file.path(getwd(), config$maths_repo_path), mustWork = FALSE)
cat("   Path:", maths_path, "\n")

if (dir.exists(maths_path)) {
  cat("   ✓ Maths repository found\n")

  # Check LaTeX files
  cat("\n   Checking LaTeX files:\n")
  for (chapter in config$chapters) {
    tex_file <- file.path(maths_path, chapter$file)
    if (file.exists(tex_file)) {
      cat("   ✓", chapter$name, "\n")
    } else {
      cat("   ✗", chapter$name, "(FILE NOT FOUND)\n")
      cat("      Expected:", tex_file, "\n")
    }
  }
} else {
  cat("   ✗ Maths repository not found\n")
  cat("   ⚠ Update 'maths_repo_path' in config.yaml\n")
}
cat("\n")

# 5. Test LaTeX parser (if possible)
cat("5. Testing LaTeX parser...\n")
tryCatch({
  source("utils/latex_parser.R")

  # Find first available tex file
  test_file <- NULL
  for (chapter in config$chapters) {
    tex_file <- file.path(maths_path, chapter$file)
    if (file.exists(tex_file)) {
      test_file <- tex_file
      break
    }
  }

  if (!is.null(test_file)) {
    cat("   Testing on:", basename(test_file), "\n")
    items <- parse_latex_file(test_file)
    cat("   ✓ Parser works! Extracted", nrow(items), "items\n")
    cat("     - Definitions:", sum(items$type == "definition"), "\n")
    cat("     - Propositions:", sum(items$type == "proposition"), "\n")
    cat("     - Remarks:", sum(items$type == "remark"), "\n")
  } else {
    cat("   ⚠ No LaTeX files available for testing\n")
  }
}, error = function(e) {
  cat("   ✗ Parser test failed:", e$message, "\n")
})
cat("\n")

# 6. Summary
cat("========================================\n")
cat("SUMMARY\n")
cat("========================================\n")

if (length(missing_packages) == 0 && dir.exists(maths_path)) {
  cat("✓ Setup looks good!\n\n")
  cat("Next steps:\n")
  cat("1. Run: source('build_question_bank.R')\n")
  cat("2. Run: shiny::runApp('app.R')\n\n")
} else {
  cat("⚠ Setup incomplete. Please fix issues above.\n\n")
  if (length(missing_packages) > 0) {
    cat("- Install packages: source('install_dependencies.R')\n")
  }
  if (!dir.exists(maths_path)) {
    cat("- Fix maths repository path in config.yaml\n")
  }
  cat("\n")
}
