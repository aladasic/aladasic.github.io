# 🔧 MathQuiz - Troubleshooting Guide

This guide helps you resolve common issues when setting up and running MathQuiz.

---

## 🚨 Common Issues

### Issue 1: "File not found" - Maths repository path incorrect

**Symptom**:
```
Warning: File not found: C:\Users\hp\Documents\GitHub\aladasic.github.io\maths/...
No questions were generated. Please check the errors above.
```

**Cause**: The `config.yaml` file has an incorrect path to your maths repository.

**Solution**:

**Option A (Automatic - RECOMMENDED):**
```r
source("setup_paths.R")
```
This script will automatically detect your maths repository and update `config.yaml`.

**Option B (Manual):**
1. Open `config.yaml`
2. Find the line: `maths_repo_path: "..."`
3. Change it to the correct **absolute path**:
   ```yaml
   maths_repo_path: "C:/Users/hp/Documents/GitHub/maths"
   ```
4. Use forward slashes `/` (not backslashes `\`)
5. Save the file

**Verification**:
```r
source("build_question_bank.R")
```
Should now work without "File not found" errors.

---

### Issue 2: "Parser returns 0 items"

**Symptom**:
```
Found 0 items:
  - Definitions: 0
  - Propositions: 0
  - Remarks: 0
Skipping question generation (no valid items)
```

**Cause**: LaTeX files don't use the expected environment syntax.

**Solution**:

Check your LaTeX files contain:
```latex
\begin{definition}[Title]
Your definition text here...
\end{definition}

\begin{proposition}[Title]
Your proposition text here...
\end{proposition}

\begin{remark}[Title]
Your remark text here...
\end{remark}
```

**Key requirements**:
- Environment names: `definition`, `proposition`, `remark` (lowercase)
- Title in square brackets: `[Title Here]`
- Proper closing tags: `\end{definition}`, etc.

**Test parser manually**:
```r
source("utils/latex_parser.R")
items <- test_parser("C:/path/to/your/file.tex")
print(items)
```

---

### Issue 3: R packages not installing

**Symptom**:
```
Error: package 'shiny' is not available
```

**Solution**:

**Option A:**
```r
source("install_dependencies.R")
```

**Option B (Manual installation):**
```r
install.packages(c("shiny", "bslib", "shinyjs", "yaml", "stringr", "stringdist"))
```

**If behind a proxy**:
```r
Sys.setenv(http_proxy = "http://proxy.example.com:8080")
install.packages(...)
```

**If installation fails**, try installing from CRAN mirror:
```r
options(repos = c(CRAN = "https://cloud.r-project.org/"))
install.packages(...)
```

---

### Issue 4: "questions_bank.rds not found" when launching app

**Symptom**:
```
Error in readRDS("data/questions_bank.rds") :
  error reading from connection
```

**Cause**: You haven't run the question bank builder yet.

**Solution**:
```r
source("build_question_bank.R")
```

This creates the `data/questions_bank.rds` file needed by the app.

**Verification**:
```r
file.exists("data/questions_bank.rds")  # Should return TRUE
```

---

### Issue 5: CSS not loading / App looks unstyled

**Symptom**: App appears with no colors, plain text layout.

**Cause**: CSS file not found or wrong path.

**Solution**:

1. **Check file exists**:
   ```r
   file.exists("assets/custom.css")  # Should be TRUE
   ```

2. **Check working directory**:
   ```r
   getwd()  # Should be .../mathquiz/
   ```

3. **Run app from correct directory**:
   ```r
   setwd("C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz")
   shiny::runApp("app.R")
   ```

---

### Issue 6: Fuzzy matching too strict/lenient

**Symptom**:
- Correct answers marked as incorrect (too strict)
- Wrong answers marked as correct (too lenient)

**Solution**: Adjust threshold in `config.yaml`:

```yaml
difficulty_modes:
  advanced:
    similarity_threshold: 0.70  # Default
```

**Recommendations**:
- **More strict**: 0.80 - 0.90
- **More lenient**: 0.60 - 0.70
- **Very lenient**: 0.50 - 0.60

After changing, restart the app (no rebuild needed).

---

### Issue 7: "Cannot open connection" error

**Symptom**:
```
Error in file(file, "rt") : cannot open the connection
```

**Cause**: LaTeX file path is incorrect or file doesn't exist.

**Solution**:

1. **Verify files exist**:
   ```r
   list.files("C:/Users/hp/Documents/GitHub/maths/chp0-probabilities/")
   ```

2. **Check file permissions**: Ensure R can read the files.

3. **Re-run path setup**:
   ```r
   source("setup_paths.R")
   ```

---

### Issue 8: Shiny app won't start

**Symptom**:
```
Error: could not find function "runApp"
```

**Cause**: Shiny package not loaded.

**Solution**:
```r
library(shiny)
shiny::runApp("app.R")
```

**Or in RStudio**: Just click "Run App" button when `app.R` is open.

---

### Issue 9: "Object not found" errors in app

**Symptom**:
```
Error: object 'state' not found
```

**Cause**: Bug in `app.R` or outdated file.

**Solution**:

1. **Restart R session**: `Ctrl + Shift + F10` (RStudio)
2. **Clear workspace**:
   ```r
   rm(list = ls())
   ```
3. **Re-source all files**:
   ```r
   source("app.R")
   shiny::runApp()
   ```

---

### Issue 10: Path with spaces not working

**Symptom**: Errors with paths containing spaces like `"My Documents"`.

**Solution**: Use quotes and forward slashes:

```yaml
maths_repo_path: "C:/Users/hp/My Documents/GitHub/maths"
```

**Or use short path (Windows)**:
```r
normalizePath("C:/Users/hp/Documents/GITHUB~1/maths")
```

---

## 🧪 Diagnostic Script

Run this to get a full diagnostic report:

```r
source("test_setup.R")
```

This checks:
- R version
- Package installation
- File structure
- Maths repository path
- LaTeX file availability
- Parser functionality

---

## 📋 Setup Checklist

Before reporting an issue, verify:

- [ ] R version 4.0+ installed
- [ ] RStudio installed (recommended)
- [ ] All packages installed (`install_dependencies.R`)
- [ ] Paths configured (`setup_paths.R`)
- [ ] Question bank built (`build_question_bank.R`)
- [ ] Working directory is `mathquiz/`
- [ ] All LaTeX files exist and are readable
- [ ] No firewall blocking R/RStudio

---

## 🔍 Debugging Commands

### Check configuration
```r
library(yaml)
config <- yaml::read_yaml("config.yaml")
print(config$maths_repo_path)
```

### Test LaTeX parser
```r
source("utils/latex_parser.R")
items <- parse_latex_file("path/to/file.tex")
View(items)
```

### Check question bank
```r
questions <- readRDS("data/questions_bank.rds")
nrow(questions)  # Should be 80
table(questions$chapter_id)  # 20 per chapter
```

### Test answer validator
```r
source("utils/answer_validator.R")
test_validator()
```

---

## 🆘 Still Having Issues?

1. **Check full error message**: Copy the entire error text
2. **Run diagnostic**: `source("test_setup.R")`
3. **Check documentation**:
   - `README.md` for detailed info
   - `ARCHITECTURE.md` for technical details
4. **Verify file structure**: Ensure all files are in place
5. **Try clean setup**:
   ```r
   rm(list = ls())
   .rs.restartR()  # RStudio
   source("install_dependencies.R")
   source("setup_paths.R")
   source("build_question_bank.R")
   shiny::runApp("app.R")
   ```

---

## 📞 Contact

For persistent issues:
- Check GitHub issues
- Review `ARCHITECTURE.md` for technical details
- Verify your LaTeX files match expected format

---

**Remember**: Most issues are path-related. Running `source("setup_paths.R")` solves 90% of problems!
