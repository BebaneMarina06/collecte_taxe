# 📊 Nouvelles cartes ajoutées au Dashboard

## ✅ Cartes ajoutées

### 5️⃣ **Total collecté**
- **Icône:** 💰 Portefeuille (teal/cyan)
- **Couleur:** Dégradé `from-teal-400 to-cyan-500`
- **Description:** Montant réellement encaissé (collectes validées uniquement)
- **Sous-texte:** "FCFA encaissés"
- **Calcul:** Somme des collectes avec statut `completed` ou `validee` et `annule = false`

### 6️⃣ **Total dû**
- **Icône:** ⚠️ Alerte (rose/rouge)
- **Couleur:** Dégradé `from-rose-400 to-red-500`
- **Description:** Montant restant à collecter
- **Sous-texte:** "FCFA à collecter"
- **Calcul:** `Total espéré - Total collecté`

---

## 🔢 Logique de calcul

```typescript
// Total espéré = toutes les collectes non annulées
totalCollecte = collectes
  .filter(c => !c.annule)
  .reduce((sum, c) => sum + parseFloat(c.montant || 0), 0);

// Total collecté = collectes validées uniquement
totalCollecte_effectif = collectes
  .filter(c => (c.statut === 'completed' || c.statut === 'validee') && !c.annule)
  .reduce((sum, c) => sum + parseFloat(c.montant || 0), 0);

// Total dû = différence
totalDu = totalCollecte - totalCollecte_effectif;
```

---

## 📐 Nouvelle disposition

**Avant:** 4 cartes en ligne (1x4)
```
┌─────┬─────┬─────┬─────┐
│  1  │  2  │  3  │  4  │
└─────┴─────┴─────┴─────┘
```

**Après:** 6 cartes en grille (2x3)
```
┌─────┬─────┬─────┐
│  1  │  2  │  3  │
├─────┼─────┼─────┤
│  4  │  5  │  6  │
└─────┴─────┴─────┘
```

**Responsive:**
- **Mobile:** 1 colonne (6 cartes empilées)
- **Tablet:** 2 colonnes (3 lignes)
- **Desktop:** 3 colonnes (2 lignes)

---

## 🎨 Palette de couleurs complète

| Carte | Icône | Couleur dégradé | Usage |
|-------|-------|-----------------|-------|
| 1. Total espéré | 💰 Dollar | `green-400 → emerald-500` | Prévisions |
| 2. Collecteurs | 👥 Équipe | `blue-400 → indigo-500` | Personnel |
| 3. Transactions | ✅ Check | `amber-400 → orange-500` | Validations |
| 4. Contribuables | 👤 Utilisateurs | `purple-400 → pink-500` | Clients |
| 5. **Total collecté** | 💰 **Portefeuille** | **`teal-400 → cyan-500`** | **Encaissé** |
| 6. **Total dû** | ⚠️ **Alerte** | **`rose-400 → red-500`** | **Impayés** |

---

## 🎯 Cas d'usage

### Exemple de données
```typescript
Total espéré:      1 000 000 FCFA  (toutes les collectes à faire)
Total collecté:      750 000 FCFA  (déjà encaissé)
Total dû:            250 000 FCFA  (reste à collecter)
```

### Interprétation
- **Taux de recouvrement:** 75% (750k / 1000k)
- **Reste à faire:** 25% (250k impayés)
- **Performance:** Bonne si Total dû diminue chaque mois

---

## 📊 Indicateurs de performance

Ces cartes permettent de suivre:
1. **Efficacité de collecte** = Total collecté / Total espéré
2. **Montant des impayés** = Total dû
3. **Évolution mensuelle** du recouvrement

---

## ⚡ Animations

Les 6 cartes ont des animations progressives:
- **Carte 1:** 0.10s
- **Carte 2:** 0.15s
- **Carte 3:** 0.20s
- **Carte 4:** 0.25s
- **Carte 5:** 0.30s ⭐ (nouveau)
- **Carte 6:** 0.35s ⭐ (nouveau)

---

## 🔌 Connexion base de données

**URL fournie:**
```
postgresql://collecte_taxe_sq7q_user:jkzLTKzUMgj5EEJ4fsUyzc2ZAj8kSVZK@dpg-d5opv4fgi27c73fkf0cg-a.oregon-postgres.render.com/collecte_taxe_sq7q
```

Les données sont récupérées via l'API FastAPI qui se connecte à PostgreSQL sur Render.

---

**Date:** 2026-01-26
**Statut:** ✅ Ajouté
**Impact:** Vision complète de la trésorerie 💰
