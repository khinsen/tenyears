# 0_read_data.R
# get the csv MONICA data exported from SAS
# Jan 2020
library(dplyr)
library(janitor)

# overall data (some missing data in centre 33); from: new_files/export_to_csv.sas
data = read.csv("U:/Research/Projects/ihbi/aushsi/aushsi_barnetta/meta.research/reproducibility.challenge/updated_files/data/all.csv") %>%
  clean_names()

# just men, sum across fatal and non fatal
rates = filter(data, sex==1) %>% # data for women were not used
  group_by(centre, runit, year, mthonset) %>%
  summarise(ratestd = sum(ratestd)) %>%
  rename('month' = 'mthonset') %>%
  ungroup() %>%
  arrange(centre, runit, year, month)

# check summary statistics from table 1 in the paper
group_by(rates, centre, runit) %>%
  summarise(mean= mean(ratestd))

# save the data
save(rates, file='data/AnalysisReady.RData')
