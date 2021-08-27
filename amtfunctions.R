library(tidyverse)
source("cigarparse.R")

M_to_S_vector <- function(chimeraTable){
  xdf = as.data.frame(chimeraTable)
  table.percent = c()
  for(i in 1:nrow(xdf)){
    
    table.percent[i] = table.match.percentage(cigar_matches(xdf = xdf,i))
    
    if(i %% 10000 == 0){
      print(i)
    }
    
  }
  
  xtibble = as.tibble(xdf)
  xtibble$M_S_score = table.percent
  return(xtibble)
}

importChimeraTable <- function(filepath, chimera.cols=c("Read.ID",
                                                       "Flag.1",
                                                       "Transcript.1",
                                                       "Start.1",
                                                       "End.1",
                                                       "Quality.1",
                                                       "CIGAR.1",
                                                       "Sequence.1",
                                                       "Flag.2",
                                                       "Transcript.2",
                                                       "Start.2",
                                                       "End.2",
                                                       "Quality.2",
                                                       "CIGAR.2",
                                                       "Sequence.2",
                                                       "Orientation")){
  inputdf = read.delim(filepath,header = F)
  
  colnames(inputdf)=chimera.cols
  
  outputtidy = as.tibble(inputdf)
  
  return(outputtidy)
  
  
}





getViennaEnergies <- function(inputtidy){
  
  input.file = as.data.frame(inputtidy)
  colnames(input.file)=chimera.cols
  RNAduplex = c()
  for(i in 1:nrow(input.file)){
    duplex = c(as.character(input.file$Sequence.1[i]),as.character(input.file$Sequence.2[i]))
    writeLines(text=duplex,con="duplex.txt")
    system("RNAduplex < duplex.txt > out.txt")
    RNAduplex[i] = readLines("out.txt")
    if(i %% 1000 == 0){
      print(i)
    }
  }
  
  outputtidy = inputtidy
  outputtidy$RNAduplex = RNAduplex
  
  energy = c()
  

  for(j in 1:length(RNAduplex)){
    x=unlist(strsplit(RNAduplex[j],split = " [(]"))[2]
    x=gsub(pattern = "[)]", replacement = "",x=x)
    energy[j] = as.numeric(x)
  }
  
  outputtidy$energy = energy
  
  return(outputtidy)
}