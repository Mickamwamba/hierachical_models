data {
  int<lower=0> N;
  int<lower=0> K;
  int total_tanks;
  int tank_tags [total_tanks];
  int survivors [N]; 
  int sample_sizes [N];
  matrix [N,K] predictors;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[N] alpha_tilde;
  real mu;
  real <lower=0> tau; // from the parent process
  vector [K] beta;
}

transformed parameters{
   vector[N] alpha; // the probability of survior
   alpha = mu+tau*alpha_tilde;
}

model {
  mu ~ normal(0,1);
  tau ~ cauchy(0,1);
  alpha_tilde ~std_normal();
  for (i in 1:N) 
      survivors[i] ~ binomial_logit(sample_sizes[i],predictors[i]*beta+alpha[tank_tags[i]]);
}

generated quantities{
  vector [N] log_lik;
  for (i in 1:N) log_lik[i] = binomial_logit_lpmf(survivors[i]|sample_sizes[i],predictors[i]*beta+alpha[tank_tags[i]]);
}


