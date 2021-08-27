


cigar_vector <- function(s){
h = c("D", "M", "S")
n = as.character(0:9)

nchar.s = nchar(s)

v = c()

count = ""
for(b in 1:nchar.s){
  b.s = substr(s,b,b)
  if(b.s %in% n){
    count = paste(count,b.s, sep="")
    #print(count)
  }else{
    v = c(v,rep(b.s, as.integer(count)))
    count = ""
  }
  
}

return(v)

}





cigar_matches <- function(xdf, r){
s.1 = as.character(xdf$CIGAR.1[r])
s.2 = as.character(xdf$CIGAR.2[r])

s.1.v = cigar_vector(s.1)
s.2.v = cigar_vector(s.2)

if(length(s.1.v) == length(s.1.v)){
  
  matches = unlist(lapply(1:length(s.1.v), function(x){paste(s.1.v[x],s.2.v[x],sep = "")}))
  
  table.matches = as.data.frame(table(matches))
  table.matches.full = table.matches
  table.matches = table.matches$Freq
  names(table.matches)=table.matches.full[,1]
}else{
  table.matches = NULL
}
return(table.matches)
}


table.match.percentage <- function(table.matches){
  #print(table.matches)
  if(!is.null(table.matches)){
  sum.df = sum(table.matches)
  sum.ms = table.matches['MS'] + table.matches['SM']
  
  return(sum.ms/sum.df)
  }else{
    return(NA)
  }
}

