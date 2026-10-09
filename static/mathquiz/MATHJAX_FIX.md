# 🔢 MathJax Integration - Rendering LaTeX Formulas

## 🐛 Problème

Les formules mathématiques LaTeX ne s'affichaient pas correctement :
- `$A_{ij}$` s'affichait comme du texte brut "A_{ij}"
- Indices, exposants, fractions, symboles mathématiques n'étaient pas rendus

## ✅ Solution Appliquée

### 1. Ajout de MathJax dans l'UI

**Fichier modifié :** `app.R`

```r
tags$head(
  tags$script(src = "https://code.jquery.com/jquery-3.6.0.min.js"),

  # MathJax pour le rendu des formules mathématiques
  tags$script(src = "https://polyfill.io/v3/polyfill.min.js?features=es6"),
  tags$script(
    id = "MathJax-script",
    async = NA,
    src = "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"
  ),

  # Configuration MathJax
  tags$script(HTML("
    window.MathJax = {
      tex: {
        inlineMath: [['$', '$'], ['\\\\(', '\\\\)']],
        displayMath: [['$$', '$$'], ['\\\\[', '\\\\]']],
        processEscapes: true
      },
      options: {
        skipHtmlTags: ['script', 'noscript', 'style', 'textarea', 'pre']
      }
    };
  "))
)
```

### 2. Conversion du texte en HTML

Les questions et options doivent être rendues avec `HTML()` au lieu de texte brut :

```r
# Questions
div(class = "question-text", HTML(question_text))

# Options QCM
tags$div(
  class = card_class,
  HTML(options[i])
)

# Feedback
div(class = "feedback-message", HTML(feedback_text))
```

### 3. Déclenchement du rendu MathJax

Après chaque changement de question ou feedback :

```r
# Après l'affichage de la question
observe({
  req(state$current_questions)
  state$current_index

  shinyjs::delay(100, {
    shinyjs::runjs("if (window.MathJax) { MathJax.typesetPromise(); }")
  })
})

# Après l'affichage du feedback
observe({
  req(state$feedback_shown)

  shinyjs::delay(150, {
    shinyjs::runjs("if (window.MathJax) { MathJax.typesetPromise(); }")
  })
})
```

### 4. Conservation des symboles $ dans le parser

**Fichier modifié :** `utils/latex_parser.R`

**AVANT (ne fonctionnait pas) :**
```r
# Supprimait les $ nécessaires pour MathJax
cleaned <- str_replace_all(cleaned, "\\$([^\\$]+)\\$", "\\1")
```

**APRÈS (fonctionne) :**
```r
# KEEP dollar signs for MathJax rendering
# DO NOT remove $ symbols - they are needed for math formulas
```

### 5. Reconstruction de la banque de questions

**IMPORTANT :** Il faut reconstruire la banque pour que les formules soient conservées :

```r
# 1. Nettoyer l'ancienne banque
file.remove("data/questions_bank.rds")

# 2. Reconstruire avec le nouveau parser
source("build_question_bank.R")

# 3. Relancer l'app
shiny::runApp("app.R")
```

## 📐 Formules LaTeX Supportées

### Inline Math (dans le texte)
```latex
$A_{ij}$          → A avec indices
$x^2$             → x au carré
$\frac{a}{b}$     → Fraction a/b
$\alpha, \beta$   → Symboles grecs
$\sum_{i=1}^n$    → Somme
```

### Display Math (centré)
```latex
$$
\int_0^1 f(x) dx = F(1) - F(0)
$$
```

### Exemples Courants

| LaTeX | Rendu |
|-------|-------|
| `$A_{ij}$` | A avec indice ij en bas |
| `$x^2 + y^2 = z^2$` | Équation avec exposants |
| `$\mathbb{R}^n$` | ℝ avec exposant n |
| `$P(A \cap B)$` | P(A intersection B) |
| `$\frac{\partial f}{\partial x}$` | Dérivée partielle |
| `$\alpha \in [0,1]$` | Alpha dans l'intervalle |

## 🧪 Test du Rendu MathJax

### Test 1 : Formule Simple
```r
# Dans l'app, vous devriez voir :
# - $A_{ij}$ rendu avec l'indice ij correctement placé
# - $x^2$ avec le 2 en exposant
# - $\frac{a}{b}$ comme une vraie fraction
```

### Test 2 : Dans les Questions
Créez une question avec :
```
"What is the definition of $\mathbb{R}^n$?"
```

Résultat attendu : ℝ avec n en exposant.

### Test 3 : Dans les Réponses
Une réponse contenant :
```
"A matrix $A_{ij}$ where $i \in \mathbb{N}$ and $j \in \mathbb{N}$"
```

Résultat attendu : Tous les symboles mathématiques correctement formatés.

## 🐛 Dépannage

### Les formules ne s'affichent toujours pas

**1. Vérifier que MathJax est chargé :**
```javascript
// Dans la console du navigateur (F12)
console.log(window.MathJax)
// Doit retourner un objet, pas undefined
```

**2. Vérifier que les $ sont présents :**
```r
# Dans R
questions <- readRDS("data/questions_bank.rds")
grep("\\$", questions$correct_answer, value = TRUE)
# Doit retourner des lignes contenant $
```

**3. Reconstruire la banque :**
```r
source("build_question_bank.R")
```

**4. Vider le cache du navigateur :**
- Chrome : Ctrl+Shift+Del
- Firefox : Ctrl+Shift+Del
- Edge : Ctrl+Shift+Del

### Les formules s'affichent au premier chargement mais pas après

**Solution :** Les observers MathJax sont déjà en place. Si ça ne fonctionne pas :

```r
# Ajouter un delay plus long
shinyjs::delay(200, {
  shinyjs::runjs("if (window.MathJax) { MathJax.typesetPromise(); }")
})
```

## 📋 Checklist de Vérification

- [ ] MathJax chargé dans `app.R` (tags$head)
- [ ] Configuration MathJax présente
- [ ] `HTML()` utilisé pour questions, options, feedback
- [ ] Observers MathJax ajoutés pour questions et feedback
- [ ] Parser LaTeX conserve les symboles `$`
- [ ] Banque de questions reconstruite
- [ ] App testée avec formules mathématiques

## ✅ Résultat Final

**Avant :**
```
Question: "What is A_{ij}?"
```

**Après :**
```
Question: "What is Aᵢⱼ?"  (avec indices correctement formatés)
```

Les formules mathématiques sont maintenant correctement rendues dans :
- ✅ Les questions
- ✅ Les options de réponse (QCM)
- ✅ Les réponses correctes (feedback)
- ✅ Les messages de feedback

---

## 🚀 Actions Requises

Pour que MathJax fonctionne, vous DEVEZ :

1. **Reconstruire la banque de questions** (obligatoire)
   ```r
   source("build_question_bank.R")
   ```

2. **Relancer l'application**
   ```r
   shiny::runApp("app.R")
   ```

3. **Tester avec une question contenant des formules**

---

**Les formules mathématiques sont maintenant supportées ! 📐✨**
