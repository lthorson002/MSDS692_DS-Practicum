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

![](media/65277fa89d7464a7908ba0767343e845.png)

**GOAL EXPECTATIONS**

The purpose of this effort is to leverage R to create code that read heartbeat
.wav files from a directory, preprocessing and filtering them, and then
leveraging machine learning packages and tools to train and test an efficient
classifier. Performance assessments will be calculated using the “CrossTable”
function from the R “gmodel” package (see sample output below). It is the
opinion of this scientist, that the highest risk to the patient with a
doctor-office-based heart beat assessment would be a mis-classifying a murmur
heartbeat as a normal heartbeat. Therefore, the goal would be to “Minimize
Murmur False Negatives” for the column highlighted below.

![](media/5f4a03025adc518b10274955866fbcf9.png)

Figure 1: Sample Output of gmodel - CrossTable Function

Previous work on this challenge attempted to leverage Continuous Wavelet
Transforms (CWT) to isolate and extract the S1 and S2 features. Then the region
around the S1 peak was sampled, analyzed, and compared with the results shown in
Figure 2.

![](media/4793edc163329ec8f59bd03016da638a.png)

Figure 2: CWT Extraction of S1 and S2 Features

My analysis will, rather, focus on indices and envelopes related to the
biological domain utilizing R packages that read in .wav files and provide
simple indices ('acoustic_diversity' and 'bioacoustic_index') based on standard
biodiversity indices (i.e. Shannon diversity index). These functions reflect
roughly how 'diverse' the acoustic energy is distributed across the recorded
frequency spectrum. While these functions do not identify patterns, it is the
opinion of the author that they can be successfully leveraged to identify normal
vs. murmur heart sound differences.

**BACKGROUND**

**Human Heart Beat Characteristics**

To properly process the data, several characteristics of human heart beats and
heart sounds were required. Per the Mayo Clinic website, the normal heart rate
for resting adults is 60 – 100 beats per minutes (approximately 1-2 Hz) and each
beat contains a S1 (first “lub-dub”) and S1 (second “lub-dub”) heart sound. Any
additional heart sounds between S1 and S2 typically represent a “heart murmur”
as described in the table below.

Table 1: Heartbeat Sound Descriptions

| **Heartbeat Category** | **Description**                                                                                                                                                                  |
|------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Normal                 | Normal, healthy heart sounds” that have “a clear ‘lub dub, lub dub’ pattern”                                                                                                     |
| Murmur                 | “Sounds as though there is a ‘whooshing, roaring, rumbling or turbulent fluid’ noise in one of two temporal locations: 1) between ‘lub’ and ‘dub’, or 2) between ‘dub’ and ‘lub’ |

**Domain Features and Measurement**

Several different descriptive measurements have been evaluated to allow
effective characterization and classification of the individual heart sound
recordings. Many different websites related to the original dataset suggested
determining the timing of the S1 and S2 signals and evaluating the signal
between. Several of the assessment options from previous work are included in
Table 2.

Table 2: Heart beat Assessment Variables

| **Domain**     | **Techniques**                                                                           |
|----------------|------------------------------------------------------------------------------------------|
| Time           | Energy Envelopes; Zero-Crossings; Min/Max Properties; Derivatives (Area Under the Curve) |
| Frequency      | Fast Fourier Transforms (FFT); Power Densities                                           |
| Time-Frequency | Short Time Fourier Transforms (STFT), Wavelet Transforms (WT)                            |

**Biological Domain Considerations**

In addition to leveraging the techniques described in the previous section,
there are several open source acoustic and/or biological sound packages
available in R including “tuneR” to read in .wav files, and “Seewave”, and
“soundecology” to processes the information. These packages contain functions
that generate indices for predefined sections of a signal or the signal as a
whole. Originally, many of these R packages were created to categories bird
songs, but can certainly be modified to decipher heart sounds, as well. After
review and analysis of the available indices the following were leveraged in
this study:

R “soundecology” package

>   \-Acoustic Complexity Index (ACI) – Signal intensity variability

>   \-Normalized Difference Soundscape (NDSI) – Segregates Biological sounds vs
>   Anthropogenic (Man-made) noise

>   \-Bioacoustic Index – Area under the curve for frequencies within a defined
>   decibel (dB) range

>   \-Acoustic Diversity Index (ADI) – Ratio of the signals beyond a defined
>   threshold, falling to specified spectrum bins

>   \-Acoustic Evenness Index (AEI) – Signal Evenness leveraging the “Gini
>   Index” for bins in spectrogram

R “Seewave” package

>   \-Count of Zero Crossings in the waveform

>   \-Acoustic Index based on the median of the amplitude envelope

>   \-Total Entropy of a time wave

>   \-Frequency Spectrum

>   \-Shannon Spectral Entropy (noisy signal \~ 1; pure tone signal \~ 0)

>   \-Spectrum Statistical Properties (meanfreq; sd; median; Q25; Q75; IQR;
>   skew; kurtosis; sp.ent; sfm; mode; centroid)

>   \-Frequency Amplitude peaks

>   \-Fundamental Frequency parameters (meanfun; minfun; maxfun)

>   \-Dominant Frequency parameters (meandom; mindom; maxdom; dfrange; duration)

>   \-Modulation Index

**ANALYSIS**

**File Processing and Data Analysis**

The code for the .wav file processing is “Read and Process wav Directory”
located at the GitHub url: https://github.com/lthorson002/MSDS692_DS-Practicum,
which processes the heart beat recordings as follows:

>   A. The .wav files in the defined working directory were translated using the
>   “readwave” function from the “tuneR” package and truncated to 20 seconds in
>   length.

>   B. A bandpass filter between 75-1500 Hz was applied to the signal as most of
>   the interesting bio-signals fall within this range. Then the data was
>   normalized to allow for comparative assessments of signals gathered overtime
>   to mitigate any intermittent noise factors. The figures below illustrate the
>   preprocessing results.

![](media/1fdbdf61ceb39ba036722ee2fbdd2590.png)

Figure 3: Preprocessing of Normal Heartbeat

![](media/8d745c5419c01accaf6d915de86b8779.png)

Figure 4: Preprocessing of Murmur Heartbeat

>   C. Three user-defined R functions were created to loop through the directory
>   containing the .wav files and ultimately create a dataframe with columns for
>   the parameters described in the previous Section 2.3. These functions
>   included: *SpectrumAnalyzehb:* reads, processes and filters .wav file;
>   *beat:* applies the previous function to a specific directory;
>   *processFolder:* creates and fills the dataframe as data is gathered during
>   the looping.

>   D. The “hbeat” dataframe which resulted from the “Read and Process wav
>   Directory” R code was run against the normal/murmur labels using R’s ggplot2
>   boxplot and facet_wrap function. Below are the resulting boxplots for each
>   of the above parameters for the cleaner, less noisy Dataset A and the
>   noisier Dataset B, segregated by heartbeat type. A review of the results
>   highlights the ones with the least distribution overlap, which enhances
>   machine learning opportunities: frequency mean; standard deviation; median,
>   skewness; kurtosis; spectral flatness centroid; acoustic complexity; zero
>   crossings; acoustic diversity; acoustic evenness.

![](media/91683491d3c1227eef28628fb21a8b59.png)

Figure 5: Boxplot Result for Data Set A (Less Noisy)

![](media/8bb940ef67a49c81ea82f5b746a89a22.png)

Figure 6: Boxplot Result for Data Set B (More Noisy)

**Machine Learning Classification Techniques**

The code for processing the R machine learning algorithms is the “Machine
Learning” file located at the above GitHub url. The classification models
leveraged during this evaluation included*: k-NN; Support Vector Machine; Random
Forest.*

**k-NN**

A. is a simple algorithm that stores all known cases and classifies any new
cases by how they match up with each of their k(count) of neighbors. In this
evaluation, the “knn” function is from the R package “class” with k=3, based on
manual evaluations. Training and test sets were created from the original
“hbeat” data at 65% and 35%, respectively.

B. Initial k-NN Classification results:

>   i. Data Set A: k-NN results: *13.6% Chance of Murmur False Neg*

![](media/da3f82270f09773659a00ba96a98dd0f.png)

>   ii. Data Set B: k-NN results: *15.7% Chance of Murmur False Neg*

![](media/efbd4496b6086fa719cbcf280774318e.png)

C. R “caret” packaging, k-NN with training optimization (repeats=3,
method="repeatedcv", tunelength=15):

>   i. Data Set A: k-NN results: *18.8% of Murmur False Negative*

![](media/e80a2071e43ad8cbdec851585465be45.png)

>   ii. Data Set B: k-NN results: *15.7% of Murmur False Negative*

![](media/b27678a47229a32301d8339690381974.png)

**SVM**

A. Initial SVM Classification results (guess: cost=1000 gamma=0.0001):

>   i. Data Set A: SVM results: *13.6% Chance of Murmur False Neg*

![](media/c7098a0085252e36e8f7f669a246d05d.png)

>   ii. Data Set B: SVM results: *6.7% Chance of Murmur False Neg*

![](media/698ec4097e7ecc628bc5018ee5a094a4.png)

B. Round 2: After R “caret” package, SVM with training optimization (cost=10,
gamma=0.1)

>   i. Data Set A: SVM results: *9.0% of Murmur False Negative*

![](media/f16e316897fbed77498f01c9d2ababbc.png)

>   ii. Data Set B: SVM results: *7.8% of Murmur False Negative*

![](media/d3a1666422cfd0ec8a1ae2e22d474007.png)

C. Round 3 After R “caret” package, SVM with training optimization and *some
manual fine tuning*

>   i. Data Set A: SVM results: *9.1% of Murmur False Negative*

1.  (cost=100, gamma=0.001)

![](media/48906ac4e7c5555f1d70e19192875b58.png)

>   ii. Data Set B: SVM results: *4.5% Chance of Murmur False Neg*

1.  (cost = .005, gamma = 1000)

![](media/755501fad7d807d21846c01e08dedfe2.png)

**Random Forest**

A. Initial randomForest Classification results;

>   i. Data Set A: randomForest results: *9.1% Chance of Murmur False Neg*

![](media/e34cdc3782332e316abd9dcc7f3c027b.png)

>   ii. Data Set B: randomForest results: *9.0% Chance of Murmur False Neg*

![](media/6aebce22e1e59398c1a21cf5f9cdc545.png)

>   iii. Data Set A: randomForest results: *13.6% Chance of Murmur False Neg*

Optimized with Repeat =2

![](media/af3d879fbd3dbe795cc05f15668174da.png)

>   iv. Data Set B: randomForest results: *7.9% Chance of Murmur False Neg*

Optimized with Repeat =3

![](media/57eb646d8a6faaaf9457278e5a7030b4.png)

**SUMMARY**

The Read and Process code worked as advertised. The Machine Learning software
also worked as expected and in most cases, caret optimization provided either
equal or better results. If this algorithm was used in a doctor’s office to
classify heartbeats, there would be a 4.5% chance that a heart murmur would be
incorrectly classified as normal.

**REFERENCES**

Bentley, P., Nordehn, G., Coimbra, M., & Mannor, S. (2011, Nov). “*Classifying
Heart Sounds Challenge”*. Retrieved from: peterjbentley:
http://www.peterjbentley.com/heartchallenge/

Edward R. Laskowski, M. (2015, Aug 22). “*What's a normal resting heart rate?”*
Mayo Clinic: Retrieved from:
http://www.mayoclinic.org/healthy-lifestyle/fitness/expertanswers/heart-rate/faq-20

King, E. (2017, October). “*Heartbeat Sounds: Classifying heartbeat anomalies
from stethoscope audio”*. Retrieved from: Kaggle, Inc:
https://www.kaggle.com/kinguistics/heartbeat-sound057979

Oppel, S. (2017, February 07). “*New R package: 'soundecology'”*. Retrieved from
wildlabs.net: htt Texas Heart Institute. (2016, July). *Heart Murmurs*. Heart
Information Center: Retrieved from:
http://www.texasheart.org/HIC/Topics/Cond/murmur.cfm

H.-l. Wang, W. Yang, W.-d. Zhang, and Y. Jun, “*Feature extraction of acoustic
signal based on wavelet analysis*.” In ICESSSYMPOSIA ’08: Proceedings of the
2008 International Conference on Embedded Software and Systems Symposia.
Washington, DC, USA: IEEE Computer Society, 2008

Cran.R Project. “*An Introduction to the soundecology Package*,” Retrieved from:
https://cran.rproject.org/web/packages/soundecology/vignettes/intro.html

M. Kuhn. (2016). “*The caret Package [Online]”.* Retrieved from:
http://topepo.github.io/caret/train-models-by-tag.html\#support-vectormachines

R. Besrour, Z. Lachiri and N. Ellouze, "*ECG Beat Classifier Using Support
Vector Machine," 2008 3rd International Conference on Information and
Communication Technologies*”: From Theory to Applications, Damascus, 2008, pp.
1-5. doi: 10.1109/ICTTA.2008.4530053. Available:
http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=4530053&is
number=4529902

Kern, Ashley, (2017, August 8), “*KaggleHeartbeatClassification*”, GitHub,
Retrieved from:
https://github.com/ankern/KaggleHeartbeatClassification/blob/master/featureExtraction.R

Sueur, Jerome, (2016, October 6), “*Seewave: A very short introduction to sound
analysis for those who like elephant trumpet calls or other wildlife sound*”,
Retrieved from
https://cran.r-project.org/web/packages/seewave/vignettes/seewave_analysis.pdf

Singh, Mandeep and Amandeep Cheema, International Journal of Computer
Applications (0975 – 8887), Volume 77– No.4, September 2013, 13, “*Heart Sounds
Classification using Feature Extraction of Phonocardiography Signal”,* Retrieved
from:
https://www.researchgate.net/publication/260549211_Heart_Sounds_Classification_using_Feature_Extraction_of_Phonocardiography_Signal

Araya-Salas, Marcelo (2016, August), “*R code for the analysis of animal
acoustic signals*”, Bioacoustics in R, Retrieved from:
https://marce10.github.io/

Liu et al. “*An open access database for the evaluation of heart sound
algorithms*”, Physiol Meas. 2016 Nov 21;37(12):2181-2213
https://www.ncbi.nlm.nih.gov/pubmed/27869105

Physionet.org, (2016, November), “*Classification of Normal/Abnormal Heart Sound
Recordings: the PhysioNet/Computing in Cardiology Challenge 2016*”, Retrieved
from: https://physionet.org/challenge/2016/\#challenge-data

Cran.R Project. (2015, October), “*Package ‘randomForest*”, Retrieved from:
https://cran.r-project.org/web/packages/randomForest/randomForest.pdf

Chopp, N., I. Cummings, H. Sweidan, and A. Kern, (2016, August), “*Classifying
Heartbeat Anomalies*”, Retrieved from:
https://github.com/ankern/KaggleHeartbeatClassification/blob/master/FinalPaper_HeartClass.pdf

3M Littmann® Stethoscopes, (2017) , “*50 Heart and Lung Sounds Library*”,
Retrieved from:
http://solutions.3mae.ae/wps/portal/3M/en_AE/3M-Littmann-EMEA/stethoscope/littmann-learning-institute/heart-lung-sounds/heart-lung-sound-library/

Becker, Kory, (2016, June), “*Identifying the Gender of a Voice using Machine
Learning*”, Primary Objects, Retrieved from:
http://www.primaryobjects.com/2016/06/22/identifying-the-gender-of-a-voice-using-machine-learning/

Rubin, Jonathan, Rui Abreu, Anurag Ganguli, Saigopal Nelaturi, Ion Matei, and
Kumar Sricharan, (2017). “*Recognizing Abnormal Heart Sounds Using Deep
Learning*”, Philips Research North America,and PARC, A Xerox Company, Retrieved
from: https://arxiv.org/pdf/1707.04642.pdf,

Gari D Clifford, CY Liu, Benjamin Moody, David Springer, Ikaro Silva, Qiao Li,
and Roger G

Mark. (2016), “*Classification of normal/abnormal heart sound recordings: the
physionet/computing in cardiology challenge*”, Computing in Cardiology, pages
609–12,2016, Retrieved from: http://lcp.mit.edu/pdf/CliffordCinC2016.pdf
