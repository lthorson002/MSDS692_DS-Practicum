# MSDS692_DS-Practicum
Heart Sound Classification through Machine Learning
**Laurene Thorson**

Regis University

Denver, CO 80221

lthorson002\@regis.edu

**Heart Sound Classification through Machine Learning**

**ABSTRACT**

Characterized datasets for “Heartbeat Sounds” are available on Kaggle. The sets
consist of recorded audio files that were collected via an iPhone app and
approximately 70% were labeled as “normal”, “murmur”, “extra heart sounds”, and
“artifact”. The focus of this study was to focus on the “normal” and “murmur”
file sets to create a machine learning classification model that would allow for
a quick assessment of a patient’s heart sounds, while in the doctor’s office.
Performing the code work in R, several functions were authored to loop through
the directory containing the recordings, efficiently reading the “.wav” files,
preprocessing the resulting signal, and ultimately extracting the acoustic
signals and indices. Finally, training and test sets were built and evaluated
using three machine learning techniques: K-nearest neighbors (KNN), Support
Machine Vector (SVM), and Random Forest. Evaluation of the models resulted in
the best classification results with SVM and caret optimization .

**KEYWORDS**

Heartbeat, Sounds, Murmur, Machine Learning, k-Nearest Neighbors, SVM,
RandomForest, Classification

**INTRODUCTION**

When a normal heart is listened to with a stethoscope, heart sounds are heard in
pairs and are a constant "lub-dub, lub-dub." The first “lub-dub" is the mitral
and the tricuspid valves closing, while the second represents the aortic and
pulmonary values closing immediately after. Additional sounds heard between
these two sounds is typically referred to as a murmur. Murmurs can occur when
blood is forced to flow through a narrowed valve (called stenosis), or when it
leaks back through a defective valve (called regurgitation). These valve
problems may be present at birth (congenital) or develop later in life because
of rheumatic fever, coronary artery disease, infective endocarditis, or aging).
Murmurs can be “innocent” are require no treatment or lifestyle modifications,
but they can also be congenital, such as a hole in the heart, or develop later
in life due to rheumatic fever, coronary artery disease, infective endocarditis,
or aging. Medicines are often prescribed by doctors to minimize the consequences
of heart murmurs, so it is important that the condition be found and properly
identified. The iPhone app technology allows for a quick assessment within the
doctor office environment.

**DATASET**

The heartbeat dataset used in this evaluation was originally published on
“peterjbentley.com” and was later hosted on the Kaggle website. Segregated into
two datasets, the “A” set represents heart sound .wav audio files (31 normal, 34
murmur) that were collected from a general population using an iPhone microphone
and associated app. Dataset B (202 normal, 66 murmur) was gathered during a
clinical trial using a digital stethoscope and a similar app. The original
datasets included other classifications, but this study only evaluated the
“normal” and “murmur” categories. In both cases, the data was very noisy and
required filtering due to issues like 60Hz electrical noise, stethoscope
movement noise, and other external noise inputs.

![](media/65277fa89d7464a7908ba0767343e845.png?raw=true)

**GOAL EXPECTATIONS**

The purpose of this effort is to leverage R to create code that read heartbeat
.wav files from a directory, preprocessing and filtering them, and then
leveraging machine learning packages and tools to train and test an efficient
classifier. Performance assessments will be calculated using the “CrossTable”
function from the R “gmodel” package (see sample output below). It is the
opinion of this scientist, that the highest risk to the patient with a
doctor-office-based heart beat assessment would be a mis-classifying a murmur
heartbeat as a normal heartbeat. Therefore, the goal would be to “Minimize
Murmur False Negatives” for the column highlighted below
