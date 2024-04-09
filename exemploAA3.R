library(dplyr)
library(ggplot2)

geraConjunto <- function(n){
  return(sort(sample(x=1:(3*n),n,FALSE)))
}

geraT <- function(n){
  return(sample(x=(4*n):(5*n),1,FALSE))
}

exactSubsetSum <- function(S,n,t){
  L <- c(0)
  for(i in 1:n){
    L <- unique(c(L,(L+S[i])))
    L <- L[L<=t]
  }
  return(max(L))
}

#PLACEHOLDER
trim <- function(L,e){
  return(L[sample(1:length(L),length(L)/2,FALSE)])
}

aproxSubsetSum <- function(S,n,t,e){
  L <- c(0)
  for(i in 1:n){
    L <- unique(c(L,(L+S[i])))
    L <- trim(L,e/(2*n))
    L <- L[L<=t]
  }
  return(max(L))
}


experimento <- function(){
  exact <- c()
  aprox <- c()
  e <- 0.4
  for(i in seq(50,2500,50)){
  S <- geraConjunto(i)
  t <- geraT(i)
  start <- Sys.time()
  exactSubsetSum(S,i,t)
  end <- Sys.time()
  exact <- c(exact,(end-start))
  start <- Sys.time()
  aproxSubsetSum(S,i,t,e)
  end <- Sys.time()
  aprox <- c(aprox,(end-start))
}
  return(c(exact,aprox))
}

Tempo <- experimento()
Tamanho <- seq(50,2500,50)
Tamanho <- c(Tamanho, Tamanho)
Algoritmo <- c(rep("Exato",length(Tempo)/2),rep("Aproximado",length(Tempo)/2))
exactPlot <- data.frame(Tamanho, Tempo, Algoritmo)

ggplot(exactPlot, aes(x=Tamanho,y=Tempo))+
  geom_line(aes(color=Algoritmo))
  #geom_point(aes(color=algoritmo))
