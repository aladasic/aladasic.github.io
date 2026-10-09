# Answer Validation for Free-Text Questions
# Uses fuzzy string matching to validate student answers

library(stringdist)

#' Validate a free-text answer against the correct answer
#'
#' @param user_answer User's text input
#' @param correct_answer Correct answer from course material
#' @param keywords Key terms that should appear
#' @param threshold Similarity threshold (0-1)
#' @return List with is_correct (boolean) and similarity_score (numeric)
#' @export
validate_freetext_answer <- function(user_answer, correct_answer, keywords, threshold = 0.70) {
  # Normalize both answers
  user_clean <- normalize_text(user_answer)
  correct_clean <- normalize_text(correct_answer)

  # Calculate overall similarity
  overall_similarity <- stringdist::stringsim(user_clean, correct_clean, method = "cosine")

  # Check keyword presence
  keyword_score <- calculate_keyword_score(user_clean, keywords)

  # Combined score (70% similarity + 30% keywords)
  combined_score <- 0.7 * overall_similarity + 0.3 * keyword_score

  # Determine if correct
  is_correct <- combined_score >= threshold

  return(list(
    is_correct = is_correct,
    similarity_score = round(combined_score, 3),
    overall_similarity = round(overall_similarity, 3),
    keyword_score = round(keyword_score, 3),
    feedback = generate_feedback(is_correct, combined_score, keyword_score)
  ))
}

#' Normalize text for comparison
#'
#' @param text Input text
#' @return Normalized text
normalize_text <- function(text) {
  if (is.na(text) || text == "") return("")

  # Convert to lowercase
  normalized <- tolower(text)

  # Remove accents (French to ASCII)
  normalized <- iconv(normalized, from = "UTF-8", to = "ASCII//TRANSLIT")

  # Remove punctuation
  normalized <- gsub("[[:punct:]]", " ", normalized)

  # Remove extra whitespace
  normalized <- gsub("\\s+", " ", normalized)
  normalized <- trimws(normalized)

  return(normalized)
}

#' Calculate keyword presence score
#'
#' @param user_answer Normalized user answer
#' @param keywords Vector of keywords to check
#' @return Score between 0 and 1
calculate_keyword_score <- function(user_answer, keywords) {
  if (length(keywords) == 0) return(0)

  # Count how many keywords are present
  keywords_present <- sum(sapply(keywords, function(kw) {
    grepl(kw, user_answer, fixed = TRUE)
  }))

  # Return proportion of keywords found
  return(keywords_present / length(keywords))
}

#' Generate feedback based on validation results
#'
#' @param is_correct Boolean
#' @param combined_score Numeric score
#' @param keyword_score Keyword score
#' @return Feedback string
generate_feedback <- function(is_correct, combined_score, keyword_score) {
  if (is_correct) {
    if (combined_score > 0.9) {
      return("Excellent! Your answer is very accurate.")
    } else {
      return("Correct! Good understanding of the concept.")
    }
  } else {
    if (combined_score > 0.5) {
      if (keyword_score < 0.5) {
        return("Close, but you're missing some key terms. Review the definition.")
      } else {
        return("You have the right idea, but try to be more precise.")
      }
    } else {
      return("Not quite. Review the course material for this concept.")
    }
  }
}

#' Validate a QCM answer
#'
#' @param user_choice Index of user's choice (1-4)
#' @param correct_option Index of correct option
#' @return Boolean
validate_qcm_answer <- function(user_choice, correct_option) {
  return(user_choice == correct_option)
}

#' Test the validator
test_validator <- function() {
  cat("Testing Answer Validator\n\n")

  # Test case 1: Exact match
  result1 <- validate_freetext_answer(
    "A random experiment is any experiment whose outcome cannot be predicted with certainty.",
    "A random experiment is any experiment whose outcome cannot be predicted with certainty.",
    c("random", "experiment", "outcome", "predicted", "certainty")
  )
  cat("Test 1 (exact match):\n")
  print(result1)
  cat("\n")

  # Test case 2: Paraphrase
  result2 <- validate_freetext_answer(
    "A random experiment has an unpredictable result.",
    "A random experiment is any experiment whose outcome cannot be predicted with certainty.",
    c("random", "experiment", "outcome", "predicted", "certainty")
  )
  cat("Test 2 (paraphrase):\n")
  print(result2)
  cat("\n")

  # Test case 3: Wrong answer
  result3 <- validate_freetext_answer(
    "A random variable is a function.",
    "A random experiment is any experiment whose outcome cannot be predicted with certainty.",
    c("random", "experiment", "outcome", "predicted", "certainty")
  )
  cat("Test 3 (wrong answer):\n")
  print(result3)
  cat("\n")

  # Test case 4: With accents and punctuation
  result4 <- validate_freetext_answer(
    "Une expérience aléatoire est une expérience dont le résultat ne peut pas être prédit avec certitude.",
    "A random experiment is any experiment whose outcome cannot be predicted with certainty.",
    c("random", "experiment", "outcome", "predicted", "certainty")
  )
  cat("Test 4 (French with accents):\n")
  print(result4)
  cat("\n")
}
