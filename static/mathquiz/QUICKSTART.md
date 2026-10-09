# 🚀 MathQuiz - Quick Start Guide

Get your math quiz app running in 3 simple steps!

## Step 1: Install Dependencies ⚙️

Open R or RStudio and run:

```r
setwd("C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz")
source("install_dependencies.R")
```

This will install all required packages (shiny, bslib, yaml, etc.)

## Step 2: Configure Paths 🔧

**IMPORTANT**: Configure the correct path to your maths repository:

```r
source("setup_paths.R")
```

This will automatically detect and configure the correct path to your LaTeX files.

## Step 3: Build Question Bank 📚

Generate questions from your LaTeX course files:

```r
source("build_question_bank.R")
```

This will:
- Parse all 4 chapter LaTeX files
- Extract definitions, propositions, and remarks
- Generate 20 questions per chapter (80 total)
- Save to `data/questions_bank.rds`

Expected output:
```
Processing: Probability Theory
Found 8 items:
  - Definitions: 5
  - Propositions: 2
  - Remarks: 1
Successfully generated 20 questions

... (repeat for all chapters)

Total questions generated: 80
```

## Step 4: Verify Setup (Optional) ✅

Test that everything is properly configured:

```r
source("test_setup.R")
```

## Step 5: Launch the App 🎉

Start the Shiny app:

```r
shiny::runApp("app.R")
```

Or in RStudio:
1. Open `app.R`
2. Click the "Run App" button

The app will open in your browser!

## 🎮 Using the App

1. **Select Chapters**: Click on chapter cards (blue borders when selected)
2. **Choose Difficulty**:
   - 📝 Medium: Multiple choice (4 options)
   - ✍️ Advanced: Type your answer
3. **Click "Start Quiz"**: 5 questions will be presented
4. **Answer Questions**: Get immediate feedback
5. **View Results**: See your score and accuracy

## 🔧 Troubleshooting

### "Questions file not found"
→ Run `source("build_question_bank.R")` first

### Parser returns 0 items
→ Check that your LaTeX files use:
- `\begin{definition}[Title]...\end{definition}`
- `\begin{proposition}[Title]...\end{proposition}`
- `\begin{remark}[Title]...\end{remark}`

### "Cannot find maths repository"
→ Update `config.yaml` with correct path:
```yaml
maths_repo_path: "../../maths"  # Adjust as needed
```

### Packages won't install
→ Try installing manually:
```r
install.packages(c("shiny", "bslib", "shinyjs", "yaml", "stringr", "stringdist"))
```

## 📝 Next Steps

Once everything works:

- **Customize**: Edit `config.yaml` for different settings
- **Extend**: Add more chapters to your quiz
- **Style**: Modify `assets/custom.css` for different colors
- **Deploy**: Use shinyapps.io for online access

For detailed documentation, see `README.md`

---

**Need Help?** Check the full README or open an issue on GitHub.

**Enjoy your math practice! 📐✨**
