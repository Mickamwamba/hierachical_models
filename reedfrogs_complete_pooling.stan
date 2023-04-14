data {
  int<lower=0> N;
  int survivors [N]; 
  int sample_sizes [N];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real alpha; // the probability of survior
}

model {
  alpha ~ normal(0,5);
  survivors ~ binomial_logit(sample_sizes,alpha);
}

generated quantities{
  vector [N] log_lik;
  for (i in 1:N) log_lik[i] = binomial_logit_lpmf(survivors[i]|sample_sizes[i],alpha);
}


