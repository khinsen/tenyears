# Ten year challenge

My entry for the [ten year reproducibility challenge](https://github.com/ReScience/ten-years).

The original paper (Barnett and Dobson, "Estimating trends and seasonality in coronary heart disease", _Statistics in Medicine_ 2004) is [here](https://onlinelibrary.wiley.com/doi/abs/10.1002/sim.1927) (not Open Access). 

My original SAS code is available [here](https://www.thl.fi/publications/monica/chd_seasonal/appendix.htm) (accessed 27 January 2020).

The folders are:

* [`article/`](article) contains the latex files and figures for the accompanying paper
* [`code/`](code) contains the original SAS code in a single commit, followed by the updated and new code. The original SAS code is Reproduced from: "WHO MONICA Project e-publications", No 29, Adrian G Barnett for the WHO MONICA Project, Estimated trends and seasonal components for the WHO MONICA Project data: appendix to a paper published in Statistics in Medicine, Copyright (2004).
* [`R/`](R) is not part of the replication of the original results, but shows how to run the "combined" analysis using the [season](https://cran.r-project.org/web/packages/season/index.html) package in R
