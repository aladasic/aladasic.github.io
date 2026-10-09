# Setup Paths Script
# Automatically configures the correct path to maths repository

cat("========================================\n")
cat("MathQuiz - Path Configuration\n")
cat("========================================\n\n")

# Try to find the maths repository
possible_paths <- c(
  "C:/Users/hp/Documents/GitHub/maths",
  "../../maths",
  "../../../maths",
  normalizePath("../../maths", mustWork = FALSE),
  file.path(dirname(dirname(dirname(getwd()))), "maths")
)

cat("Searching for maths repository...\n\n")

maths_path <- NULL
for (path in possible_paths) {
  cat("Trying:", path, "... ")
  if (dir.exists(path)) {
    # Check if it contains the expected chapter directories
    test_file <- file.path(path, "chp0-probabilities/chp0-course-probabilities.tex")
    if (file.exists(test_file)) {
      maths_path <- normalizePath(path)
      cat("✓ FOUND!\n")
      break
    } else {
      cat("(exists but no LaTeX files)\n")
    }
  } else {
    cat("(not found)\n")
  }
}

if (is.null(maths_path)) {
  cat("\n❌ ERROR: Could not find maths repository!\n\n")
  cat("Please manually edit config.yaml and set maths_repo_path to the correct path.\n")
  cat("Expected structure:\n")
  cat("  maths/\n")
  cat("    ├── chp0-probabilities/\n")
  cat("    │   └── chp0-course-probabilities.tex\n")
  cat("    ├── chp1-finite-rv/\n")
  cat("    ├── chp2-continuous-rv/\n")
  cat("    └── chp3-rv-pair/\n\n")
  stop("Maths repository not found")
}

cat("\n✓ Maths repository found at:\n")
cat("  ", maths_path, "\n\n")

# Update config.yaml
library(yaml)
config_file <- "config.yaml"
config <- yaml::read_yaml(config_file)

# Update path (use forward slashes for cross-platform compatibility)
config$maths_repo_path <- gsub("\\\\", "/", maths_path)

# Write back to file
yaml::write_yaml(config, config_file)

cat("✓ Updated config.yaml with correct path\n\n")

# Verify all LaTeX files exist
cat("Verifying LaTeX files:\n")
all_found <- TRUE
for (chapter in config$chapters) {
  tex_file <- file.path(maths_path, chapter$file)
  if (file.exists(tex_file)) {
    cat("  ✓", chapter$name, "\n")
  } else {
    cat("  ✗", chapter$name, "(FILE NOT FOUND)\n")
    cat("    Expected:", tex_file, "\n")
    all_found <- FALSE
  }
}

cat("\n========================================\n")
if (all_found) {
  cat("✓ Setup complete! All files found.\n")
  cat("========================================\n\n")
  cat("Next step: Run source('build_question_bank.R')\n\n")
} else {
  cat("⚠ Setup incomplete - some files missing\n")
  cat("========================================\n\n")
  cat("Please check the file paths above.\n\n")
}
