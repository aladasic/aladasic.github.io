# Deploy MathQuiz to ShinyApps.io
# This script deploys your application to shinyapps.io for online hosting

library(rsconnect)

cat("========================================\n")
cat("MathQuiz - Deploy to ShinyApps.io\n")
cat("========================================\n\n")

# Check if rsconnect is configured
accounts <- rsconnect::accounts()

if (nrow(accounts) == 0) {
  cat("❌ No ShinyApps.io account configured!\n\n")
  cat("SETUP INSTRUCTIONS:\n")
  cat("1. Create a free account at https://www.shinyapps.io/\n")
  cat("2. Go to Account → Tokens\n")
  cat("3. Click 'Show' then 'Show Secret'\n")
  cat("4. Run this command with your credentials:\n\n")
  cat("   rsconnect::setAccountInfo(\n")
  cat("     name = 'YOUR_USERNAME',\n")
  cat("     token = 'YOUR_TOKEN',\n")
  cat("     secret = 'YOUR_SECRET'\n")
  cat("   )\n\n")
  cat("5. Then run this script again\n\n")
  stop("ShinyApps.io not configured")
}

cat("✓ ShinyApps.io account found:", accounts$name[1], "\n\n")

# Check that question bank exists
if (!file.exists("data/questions_bank.rds")) {
  cat("❌ Question bank not found!\n")
  cat("Please run: source('build_question_bank.R')\n\n")
  stop("Question bank missing")
}

cat("✓ Question bank found\n\n")

# Deploy
cat("Deploying to ShinyApps.io...\n")
cat("This may take several minutes...\n\n")

tryCatch({
  rsconnect::deployApp(
    appDir = ".",
    appName = "mathquiz",
    appTitle = "MathQuiz - Interactive Math Learning",
    account = accounts$name[1],
    forceUpdate = TRUE
  )

  cat("\n========================================\n")
  cat("✓ DEPLOYMENT SUCCESSFUL!\n")
  cat("========================================\n\n")
  cat("Your app is now live at:\n")
  cat(sprintf("https://%s.shinyapps.io/mathquiz/\n\n", accounts$name[1]))
  cat("You can now create a link on your website.\n")

}, error = function(e) {
  cat("\n❌ Deployment failed!\n")
  cat("Error:", e$message, "\n\n")
})
