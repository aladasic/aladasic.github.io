# MathQuiz - R Shiny Application (FIXED VERSION)
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
    bg = "#e8e6db",  # Fond beige personnalisé
    fg = "#3C3C3C",
    primary = "#58CC02",
    base_font = font_google("Nunito")
  ),
  useShinyjs(),

  # Load jQuery and MathJax for mathematical notation
  tags$head(
    tags$script(src = "https://code.jquery.com/jquery-3.6.0.min.js"),
    # MathJax configuration (must be BEFORE loading MathJax script)
    tags$script(HTML("
      window.MathJax = {
        tex: {
          inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
          displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']],
          processEscapes: true,
          processEnvironments: true
        },
        options: {
          skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre']
        },
        startup: {
          ready: function() {
            MathJax.startup.defaultReady();
            console.log('MathJax loaded successfully!');
          }
        }
      };
    ")),
    # MathJax for rendering LaTeX math formulas
    tags$script(src = "https://polyfill.io/v3/polyfill.min.js?features=es6"),
    tags$script(
      id = "MathJax-script",
      async = NA,
      src = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
    ),
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
    tags$style(HTML("
      body { background-color: #e8e6db !important; }
      .chapter-card:hover { cursor: pointer; }
      .answer-option:hover { cursor: pointer; }
      .MathJax { font-size: 1.1em !important; }
    "))
  ),

  # Logo Banner (uniquement le logo Chebychev)
  div(
    style = "text-align: center; padding: 30px 0; background-color: #e8e6db;",
    tags$img(src = "chebychev.png", style = "max-width: 800px; width: 100%; height: auto;")
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
        uiOutput("progress_bar_ui"),
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
    feedback_shown = FALSE,
    selected_option_index = NULL
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
        h3(chapter$name),
        style = if (is_selected) "border-color: #58CC02 !important;" else ""
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
  })

  # Difficulty selection
  observeEvent(input$diff_medium, {
    state$difficulty <- "medium"
    addClass("diff_medium", "active")
    removeClass("diff_advanced", "active")
  })

  observeEvent(input$diff_advanced, {
    state$difficulty <- "advanced"
    addClass("diff_advanced", "active")
    removeClass("diff_medium", "active")
  })

  # Start quiz
  observeEvent(input$start_quiz, {
    if (length(state$selected_chapters) == 0) {
      showNotification("Please select at least one chapter!", type = "warning", duration = 3)
      return()
    }

    # Filter questions for selected chapters
    filtered_questions <- questions_bank[questions_bank$chapter_id %in% state$selected_chapters, ]

    if (nrow(filtered_questions) == 0) {
      showNotification("No questions available for selected chapters!", type = "error", duration = 3)
      return()
    }

    # Sample questions
    num_questions <- min(config$questions_per_session, nrow(filtered_questions))
    sampled_indices <- sample(1:nrow(filtered_questions), num_questions)
    state$current_questions <- filtered_questions[sampled_indices, ]

    # Reset state
    state$current_index <- 1
    state$score <- 0
    state$answers <- list()
    state$feedback_shown <- FALSE
    state$selected_option_index <- NULL
    state$screen <- "quiz"
  })

  # Progress bar
  output$progress_bar_ui <- renderUI({
    req(state$current_questions)
    progress <- ((state$current_index - 1) / nrow(state$current_questions)) * 100

    div(
      class = "progress-container",
      div(class = "progress-bar", style = paste0("width: ", progress, "%;"))
    )
  })

  # Progress text
  output$progress_text <- renderUI({
    req(state$current_questions)
    total <- nrow(state$current_questions)
    HTML(sprintf("<strong>Question %d of %d</strong>", state$current_index, total))
  })

  # Display current question
  output$question_display <- renderUI({
    req(state$current_questions)
    question <- state$current_questions[state$current_index, ]

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
      div(class = "question-text", HTML(question_text))
    )
  })

  # Trigger MathJax rendering after question display
  observe({
    req(state$current_questions)
    state$current_index  # Depend on current index

    # Delay to ensure DOM is updated
    shinyjs::delay(100, {
      shinyjs::runjs("if (window.MathJax) { MathJax.typesetPromise(); }")
    })
  })

  # Display answer area
  output$answer_area <- renderUI({
    req(state$current_questions)
    question <- state$current_questions[state$current_index, ]

    if (state$difficulty == "medium") {
      # QCM options
      options <- strsplit(question$options_qcm, "|||", fixed = TRUE)[[1]]

      div(
        class = "answer-options",
        lapply(1:length(options), function(i) {
          is_selected <- !is.null(state$selected_option_index) && state$selected_option_index == i
          is_correct_answer <- state$feedback_shown && i == question$correct_option
          is_wrong_answer <- state$feedback_shown && is_selected && i != question$correct_option

          card_class <- "answer-option"
          if (is_selected && !state$feedback_shown) card_class <- paste(card_class, "selected")
          if (is_correct_answer) card_class <- paste(card_class, "correct")
          if (is_wrong_answer) card_class <- paste(card_class, "incorrect")

          tags$div(
            class = card_class,
            id = paste0("option_", i),
            onclick = if (!state$feedback_shown) {
              sprintf("Shiny.setInputValue('select_option', %d, {priority: 'event'})", i)
            } else NULL,
            HTML(options[i])
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
  observeEvent(input$select_option, {
    if (!state$feedback_shown) {
      state$selected_option_index <- input$select_option
    }
  })

  # Submit answer
  observeEvent(input$submit_answer, {
    req(state$current_questions)

    if (state$feedback_shown) {
      # Move to next question
      if (state$current_index < nrow(state$current_questions)) {
        state$current_index <- state$current_index + 1
        state$feedback_shown <- FALSE
        state$selected_option_index <- NULL
        updateTextAreaInput(session, "freetext_answer", value = "")
        updateActionButton(session, "submit_answer", "Check Answer")
      } else {
        # Show results
        state$screen <- "results"
      }
    } else {
      # Check answer
      question <- state$current_questions[state$current_index, ]
      is_correct <- FALSE

      if (state$difficulty == "medium") {
        if (is.null(state$selected_option_index)) {
          showNotification("Please select an answer!", type = "warning", duration = 2)
          return()
        }
        is_correct <- (state$selected_option_index == question$correct_option)
      } else {
        if (is.null(input$freetext_answer) || input$freetext_answer == "") {
          showNotification("Please type an answer!", type = "warning", duration = 2)
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
      div(class = "feedback-message", HTML(feedback_text))
    )
  })

  # Trigger MathJax for feedback
  observe({
    req(state$feedback_shown)

    shinyjs::delay(150, {
      shinyjs::runjs("if (window.MathJax) { MathJax.typesetPromise(); }")
    })
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
}

# Run the application
shinyApp(ui = ui, server = server)
