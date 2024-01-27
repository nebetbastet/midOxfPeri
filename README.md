# Analyse de données biométriques de Perisphinctidae de l'Oxfordien Moyen

Ce projet a pour objectif de classer des ammonites de la famille des Perisphinctidae, de l’Oxfordien Moyen, afin d’obtenir des groupes d’ammonites cohérents.

La motivation derrière ce projet est de pouvoir classer ma propre collection de Perisphinctidae du Poitou. En raison des difficultés que je rencontre dans l'identification de ces ammonites, j’ai décidé de mesurer plusieurs caractères et de laisser les algorithmes les classer pour moi, sur la base de ces caractères.

Est-ce que cette classification correspondra à la taxonomie ? Mystère pour l’instant… 

<p align="center">
<img src="https://private-user-images.githubusercontent.com/6839261/300179184-f6a6aca8-c697-4c62-b028-4816182c9ad8.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjA3MzcsIm5iZiI6MTcwNjM2MDQzNywicGF0aCI6Ii82ODM5MjYxLzMwMDE3OTE4NC1mNmE2YWNhOC1jNjk3LTRjNjItYjAyOC00ODE2MTgyYzlhZDgucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMwMDM3WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9MzliOGU5ZGIzYzU5NDg4M2FlYmYzYjc5Njk0ZjFkMGU0MzEwMzJiNTFiMzIxNWEwNzg2OGYyMTI0NjM0ODY2MSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.wixKmvV5UvsP9mVzgDbCetIslcUHctdbGGlMT5uTINA" width="150"/>
</p>

## Méthode
### Photographie des ammonites
Pour pouvoir prendre des mesures sur mes ammonites, je les photographie de deux façon : de face et sur le côté, à chaque fois avec une échelle.
Pour la photo sur le côté, je me situe "perpendiculairement" à la dernière spire (cf. la position de l'oeil sur l'image ci-dessous)
![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/613d0d4a-aeb2-4269-b317-dbd7c5cd6da4)

Concrètement, pour chacune des ammonites que je souhaite mesures, j'obtiens ce genre d'image :

<img src="https://private-user-images.githubusercontent.com/6839261/300180447-004ce86d-58cd-4145-b924-bfdac3b2632a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjIyMjYsIm5iZiI6MTcwNjM2MTkyNiwicGF0aCI6Ii82ODM5MjYxLzMwMDE4MDQ0Ny0wMDRjZTg2ZC01OGNkLTQxNDUtYjkyNC1iZmRhYzNiMjYzMmEucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMyNTI2WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NDUxZmIwNjliN2RkMzlhZTJkZTVjNzE3NDA2YjMxNTQ2YzVmNzFmMDM4ODY0NTkwZWM2NWIxNmM3ZTZmOTEzNCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.TUBkyTrInkQhO2nW-dHOJssBZQbtwmsQCCofVFB2UbM" height="250"/> <img src="https://private-user-images.githubusercontent.com/6839261/300180526-3e8f11e3-348b-4214-a8d4-51b061440960.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjIyMjYsIm5iZiI6MTcwNjM2MTkyNiwicGF0aCI6Ii82ODM5MjYxLzMwMDE4MDUyNi0zZThmMTFlMy0zNDhiLTQyMTQtYThkNC01MWIwNjE0NDA5NjAucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMyNTI2WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YjIzNWQ3MjEwMzcyNmNhYTcxZjg4ZGFlZGM1MTBlM2Y4YzgwZmYzOWVlZDVlYzQxMTM2YzgxMzA0OGU0NzA1YiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.QoHbuquopJQyr7LaAr0eBVJ-kqLkgK5HqKcMOTmuzjI" height="250"/>

### Ammonites références
Afin d'avoir des points de références, j'ai récupéré dans la littérature ou sur certains sites (par ex. https://www.ammonites.org/) des photographies d'ammonites (toujours de face et de côté). En général, le diamètre est indiqué, ce qui me permet d'avoir une échelle.
Ainsi, dans mes analyses, j'aurai des ammonites pour lesquels j'aurai à la fois les données biométriques et la taxonomie, ce qui peut me permettre de faire le lien entre forme de la coquille et taxonomie.

🔴 **Si vous souhaitez m'aider dans ce projet et que vous avez des Perisphinctidae de l'Oxfordien Moyen bien identifiées, vous pouvez m'envoyer des photographies d'ammonites (telles que détaillées dans le paragraphe précédent) avec leur nom. Mon mail est nebetbastet[at]hotmail.com** 🔴


### Mesures
J'utilise le logiciel [imageJ](https://imagej.net/ij/) pour réaliser mes mesures.

Les mesures que j'ai réalisées sont pour la plupart très classiques et on peut les trouver dans de nombreuses publications scientifiques : 
+ diamètre total (**dm**)
+ hauteur de la spire (**wh**)
+ épaisseur de la spire (**ww**)
+ diamètre de l'ombilic (**uw**).

J'ai rajouté une mesure inédite : l'écart entre les côtes au niveau de la dernière spire (**e**) afin de prendre en compte la densité de la costulation.
![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/5b7373e7-f30d-4ce0-b35d-1e09f858102d)

### Calcul de ratios
Ces mesures m'ont permis de calculer de nouveaux ratios que l'on trouve pour la plupart dans la littérature scientifique :
+ **UWI** = uw/dm : Umbilical Width Index = Indice de Largeur Ombilical, représente le rapport entre le diamètre de l'ombilic et celui de la coquille, ce qui permet de mesurer le degré d'involution (plus une coquille est involute, plus les tours se recouvrent)
+ **WWI** = ww/wh : Whorl width index = Indice de Largeur de la Spire, mesure le ratio entre la largeur et la hauteur d'une spire. Cela permet de mesurer si une coquille est plutôt mince ou épaisse (niveau de compression).
+ **Shape** = ww/dm : Shape = Forme, représente ici la largeur de la coquille sur son diamètre. C'est une autre mesure du niveau de compression de la coquille.
+ **WER** =  (dm/(dm-wh))^2 : Whorl expansion rate = Taux d'expansion des spires, représente le taux auquel le diamètre de la coquille augmente par tour.
+ **WHI** = wh/dm : Whorl height index = Indice de Hauteur de la spire, represente le ratio de la hauteur de la dernière spire et le diamètre de la coquille entière. C'est une autre façon de calculer le taux auquel le diamètre de la coquille augmente par tour
+ **o**=e/dm : ornementation, densité de la costulation

### Méthode d'analyse
Je n'ai choisi que certaines variables pour réaliser mon analyse :
+ dm
+ WWI
+ WER
+ UWI
+ Shape
+ WHI
+ o

A part le diamètre (dm), toutes ces variables sont des ratios.
J'ai réalisé une ACP sur ces variables, et un clustering sur les premières dimensions de l'ACP (j'ai choisi le nombre d'axes me permettant d'avoir au moins 80% de la variance).
