# R code for Reading Heart Sound Wave (.wav) Files Stored in a Directory...

# Working Directory: Heartbeat files - normal in "Normal" subdir & murmur in "Murmur" subdir
# Working Directory example: D:/HeartBeatSounds/HB Data

setwd("D:/HeartBeatSounds/HB Data B")

#...Call Packages 
library(tuneR)
library(seewave)
library(warbleR)
library(soundecology)
library(plyr)
library(ggplot2)

#..#SpecAnalyze Function - Process Sound (.wav) files

#...Spectrum Analyzer Function (from WarbleR) - Process Sound (.wav) files
SpecAnalyzehb <- function(X, bp = c(0,22), wl = 2048, threshold = 5, parallel = 1){
  if(class(X) == "data.frame") {if(all(c("sound.files", "selec", 
                                         "start", "end") %in% colnames(X))) 
  {
    
    start <- as.numeric(unlist(X$start))
    end <- as.numeric(unlist(X$end))
    sound.files <- as.character(unlist(X$sound.files))
    selec <- as.character(unlist(X$selec))
  } else stop(paste(paste(c("sound.files", "selec", "start", "end")[!(c("sound.files", "selec", 
                                                                        "start", "end") %in% colnames(X))], collapse=", "), "column(s) not found in data frame"))
  } else  stop("X is not a data frame")
  
  #if there are NAs in start or end stop
  if(any(is.na(c(end, start)))) stop("NAs found in start and/or end")  
  
  #if end or start are not numeric stop
  if(all(class(end) != "numeric" & class(start) != "numeric")) stop("'end' and 'selec' must be numeric")
  
   #return warning if not all sound files were found
  fs <- list.files(path = getwd(), pattern = ".wav$", ignore.case = TRUE)
  if(length(unique(sound.files[(sound.files %in% fs)])) != length(unique(sound.files))) 
    cat(paste(length(unique(sound.files))-length(unique(sound.files[(sound.files %in% fs)])), 
              ".wav file(s) not found"))
  
  #count number of sound files in working directory and if 0 stop
  d <- which(sound.files %in% fs) 
  if(length(d) == 0){
    stop("The .wav files are not in the working directory")
  }  else {
    start <- start[d]
    end <- end[d]
    selec <- selec[d]
    sound.files <- sound.files[d]
  }
  
  # If parallel is not numeric
  if(!is.numeric(parallel)) stop("'parallel' must be a numeric vector of length 1") 
  if(any(!(parallel %% 1 == 0),parallel < 1)) stop("'parallel' should be a positive integer")
  
  # If parallel was called
  if(parallel > 1)
  { options(warn = -1)
    if(all(Sys.info()[1] == "Windows",requireNamespace("parallelsugar", quietly = TRUE) == TRUE)) 
      lapp <- function(X, FUN) parallelsugar::mclapply(X, FUN, mc.cores = parallel) else
        if(Sys.info()[1] == "Windows"){ 
          cat("Windows users need to install the 'parallelsugar' package for parallel computing (you are not doing it now!)")
          lapp <- pbapply::pblapply} else lapp <- function(X, FUN) parallel::mclapply(X, FUN, mc.cores = parallel)} else lapp <- pbapply::pblapply
  
  options(warn = 0)
  
  if(parallel == 1) cat("Measuring acoustic parameters:")
  x <- as.data.frame(lapp(1:length(start), function(i) { 
    
    #read 20sec of .wav file
    r <- tuneR::readWave(file.path(getwd(), sound.files[i]), from = start[i], to = 20, units = "seconds") 
    
    #195 Hz lowpass noise filter
    r <- bwfilter(r, 22050, n = 3, from = 195, bandpass = TRUE, listen = FALSE, output = "Wave")
    
    b <- bp #in case bp its higher than can be due to sampling rate
    if(b[2] > ceiling(r@samp.rate/2000) - 1) b[2] <- ceiling(r@samp.rate/2000) - 1 
    
    #normalize all files to 1
    r <- normalize(r, unit = c("1"), center = TRUE, level = 1)
    
    #working with mono singal - left
    leftTS <- ts(data = r@left)  
    
    #plot normalized waveform
    plot.ts(leftTS, ylim = c(-1.0, 1.0))
    
#Waveform Characterization - Soundecology Package
    
    ##Calculate the Normalized Difference Soundscape Index (NDSI)
    #sound_indx <- ndsi(r, fft_w = 512, anthro_min = 0, anthro_max = 198, bio_min = 200, bio_max = 1800)
    
    ##Calculate the Bioacoustic Index
    bio_ind <- bioacoustic_index(r, min_freq = 0, max_freq = 2000, fft_w = 512)
    bio_ind_L <- (bio_ind$left_area)
    
    #Calculate the Acoustic Diversity Index (ADI)
    #ad_result <- acoustic_diversity(r, max_freq = 2000)
    ad_result <- acoustic_diversity(r, max_freq = 2000, db_threshold = -50, freq_step = 10, shannon = TRUE)
    ad_result_L <- (ad_result$adi_left)
    
    
    ##Calcualte the Acoustic Evenness Index (AEI)
    ae_result <- acoustic_evenness(r)
    ae_result_L <- (ae_result$aei_left)
    
#Waveform Characterization - Seewave Package
    
    #spec100 <- soundscapespec(r, plot=TRUE)
    #sound_indx <- seewave::NDSI(spec100, biophony = 1:2)
    
    
    ##count the number of zero crossings in the waveform 
    zX <- zcr(r, wl=NULL)
    
    ##compute an acoustic index based on the median of the amplitude envelope
    m <- M(r)
    
    ##Estimate the total entropy of a time wave
    H <- H(r)
    
    ##Compute first a short-term Fourier transform and then the Acoustic Complexity Index (ACI) index
    ACI <- ACI(r)
    
    #Perform frequency spectrum analysis
    songspec <- seewave::spec(r, f = r@samp.rate, plot = TRUE)
    
    ## Compute Shannon spectral entropy: noisy signal -> 1; pure tone signal -> 0
    sh <- sh(songspec)    
    
    ##Determine the statistical properties of a frequency spectrum
    analysis <- seewave::specprop(songspec, f = r@samp.rate, plot = FALSE)
    
    #save specprop analysis parameters with variable ids
    meanfreq <- analysis$mean/1000
    sd <- analysis$sd/1000
    median <- analysis$median/1000
    Q25 <- analysis$Q25/1000
    Q75 <- analysis$Q75/1000
    IQR <- analysis$IQR/1000
    skew <- analysis$skewness
    kurt <- analysis$kurtosis
    sp.ent <- analysis$sh
    sfm <- analysis$sfm
    mode <- analysis$mode/1000
    centroid <- analysis$cent/1000
    
    ##Determine Frequency with amplitude peaks 
    peakf <- seewave::fpeaks(songspec, f = r@samp.rate, wl = wl, nmax = 2, plot = TRUE)[1, 1]
    
    ##Determine Fundamental frequency parameters
    ff <- seewave::fund(r, f = r@samp.rate, ovlp = 50, threshold = threshold, 
                        fmax = 280, ylim=c(0, 280/1000), plot = FALSE, wl = wl)[, 2]
    meanfun<-mean(ff, na.rm = T)
    minfun<-min(ff, na.rm = T)
    maxfun<-max(ff, na.rm = T)
    
#Determine Dominant frequency parameters
    y <- seewave::dfreq(r, f = r@samp.rate, wl = wl, ylim=c(0, 280/1000), ovlp = 0, plot = F, threshold = threshold, 
                        bandpass = b * 1000, fftw = TRUE)[, 2]
    meandom <- mean(y, na.rm = TRUE)
    mindom <- min(y, na.rm = TRUE)
    maxdom <- max(y, na.rm = TRUE)
    dfrange <- (maxdom - mindom)
    duration <- (end[i] - start[i])
    
    
#Calculate Modulation Index
    changes <- vector()
    for(j in which(!is.na(y))){
      change <- abs(y[j] - y[j + 1])
      changes <- append(changes, change)
    }
    if(mindom==maxdom) modindx<-0 else modindx <- mean(changes, na.rm = T)/dfrange
    
    #Frequency with amplitude peaks
    peakf <- seewave::fpeaks(songspec, f = r@samp.rate, wl = wl, nmax = 3, plot = FALSE)[1, 1]
    
#Dominant frecuency parameters
    y <- seewave::dfreq(r, f = r@samp.rate, wl = wl, ylim=c(0, 280/1000), ovlp = 0, plot = F, threshold = threshold, 
                        bandpass = b * 1000, fftw = TRUE)[, 2]
    meandom <- mean(y, na.rm = TRUE)
    mindom <- min(y, na.rm = TRUE)
    maxdom <- max(y, na.rm = TRUE)
    dfrange <- (maxdom - mindom)
    duration <- (end[i] - start[i])
    
    
#modulation index calculation
    changes <- vector()
    for(j in which(!is.na(y))){
      change <- abs(y[j] - y[j + 1])
      changes <- append(changes, change)
    }
    if(mindom==maxdom) modindx<-0 else modindx <- mean(changes, na.rm = T)/dfrange
    
    #save results
    return(c(duration, meanfreq, sd, median, Q25, Q75, IQR, skew, kurt, sp.ent, sfm, mode, 
             centroid, peakf, meanfun, minfun, maxfun, meandom, mindom, maxdom, dfrange, modindx, m, H,ACI, zX, sh, bio_ind_L, ad_result_L, ae_result_L))
  }))
  
  #Organize above results
  rownames(x) <- c("duration", "meanfreq", "sd", "median", "Q25", "Q75", "IQR", "skew", "kurt", "sp.ent", "sfm","mode", "centroid", "peakf", "meanfun", "minfun", "maxfun", "meandom", "mindom", "maxdom", "dfrange", "modindx", "m", "H", "ACI", "zX", "sh", "bio_ind_L", "ad_result_L", "ae_result_L")
  x <- data.frame(sound.files, selec, as.data.frame(t(x)))
  colnames(x)[1:2] <- c("sound.files", "selec")
  rownames(x) <- c(1:nrow(x))
  
  return(x)
}


#...beat Function - Create dataframe with Normal and Murmur Heartbeats Identified

beat <- function(filePath) {
  if (!exists('beatBoosted')) {
    load('model.bin')
  }
  
  # Setup paths.
  currentPath <- getwd()
  fileName <- basename("D:/HeartBeatSounds/HB Data B")
  path <- dirname("D:/HeartBeatSounds/HB Data B")
  
  # Set directory to read file.
  setwd(path)
  
  # Start with empty data.frame.
  data <- data.frame(fileName, 0, 0, 20)
  
  # Set column names.
  names(data) <- c('sound.files', 'selec', 'start', 'end')
  
  # Process files.
  acoustics <- SpecAnalyzehb(data, parallel=1)
  
  # Restore path.
  setwd(currentPath)
  
  predict(beatCombo, newdata=acoustics)
}


#...ProcessFolder Function - Run Specan on Data Folder to Process .wav files

processFolder <- function(folderName) {
  # Start with empty data.frame.
  data <- data.frame()
  
  # Get list of files in the folder.
  list <- list.files(folderName, '\\.wav')
  
  # Add file list to data.frame for processing.
  for (fileName in list) {
    row <- data.frame(fileName, 0, 0, 20)
    data <- rbind(data, row)
  }
  
  # Set column names.
  names(data) <- c('sound.files', 'selec', 'start', 'end')
  
  # Move into folder for processing.
  setwd(folderName)
  
  # Process files.
  acoustics <- SpecAnalyzehb(data, parallel=1)
  
  # Move back into parent folder.
  setwd('..')
  
  acoustics
}

#...Load data using the 3 Functions (SpecAnalyzehb, beat, processFolder )

normal<- processFolder('D:/HeartBeatSounds/HB Data B/Normal')
murmur <- processFolder('D:/HeartBeatSounds/HB Data B/Murmur')

# Set labels.
normal$label <- 1
murmur$label <- 2

hbeat <-rbind.fill(normal, murmur)

hbeat$label2 <- factor(hbeat$label, labels=c('normal', 'murmur'))

# Remove rows containing NA's.
hbeat <- hbeat[complete.cases(hbeat),]


library(reshape2)
hbeat2 <- hbeat[,-(1:3)]
hbeat2 <- hbeat2[,-30]
hbeat3 <- melt(hbeat2)

ggplot(data = melt(hbeat2), aes(x=variable, y=value)) + geom_boxplot(aes(fill=variable))

ggplot(hbeat3) +
  geom_boxplot(aes(x=variable,y=value,fill=label2))+
  facet_wrap(~variable, scales="free")
