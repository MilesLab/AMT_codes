#!/usr/bin/env Rscript

rm(list=ls())

library("optparse")

option_list = list(
  make_option(c("-f", "--file"), 
              type="character", 
              default="input.txt", 
              help="dataset file name", 
              metavar="character"),
  make_option(c("-o", "--out"), 
              type="character", 
              default="sample.txt", 
              help="output file name [default= %default]", 
              metavar="character"),
  make_option(c("-s", "--sample"), 
              type="integer", 
              default=10000, 
              help="output file name [default= %default]", 
              metavar="character")
); 

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

fileName = as.character(opt$file)

#print(paste("We will sample", opt$sample, "reads from the input file", fileName))

con = file(fileName, "r")
lc = 0
while ( TRUE ) {
  line = readLines(con, n = 1)
  lc = lc + 1
  
  if ( length(line) == 0 ) {
    break
  }
  
}

close(con)

print(paste("We have a total of", lc, "reads"))

if(opt$sample < lc){
  
  print(paste("We will sample", opt$sample, "reads"))
  sample.list = sample.int(n = lc, size=opt$sample)
  
  
  con = file(fileName, "r")
  
  if(file.exists(opt$out) == FALSE){
    file.create(opt$out)
  }else{
    file.remove(opt$out)
    file.create(opt$out)
  }
  
  
  conW = file(opt$out, open = "a")
  
  r = 0
  while ( TRUE ) {
    line = readLines(con, n = 1)
    r = r + 1
    if(r %in% sample.list){
      writeLines(line, con=conW)
    }
    
    
    if ( length(line) == 0 ) {
      break
    }
    
  }
  
  close(con)
  close(conW)
  
}else{
  print("The number of reads to sample > total counts")
}

