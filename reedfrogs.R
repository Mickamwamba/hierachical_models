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
print(model2,pars=c('alpha'))

#considering shared information between group - fitting partial pooling / hierachical. 
model3 <- stan('reedfrogs_partial_pooling.stan',data=stan_data,cores=4)
print(model3,pars=c('alpha','mu','tau'))

library(loo)

loo1= loo(model1)
loo2= loo(model2)
loo3= loo(model3)

loo_compare(loo1,loo2,loo3)
loo_model_weights(list(loo1,loo2,loo3))

# Add Predictors: 

predictors <- model.matrix(~pred+size,data=reedfrogs)
#Define the grouping structure: 
total_tanks <- length(survivors); #each data is from one tank
tank_tags <- seq(1,total_tanks)

stan_data2 <- list(N=length(survivors),K=ncol(predictors),predictors=predictors,survivors=survivors,
                   sample_sizes=sample_sizes,total_tanks=total_tanks,tank_tags=tank_tags)

model4 <- stan('reedfrogs_partial_pooling_predictors.stan',data=stan_data2,cores=2)
print(model4,pars=c('alpha','mu','tau'))

#Compare this model with the rest
loo4= loo(model4)
loo_compare(loo1,loo2,loo3,loo4)




