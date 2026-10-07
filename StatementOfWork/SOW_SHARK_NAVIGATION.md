# Statement of Work (SOW) — Interactive Shark Patrol & Motion Design

Composant : Moteur WebGL, Navigation AI & Interface Utilisateur (UI Header)
Objet : Patrouille d'Ailerons de Requins Réalistes avec Contrôles UI & Motion Design d'Arrivée/Départ
Répertoire Cible : ./StatementOfWork/SOW_SHARK_NAVIGATION.md

---

## 📋 Spécifications Fonctionnelles (SF)

### SF-01 : Modélisation 3D & Rendu Réaliste de l'Aileron
- Forme Signed Distance Field (SDF) d'aileron dorsal profilé (bord d'attaque galbé, bord de fuite effilé et entaille postérieure).
- Matériau mat sombre (gris ardoise marin `#2c3539`) avec reflet spéculaire mouillé.
- Sillage d'écume blanche généré à la base de l'aileron en mouvement.
- Ondulation latérale de nage synchronisée sur le temps `u_time`.

### SF-02 : Zone d'Exclusion Stricte & Patrouille
- Zone d'exclusion absolue de rayon R_min = 3.5m autour du centre du radeau (`u_ship_pos`).
- Les ailerons se maintiennent dans la couronne de patrouille (3.5m à 8.5m).
- Poursuite fluide (Steering Behavior) qui suit le radeau sans jamais le toucher ni croiser sa trajectoire.
- Anti-collision inter-requins (distance minimale de 2.5m).

### SF-03 : Interface Utilisateur (Header UI)
- **Sélecteur Nombre (`$SharkNb`) :** Menu déroulant (`<select id="shark-nb">`) avec les options `1`, `3` ou `5` requins (Défaut : `3`).
- **Bouton Toggle Action (`<button id="btn-shark-toggle">`) :** Bouton `[🦈 Requins : ON / OFF]` dans le bandeau supérieur.

### SF-04 : Motion Design d'Arrivée & Départ (Transitions Fluides)
- **Transition ON (Arrivée du large) :**
  Lors du clic sur **ON**, les `$SharkNb` requins apparaissent au large ($R \approx 25\text{m}$) et nagent progressivement vers le radeau jusqu'à entrer en zone de patrouille ($R \in [3.5\text{m}, 8.5\text{m}]$).
- **Transition OFF (Départ vers le large) :**
  Lors du clic sur **OFF**, les requins font demi-tour et s'éloignent progressivement vers le large ($R > 25\text{m}$) jusqu'à disparaître sous l'horizon d'affichage.

---

## 🛠️ Spécifications Techniques (ST)

### ST-A : Shader Fragment WebGL (`pirates_bay_caribbean.html`)
- Accepter un tableau d'uniformes `uniform vec3 u_sharks[5];` et `uniform float u_shark_yaws[5];`.
- Gérer la hauteur d'immersion progressive des ailerons lors de l'éloignement au large.
- Calculer le rendu de l'aileron `sd_shark_fin` et de l'écume associée.

### ST-B : Machine à États & Navigation JS (`render()` loop)
- Gérer les états individuels des requins : `OFFSCREEN`, `APPROACHING`, `PATROLLING`, `DEPARTING`.
- Adapter le nombre d'agents actifs dynamiquement selon la sélection `$SharkNb` (1, 3 ou 5).
- Mettre à jour les positions et transmettre `u_sharks` à WebGL à chaque frame.

---

## 🧪 Validation & Tests (`pytest`)
- Créer le test `./workspace/test_shark_navigation.py`.
- Vérifier la présence des éléments UI `#shark-nb`, `#btn-shark-toggle`, de la fonction `sd_shark_fin` et du rayon d'exclusion R_min = 3.5m dans le code.
- Valider avec `pytest` dans le conteneur `pirates-bay-sandbox`.
