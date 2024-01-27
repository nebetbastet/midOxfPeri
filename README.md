# Analyse de données biométriques de Perisphinctidae de l'Oxfordien Moyen

Ce projet a pour objectif de classer des ammonites de la famille des Perisphinctidae, de l’Oxfordien Moyen, afin d’obtenir des groupes d’ammonites cohérents.

La motivation derrière ce projet est de pouvoir classer ma propre collection de Perisphinctidae du Poitou. En raison des difficultés que je rencontre dans l'identification de ces ammonites, j’ai décidé de mesurer plusieurs caractères et de laisser les algorithmes les classer pour moi, sur la base de ces caractères.

Est-ce que cette classification correspondra à la taxonomie ? Mystère pour l’instant… 

<p align="center">
<img src="https://private-user-images.githubusercontent.com/6839261/300179184-f6a6aca8-c697-4c62-b028-4816182c9ad8.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjA3MzcsIm5iZiI6MTcwNjM2MDQzNywicGF0aCI6Ii82ODM5MjYxLzMwMDE3OTE4NC1mNmE2YWNhOC1jNjk3LTRjNjItYjAyOC00ODE2MTgyYzlhZDgucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMwMDM3WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9MzliOGU5ZGIzYzU5NDg4M2FlYmYzYjc5Njk0ZjFkMGU0MzEwMzJiNTFiMzIxNWEwNzg2OGYyMTI0NjM0ODY2MSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.wixKmvV5UvsP9mVzgDbCetIslcUHctdbGGlMT5uTINA" width="150"/>
</p>

## Méthode
### Etape 1 : photographie des ammonites
Pour pouvoir prendre des mesures sur mes ammonites, je les photographie de deux façon : de face et sur le côté, à chaque fois avec une échelle.
Pour la photo sur le côté, je me situe "perpendiculairement" à la dernière spire (cf. la position de l'oeil sur l'image ci-dessous)
![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/613d0d4a-aeb2-4269-b317-dbd7c5cd6da4)

Concrètement, pour chacune des ammonites que je souhaite mesures, j'obtiens ce genre d'image :

<img src="https://private-user-images.githubusercontent.com/6839261/300180447-004ce86d-58cd-4145-b924-bfdac3b2632a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjIyMjYsIm5iZiI6MTcwNjM2MTkyNiwicGF0aCI6Ii82ODM5MjYxLzMwMDE4MDQ0Ny0wMDRjZTg2ZC01OGNkLTQxNDUtYjkyNC1iZmRhYzNiMjYzMmEucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMyNTI2WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NDUxZmIwNjliN2RkMzlhZTJkZTVjNzE3NDA2YjMxNTQ2YzVmNzFmMDM4ODY0NTkwZWM2NWIxNmM3ZTZmOTEzNCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.TUBkyTrInkQhO2nW-dHOJssBZQbtwmsQCCofVFB2UbM" height="250"/> <img src="https://private-user-images.githubusercontent.com/6839261/300180526-3e8f11e3-348b-4214-a8d4-51b061440960.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjIyMjYsIm5iZiI6MTcwNjM2MTkyNiwicGF0aCI6Ii82ODM5MjYxLzMwMDE4MDUyNi0zZThmMTFlMy0zNDhiLTQyMTQtYThkNC01MWIwNjE0NDA5NjAucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMyNTI2WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YjIzNWQ3MjEwMzcyNmNhYTcxZjg4ZGFlZGM1MTBlM2Y4YzgwZmYzOWVlZDVlYzQxMTM2YzgxMzA0OGU0NzA1YiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.QoHbuquopJQyr7LaAr0eBVJ-kqLkgK5HqKcMOTmuzjI" height="250"/>

### Etape 2 : mesures
J'utilise le logiciel [imageJ](https://imagej.net/ij/) pour réaliser mes mesures.

Les mesures que j'ai réalisées sont pour la plupart très classiques et on peut les trouver dans de nombreuses publications scientifiques : diamètre total, hauteur de la spire, épaisseur de la spire, diamètre de l'ombilic.

J'ai rajouté une mesure inédite : l'écart entre les côtes (au niveau de la dernière spire) afin de prendre en compte la densité de la costulation.
![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/5b7373e7-f30d-4ce0-b35d-1e09f858102d)



### Etape 3 : calcul de ratios
### Etape 4 : analyse
