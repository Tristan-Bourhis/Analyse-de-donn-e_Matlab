# Analyse-de-donn-e_Matlab

Collection de scripts MATLAB pour des travaux pratiques d'analyse de donnees:

- Classification supervisee
- ANOVA (1 facteur, 2 facteurs, N facteurs)
- PCA (Analyse en composantes principales)
- Clustering (hierarchique et k-means)

## Sommaire

1. [Vue d'ensemble](#vue-densemble)
2. [Structure du depot](#structure-du-depot)
3. [Prerequis](#prerequis)
4. [Execution rapide](#execution-rapide)
5. [Description des modules](#description-des-modules)
6. [Jeux de donnees](#jeux-de-donnees)
7. [Reproductibilite](#reproductibilite)
8. [Problemes connus](#problemes-connus)
9. [Pistes d'amelioration](#pistes-damelioration)

## Vue d'ensemble

Le depot est organise par theme/statistique:

- `Classification/` (script principal `p02.m`)
- `ANOVA/` (script principal `p03.m`)
- `PCA/` (script principal `p04.m`)
- `Clustering/` (script principal `p05.m`)

Chaque dossier contient:

- un script principal (`p0x.m`)
- des fonctions utilitaires associees
- un fichier de donnees `.mat` charge directement par le script

## Structure du depot

```text
Analyse-de-donn-e_Matlab/
|- Classification/
|  |- p02.m
|  |- p02crosstab.m
|  |- p02PlotConfusionMatrix.m
|  |- p02PlotInputSpacePartition.m
|  |- p02Plotcrosstab.m
|  |- telcoChurn.mat
|- ANOVA/
|  |- p03.m
|  |- p03showMeansModel.m
|  |- autos.mat
|- PCA/
|  |- p04.m
|  |- p04ScreePlot.m
|  |- forex.mat
|- Clustering/
|  |- p05.m
|  |- customers.mat
```

## Prerequis

- MATLAB (version recente recommandee)
- Toolboxes utilises par les scripts:
  - Statistics and Machine Learning Toolbox
  - Deep Learning Toolbox (pour `plotconfusion` dans la partie classification)

Remarques:

- Les scripts chargent les fichiers `.mat` avec des chemins relatifs (ex: `load('telcoChurn.mat')`).
- Il faut executer chaque script depuis son dossier, ou ajouter le dossier correspondant au path MATLAB.

## Execution rapide

Depuis MATLAB:

```matlab
cd('.../Analyse-de-donn-e_Matlab/Classification'); p02
cd('.../Analyse-de-donn-e_Matlab/ANOVA'); p03
cd('.../Analyse-de-donn-e_Matlab/PCA'); p04
cd('.../Analyse-de-donn-e_Matlab/Clustering'); p05
```

Option robuste depuis la racine (sans changer manuellement de dossier):

```matlab
root = 'C:\Users\trist\Documents\EPF\Analyse-de-donn-e_Matlab';

cd(fullfile(root,'Classification')); p02
cd(fullfile(root,'ANOVA'));          p03
cd(fullfile(root,'PCA'));            p04
cd(fullfile(root,'Clustering'));     p05
```

## Description des modules

### 1) Classification (`Classification/p02.m`)

Objectif:

- Predire `Churn` (Yes/No) sur un dataset telco.

Pipeline:

1. Chargement de `telcoChurn.mat` (`td` table).
2. Split train/test 70/30 via `cvpartition`.
3. Analyse exploratoire (tableaux croises + boxplots + nuage tenure/monthly charges).
4. Arbre de classification complet (`fitctree`) puis elagage (`prune`, niveau fixe `29`).
5. Evaluation train/test via matrices de confusion.
6. Modeles LDA et QDA (`fitcdiscr`) sur `tenure` et `MonthlyCharges`.
7. Visualisation des frontieres de decision.

Fonctions utilitaires:

- `p02Plotcrosstab.m`
- `p02crosstab.m`
- `p02PlotInputSpacePartition.m`
- `p02PlotConfusionMatrix.m`

### 2) ANOVA (`ANOVA/p03.m`)

Objectif:

- Etudier l'effet de variables categorielles sur le prix de vehicules.

Pipeline:

1. Chargement de `autos.mat`.
2. Analyse exploratoire (summary, plotmatrix, boxplots).
3. Suppression d'outliers (regles percentiles + mois invalides).
4. ANOVA 1 facteur (`anova1`) sur `vehicleType` puis `monthOfRegistration`.
5. ANOVA 2 facteurs sans interaction puis avec interaction (`anovan`).
6. ANOVA 3 facteurs (modele `full`).
7. Regression lineaire (`fitlm`) puis ANOVA sur residus.
8. Modeles lineaires generalises via formules `fitlm`.

Fonction utilitaire:

- `p03showMeansModel.m` (affichage des moyennes/coefs du modele de moyennes).

### 3) PCA (`PCA/p04.m`)

Objectif:

- Realiser une PCA sur des series forex et interpreter les composantes.

Pipeline:

1. Chargement de `forex.mat`.
2. Conversion temporelle en `datetime`.
3. Filtrage des observations sur 2019-2020.
4. PCA via `pca(X)` (loadings, scores, variance expliquee).
5. Scree plot (`p04ScreePlot.m`).
6. Analyse des loadings et projection des scores (2D).
7. Reconstruction des variables avec les 2 premieres composantes.
8. Biplot 2D/3D.

Fonction utilitaire:

- `p04ScreePlot.m`

### 4) Clustering (`Clustering/p05.m`)

Objectif:

- Segmenter des comportements clients a partir de transactions.

Pipeline:

1. Chargement de `customers.mat`.
2. Analyse exploratoire des montants/nombres de transactions.
3. Clustering hierarchique des variables (`linkage` + `dendrogram`, distance correlation).
4. K-means 2D (montants 2013/2014), `K=3`, 100 replicats.
5. Selection de `K` par courbe d'erreur de quantification (QE).
6. K-means multi-variables + visualisation des centrodes/profils.

## Jeux de donnees

- `Classification/telcoChurn.mat`
- `ANOVA/autos.mat`
- `PCA/forex.mat`
- `Clustering/customers.mat`

Convention commune:

- chaque fichier charge une variable table nommee `td`.

## Reproductibilite

Certaines parties fixent explicitement l'aleatoire:

- `Classification/p02.m` utilise `rng('default')` avant le split train/test.
- `Clustering/p05.m` utilise `rng('default')` avant `kmeans`.

Cela facilite la comparaison des resultats d'une execution a l'autre.

## Problemes connus

1. Incoherence de nom de fonction dans la classification:
   - fichier: `p02PlotConfusionMatrix.m`
   - fonction declaree: `p02PlotConfussionMatrix(...)`
   - si MATLAB signale une erreur de nom de fonction/fichier, aligner les deux noms.
2. Dependance a `plotconfusion`:
   - cette fonction n'est pas disponible sans toolbox adequat.
3. Chemins relatifs:
   - les `load('xxx.mat')` supposent un repertoire courant correct.

## Pistes d'amelioration

1. Remplacer `eval` dans les fonctions de crosstab par un acces dynamique de champs (`td.(varName)`).
2. Centraliser les chemins de donnees pour executer tous les scripts depuis la racine.
3. Ajouter une fonction `main.m` qui orchestre les 4 TP.
4. Ajouter des tests unitaires pour les fonctions utilitaires de trace.
5. Homogeneiser la langue et les conventions de nommage.
