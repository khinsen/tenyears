# 1_seasonal_analysis.R
# analysis of seasonal patterns in the MONICA data
# from "Estimating trends and seasonality in coronary heart disease", DOI: 10.1002/sim.1927
# Jan 2020
source('1_boot_periodogram.R')
library(season)
library(dplyr)
library(ggplot2)

# get the data (from 0_read_data.R)
load('data/AnalysisReady.RData')
# select which centre to run
to.run = data.frame(filter(rates, centre==10)) # select one centre, Perth
to.run = data.frame(filter(rates, centre==36)) # select one centre, Warsaw
to.run = data.frame(filter(rates, centre==34)) # select one centre, Belfast

### loop for to find all seasonal cycles ###
## start with 12 month cycle
f = c(12) # cycle at 12 months
tau = c(1,50) # (trend, season)
end.season = FALSE
while(end.season == FALSE){
  smodel = nscosinor(data=to.run, response='ratestd', cycles=f, niters=5000, burnin=500, tau=tau)
  summary(smodel)
  plot(smodel)
  season::seasrescheck(smodel$residuals)
  # test the residuals for any remaining seasonal pattern
  test.res = boot.seas.test(smodel$residuals)
  freqs = select(test.res$outside, -f) %>% # remove f in data.frame
    filter(!c%in% f) # exclude frequencies already modelled
  if(nrow(freqs)==0){ # no more frequencies, so end
    end.season = TRUE
  }
  if(nrow(freqs)>0){ # more seasonal frequencies, so re-fit model with one extra frequency
    largest = freqs$c[1] # take the frequency with the largest amplitude
    f = c(f, largest) 
    tau = c(tau, 50) # add additional seasonal tau
  }
} # end of while
cat('There were ', length(f), ' seasonal frequencies.\n', sep='')
seasrescheck(smodel$residuals)
