# 🏗️ MathQuiz - Technical Architecture

This document provides a detailed overview of the MathQuiz application architecture, data flow, and design decisions.

## 📁 Project Structure

```
mathquiz/
│
├── app.R                          # Main Shiny application (UI + Server)
├── config.yaml                    # Configuration (paths, settings, themes)
├── build_question_bank.R          # Offline script to generate questions
├── install_dependencies.R         # Package installation script
├── test_setup.R                   # Setup verification script
├── QUICKSTART.md                  # Quick start guide
├── README.md                      # Full documentation
├── ARCHITECTURE.md                # This file
├── .gitignore                     # Git ignore rules
│
├── modules/                       # (Future) Modular Shiny components
│   └── (empty - for future extensions)
│
├── utils/                         # Core utility functions
│   ├── latex_parser.R            # LaTeX file parsing
│   ├── question_generator.R      # Question generation logic
│   └── answer_validator.R        # Answer validation (QCM + fuzzy)
│
├── data/                          # Generated data (gitignored)
│   └── questions_bank.rds        # Precomputed question database
│
└── assets/                        # Static resources
    ├── custom.css                # Duolingo-inspired styles
    └── sounds/                   # (Future) Audio feedback
```

## 🔄 Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    OFFLINE PHASE (Setup)                     │
└─────────────────────────────────────────────────────────────┘

LaTeX Files (.tex)
    │
    ├─> latex_parser.R
    │   ├─ Regex extraction of environments
    │   ├─ \begin{definition}[...] → Title + Content
    │   ├─ \begin{proposition}[...] → Title + Content
    │   └─ \begin{remark}[...] → Title + Content
    │
    └─> Parsed Items (data.frame)
            │
            └─> question_generator.R
                ├─ Generate QCM questions + distractors
                ├─ Generate free-text questions + keywords
                └─ Create unified question bank
                    │
                    └─> questions_bank.rds (80 questions)

┌─────────────────────────────────────────────────────────────┐
│                    ONLINE PHASE (Runtime)                    │
└─────────────────────────────────────────────────────────────┘

User Opens App
    │
    ├─> app.R loads questions_bank.rds
    │
    ├─> User selects chapters & difficulty
    │
    ├─> Random sample of 5 questions
    │
    └─> Quiz Loop:
        │
        ├─> Display question (QCM or free-text)
        │
        ├─> User submits answer
        │       │
        │       ├─ [Medium] → validate_qcm_answer()
        │       │             Compare index
        │       │
        │       └─ [Advanced] → validate_freetext_answer()
        │                        Fuzzy string matching
        │                        Keyword detection
        │
        ├─> Show feedback (correct/incorrect)
        │
        ├─> Update score & progress
        │
        └─> Next question or Results screen
```

## 🧩 Component Details

### 1. LaTeX Parser (`utils/latex_parser.R`)

**Purpose**: Extract structured content from LaTeX course files

**Key Functions**:
- `parse_latex_file(tex_file_path)`: Main entry point
- `extract_environment(text, env_name)`: Regex-based extraction
- `clean_latex_content(text)`: Remove LaTeX commands, convert symbols

**Supported Environments**:
```latex
\begin{definition}[Title]
Content here...
\end{definition}

\begin{proposition}[Title]
Content here...
\end{proposition}

\begin{remark}[Title]
Content here...
\end{remark}
```

**Output Schema**:
```r
data.frame(
  type = "definition" | "proposition" | "remark",
  title = "Concept name",
  content = "Cleaned text content",
  line_start = 128  # Line number in .tex file
)
```

**Design Decisions**:
- ✅ Regex over full LaTeX parsing (simpler, faster)
- ✅ Line numbers stored for reference links
- ✅ Minimal cleanup preserves mathematical notation

### 2. Question Generator (`utils/question_generator.R`)

**Purpose**: Transform parsed content into quiz questions

**Question Types**:

#### A. QCM Questions (Medium Difficulty)
```r
Question: "What is the definition of 'Random Experiment'?"
Options:
  1. [Correct answer from course]
  2. [Another definition of same type]
  3. [Definition from different concept]
  4. [Modified/incorrect version]
```

**Distractor Generation Strategy**:
1. **Same-type distractor**: Another definition/proposition/remark
2. **Different-type distractor**: Cross-type confusion
3. **Modified distractor**: Negated or slightly altered correct answer

#### B. Free-Text Questions (Advanced Difficulty)
```r
Question: "Define 'Random Experiment' in your own words."
Validation:
  - Fuzzy string similarity (Cosine distance)
  - Keyword presence check
  - Combined score ≥ threshold (default 0.70)
```

**Key Functions**:
- `generate_questions()`: Main generator (20 per chapter)
- `generate_qcm_options()`: Create 4 options with 1 correct
- `generate_freetext_question()`: Create open-ended prompt
- `extract_keywords()`: Identify key terms for validation

**Output Schema**:
```r
data.frame(
  id = "chp0_q1",
  chapter_id = "chp0",
  type = "definition",
  concept = "Random Experiment",
  question_qcm = "What is...",
  options_qcm = "Option1|||Option2|||Option3|||Option4",
  correct_option = 1,
  question_freetext = "Define...",
  correct_answer = "Full text...",
  keywords = "random|||experiment|||outcome|||predicted",
  line_ref = 128
)
```

### 3. Answer Validator (`utils/answer_validator.R`)

**Purpose**: Validate both QCM and free-text answers

#### QCM Validation
```r
validate_qcm_answer(user_choice, correct_option)
# Simple equality check
```

#### Free-Text Validation
```r
validate_freetext_answer(user_answer, correct_answer, keywords, threshold = 0.70)
```

**Algorithm**:
1. **Normalize** both answers:
   - Lowercase
   - Remove accents (é → e)
   - Remove punctuation
   - Trim whitespace

2. **Calculate similarity**:
   - Cosine similarity (stringdist package)
   - Range: 0 (different) to 1 (identical)

3. **Check keywords**:
   - Count present keywords
   - Score = keywords_found / total_keywords

4. **Combined score**:
   ```
   final_score = 0.7 × similarity + 0.3 × keyword_score
   correct if final_score ≥ threshold
   ```

**Design Decisions**:
- ✅ Fuzzy matching allows paraphrasing
- ✅ Keyword weighting ensures key concepts mentioned
- ✅ Adjustable threshold (config.yaml)
- ⚠️ Does not use NLP/LLM (future enhancement)

### 4. Shiny Application (`app.R`)

**Architecture**: Single-file Shiny app (UI + Server)

#### UI Structure
```
FluidPage
├─ Header (gradient banner)
├─ Conditional Panels (3 screens)
│   ├─ Home Screen
│   │   ├─ Chapter selector (cards)
│   │   ├─ Difficulty toggle
│   │   └─ Start button
│   │
│   ├─ Quiz Screen
│   │   ├─ Progress bar
│   │   ├─ Question display
│   │   ├─ Answer area (dynamic)
│   │   ├─ Submit button
│   │   └─ Feedback display
│   │
│   └─ Results Screen
│       ├─ Final score
│       ├─ Stats cards
│       └─ Action buttons
```

#### Server Logic - Reactive State
```r
state <- reactiveValues(
  screen = "home" | "quiz" | "results",
  selected_chapters = c("chp0", "chp1"),
  difficulty = "medium" | "advanced",
  current_questions = data.frame(...),
  current_index = 1,
  score = 0,
  answers = list(),
  feedback_shown = FALSE
)
```

#### Key Reactive Flows

**1. Start Quiz**:
```r
observeEvent(input$start_quiz, {
  # Filter questions by selected chapters
  # Sample 5 questions randomly
  # Reset state
  # Switch to quiz screen
})
```

**2. Submit Answer**:
```r
observeEvent(input$submit_answer, {
  if (!feedback_shown) {
    # Validate answer (QCM or free-text)
    # Update score
    # Show feedback
    # Change button to "Next"
  } else {
    # Move to next question or results
  }
})
```

**3. Dynamic UI Rendering**:
```r
output$answer_area <- renderUI({
  if (difficulty == "medium") {
    # Render clickable option cards
  } else {
    # Render text area
  }
})
```

## 🎨 Design System

### CSS Architecture (`assets/custom.css`)

**CSS Variables** (easy theming):
```css
:root {
  --primary-green: #58CC02;   /* Success */
  --primary-red: #FF4B4B;     /* Error */
  --primary-blue: #1CB0F6;    /* Primary */
  --bg-light: #F7F7F7;        /* Background */
  --shadow: 0 2px 8px rgba(0,0,0,0.1);
}
```

**Component Classes**:
- `.quiz-card`: Main content container
- `.chapter-card`: Selectable chapter cards
- `.answer-option`: QCM option buttons
- `.feedback-correct` / `.feedback-incorrect`: Feedback messages
- `.progress-bar`: Animated progress indicator

**Responsive Breakpoints**:
```css
@media (max-width: 768px) {
  /* Mobile optimizations */
  .chapter-selector { grid-template-columns: 1fr; }
  .quiz-card { padding: 20px; }
}
```

### Animations
- **slideIn**: Card entrance animation
- **pulse**: Feedback appearance
- **transitions**: Hover effects, progress bar

## 🔧 Configuration (`config.yaml`)

**Centralized Settings**:
```yaml
questions_per_session: 5
maths_repo_path: "../../maths"

chapters:
  - id: "chp0"
    name: "Probability Theory"
    file: "chp0-probabilities/chp0-course-probabilities.tex"
    color: "#1CB0F6"

difficulty_modes:
  advanced:
    similarity_threshold: 0.70

theme:
  primary_green: "#58CC02"
  primary_red: "#FF4B4B"
```

**Why YAML?**
- ✅ Human-readable
- ✅ Easy to edit without code changes
- ✅ Supports complex nested structures

## 🚀 Performance Considerations

### Precomputation Strategy
- ❌ Don't parse LaTeX on every app load
- ✅ Parse once → save to RDS → load quickly
- **Result**: App startup < 1 second

### Question Sampling
- Don't load all 80 questions into UI
- Sample 5 per session → minimal memory
- Shuffle options dynamically

### Reactive Optimization
- Use `req()` to prevent premature rendering
- `suspendWhenHidden = FALSE` for screen switching
- Minimal re-renders with targeted updates

## 🔐 Security & Privacy

### Current State
- ✅ Local-only execution (no data sent to servers)
- ✅ No user authentication (single-user app)
- ✅ No external API calls
- ❌ No persistent data storage (privacy-first)

### Future Considerations (if deployed)
- Use shinyapps.io with authentication
- Encrypt stored user data
- GDPR compliance for user statistics

## 🧪 Testing Strategy

### Manual Testing Scripts
- `test_setup.R`: Verify installation and file structure
- `test_parser()`: Unit test LaTeX parser
- `test_validator()`: Unit test answer validation

### Recommended Testing Workflow
1. Run `source("test_setup.R")` after initial setup
2. Manually verify each chapter parses correctly
3. Test both QCM and free-text modes in app
4. Validate edge cases (empty answers, special characters)

### Future: Automated Testing
```r
library(testthat)

test_that("Parser extracts definitions", {
  items <- parse_latex_file("test_file.tex")
  expect_gt(nrow(items), 0)
  expect_true("definition" %in% items$type)
})
```

## 📈 Future Architecture Enhancements

### 1. Modular UI Components (`modules/`)
```r
# modules/quiz_question.R
questionUI <- function(id) { ... }
questionServer <- function(id, question) { ... }
```

### 2. Database Backend (SQLite)
```
questions_bank.rds → questions.db
+ user_stats table
+ session_history table
```

### 3. API Integration (Claude)
```r
# Generate intelligent distractors
generate_distractor_with_claude <- function(correct_answer) {
  response <- httr::POST(
    "https://api.anthropic.com/v1/messages",
    body = list(prompt = "Generate a plausible incorrect answer...")
  )
}
```

### 4. Advanced Analytics
```r
# modules/analytics.R
plot_performance_over_time()
identify_weak_topics()
recommend_next_topics()
```

## 🎯 Design Principles

1. **Modularity**: Separate concerns (parser, generator, validator)
2. **Simplicity**: No over-engineering, straightforward logic
3. **Extensibility**: Easy to add chapters, modify themes, extend features
4. **Performance**: Precompute expensive operations, reactive efficiency
5. **User Experience**: Duolingo-inspired gamification, immediate feedback

## 📚 Key Dependencies

| Package | Purpose | Why? |
|---------|---------|------|
| `shiny` | Web framework | Industry standard for R web apps |
| `bslib` | Bootstrap 5 theming | Modern, responsive UI components |
| `shinyjs` | JavaScript integration | Dynamic UI updates, animations |
| `yaml` | Config parsing | Human-readable configuration |
| `stringr` | String operations | Regex, text cleaning |
| `stringdist` | Fuzzy matching | Cosine similarity for free-text validation |

## 🐛 Known Limitations

1. **Parser**: Only supports specific LaTeX environments (definition, proposition, remark)
2. **Validation**: Fuzzy matching not as intelligent as LLM-based validation
3. **Distractors**: Generated heuristically, not always optimal
4. **No persistence**: User stats lost on session end
5. **Single user**: No multi-user support or authentication

## 📞 Debugging Guide

### "Parser returns 0 items"
**Check**:
1. LaTeX file uses correct environments
2. File encoding (should be UTF-8)
3. Run `test_parser("path/to/file.tex")` for details

### "Questions not randomizing"
**Check**:
```r
questions <- readRDS("data/questions_bank.rds")
nrow(questions)  # Should be 80
table(questions$chapter_id)  # Should show 20 per chapter
```

### "App crashes on startup"
**Check**:
1. `data/questions_bank.rds` exists
2. All dependencies installed
3. R console for error messages

---

**For implementation details, see source code comments.**

**For user documentation, see README.md and QUICKSTART.md.**
