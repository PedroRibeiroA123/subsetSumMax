library(dplyr)
library(ggplot2)

geraConjunto <- function(n){
  return(sample(x=1:(3*n),n,FALSE))
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

trim <- function(L,e){
  m <- length(L)
  L2 <- c(L[1])
  last <- L[1]
  for(i in 2:m){
    if(L[i]>last*(1+e)){
      L2 <- c(L2,L[i])
      last <- L[i]
    }
  }
  return(L2)
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
  exactResul <- c()
  aproxResul <- c()
  e <- 0.4
  for(i in seq(50,2500,50)){
  S <- geraConjunto(i)
  t <- geraT(i)
  start <- Sys.time()
  exactResul <- c(exactResul,exactSubsetSum(S,i,t))
  end <- Sys.time()
  exact <- c(exact,(end-start))
  start <- Sys.time()
  aproxResul <- c(aproxResul,aproxSubsetSum(S,i,t,e))
  end <- Sys.time()
  aprox <- c(aprox,(end-start))
  }
  print(exactResul)
  print(aproxResul)
  erroRelativo <- 100*(exactResul-aproxResul)/exactResul
  return(c(exact,aprox,erroRelativo))
}

tamanho <- seq(50,2500,50)
Expe <- experimento()
Tempo <- Expe[1:(length(tamanho)*2)]
ErroRelativo <- Expe[(length(tamanho)*2+1):(length(tamanho)*3)]
Tamanho <- c(tamanho, tamanho)
Algoritmo <- c(rep("Exato",length(Tempo)/2),rep("Aproximado",length(Tempo)/2))
compPlot <- data.frame(Tamanho, Tempo, Algoritmo)

ggplot(compPlot, aes(x=Tamanho,y=Tempo))+
  geom_line(aes(color=Algoritmo))
  #geom_point(aes(color=Algoritmo))

#erroPlot <- data.frame(Tamanho, ErroRelativo)

#ggplot(erroPlot, aes(x=Tamanho,y=ErroRelativo))+
#  geom_line()