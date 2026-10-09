# MathQuiz - R Shiny Application
# Interactive math quiz application with Duolingo-style design

library(shiny)
library(bslib)
library(shinyjs)
library(yaml)

# Source utilities
source("utils/answer_validator.R")

# Load configuration
config <- yaml::read_yaml("config.yaml")

# Load question bank
questions_bank <- readRDS("data/questions_bank.rds")

# Define UI
ui <- fluidPage(
  theme = bs_theme(
    version = 5,
    bg = "#F7F7F7",
    fg = "#3C3C3C",
    primary = "#58CC02",
    base_font = font_google("Nunito")
  ),
  useShinyjs(),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  # Header
  div(
    class = "app-header",
    h1("📐 MathQuiz"),
    div(class = "tagline", "Master your math concepts with interactive quizzes")
  ),

  # Main Content
  div(
    style = "max-width: 1200px; margin: 0 auto; padding: 20px;",

    # Home Screen (Chapter Selection)
    conditionalPanel(
      condition = "output.screen == 'home'",
      div(
        class = "quiz-card",
        h2("Select a Chapter", style = "text-align: center; margin-bottom: 30px;"),

        # Chapter selection
        div(
          class = "chapter-selector",
          uiOutput("chapter_cards")
        ),

        # Difficulty selection
        h3("Choose Difficulty", style = "text-align: center; margin-top: 30px;"),
        div(
          class = "difficulty-selector",
          actionButton("diff_medium", "📝 Medium (QCM)",
                      class = "difficulty-btn active"),
          actionButton("diff_advanced", "✍️ Advanced (Free Text)",
                      class = "difficulty-btn")
        ),

        # Start button
        div(
          style = "text-align: center; margin-top: 30px;",
          actionButton("start_quiz", "Start Quiz", class = "btn-primary")
        )
      )
    ),

    # Quiz Screen
    conditionalPanel(
      condition = "output.screen == 'quiz'",
      div(
        class = "quiz-card",

        # Progress bar
        div(
          class = "progress-container",
          div(class = "progress-bar", style = paste0("width: ", 0, "%;"))
        ),
        div(class = "progress-text", uiOutput("progress_text")),

        # Question
        uiOutput("question_display"),

        # Answer area (QCM or free text)
        uiOutput("answer_area"),

        # Submit button
        div(
          style = "text-align: center; margin-top: 30px;",
          actionButton("submit_answer", "Check Answer", class = "btn-primary")
        ),

        # Feedback
        uiOutput("feedback_display")
      )
    ),

    # Results Screen
    conditionalPanel(
      condition = "output.screen == 'results'",
      div(
        class = "quiz-card results-container",
        h2("Quiz Complete! 🎉"),
        div(class = "results-score", textOutput("final_score")),
        div(class = "results-message", textOutput("results_message")),

        div(
          class = "results-stats",
          div(
            class = "stat-card",
            div(class = "stat-number", textOutput("correct_count")),
            div(class = "stat-label", "Correct Answers")
          ),
          div(
            class = "stat-card",
            div(class = "stat-number", textOutput("accuracy_percent")),
            div(class = "stat-label", "Accuracy")
          )
        ),

        div(
          style = "text-align: center; margin-top: 40px;",
          actionButton("restart_quiz", "Take Another Quiz", class = "btn-primary"),
          actionButton("go_home", "Back to Home", class = "btn-secondary",
                      style = "margin-left: 15px;")
        )
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  # Reactive values
  state <- reactiveValues(
    screen = "home",
    selected_chapters = character(0),
    difficulty = "medium",
    current_questions = NULL,
    current_index = 1,
    score = 0,
    answers = list(),
    feedback_shown = FALSE
  )

  # Screen output
  output$screen <- reactive({ state$screen })
  outputOptions(output, "screen", suspendWhenHidden = FALSE)

  # Generate chapter cards
  output$chapter_cards <- renderUI({
    lapply(config$chapters, function(chapter) {
      is_selected <- chapter$id %in% state$selected_chapters

      tags$div(
        class = paste("chapter-card", if (is_selected) "selected" else ""),
        onclick = sprintf("Shiny.setInputValue('toggle_chapter', '%s', {priority: 'event'})", chapter$id),
        div(class = "chapter-icon", "📚"),
        h3(chapter$name)
      )
    })
  })

  # Toggle chapter selection
  observeEvent(input$toggle_chapter, {
    chapter_id <- input$toggle_chapter
    if (chapter_id %in% state$selected_chapters) {
      state$selected_chapters <- setdiff(state$selected_chapters, chapter_id)
    } else {
      state$selected_chapters <- c(state$selected_chapters, chapter_id)
    }
    # Force re-render of chapter cards to show selection
    output$chapter_cards <- renderUI({
      lapply(config$chapters, function(chapter) {
        is_selected <- chapter$id %in% state$selected_chapters

        tags$div(
          class = paste("chapter-card", if (is_selected) "selected" else ""),
          onclick = sprintf("Shiny.setInputValue('toggle_chapter', '%s', {priority: 'event'})", chapter$id),
          div(class = "chapter-icon", "📚"),
          h3(chapter$name)
        )
      })
    })
  })

  # Difficulty selection
  observeEvent(input$diff_medium, {
    state$difficulty <- "medium"
    runjs("$('.difficulty-btn').removeClass('active'); $('#diff_medium').addClass('active');")
  })

  observeEvent(input$diff_advanced, {
    state$difficulty <- "advanced"
    runjs("$('.difficulty-btn').removeClass('active'); $('#diff_advanced').addClass('active');")
  })

  # Start quiz
  observeEvent(input$start_quiz, {
    if (length(state$selected_chapters) == 0) {
      showNotification("Please select at least one chapter!", type = "warning")
      return()
    }

    # Filter questions for selected chapters
    filtered_questions <- questions_bank[questions_bank$chapter_id %in% state$selected_chapters, ]

    # Sample 5 questions
    num_questions <- min(config$questions_per_session, nrow(filtered_questions))
    sampled_indices <- sample(1:nrow(filtered_questions), num_questions)
    state$current_questions <- filtered_questions[sampled_indices, ]

    # Reset state
    state$current_index <- 1
    state$score <- 0
    state$answers <- list()
    state$feedback_shown <- FALSE
    state$screen <- "quiz"

    # Update progress bar
    update_progress_bar(0)
  })

  # Display current question
  output$question_display <- renderUI({
    req(state$current_questions)
    question <- state$current_questions[state$current_index, ]

    # Type badge
    badge_class <- switch(
      question$type,
      "definition" = "badge-definition",
      "proposition" = "badge-proposition",
      "remark" = "badge-remark"
    )

    question_text <- if (state$difficulty == "medium") {
      question$question_qcm
    } else {
      question$question_freetext
    }

    div(
      class = "question-container",
      span(class = paste("question-type-badge", badge_class),
           toupper(question$type)),
      div(class = "question-text", question_text)
    )
  })

  # Display answer area
  output$answer_area <- renderUI({
    req(state$current_questions)
    question <- state$current_questions[state$current_index, ]

    if (state$difficulty == "medium") {
      # QCM options
      options <- strsplit(question$options_qcm, "|||", fixed = TRUE)[[1]]
      shuffled_indices <- sample(1:length(options))

      div(
        class = "answer-options",
        lapply(shuffled_indices, function(i) {
          tags$div(
            class = "answer-option",
            id = paste0("option_", i),
            onclick = sprintf("Shiny.setInputValue('selected_option', %d, {priority: 'event'})", i),
            options[i]
          )
        })
      )
    } else {
      # Free text input
      textAreaInput("freetext_answer", NULL,
                   placeholder = "Type your answer here...",
                   width = "100%",
                   rows = 5)
    }
  })

  # Handle option selection (QCM)
  observeEvent(input$selected_option, {
    runjs("$('.answer-option').removeClass('selected');")
    runjs(sprintf("$('#option_%d').addClass('selected');", input$selected_option))
  })

  # Progress display
  output$progress_text <- renderUI({
    req(state$current_questions)
    total <- nrow(state$current_questions)
    HTML(sprintf("<strong>Question %d of %d</strong>", state$current_index, total))
  })

  # Submit answer
  observeEvent(input$submit_answer, {
    req(state$current_questions)

    if (state$feedback_shown) {
      # Move to next question
      if (state$current_index < nrow(state$current_questions)) {
        state$current_index <- state$current_index + 1
        state$feedback_shown <- FALSE

        # Update progress
        progress <- (state$current_index - 1) / nrow(state$current_questions) * 100
        update_progress_bar(progress)

        # Clear selection
        runjs("$('.answer-option').removeClass('selected correct incorrect');")
        updateTextAreaInput(session, "freetext_answer", value = "")
      } else {
        # Show results
        state$screen <- "results"
      }
    } else {
      # Check answer
      question <- state$current_questions[state$current_index, ]
      is_correct <- FALSE

      if (state$difficulty == "medium") {
        if (is.null(input$selected_option)) {
          showNotification("Please select an answer!", type = "warning")
          return()
        }
        is_correct <- (input$selected_option == question$correct_option)

        # Visual feedback
        if (is_correct) {
          runjs(sprintf("$('#option_%d').addClass('correct');", input$selected_option))
        } else {
          runjs(sprintf("$('#option_%d').addClass('incorrect');", input$selected_option))
          runjs(sprintf("$('#option_%d').addClass('correct');", question$correct_option))
        }
      } else {
        if (is.null(input$freetext_answer) || input$freetext_answer == "") {
          showNotification("Please type an answer!", type = "warning")
          return()
        }

        keywords <- strsplit(question$keywords, "|||", fixed = TRUE)[[1]]
        validation <- validate_freetext_answer(
          input$freetext_answer,
          question$correct_answer,
          keywords,
          config$difficulty_modes$advanced$similarity_threshold
        )
        is_correct <- validation$is_correct
      }

      # Update score
      if (is_correct) state$score <- state$score + 1

      # Store answer
      state$answers[[state$current_index]] <- list(
        question_id = question$id,
        is_correct = is_correct
      )

      # Show feedback
      state$feedback_shown <- TRUE

      # Change button text
      if (state$current_index < nrow(state$current_questions)) {
        updateActionButton(session, "submit_answer", "Next Question")
      } else {
        updateActionButton(session, "submit_answer", "See Results")
      }
    }
  })

  # Feedback display
  output$feedback_display <- renderUI({
    req(state$feedback_shown)
    question <- state$current_questions[state$current_index, ]
    is_correct <- state$answers[[state$current_index]]$is_correct

    feedback_class <- if (is_correct) "feedback-correct" else "feedback-incorrect"
    feedback_text <- if (is_correct) {
      "Excellent! That's correct! ✓"
    } else {
      paste0("Not quite. The correct answer is: ", question$correct_answer)
    }

    div(
      class = feedback_class,
      div(class = "feedback-message", feedback_text)
    )
  })

  # Results outputs
  output$final_score <- renderText({
    req(state$current_questions)
    sprintf("%d / %d", state$score, nrow(state$current_questions))
  })

  output$results_message <- renderText({
    req(state$current_questions)
    percentage <- (state$score / nrow(state$current_questions)) * 100

    if (percentage == 100) {
      "Perfect score! You're a math master! 🏆"
    } else if (percentage >= 80) {
      "Great job! Keep up the excellent work! 🌟"
    } else if (percentage >= 60) {
      "Good effort! Review the topics and try again. 💪"
    } else {
      "Keep practicing! You'll improve with time. 📚"
    }
  })

  output$correct_count <- renderText({
    state$score
  })

  output$accuracy_percent <- renderText({
    req(state$current_questions)
    sprintf("%.0f%%", (state$score / nrow(state$current_questions)) * 100)
  })

  # Restart quiz
  observeEvent(input$restart_quiz, {
    state$screen <- "home"
    state$selected_chapters <- character(0)
    state$difficulty <- "medium"
    updateActionButton(session, "submit_answer", "Check Answer")
  })

  observeEvent(input$go_home, {
    state$screen <- "home"
    state$selected_chapters <- character(0)
    updateActionButton(session, "submit_answer", "Check Answer")
  })

  # Helper function to update progress bar
  update_progress_bar <- function(percentage) {
    runjs(sprintf("$('.progress-bar').css('width', '%d%%');", round(percentage)))
  }
}

# Run the application
shinyApp(ui = ui, server = server)
