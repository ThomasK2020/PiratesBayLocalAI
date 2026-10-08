# Statement of Work (SOW) — Seagull Flock Patrol & Motion Design

Composant : Moteur WebGL, Animation AI Boids & Interface Utilisateur (UI Header)
Objet : Volée de Mouettes Marines Survolant le Radeau de Sauvetage
Répertoire Cible : ./StatementOfWork/SOW_SEAGULL_FLOCK.md

---

## 📋 Spécifications Fonctionnelles (SF)

### SF-01 : Modélisation 3D & Animation de Vol (`sd_seagull`)
- Forme Signed Distance Field (SDF) de mouette marine (corps fuselé + ailes arquées en V).
- Animation de battement d'ailes dynamique (fréquence ~10 Hz) synchronisée sur `u_time` et alternée avec des phases de vol plané.
- Couleur plumage blanc/gris clair avec ombrage solaire naturel et bout des ailes sombre.

### SF-02 : Vol en Formation / Flocking au-dessus du Radeau
- Le groupe de mouettes gravite au-dessus du radeau (altitude Y = 4.5m à 9.0m, rayon R = 3.0m à 8.0m).
- Algorithme de comportement Boids (Cohésion, Séparation, Alignement) qui suit les déplacements du radeau.
- Anti-collision entre oiseaux (distance minimale de 1.8m).

### SF-03 : Interface Utilisateur (Header UI)
- **Sélecteur Nombre (`$BirdNb`) :** Menu déroulant (`<select id="bird-nb">`) avec les options `4`, `8` ou `12` mouettes (Défaut : `8`).
- **Bouton Toggle Action (`<button id="btn-bird-toggle">`) :** Bouton `[🕊️ Mouettes : ON / OFF]` dans le bandeau supérieur.

### SF-04 : Motion Design d'Arrivée & Dispersion
- **Transition ON (Arrivée) :** Les mouettes arrivent depuis le ciel/les falaises et descendent se mettre en formation au-dessus du radeau.
- **Transition OFF (Dispersion) :** Les mouettes prennent de l'altitude et se dispersent vers les nuages jusqu'à disparition.

---

## 🛠️ Spécifications Techniques (ST)

### ST-A : Shader Fragment WebGL (`pirates_bay_caribbean.html`)
- Accepter un tableau d'uniformes `uniform vec3 u_birds[12];` et `uniform float u_bird_yaws[12];`.
- Calculer le rendu SDF `sd_seagull` et intégrer l'éclairage spéculaire du soleil sur le plumage.

### ST-B : Moteur de Flocking JS (`render()` loop)
- Classe `SeagullAgent` gérant la position (X, Y, Z), le cap, l'altitude, la vitesse et l'état de battement d'ailes.
- Mettre à jour les positions Boids et transmettre `u_birds` à WebGL à chaque frame.

---

## 🧪 Validation & Tests (`pytest`)
- Créer le test `./workspace/test_seagull_flock.py`.
- Vérifier la présence des éléments UI `#bird-nb`, `#btn-bird-toggle`, de la fonction `sd_seagull` et de la boucle Boids dans le code.
- Valider avec `pytest` dans le conteneur `pirates-bay-sandbox`.
