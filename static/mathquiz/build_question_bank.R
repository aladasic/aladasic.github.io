# Build Question Bank Script
# Parses LaTeX files and generates questions for all chapters

library(yaml)

# Source utility functions
source("utils/latex_parser.R")
source("utils/question_generator.R")

# Load configuration
config <- yaml::read_yaml("config.yaml")

# Base path for maths repository
# Check if path is absolute or relative
if (grepl("^[A-Za-z]:|^/", config$maths_repo_path)) {
  # Absolute path (e.g., C:/... or /home/...)
  maths_path <- normalizePath(config$maths_repo_path, mustWork = FALSE)
} else {
  # Relative path
  maths_path <- normalizePath(file.path(getwd(), config$maths_repo_path), mustWork = FALSE)
}

if (!dir.exists(maths_path)) {
  cat("ERROR: Maths repository not found at:", maths_path, "\n")
  cat("Please run source('setup_paths.R') to configure the correct path.\n\n")
  stop("Maths repository not found")
}

cat("Maths repository path:", maths_path, "\n\n")

# Initialize question bank
all_questions <- list()

# Process each chapter
for (chapter in config$chapters) {
  cat("========================================\n")
  cat("Processing:", chapter$name, "\n")
  cat("========================================\n")

  # Build full path to tex file
  tex_file <- file.path(maths_path, chapter$file)

  if (!file.exists(tex_file)) {
    cat("Warning: File not found:", tex_file, "\n\n")
    next
  }

  # Parse LaTeX file
  cat("Parsing LaTeX file...\n")
  parsed_items <- parse_latex_file(tex_file)
  cat("Found", nrow(parsed_items), "items:\n")
  cat("  - Definitions:", sum(parsed_items$type == "definition"), "\n")
  cat("  - Propositions:", sum(parsed_items$type == "proposition"), "\n")
  cat("  - Remarks:", sum(parsed_items$type == "remark"), "\n\n")

  # Generate questions
  if (nrow(parsed_items) > 0) {
    cat("Generating 20 questions...\n")
    tryCatch({
      questions <- generate_questions(parsed_items, chapter$id, num_questions = 20)
      all_questions[[chapter$id]] <- questions
      cat("Successfully generated", nrow(questions), "questions\n\n")
    }, error = function(e) {
      cat("Error generating questions:", e$message, "\n\n")
    })
  } else {
    cat("Skipping question generation (no valid items)\n\n")
  }
}

# Combine all questions
if (length(all_questions) > 0) {
  combined_questions <- do.call(rbind, all_questions)

  # Save to data directory
  output_file <- "data/questions_bank.rds"
  dir.create("data", showWarnings = FALSE, recursive = TRUE)
  saveRDS(combined_questions, output_file)

  cat("========================================\n")
  cat("SUMMARY\n")
  cat("========================================\n")
  cat("Total questions generated:", nrow(combined_questions), "\n")
  cat("Questions per chapter:\n")
  for (chapter in config$chapters) {
    count <- sum(combined_questions$chapter_id == chapter$id)
    cat("  -", chapter$name, ":", count, "\n")
  }
  cat("\nQuestion bank saved to:", output_file, "\n")
} else {
  cat("No questions were generated. Please check the errors above.\n")
}
