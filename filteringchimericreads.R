#!/usr/bin/env Rscript

rm(list=ls())

library("optparse")

option_list = list(
  make_option(c("-f", "--file"), 
              type="character", 
              default=NULL, 
              help="dataset file name", 
              metavar="character"),
  make_option(c("-o", "--out"), 
              type="character", 
              default="out.txt", 
              help="output file name [default= %default]", 
              metavar="character"),
  make_option(c("-s", "--strand"), 
              type="character", 
              default="Main", 
              help="Strand (Main or RC) [default= %default]", 
              metavar="character"),
  make_option(c("-q", "--qcmin"), 
              type="numeric", 
              default=20, 
              help="Minimum Quality Threshold", 
              metavar="numeric")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

print(opt)

qc_th = opt$qcmin

print(paste("The quality threshold is",qc_th))

if(opt$strand == "Main"){
  flag_filter = 0
  print("We will remove any RC aligned reads")
}else{
  flag_filter = 32
  print("We will seek reads that are RC in both arms")
}

newfile = 0
outputfile = opt$out

filepath = opt$file

#filepath = "collected_results/AMT4_7_trimmed_pear.fq.assembled.fastq_bwa_transcriptome.sorted.rmdups.chimera-raw.csv"
chimera.cols = c("Read.ID",
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
                 "Orientation")

count = 0

  con = file(filepath, "r")
  while ( TRUE ) {
    line = readLines(con, n = 1)
    count = count + 1
    
    if(count %% 20000 == 0){
      print(paste(count, "reads processed"))
    }
    
    if ( length(line) == 0 ) {
      break
    }else{
      linev = unlist(strsplit(line, split="\t"))
      names(linev)=chimera.cols
      qc_min = min(as.numeric(linev["Quality.1"]),
                   as.numeric(linev["Quality.2"]))
      flag_score = as.numeric(linev["Flag.1"]) + as.numeric(linev["Flag.2"])
      
      if(qc_min >= qc_th & flag_score == flag_filter){
        if(newfile == 0){
          print("File to be written")
          cat(line, file = outputfile, append = FALSE, sep = "\n")
          newfile = 1
        }else{
          cat(line, file = outputfile, append = TRUE, sep = "\n")
        }
        
      }
    }
    
  }
  
  close(con)
