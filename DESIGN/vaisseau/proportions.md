# Proportions — vaisseau

Proposition de dimensionnement, à valider avant passation vers `dev`. Toutes les valeurs sont
exprimées en unités relatives à la longueur totale de la coque `L = 1.0`.

## Coque

| Élément | Valeur | Repère |
|---|---|---|
| Longueur totale (L) | 1.0 | référence |
| Diamètre max du fuselage | 0.22 L | à 0.35 L depuis l'avant |
| Diamètre à l'avant (nez) | 0.06 L | 0 L |
| Diamètre à l'arrière | 0.14 L | 1.0 L |
| Profil | fuselage effilé, section circulaire à ovale | avant fin, arrière renflé (moteurs) |

## Coupole — observatoire

| Élément | Valeur | Repère |
|---|---|---|
| Diamètre | 0.30 L | — |
| Position (centre) | 0.55 L depuis l'avant | côté ventral (nadir) du fuselage |
| Hauteur du sommet en dessous de l'axe du fuselage | 0.30 L | — |
| Forme | demi-sphère tronquée | base ovale suivant la courbure du fuselage |

### Armature de la coupole
- 12 montants verticaux (radiaux), espacés de 30°.
- 3 cerclages horizontaux : base, mi-hauteur (0.15 L en dessous de l'axe du fuselage), sommet.
- Montants et cerclages : section pleine, opaques (aucun verre modélisé côté intérieur — cf. D3).
- Depuis l'intérieur, la coque et les structures externes doivent rester visibles entre les
  montants (contrainte roadmap D2) : espacement de 30° jugé suffisant, à confirmer visuellement
  en D3.

## Cockpit

| Élément | Valeur | Repère |
|---|---|---|
| Longueur | 0.15 L | 0 L à 0.15 L (section avant) |
| Largeur max | 0.12 L | — |
| Orientation | vers l'avant uniquement | aucune ouverture latérale ou arrière vers la coque |

Le cockpit est une section fermée à l'avant du fuselage, sans ligne de vue vers le reste de la
coque : conforme à la contrainte « le vaisseau n'est pas visible depuis le cockpit ».

## Structures externes

| Élément | Valeur | Repère |
|---|---|---|
| Panneaux solaires (x2) | longueur 0.40 L, largeur 0.15 L | de part et d'autre du fuselage, à 0.45 L |
| Antennes (x2) | hauteur 0.10 L | arrière du fuselage, 0.90 L |
| Nacelles moteur (x2) | diamètre 0.08 L, longueur 0.12 L | arrière, 0.85 L à 1.0 L |

## Statut
Validé par l'utilisateur le 2026-07-31, sans modification. Les planches (`vue_face.svg`,
`vue_cote.svg`, `vue_dessus.svg`) illustrent ce chiffrage sous forme de schémas techniques cotés.
Correction du 2026-08-11 : § Coupole — observatoire resynchronisé sur le repositionnement ventral
(nadir) de la coupole/observatoire, déjà appliqué côté `dev` le 2026-08-04
(`DEV/roadmap_dev.md`, Phase 4).
