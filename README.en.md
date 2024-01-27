# Biometric Analysis of Middle Oxfordian Perisphinctidae

This project aims to classify ammonites belonging to the Perisphinctidae family from the Middle Oxfordian in order to obtain cohesive groups of ammonites.

The motivation behind this project is to classify my own collection of Perisphinctidae from Poitou. Due to difficulties in identifying these ammonites, I decided to measure various characteristics and let algorithms classify them based on these features.

Will this classification align with taxonomy? It remains a mystery for now…

<p align="center">
<img src="https://github.com/nebetbastet/midOxfPeri/assets/6839261/43b107cb-1c89-4393-8019-4608a90e3e69" width="150"/>
</p>

## Method
### Photography of Ammonites
To take measurements of my ammonites, I photograph them in two ways: from the front and from the side, each time with a scale. For the side photo, I position myself "perpendicularly" to the last whorl (see the eye position in the image below).
![image](https://github.com/nebetbastet/midOxfPeri/assets/6839261/613d0d4a-aeb2-4269-b317-dbd7c5cd6da4)

In practice, for each ammonite I want to measure, I obtain an image like this:

<img src="https://github.com/nebetbastet/midOxfPeri/assets/6839261/77500f4e-d198-40d7-9295-72075a4f5041" height="250"/>
<img src="https://github.com/nebetbastet/midOxfPeri/assets/6839261/14cde844-e8cb-4bb1-974b-3bbd995e8ab6" height="250"/>


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

### Ratio Computing
These measurements allowed me to calculate new ratios, most of which are found in scientific literature:
+ **UWI** = uw/dm : Umbilical Width Index = Measures the ratio between umbilical diameter and shell diameter, providing a measure of involution (more involution indicates more overlap of whorls)
+ **WWI** = ww/wh : Whorl width index = measures the ratio between the width and height of a whorl, indicating whether a shell is thin or thick (level of compression).
+ **Shape** = ww/dm : Shape = represents the width of the shell relative to its diameter. It is another measure of shell compression.
+ **WER** =  (dm/(dm-wh))^2 : Whorl expansion rate = represents the rate at which the shell diameter increases per revolution.
+ **WHI** = wh/dm : Whorl height index = represents the ratio of the height of the last whorl to the diameter of the entire shell. It is another way to calculate the rate at which the shell diameter increases per revolution.
+ **o** = e/dm : ornamentation, rib density.

### Analysis method
I selected only certain variables for my analysis:
+ dm
+ WWI
+ WER
+ UWI
+ Shape
+ WHI
+ o

Except for diameter (dm), all these variables are ratios. I performed Principal Component Analysis (PCA) on these variables and clustering on the first dimensions of PCA (I chose the number of axes that allowed me to capture at least 80% of the variance).

### Results
I am still at the early stages of the analysis, and I prefer not to disclose my results yet.

🔴 You can help advance this project:
+ by sending photographs of your well-identified Middle Oxfordian Perisphinctidae (as detailed in the "Photography of Ammonites" paragraph) with their names.
+ by helping in the identification of my own ammonites.

If you want to help or just learn more, feel free to contact me at nebetbastet[at]hotmail.com.

### Online Application
If the project progresses successfully (i.e., if biometric measurements allow accurate identification of the taxon), I will try to create an online application so that everyone can identify their Perisphinctidae based on biometric measurements.
