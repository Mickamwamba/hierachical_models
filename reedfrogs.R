setwd("~/Documents/PERSONAL/UNF/MCIS-DS/Modeling/Hierachical Models")
library(rethinking)

data("reedfrogs")
head(reedfrogs)

survivors <- reedfrogs$surv
sample_sizes <-  reedfrogs$density
stan_data <- list(N=length(survivors),survivors=survivors,sample_sizes=sample_sizes)

#ignore differences among group, use complete pooling.
model1 <- stan('reedfrogs_complete_pooling.stan',data=stan_data,cores=4)
print(model1,pars = c('alpha'))

#considering each tank separately - fitting with no pooling
model2 <- stan('reedfrogs_no_pooling.stan',data=stan_data,cores=4)
print(model1,pars=c('alpha'))

#considering shared information between group - fitting partial pooling / hierachical. 
model3 <- stan('reedfrogs_partial_pooling.stan',data=stan_data,cores=4)
print(model3,pars=c('alpha','mu','tau'))



