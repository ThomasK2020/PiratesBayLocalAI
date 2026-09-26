# Statement of Work (SOW) — Red & Yellow Striped Marine Buoy Shading

**Composant :** Fragment Shader WebGL 2.0 / Système de Matériaux Raymarching (`pirates_bay_caribbean.html`)  
**Objet :** Remplacement de la couleur orange unie du flotteur pneumatique par un motif bicolore alterné Rouge vif et Jaune signalétique (style bouée de sauvetage maritime haute visibilité).  
**Version Cible :** v3.60  

---

## 1. Contexte & Objectif

Dans la version actuelle (v3.50), le flotteur extérieur du radeau/bouée (`raftMat == 1`) utilise un matériau uniforme orange pastel (`vec3(1.0, 0.40, 0.08)`).  
L'objectif de cette évolution est de lui conférer une identité visuelle marine emblématique de secours en mer, en appliquant un **motif à rayures radiales alternées Rouge et Jaune** le long du boudin toroïdal, avec des transitions propres, anti-aliasées et réactives à l'éclairage dynamique du soleil et de l'océan.

---

## 2. Spécifications Fonctionnelles (SF)

* **SF-01 : Motif Bicolore à Rayures Radiales**  
  Le flotteur périphérique doit être segmenté en une alternance régulière de secteurs **Rouge Sauveteur** et **Jaune Signalisation**.
* **SF-02 : Transitions Nettes & Anti-aliasées**  
  La frontière entre les rayures rouges et jaunes doit être franche sans effet d'escalier ni crénelage (aliasing) lors des rotations et déplacements du radeau.
* **SF-03 : Conservation des Propriétés de Surface Photoréalistes**  
  Le nouveau motif doit conserver :
  - La réaction à la lumière directe du soleil (`diff`) et aux reflets spéculaires intenses de polymère marin ciré (`spec`).
  - L'effet de mouillage foncé à la ligne de flottaison (`wetLevel`).
  - L'ambiance lumineuse du ciel et les rebonds de couleur de l'eau turquoise (`seaBounce`).
* **SF-04 : Préservation des Éléments Annexes**  
  Le plancher composite anthracite (`raftMat == 2`), les bandes rétroréfléchissantes SOLAS (`raftMat == 3`), la balise stroboscopique (`raftMat == 4`) et les cordages (`raftMat == 5`) doivent demeurer parfaitement distincts et inchangés.

---

## 3. Spécifications Techniques & Algorithmiques (ST)

Dans `pirates_bay_caribbean.html`, au niveau du bloc de rendu du matériau du flotteur (`if (raftMat == 1)` dans le Fragment Shader) :

### A. Coordonnées Polaires Locales & Fréquence Périodique
Les coordonnées locales $q = (q_x, q_y, q_z)$ correspondent au repère centré du radeau :
1. Calcul de l'angle azimutal $\theta$ le long du boudin :
   $$\theta = \operatorname{atan}(q.z, q.x)$$
2. Génération de 8 secteurs alternés (4 rayures rouges, 4 rayures jaunes) via une fonction sinusoïdale de période $4$ :
   $$\text{pattern} = \sin(\theta \times 4.0)$$

### B. Anti-Aliasing de la Frontière (Hermite Interpolation)
Application d'une transition lissée sur un intervalle étroit pour éliminer le scintillement à distance :
$$\text{mask} = \operatorname{smoothstep}(-0.05, 0.05, \text{pattern})$$

### C. Palette Colorimétrique Marine Normalisée
* **Rouge Sauveteur Marine :** `vec3(0.92, 0.12, 0.08)`
* **Jaune Signalisation Maritime :** `vec3(0.98, 0.82, 0.06)`

$$C_{\text{base}} = \operatorname{mix}(\text{vec3}(0.92, 0.12, 0.08), \text{vec3}(0.98, 0.82, 0.06), \text{mask})$$

### D. Intégration de l'Ombrage Complet
Remplacer la variable `orangePastel` par `colBuoy` :
```glsl
// Angle azimutal et motif périodique 8 bandes (4 rouges, 4 jaunes)
float theta = atan(q.z, q.x);
float stripeSignal = sin(theta * 4.0);
float stripeMask = smoothstep(-0.06, 0.06, stripeSignal);

vec3 buoyRed = vec3(0.92, 0.12, 0.08);
vec3 buoyYellow = vec3(0.98, 0.82, 0.06);
vec3 colBuoy = mix(buoyRed, buoyYellow, stripeMask);

// Texture subtile de nervures d'assemblage pneumatique
float segments = cos(theta * 8.0) * 0.03;
colBuoy += segments;

// Mouillage à la base du flotteur
float wetLevel = smoothstep(0.35, -0.1, q.y);
colBuoy = mix(colBuoy, colBuoy * 0.70, wetLevel * 0.5);

// Spécularité douce de polymère marin et intégration atmosphérique
float spec = pow(max(dot(ref, sunDir), 0.0), 28.0);
col = colBuoy * (diff * vec3(1.25, 1.15, 0.95) + skyAmb + seaBounce);
col += vec3(1.0, 0.92, 0.85) * spec * (0.25 + 0.35 * wetLevel) + rim * vec3(1.0, 0.6, 0.2) * 0.20;
```

---

## 4. Plan de Validation & Recette

1. **Test Automatisé (`pytest` dans `./workspace/test_buoy_stripes.py`) :**
   * Présence de `atan(q.z, q.x)` et de `smoothstep` pour l'anti-aliasing des rayures dans `pirates_bay_caribbean.html`.
   * Présence des composantes chromatiques rouge (`0.92, 0.12, 0.08`) et jaune (`0.98, 0.82, 0.06`).
   * Absence de syntaxe GLSL invalide (compilation sans erreur dans Chrome).
2. **Validation Visuelle Directe (Serveur Local :8888) :**
   * Ouverture de `http://localhost:8888/pirates_bay_caribbean.html`.
   * En faisant pivoter le radeau (touches `Q` / `D` ou boutons "↺ Rotation G" / "Rotation D ↻"), les rayures rouges et jaunes doivent tourner de façon solidaire avec la structure.
   * L'effet de brillance spéculaire du soleil doit balayer uniformément les deux couleurs.

---

## 5. Consignes d'Orchestration (Hermes Agent & OpenCode)

1. **OpenCode :** Créer le script de validation `test_buoy_stripes.py` dans `./workspace/` et appliquer le patch GLSL.
2. **Docker :** Exécuter `pytest /app/workspace/test_buoy_stripes.py` dans `pirates-bay-sandbox`.
3. **Hermes :** Vérifier le rechargement WebGL dans Chrome et notifier la fin des opérations.
