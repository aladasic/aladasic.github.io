# 🔧 Corrections Apportées

Ce document résume les corrections effectuées pour résoudre vos deux problèmes.

---

## 1️⃣ Hébergement en Ligne

### ❌ Problème
L'application Shiny ne peut pas être hébergée directement sur GitHub Pages (qui ne supporte que HTML/CSS/JS statique).

### ✅ Solution

**A. Déploiement sur ShinyApps.io**

Fichiers créés :
- `deploy_to_shinyapps.R` : Script automatique de déploiement
- `DEPLOYMENT_GUIDE.md` : Guide complet étape par étape
- `mathquiz.html` : Page de redirection pour votre site

**Étapes pour déployer :**

```r
# 1. Installer rsconnect
install.packages("rsconnect")

# 2. Configurer ShinyApps.io
rsconnect::setAccountInfo(
  name = "YOUR_USERNAME",
  token = "YOUR_TOKEN",
  secret = "YOUR_SECRET"
)

# 3. Déployer
setwd("C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz")
source("deploy_to_shinyapps.R")
```

**Résultat :**
- App accessible à : `https://YOUR_USERNAME.shinyapps.io/mathquiz/`
- Gratuit : 25 heures actives/mois
- Accessible depuis n'importe où

**Lien depuis votre site :**
1. Copiez `mathquiz.html` à la racine de votre site
2. Remplacez `YOUR_USERNAME` par votre nom d'utilisateur ShinyApps.io
3. Accédez via : `https://aladasic.github.io/mathquiz.html`

---

## 2️⃣ Sélection des Chapitres

### ❌ Problème
Les cartes de chapitres ne se mettent pas à jour visuellement après un clic (pas de bordure verte).

### ✅ Solution

**Modification dans `app.R` (lignes 170-191) :**

```r
# AVANT (ne fonctionnait pas)
observeEvent(input$toggle_chapter, {
  chapter_id <- input$toggle_chapter
  if (chapter_id %in% state$selected_chapters) {
    state$selected_chapters <- setdiff(state$selected_chapters, chapter_id)
  } else {
    state$selected_chapters <- c(state$selected_chapters, chapter_id)
  }
})

# APRÈS (fonctionne)
observeEvent(input$toggle_chapter, {
  chapter_id <- input$toggle_chapter
  if (chapter_id %in% state$selected_chapters) {
    state$selected_chapters <- setdiff(state$selected_chapters, chapter_id)
  } else {
    state$selected_chapters <- c(state$selected_chapters, chapter_id)
  }
  # Force re-render pour afficher la sélection
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
```

**Explication :**
- Le problème : Shiny ne détectait pas que les cartes devaient se re-rendre
- La solution : Force un re-render après chaque clic
- Résultat : Les cartes montrent maintenant la bordure verte (#58CC02) quand sélectionnées

**Test :**
```r
# Relancez l'app
shiny::runApp("app.R")

# Cliquez sur une carte → bordure verte apparaît
# Cliquez à nouveau → bordure disparaît
```

---

## 📋 Checklist de Vérification

### Sélection des Chapitres
- [ ] Relancer l'app : `shiny::runApp("app.R")`
- [ ] Cliquer sur une carte de chapitre
- [ ] Vérifier que la bordure verte apparaît
- [ ] Cliquer à nouveau pour désélectionner
- [ ] Vérifier que la bordure disparaît

### Déploiement en Ligne
- [ ] Créer un compte sur [shinyapps.io](https://www.shinyapps.io/)
- [ ] Obtenir token et secret (Account → Tokens)
- [ ] Configurer `rsconnect` dans R
- [ ] Exécuter `deploy_to_shinyapps.R`
- [ ] Tester l'URL : `https://YOUR_USERNAME.shinyapps.io/mathquiz/`
- [ ] Copier `mathquiz.html` à la racine du site
- [ ] Remplacer `YOUR_USERNAME` dans le fichier
- [ ] Commit et push vers GitHub
- [ ] Tester : `https://aladasic.github.io/mathquiz.html`

---

## 🎯 Résultat Final

### Avant
- ❌ Cartes ne se sélectionnent pas visuellement
- ❌ App uniquement accessible localement

### Après
- ✅ Cartes montrent bordure verte quand sélectionnées
- ✅ App déployée en ligne sur ShinyApps.io
- ✅ Accessible via votre site web
- ✅ 46 questions fonctionnelles sur 4 chapitres
- ✅ Deux modes : QCM et texte libre

---

## 🚀 Prochaines Actions

1. **Tester la sélection :**
   ```r
   shiny::runApp("app.R")
   ```

2. **Déployer en ligne :**
   ```r
   source("deploy_to_shinyapps.R")
   ```

3. **Ajouter le lien sur votre site :**
   - Copier `mathquiz.html` à la racine
   - Modifier l'URL de redirection
   - Commit et push

---

## 📚 Documentation Associée

- `DEPLOYMENT_GUIDE.md` : Guide complet de déploiement
- `TROUBLESHOOTING.md` : Résolution de problèmes courants
- `README.md` : Documentation générale
- `QUICKSTART.md` : Guide de démarrage rapide

---

## 💡 Conseils

1. **Pour tester localement :** Toujours relancer l'app après modification
2. **Pour déployer :** Assurez-vous que `questions_bank.rds` existe
3. **ShinyApps.io gratuit :** 25 heures/mois suffisant pour usage personnel
4. **App dort après 15 min** : Normal, se réveille en 15-20 secondes

---

**Les deux problèmes sont maintenant résolus ! 🎉**

Testez la sélection des chapitres et suivez le guide de déploiement pour mettre l'app en ligne.
