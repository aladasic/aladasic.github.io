# ✅ Test l'Application - Guide Rapide

## 🚀 Lancer l'Application

```r
setwd("C:/Users/hp/Documents/GitHub/aladasic.github.io/static/mathquiz")
shiny::runApp("app.R")
```

---

## ✓ Checklist de Test

### 1. Écran d'Accueil

- [ ] **Voir 4 cartes de chapitres** avec icônes 📚
- [ ] **Cliquer sur "Probability Theory"**
  - Résultat attendu : Bordure verte apparaît autour de la carte
- [ ] **Cliquer sur "Finite Random Variables"**
  - Résultat attendu : Bordure verte apparaît aussi
- [ ] **Re-cliquer sur "Probability Theory"**
  - Résultat attendu : Bordure verte disparaît
- [ ] **Cliquer sur bouton de difficulté "Advanced"**
  - Résultat attendu : Bouton devient actif (style changé)

### 2. Démarrer le Quiz

- [ ] **Sans sélectionner de chapitre, cliquer "Start Quiz"**
  - Résultat attendu : Notification "Please select at least one chapter!"
- [ ] **Sélectionner au moins un chapitre**
- [ ] **Cliquer "Start Quiz"**
  - Résultat attendu : Passage à l'écran de quiz

### 3. Quiz - Mode QCM (Medium)

- [ ] **Voir une question affichée** avec badge (DEFINITION/PROPOSITION/REMARK)
- [ ] **Voir 4 options de réponse**
- [ ] **Cliquer sur une option**
  - Résultat attendu : Option devient bleue (selected)
- [ ] **Cliquer "Check Answer"**
  - Si correct :
    - [ ] Option devient verte
    - [ ] Message "Excellent! That's correct! ✓" affiché
  - Si incorrect :
    - [ ] Option sélectionnée devient rouge
    - [ ] Bonne option devient verte
    - [ ] Message "Not quite. The correct answer is: [réponse]" affiché
- [ ] **Bouton change en "Next Question"**
- [ ] **Cliquer "Next Question"**
  - Résultat attendu : Question suivante affichée
  - Barre de progression augmente

### 4. Quiz - Mode Texte Libre (Advanced)

- [ ] **Revenir à l'accueil et sélectionner mode "Advanced"**
- [ ] **Démarrer un nouveau quiz**
- [ ] **Voir zone de texte pour réponse**
- [ ] **Taper une réponse** (ex: "A random experiment is unpredictable")
- [ ] **Cliquer "Check Answer"**
  - Si correct (score > 70%) :
    - [ ] Message vert affiché
  - Si incorrect :
    - [ ] Message rouge avec bonne réponse affiché
- [ ] **Continuer jusqu'à la fin**

### 5. Écran de Résultats

- [ ] **Après 5 questions, voir l'écran de résultats**
- [ ] **Vérifier** :
  - [ ] Score affiché (ex: "4 / 5")
  - [ ] Pourcentage de réussite (ex: "80%")
  - [ ] Message motivationnel approprié
  - [ ] Nombre de réponses correctes
- [ ] **Cliquer "Take Another Quiz"**
  - Résultat attendu : Retour à l'écran d'accueil
- [ ] **Cliquer "Back to Home"**
  - Résultat attendu : Retour à l'écran d'accueil

---

## 🐛 Problèmes Connus Résolus

✅ **Sélection des chapitres** : Maintenant visible avec bordure verte
✅ **Affichage des solutions** : Feedback affiché correctement
✅ **Options QCM colorées** : Vert pour correct, rouge pour incorrect
✅ **Navigation** : Bouton change de "Check Answer" → "Next Question"

---

## 🎯 Ce Qui Doit Fonctionner

### Visual Feedback
- Cartes de chapitres : bordure verte quand sélectionnées
- Options QCM : bleue (sélectionnée), verte (correcte), rouge (incorrecte)
- Messages : vert (succès), rouge (erreur)
- Barre de progression : animée, augmente à chaque question

### Interactions
- Clic sur carte de chapitre : toggle sélection
- Clic sur option QCM : sélection visible
- Clic "Check Answer" : validation + feedback
- Clic "Next Question" : passage à la suivante
- Score : mis à jour en temps réel

### Responsive
- Design s'adapte à la taille de l'écran
- Fonctionne sur mobile/tablette/desktop

---

## 📊 Scénario de Test Complet

**Durée : 2-3 minutes**

1. Lancer l'app
2. Sélectionner 2 chapitres (Probability + Finite RV)
3. Choisir mode "Medium (QCM)"
4. Cliquer "Start Quiz"
5. Pour chaque question :
   - Sélectionner une réponse
   - Cliquer "Check Answer"
   - Observer le feedback
   - Cliquer "Next Question"
6. Voir les résultats finaux
7. Cliquer "Take Another Quiz"
8. Essayer mode "Advanced (Free Text)"
9. Répéter le quiz

---

## ❌ Si Quelque Chose Ne Fonctionne Pas

### Sélection ne s'affiche pas
```r
# Vérifier que custom.css est dans www/
file.exists("www/custom.css")  # Doit retourner TRUE

# Si FALSE, exécuter :
dir.create("www", showWarnings = FALSE)
file.copy("assets/custom.css", "www/custom.css", overwrite = TRUE)
```

### Feedback ne s'affiche pas
```r
# Redémarrer R et relancer
.rs.restartR()  # Dans RStudio
shiny::runApp("app.R")
```

### Erreur "Questions not found"
```r
# Reconstruire la banque de questions
source("build_question_bank.R")
```

### Erreur de packages
```r
# Réinstaller les dépendances
source("install_dependencies.R")
```

---

## ✅ Critères de Succès

L'application est **fonctionnelle** si :

- [x] Vous pouvez sélectionner des chapitres (bordure verte visible)
- [x] Le quiz démarre sans erreur
- [x] Les questions s'affichent correctement
- [x] Vous pouvez répondre (QCM ou texte)
- [x] Le feedback s'affiche après validation
- [x] Les bonnes réponses sont colorées en vert
- [x] Vous pouvez naviguer entre les questions
- [x] L'écran de résultats s'affiche
- [x] Le score est correct

---

## 🎉 Si Tout Fonctionne

**Félicitations ! Votre application est opérationnelle !**

Prochaine étape : Déployer en ligne
```r
source("deploy_to_shinyapps.R")
```

Consultez `DEPLOYMENT_GUIDE.md` pour les instructions complètes.

---

## 📞 Support

Si vous rencontrez des problèmes :
1. Consultez `BUGFIXES.md` pour les bugs connus
2. Consultez `TROUBLESHOOTING.md` pour les solutions courantes
3. Vérifiez `README.md` pour la documentation complète

---

**Bon test ! 🚀**
