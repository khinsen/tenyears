# 1_boot_periodogram.R
# Function to test the residuals for remaining seasonality using a bootstrap test of the periodogram
# Feb 2020

boot.seas.test = function(res, n.boot=1000){
# observed periodogram
  obs.p = peri(res, plot=FALSE)
  obs.p = data.frame(f=obs.p$f, c=obs.p$c, amp=obs.p$amp) %>%
    filter(c>=2, c<=24) # Limited to 2 years (24 months)
  
all.peri = NULL
for (k in 1:n.boot){
  # Generate bootstrap data from the observed errors by re-ordering
  new.res = res[order(runif(length(res)))]
  # run the spectrum; spectrum with weights: 0.1464466 0.5 0.8535534 1 0.8535534 0.5 0.1464466; * Hanning window, bandwidth=3
  p = peri(new.res, plot=FALSE)
  this.p = data.frame(boot=k, f=p$f, c=p$c, amp=p$amp) %>%
    filter(c>=2, c<=24) # Limited to 2 years (24 months)
  all.peri = bind_rows(all.peri, this.p)
  
  if(k%%100==0){cat('Bootstrap reached ', k,'\r', sep='')}
}

# calculate the bootstrap limits
blimits = group_by(all.peri, c) %>%
  summarise(limit = quantile(amp, 0.95)) # use alpha = 5%

# merge limits and observed and plot
to.plot = left_join(obs.p, blimits, by='c')
gplot = ggplot(data=to.plot, aes(x=c, y=amp))+
  geom_line()+
  geom_line(data=to.plot, aes(x=c, y=limit), col='red', lty=2)+
  xlab('Frequency, cycles')+
  ylab('Amplitude')+
  theme_bw()

# any frequencies outside limits?
outside = filter(to.plot, amp > limit) %>%
  arrange(-amp) # order from strongest to weakest 

# return
to.return = list()
to.return$outside = outside
to.return$plot = gplot
return(to.return)

} # end of function
