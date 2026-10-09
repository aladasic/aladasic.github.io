# 📐 MathQuiz - Interactive Math Self-Assessment App

A Duolingo-inspired R Shiny application for interactive mathematics quiz practice. MathQuiz automatically parses your LaTeX course files to generate engaging quizzes with two difficulty modes.

![Status](https://img.shields.io/badge/status-active-success)
![R](https://img.shields.io/badge/R-4.0%2B-blue)
![Shiny](https://img.shields.io/badge/Shiny-1.7%2B-brightgreen)

## ✨ Features

- **📚 Automatic Content Parsing**: Extracts definitions, propositions, and remarks from LaTeX course files
- **🎯 Two Difficulty Modes**:
  - **Medium (QCM)**: Multiple-choice questions with 4 options
  - **Advanced (Free Text)**: Type answers freely with fuzzy matching validation
- **🎨 Modern UI**: Duolingo-inspired design with vibrant colors and smooth animations
- **📊 Progress Tracking**: Real-time score updates and progress bar
- **📱 Responsive Design**: Works seamlessly on desktop and mobile devices
- **🎓 Chapter Selection**: Choose specific topics to practice

## 🏗️ Architecture

```
mathquiz/
├── app.R                      # Main Shiny application
├── config.yaml                # Configuration file
├── build_question_bank.R      # Script to generate questions
├── modules/                   # (Future: modular UI components)
├── utils/
│   ├── latex_parser.R        # LaTeX parsing functions
│   ├── question_generator.R  # Question generation logic
│   └── answer_validator.R    # Answer validation & fuzzy matching
├── data/
│   └── questions_bank.rds    # Generated question database
└── assets/
    └── custom.css            # Duolingo-style CSS
```

## 📋 Prerequisites

### Required R Packages

```r
install.packages(c(
  "shiny",
  "bslib",
  "shinyjs",
  "yaml",
  "stringr",
  "stringdist"
))
```

### System Requirements

- R >= 4.0.0
- RStudio (recommended)
- LaTeX course files in structured format

## 🚀 Quick Start

### 1. Setup

Clone or navigate to the project directory:

```bash
cd C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz
```

### 2. Build Question Bank

Before running the app, generate the question bank from your LaTeX files:

```r
# Open R or RStudio
source("build_question_bank.R")
```

This will:
- Parse all LaTeX files specified in `config.yaml`
- Extract definitions, propositions, and remarks
- Generate 20 questions per chapter
- Save to `data/questions_bank.rds`

### 3. Run the App

#### Option A: RStudio
1. Open `app.R` in RStudio
2. Click "Run App" button

#### Option B: R Console
```r
library(shiny)
runApp("app.R")
```

The app will open in your default browser at `http://127.0.0.1:XXXX`

## ⚙️ Configuration

Edit `config.yaml` to customize:

```yaml
# Number of questions per quiz session
questions_per_session: 5

# Add/remove chapters
chapters:
  - id: "chp0"
    name: "Probability Theory"
    file: "chp0-probabilities/chp0-course-probabilities.tex"
    color: "#1CB0F6"

# Adjust fuzzy matching threshold (0-1)
difficulty_modes:
  advanced:
    similarity_threshold: 0.70  # Lower = more lenient
```

## 📖 LaTeX File Format

The parser expects LaTeX files with these environments:

```latex
\begin{definition}[Concept Name]
Your definition text here...
\end{definition}

\begin{proposition}[Theorem Name]
Statement of the proposition...
\end{proposition}

\begin{remark}[Note Title]
Important observation...
\end{remark}
```

### Supported Environments
- `\begin{definition}[...]`
- `\begin{proposition}[...]`
- `\begin{remark}[...]`

The title in square brackets becomes the concept name used in questions.

## 🎮 How to Use

### 1. Select Chapters
Click on chapter cards to select topics you want to practice. Multiple selections allowed!

### 2. Choose Difficulty
- **📝 Medium (QCM)**: Select from 4 multiple-choice options
- **✍️ Advanced (Free Text)**: Type your answer manually

### 3. Answer Questions
- Progress bar shows your advancement
- Immediate feedback after each answer
- Correct answers highlighted in green
- Incorrect answers shown with correct solution

### 4. View Results
- Final score and accuracy percentage
- Motivational message based on performance
- Option to retake quiz or return home

## 🧪 Testing Components

### Test LaTeX Parser
```r
source("utils/latex_parser.R")

# Test on a specific file
items <- test_parser("C:/Users/hp/Documents/GitHub/maths/chp0-probabilities/chp0-course-probabilities.tex")
print(items)
```

### Test Answer Validator
```r
source("utils/answer_validator.R")

# Run built-in tests
test_validator()
```

### Test Question Generator
```r
source("utils/latex_parser.R")
source("utils/question_generator.R")

# Parse a file
items <- parse_latex_file("path/to/file.tex")

# Generate questions
questions <- generate_questions(items, "test_chapter", 10)
print(questions)
```

## 🎨 Customizing the Design

### Colors (config.yaml)
```yaml
theme:
  primary_green: "#58CC02"  # Success color
  primary_red: "#FF4B4B"    # Error color
  primary_blue: "#1CB0F6"   # Primary accent
  bg_light: "#F7F7F7"       # Background
```

### CSS (assets/custom.css)
Modify CSS variables at the top of `custom.css`:

```css
:root {
  --primary-green: #58CC02;
  --primary-red: #FF4B4B;
  --primary-blue: #1CB0F6;
  /* ... */
}
```

## 📂 Adding New Chapters

1. **Add LaTeX file** to your maths repository
2. **Update config.yaml**:
```yaml
chapters:
  - id: "chp4"
    name: "New Chapter Name"
    file: "path/to/file.tex"
    color: "#FF6600"
```
3. **Rebuild question bank**:
```r
source("build_question_bank.R")
```

## 🔧 Troubleshooting

### Issue: "Questions file not found"
**Solution**: Run `source("build_question_bank.R")` first to generate the question bank.

### Issue: Parser returns empty results
**Causes**:
- LaTeX file doesn't use supported environments
- File path in config.yaml is incorrect
- LaTeX syntax errors

**Debug**:
```r
source("utils/latex_parser.R")
items <- parse_latex_file("path/to/problem_file.tex")
print(items)  # Check what was extracted
```

### Issue: Fuzzy matching too strict/lenient
**Solution**: Adjust `similarity_threshold` in `config.yaml`:
- Higher (0.80-0.90): More strict
- Lower (0.60-0.70): More lenient

### Issue: CSS not loading
**Ensure**:
1. `assets/custom.css` exists
2. Path in `app.R` is correct: `tags$link(rel = "stylesheet", href = "custom.css")`
3. Run from correct working directory

## 📊 Question Bank Statistics

After building, check your question bank:

```r
questions <- readRDS("data/questions_bank.rds")

# Total questions
nrow(questions)

# Questions per chapter
table(questions$chapter_id)

# Questions by type
table(questions$type)
```

## 🚀 Deployment Options

### Local Deployment
Already configured! Just run `app.R`

### Shinyapps.io Deployment
```r
library(rsconnect)

# First time: configure account
rsconnect::setAccountInfo(name='<ACCOUNT>', token='<TOKEN>', secret='<SECRET>')

# Deploy
rsconnect::deployApp(appDir = ".")
```

### Self-Hosted Server
Use Shiny Server or Docker. See [Shiny Server documentation](https://www.rstudio.com/products/shiny/shiny-server/).

## 🔮 Future Enhancements

Potential features for extension:

- [ ] **Persistent Statistics**: Save user progress across sessions (SQLite)
- [ ] **Claude API Integration**: Generate smarter distractors and validate complex answers
- [ ] **Spaced Repetition**: Intelligent question scheduling based on performance
- [ ] **Audio Feedback**: Sound effects for correct/incorrect answers
- [ ] **Dark Mode**: Theme toggle
- [ ] **Export Results**: Download quiz history as CSV
- [ ] **Timed Mode**: Add countdown timer option
- [ ] **Leaderboard**: Compare scores with others

## 📝 Code Structure

### Modular Design
Each component is self-contained for easy maintenance:

- **latex_parser.R**: Handles all LaTeX file processing
- **question_generator.R**: Creates quiz questions and distractors
- **answer_validator.R**: Validates both QCM and free-text answers
- **app.R**: Shiny UI and server logic

### Key Functions

#### LaTeX Parser
```r
parse_latex_file(tex_file_path)        # Main parsing function
extract_environment(text, env_name)     # Extract specific environments
clean_latex_content(text)               # Remove LaTeX commands
```

#### Question Generator
```r
generate_questions(parsed_items, chapter_id, num_questions)
generate_qcm_options(item, all_items)   # Create multiple-choice options
generate_freetext_question(item)        # Create open-ended questions
```

#### Answer Validator
```r
validate_freetext_answer(user_answer, correct_answer, keywords, threshold)
validate_qcm_answer(user_choice, correct_option)
```

## 🤝 Contributing

To extend or modify the app:

1. **Fork** the project
2. Create a **feature branch**
3. Make your changes with **clear comments**
4. Test thoroughly
5. Submit a **pull request**

## 📄 License

This project is for personal educational use. Course content belongs to the original author.

## 👤 Author

**Alexis Ladasic**
- GitHub: [@aladasic](https://github.com/aladasic)
- Website: [aladasic.github.io](https://aladasic.github.io)

## 🙏 Acknowledgments

- Inspired by [Duolingo](https://www.duolingo.com)'s gamified learning approach
- Built with [R Shiny](https://shiny.rstudio.com/)
- Uses [bslib](https://rstudio.github.io/bslib/) for Bootstrap 5 theming

---

**Happy Learning! 📚✨**

For issues or questions, please open an issue on GitHub.
