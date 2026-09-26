# Statement of Work (SOW) — Dynamic Wave & Buoy Floating Physics Fix

Composant : Moteur Physique & Rendu WebGL / Hydrodynamique Objet Flottant
Objet : Correction de l'intersection Vague/Bouée (Infiltration d'eau dans la cavité intérieure)

---

## 1. Diagnostic Technique & Cause Racine (Root Cause Analysis)

L'artefact d'eau traversant l'intérieur du radeau/bouée provient de 3 limitations dans le shader et la physique actuelle :

1. **Absence de Masque de Cavité (Hull Cavity Masking) :**
   Le champ de hauteur de l'océan (`sea_height` / `map_sea`) est évalué sur un plan continu sans vérifier l'empreinte géométrique intérieure du radeau (`dFloor`). Lorsque la crête d'une vague passe au centre du radeau (`waveY > raftY`), le maillage/marching de la mer passe à travers le plancher.

2. **Attitude de Flottaison Statique (Zero Pitch / Roll) :**
   Le radeau reste rigidement horizontal (`u_ship_rot = vec3(yaw, 0.0, 0.0)`). Il ne s'incline pas le long du gradient de la houle incidente, laissant la vague submerger le boudin au lieu de le soulever.

3. **Absence de Refoulement d'Eau (CSG Displacement) :**
   Aucune soustraction volumétrique n'est appliquée entre la géométrie de la vague et le volume étanche de la bouée.

---

## 2. Spécifications Fonctionnelles (SF)

* **SF-01 : Étanchéité de la Cavité Intérieure**
  La surface de l'océan ne doit sous aucun prétexte traverser ou apparaître au-dessus du plancher du radeau.

* **SF-02 : Réponse Dynamique à la Houle (Tangage & Roulis)**
  La bouée doit adapter son attitude spatiale (angles de Pitch et Roll) en fonction du vecteur pente de la vague locale au point central et sur le périmètre des boudins.

* **SF-03 : Refoulement Visuel & Écume d'Étrave**
  La vague arrivant contre le boudin extérieur doit être défléchie (atténuation progressive de la hauteur à l'intérieur de l'enceinte de la bouée).

---

## 3. Spécifications Techniques & Algorithmiques (ST)

### A. Algorithme Physico-Mathématique de Flottaison (JavaScript / CPU)
Dans la boucle d'animation (`requestAnimationFrame`) :

1. **Échantillonnage du Gradient de Vague (Pente) :**
   Échantillonner la hauteur de vague en 4 points autour du centre de la bouée $(X_0, Z_0)$ avec un décalage $\delta = 0.8\text{m}$ (rayon du boudin) :
   $$\text{dz} = \frac{H(X_0, Z_0 + \delta) - H(X_0, Z_0 - \delta)}{2\delta}$$
   $$\text{dx} = \frac{H(X_0 + \delta, Z_0) - H(X_0 - \delta, Z_0)}{2\delta}$$

2. **Calcul des Angles de Tangage (`pitch`) et Roulis (`roll`) :**
   $$\text{pitch} = \arctan(-\text{dz}), \quad \text{roll} = \arctan(\text{dx})$$

3. **Transmission aux Uniformes WebGL :**
   Injecter le vecteur d'orientation complet via `gl.uniform3f(uShipRot, raftYaw, pitch, roll)`.

### B. Masquage Hydrodynamique dans le Fragment Shader (WebGL 2.0 / GPU)
Dans le shader de rendu (`map_sea` / Raymarching) :

1. **Définition de l'Espace Local Radeau :**
   Transformer les coordonnées du rayon dans le repère local de la bouée :
   $$q = R_{\text{yaw, pitch, roll}} \cdot (P - \text{u\_ship\_pos})$$

2. **Application d'un Masque de Cavité d'Évitement (`inside_hull_mask`) :**
   Calculer la distance 2D relative au plancher intérieur :
   $$\text{inside\_hull} = \text{smoothstep}(1.0, 0.4, \text{length}(\max(|q.xz| - (0.8, 1.2), 0.0)))$$

3. **Atténuation / Enfoncement de la Vague sous le Plancher :**
   Appliquer une opération CSG (Constructive Solid Geometry) ou forcer la hauteur de l'eau $y_{\text{eau}}$ à rester sous le plancher $y_{\text{plancher}}$ dans la zone `inside_hull` :
   $$y_{\text{eau\_effectif}} = \text{mix}(y_{\text{eau\_globale}}, \min(y_{\text{eau\_globale}}, y_{\text{plancher}} - 0.1), \text{inside\_hull})$$

---

## 4. Plan de Validation & Recette

1. **Test unitaire automatisé (`pytest` dans `./workspace/test_buoy_physics.py`) :**
   * Vérification de l'injection des 3 angles de rotation (`u_ship_rot`) dans les uniformes WebGL.
   * Vérification de la présence du masque de cavité dans la fonction shader.

2. **Test visuel dans la sandbox / navigateur :**
   * Réglage de la mer sur "Tempête" (`roughness = 2.0`).
   * Observation à 360° : la bouée doit monter/s'incliner sur les vagues géantes sans qu'aucune goutte d'eau ne soit visible à l'intérieur du plancher.
