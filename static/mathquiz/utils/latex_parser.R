# LaTeX Parser for Math Course Files
# Extracts definitions, propositions, and remarks from .tex files

library(stringr)

#' Parse a LaTeX file to extract structured content
#'
#' @param tex_file_path Path to the .tex file
#' @return A data frame with columns: type, title, content, line_start
#' @export
parse_latex_file <- function(tex_file_path) {
  # Read the entire file
  lines <- readLines(tex_file_path, warn = FALSE, encoding = "UTF-8")
  full_text <- paste(lines, collapse = "\n")

  # Extract all definitions
  definitions <- extract_environment(full_text, "definition", lines)

  # Extract all propositions
  propositions <- extract_environment(full_text, "proposition", lines)

  # Extract all remarks
  remarks <- extract_environment(full_text, "remark", lines)

  # Combine all items (only non-empty ones)
  all_items <- list()

  if (nrow(definitions) > 0) {
    all_items[[length(all_items) + 1]] <- data.frame(type = "definition", definitions, stringsAsFactors = FALSE)
  }

  if (nrow(propositions) > 0) {
    all_items[[length(all_items) + 1]] <- data.frame(type = "proposition", propositions, stringsAsFactors = FALSE)
  }

  if (nrow(remarks) > 0) {
    all_items[[length(all_items) + 1]] <- data.frame(type = "remark", remarks, stringsAsFactors = FALSE)
  }

  # Combine into single data frame
  if (length(all_items) > 0) {
    all_items <- do.call(rbind, all_items)

    # Clean LaTeX commands from content
    all_items$content <- sapply(all_items$content, clean_latex_content)
    all_items$title <- sapply(all_items$title, clean_latex_content)
  } else {
    # Return empty data frame with correct structure
    all_items <- data.frame(
      type = character(0),
      title = character(0),
      content = character(0),
      line_start = integer(0),
      stringsAsFactors = FALSE
    )
  }

  return(all_items)
}

#' Extract all instances of a specific LaTeX environment
#'
#' @param text Full text of the LaTeX document
#' @param env_name Name of the environment (e.g., "definition")
#' @param lines Original lines for line number tracking
#' @return Data frame with title, content, line_start
extract_environment <- function(text, env_name, lines) {
  # Pattern to match \begin{env_name}[optional_title] ... \end{env_name}
  pattern <- sprintf(
    "\\\\begin\\{%s\\}\\[([^\\]]*)\\]\\s*([\\s\\S]*?)\\\\end\\{%s\\}",
    env_name, env_name
  )

  # Find all matches
  matches <- str_match_all(text, pattern)[[1]]

  if (nrow(matches) == 0) {
    return(data.frame(title = character(0), content = character(0),
                     line_start = integer(0), stringsAsFactors = FALSE))
  }

  # Extract title (capture group 1) and content (capture group 2)
  titles <- matches[, 2]
  contents <- matches[, 3]

  # Find line numbers (approximate)
  line_starts <- sapply(matches[, 1], function(match_text) {
    # Find the line where this match starts
    first_line <- strsplit(match_text, "\n")[[1]][1]
    which(str_detect(lines, fixed(substr(first_line, 1, 20))))[1]
  })

  return(data.frame(
    title = titles,
    content = contents,
    line_start = line_starts,
    stringsAsFactors = FALSE
  ))
}

#' Clean LaTeX commands from text
#'
#' @param text Text with LaTeX commands
#' @return Cleaned text
clean_latex_content <- function(text) {
  if (is.na(text) || text == "") return("")

  # Remove common LaTeX commands but keep math content readable
  cleaned <- text

  # Remove line breaks and extra whitespace
  cleaned <- str_replace_all(cleaned, "\\n+", " ")
  cleaned <- str_replace_all(cleaned, "\\s+", " ")

  # Remove simple LaTeX commands like \textit{}, \textbf{}
  cleaned <- str_replace_all(cleaned, "\\\\text(it|bf|tt)\\{([^}]*)\\}", "\\2")

  # KEEP dollar signs for MathJax rendering
  # DO NOT remove $ symbols - they are needed for math formulas

  # Remove itemize/enumerate environments
  cleaned <- str_replace_all(cleaned, "\\\\begin\\{(itemize|enumerate)\\}", "")
  cleaned <- str_replace_all(cleaned, "\\\\end\\{(itemize|enumerate)\\}", "")
  cleaned <- str_replace_all(cleaned, "\\\\item\\s*", "• ")

  # Trim whitespace
  cleaned <- str_trim(cleaned)

  return(cleaned)
}

#' Extract chapter metadata
#'
#' @param tex_file_path Path to the .tex file
#' @return List with chapter_name and section_names
extract_chapter_metadata <- function(tex_file_path) {
  lines <- readLines(tex_file_path, warn = FALSE, encoding = "UTF-8")
  full_text <- paste(lines, collapse = "\n")

  # Extract chapter name from \mychapter{}
  chapter_match <- str_match(full_text, "\\\\mychapter\\{[^}]*\\\\textbf\\{([^}]+)\\}")
  chapter_name <- if (!is.na(chapter_match[1, 2])) chapter_match[1, 2] else "Unknown Chapter"

  # Extract all section names
  section_matches <- str_match_all(full_text, "\\\\section\\{([^}]+)\\}")[[1]]
  section_names <- if (nrow(section_matches) > 0) section_matches[, 2] else character(0)

  return(list(
    chapter_name = chapter_name,
    sections = section_names
  ))
}

#' Test the parser on a file
#'
#' @param tex_file_path Path to test file
test_parser <- function(tex_file_path) {
  cat("Testing parser on:", tex_file_path, "\n\n")

  # Extract metadata
  metadata <- extract_chapter_metadata(tex_file_path)
  cat("Chapter:", metadata$chapter_name, "\n")
  cat("Sections:", paste(metadata$sections, collapse = ", "), "\n\n")

  # Parse content
  items <- parse_latex_file(tex_file_path)
  cat("Extracted", nrow(items), "items:\n")
  cat("- Definitions:", sum(items$type == "definition"), "\n")
  cat("- Propositions:", sum(items$type == "proposition"), "\n")
  cat("- Remarks:", sum(items$type == "remark"), "\n\n")

  # Show first few items
  if (nrow(items) > 0) {
    cat("Sample items:\n")
    print(head(items[, c("type", "title")], 5))
  }

  return(items)
}
