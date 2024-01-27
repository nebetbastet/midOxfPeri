# Biometric Analysis of Middle Oxfordian Perisphinctidae

This project aims to classify ammonites belonging to the Perisphinctidae family from the Middle Oxfordian in order to obtain cohesive groups of ammonites.

The motivation behind this project is to classify my own collection of Perisphinctidae from Poitou. Due to difficulties in identifying these ammonites, I decided to measure various characteristics and let algorithms classify them based on these features.

Will this classification align with taxonomy? It remains a mystery for now…

<p align="center">
<img src="https://private-user-images.githubusercontent.com/6839261/300179184-f6a6aca8-c697-4c62-b028-4816182c9ad8.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjA3MzcsIm5iZiI6MTcwNjM2MDQzNywicGF0aCI6Ii82ODM5MjYxLzMwMDE3OTE4NC1mNmE2YWNhOC1jNjk3LTRjNjItYjAyOC00ODE2MTgyYzlhZDgucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMwMDM3WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9MzliOGU5ZGIzYzU5NDg4M2FlYmYzYjc5Njk0ZjFkMGU0MzEwMzJiNTFiMzIxNWEwNzg2OGYyMTI0NjM0ODY2MSZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.wixKmvV5UvsP9mVzgDbCetIslcUHctdbGGlMT5uTINA" width="150"/>
</p>

## Method
### Photography of Ammonites
To take measurements of my ammonites, I photograph them in two ways: from the front and from the side, each time with a scale. For the side photo, I position myself "perpendicularly" to the last whorl (see the eye position in the image below).
![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/613d0d4a-aeb2-4269-b317-dbd7c5cd6da4)

In practice, for each ammonite I want to measure, I obtain an image like this:

<img src="https://private-user-images.githubusercontent.com/6839261/300180447-004ce86d-58cd-4145-b924-bfdac3b2632a.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjIyMjYsIm5iZiI6MTcwNjM2MTkyNiwicGF0aCI6Ii82ODM5MjYxLzMwMDE4MDQ0Ny0wMDRjZTg2ZC01OGNkLTQxNDUtYjkyNC1iZmRhYzNiMjYzMmEucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMyNTI2WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9NDUxZmIwNjliN2RkMzlhZTJkZTVjNzE3NDA2YjMxNTQ2YzVmNzFmMDM4ODY0NTkwZWM2NWIxNmM3ZTZmOTEzNCZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.TUBkyTrInkQhO2nW-dHOJssBZQbtwmsQCCofVFB2UbM" height="250"/> <img src="https://private-user-images.githubusercontent.com/6839261/300180526-3e8f11e3-348b-4214-a8d4-51b061440960.png?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3MDYzNjIyMjYsIm5iZiI6MTcwNjM2MTkyNiwicGF0aCI6Ii82ODM5MjYxLzMwMDE4MDUyNi0zZThmMTFlMy0zNDhiLTQyMTQtYThkNC01MWIwNjE0NDA5NjAucG5nP1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQVZDT0RZTFNBNTNQUUs0WkElMkYyMDI0MDEyNyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyNDAxMjdUMTMyNTI2WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YjIzNWQ3MjEwMzcyNmNhYTcxZjg4ZGFlZGM1MTBlM2Y4YzgwZmYzOWVlZDVlYzQxMTM2YzgxMzA0OGU0NzA1YiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QmYWN0b3JfaWQ9MCZrZXlfaWQ9MCZyZXBvX2lkPTAifQ.QoHbuquopJQyr7LaAr0eBVJ-kqLkgK5HqKcMOTmuzjI" height="250"/>

### Reference Ammonites
To have reference points, I gathered photographs of ammonites from literature or certain websites (e.g., https://www.ammonites.org/), always from the front and side. Usually, the diameter is indicated, providing a scale for my analyses. Therefore, in my analyses, I will have ammonites for which I have both biometric data and taxonomy, allowing me to link shell shape and taxonomy.

🔴 **If you want to help in this project and have well-identified Middle Oxfordian Perisphinctidae, you can send me photographs of ammonites (as detailed in the previous paragraph) with their names. My email is nebetbastet[at]hotmail.com** 🔴


### Measurements
I use the software [imageJ](https://imagej.net/ij/)  to make my measurements.

The measurements I made are mostly standard and can be found in many scientific publications:
+ diameter (**dm**)
+ whorl height (**wh**)
+ whorl width (**ww**)
+ umbilical width (**uw**)

I added a novel measurement: the gap between the ribs at the last whorl (**e**) to account for rib density.

![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/5b7373e7-f30d-4ce0-b35d-1e09f858102d)

### Calcul de ratios
Ces mesures m'ont permis de calculer de nouveaux ratios que l'on trouve pour la plupart dans la littérature scientifique :
+ **UWI** = uw/dm : Umbilical Width Index = Indice de Largeur Ombilical, représente le rapport entre le diamètre de l'ombilic et celui de la coquille, ce qui permet de mesurer le degré d'involution (plus une coquille est involute, plus les tours se recouvrent)
+ **WWI** = ww/wh : Whorl width index = Indice de Largeur de la Spire, mesure le ratio entre la largeur et la hauteur d'une spire. Cela permet de mesurer si une coquille est plutôt mince ou épaisse (niveau de compression).
+ **Shape** = ww/dm : Shape = Forme, représente ici la largeur de la coquille sur son diamètre. C'est une autre mesure du niveau de compression de la coquille.
+ **WER** =  (dm/(dm-wh))^2 : Whorl expansion rate = Taux d'expansion des spires, représente le taux auquel le diamètre de la coquille augmente par tour.
+ **WHI** = wh/dm : Whorl height index = Indice de Hauteur de la spire, represente le ratio de la hauteur de la dernière spire et le diamètre de la coquille entière. C'est une autre façon de calculer le taux auquel le diamètre de la coquille augmente par tour
+ **o** = e/dm : ornementation, densité de la costulation

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

### Résultats 
Je suis encore au début de l'analyse, je ne préfère pas encore rendre publiques mes résultats.

🔴 Vous pouvez m'aider à avancer dans ce projet :
+ soit en m'envoyant des photographies de vos Perisphinctidae de l'Oxfordien Moyen bien identifiées (telles que détaillées dans le paragraphe "Photographie des ammonites") avec leur nom.
+ soit en m'aidant à identifier mes propres ammonites 

Si vous voulez aider ou juste en savoir plus, n'hésitez pas à me contacter à nebetbastet[at]hotmail.com

### Application en ligne
Si le project fonctionne bien (c'est-à-dire si les mesures biométriques permettent d'identifier le bon taxon), je tacherai de faire une application en ligne pour que chacun et chacune puisse identifier sa Perisphinctidae à partir de mesures biométriques.
