# Question Generator for Math Quiz
# Creates QCM and free-text questions from parsed LaTeX content

library(stringr)

#' Generate questions from parsed LaTeX content
#'
#' @param parsed_items Data frame from parse_latex_file()
#' @param chapter_id Chapter identifier
#' @param num_questions Number of questions to generate
#' @return Data frame with questions
#' @export
generate_questions <- function(parsed_items, chapter_id, num_questions = 20) {
  questions <- list()

  # Filter out items with empty or very short content
  valid_items <- parsed_items[nchar(parsed_items$content) > 30, ]

  if (nrow(valid_items) == 0) {
    stop("No valid items found in parsed content")
  }

  # Generate questions (balance between types)
  for (i in 1:min(num_questions, nrow(valid_items))) {
    item <- valid_items[i, ]

    # Generate both QCM and free-text versions
    question_data <- list(
      id = paste0(chapter_id, "_q", i),
      chapter_id = chapter_id,
      type = item$type,
      concept = item$title,
      correct_answer = item$content,
      line_ref = item$line_start,

      # QCM version
      question_qcm = generate_qcm_question(item),
      options_qcm = generate_qcm_options(item, valid_items),
      correct_option = 1,  # Correct answer is always first (will be shuffled in UI)

      # Free text version
      question_freetext = generate_freetext_question(item),
      keywords = extract_keywords(item$content)
    )

    questions[[i]] <- question_data
  }

  # Convert to data frame
  questions_df <- do.call(rbind, lapply(questions, function(q) {
    data.frame(
      id = q$id,
      chapter_id = q$chapter_id,
      type = q$type,
      concept = q$concept,
      question_qcm = q$question_qcm,
      options_qcm = paste(q$options_qcm, collapse = "|||"),  # Delimiter for splitting
      correct_option = q$correct_option,
      question_freetext = q$question_freetext,
      correct_answer = q$correct_answer,
      keywords = paste(q$keywords, collapse = "|||"),
      line_ref = q$line_ref,
      stringsAsFactors = FALSE
    )
  }))

  return(questions_df)
}

#' Generate a QCM question stem
#'
#' @param item Single row from parsed_items
#' @return Question string
generate_qcm_question <- function(item) {
  templates <- switch(
    item$type,
    "definition" = c(
      sprintf("What is the definition of '%s'?", item$title),
      sprintf("How is '%s' defined?", item$title),
      sprintf("Which of the following defines '%s'?", item$title)
    ),
    "proposition" = c(
      sprintf("What does the proposition '%s' state?", item$title),
      sprintf("Which statement corresponds to '%s'?", item$title)
    ),
    "remark" = c(
      sprintf("What is noted in the remark about '%s'?", item$title),
      sprintf("What observation is made regarding '%s'?", item$title)
    )
  )

  # Return first template (could randomize later)
  return(templates[1])
}

#' Generate QCM options (1 correct + 3 distractors)
#'
#' @param item Correct item
#' @param all_items All available items for distractors
#' @return Character vector of 4 options
generate_qcm_options <- function(item, all_items) {
  correct_answer <- item$content

  # Generate distractors
  distractors <- list()

  # Distractor 1: Another item of the same type
  same_type_items <- all_items[all_items$type == item$type &
                               all_items$title != item$title, ]
  if (nrow(same_type_items) > 0) {
    distractors[[1]] <- sample(same_type_items$content, 1)
  } else {
    distractors[[1]] <- generate_generic_distractor(item, 1)
  }

  # Distractor 2: Different type item
  diff_type_items <- all_items[all_items$type != item$type, ]
  if (nrow(diff_type_items) > 0) {
    distractors[[2]] <- sample(diff_type_items$content, 1)
  } else {
    distractors[[2]] <- generate_generic_distractor(item, 2)
  }

  # Distractor 3: Modified version of correct answer
  distractors[[3]] <- generate_modified_answer(correct_answer)

  # Combine and ensure uniqueness
  all_options <- c(correct_answer, distractors)
  all_options <- unique(substr(unlist(all_options), 1, 200))  # Truncate if too long

  # Ensure we have 4 options
  while (length(all_options) < 4) {
    all_options <- c(all_options, generate_generic_distractor(item, length(all_options)))
  }

  return(all_options[1:4])
}

#' Generate a generic distractor when no other items available
#'
#' @param item The correct item
#' @param variant Which variant of distractor
#' @return Distractor string
generate_generic_distractor <- function(item, variant) {
  switch(
    as.character(variant),
    "1" = "This definition is not covered in this chapter.",
    "2" = "This concept relates to a different mathematical domain.",
    "3" = "This statement is not accurate according to the course material."
  )
}

#' Generate a modified version of the correct answer (plausible but wrong)
#'
#' @param correct_answer The correct answer text
#' @return Modified answer
generate_modified_answer <- function(correct_answer) {
  # Simple modifications: negate, swap key terms
  modified <- correct_answer

  # Add negation words
  negations <- c("not", "never", "always", "only", "except")
  modified <- paste(sample(negations, 1), tolower(modified))

  # Truncate if too long
  if (nchar(modified) > 200) {
    modified <- paste0(substr(modified, 1, 197), "...")
  }

  return(modified)
}

#' Generate free-text question
#'
#' @param item Single row from parsed_items
#' @return Question string
generate_freetext_question <- function(item) {
  templates <- switch(
    item$type,
    "definition" = sprintf("Define '%s' in your own words.", item$title),
    "proposition" = sprintf("State the proposition about '%s'.", item$title),
    "remark" = sprintf("What is the key remark about '%s'?", item$title)
  )

  return(templates)
}

#' Extract keywords from content for fuzzy matching
#'
#' @param content Text content
#' @return Vector of keywords
extract_keywords <- function(content) {
  # Remove common words
  stopwords <- c("the", "a", "an", "is", "are", "was", "were", "in", "on", "at",
                "to", "for", "of", "and", "or", "but", "with", "from", "by")

  # Split into words and filter
  words <- str_split(tolower(content), "\\s+")[[1]]
  words <- words[nchar(words) > 3]  # Keep words longer than 3 chars
  words <- words[!words %in% stopwords]

  # Return top 5-10 keywords
  return(unique(words)[1:min(10, length(words))])
}

#' Save questions to RDS file
#'
#' @param questions Data frame of questions
#' @param output_path Path to save RDS file
save_questions <- function(questions, output_path) {
  saveRDS(questions, output_path)
  cat("Saved", nrow(questions), "questions to", output_path, "\n")
}

#' Load questions from RDS file
#'
#' @param input_path Path to RDS file
#' @return Data frame of questions
load_questions <- function(input_path) {
  if (!file.exists(input_path)) {
    stop("Questions file not found:", input_path)
  }
  questions <- readRDS(input_path)
  cat("Loaded", nrow(questions), "questions from", input_path, "\n")
  return(questions)
}
