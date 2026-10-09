# Changelog

All notable changes to the MathQuiz project will be documented in this file.

## [1.0.0] - 2025-12-16

### Initial Release 🎉

#### ✨ Features
- **LaTeX Parser**: Automatic extraction of definitions, propositions, and remarks from course files
- **Question Generator**: Creates 20 questions per chapter (80 total for 4 chapters)
- **Two Difficulty Modes**:
  - Medium: Multiple-choice questions with 4 options
  - Advanced: Free-text answers with fuzzy string matching
- **Duolingo-Inspired UI**: Modern, colorful, gamified design
- **Responsive Design**: Works on desktop, tablet, and mobile
- **Progress Tracking**: Real-time score updates and progress bar
- **Immediate Feedback**: Visual feedback (green/red) after each answer
- **Chapter Selection**: Choose specific topics to practice
- **Results Screen**: Final score with accuracy percentage

#### 📁 Project Structure
- `app.R`: Main Shiny application (UI + Server)
- `config.yaml`: Centralized configuration
- `build_question_bank.R`: Offline question generation script
- `utils/latex_parser.R`: LaTeX parsing utilities
- `utils/question_generator.R`: Question generation logic
- `utils/answer_validator.R`: Answer validation (QCM + fuzzy)
- `assets/custom.css`: Duolingo-style CSS
- `install_dependencies.R`: Package installation script
- `test_setup.R`: Setup verification script

#### 📚 Documentation
- `README.md`: Comprehensive user and developer documentation
- `QUICKSTART.md`: 3-step quick start guide
- `ARCHITECTURE.md`: Technical architecture documentation
- `CHANGELOG.md`: This file

#### 🎨 Design
- Color palette: Green (#58CC02), Red (#FF4B4B), Blue (#1CB0F6)
- Animations: slideIn, pulse, smooth transitions
- Typography: Nunito font (Google Fonts)
- Cards: Rounded corners, soft shadows, hover effects

#### ⚙️ Configuration
- 5 questions per session (configurable)
- 4 chapters supported: Probability, Finite RV, Continuous RV, RV Pairs
- Fuzzy matching threshold: 0.70 (adjustable)
- Relative path to maths repository: `../../maths`

#### 🧪 Testing
- `test_setup.R`: Verifies installation, file structure, and parser
- Manual testing scripts for parser and validator
- LaTeX parser tested on all 4 chapters

#### 📦 Dependencies
- shiny (>= 1.7)
- bslib (>= 0.5)
- shinyjs (>= 2.1)
- yaml (>= 2.3)
- stringr (>= 1.5)
- stringdist (>= 0.9)

#### 🎯 Supported LaTeX Environments
```latex
\begin{definition}[Title]...\end{definition}
\begin{proposition}[Title]...\end{proposition}
\begin{remark}[Title]...\end{remark}
```

#### 🚀 Performance
- Question bank precomputed offline
- App startup time: < 1 second
- Minimal memory footprint
- Efficient reactive updates

#### 🔐 Privacy
- Local-only execution
- No external API calls (v1.0)
- No persistent data storage
- No user tracking

#### 📱 Browser Support
- Chrome/Edge (Chromium) ✅
- Firefox ✅
- Safari ✅
- Mobile browsers ✅

---

## 🔮 Planned Features (Future Versions)

### v1.1 (Planned)
- [ ] Sound effects for correct/incorrect answers
- [ ] Dark mode toggle
- [ ] Export results to CSV
- [ ] Improved distractor generation

### v1.2 (Planned)
- [ ] Persistent user statistics (SQLite)
- [ ] Performance analytics dashboard
- [ ] Spaced repetition algorithm
- [ ] Custom question sets

### v2.0 (Planned)
- [ ] Claude API integration for intelligent validation
- [ ] Multi-user support with authentication
- [ ] Leaderboard and challenges
- [ ] Mobile app (Shiny for iOS/Android)

---

## 📝 Version History

- **v1.0.0** (2025-12-16): Initial release with core features

---

**Note**: This project follows [Semantic Versioning](https://semver.org/).
- **MAJOR**: Incompatible API/structure changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)
