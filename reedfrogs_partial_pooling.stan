data {
  int<lower=0> N;
  int survivors [N]; 
  int sample_sizes [N];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[N] alpha_tilde;
  real<lower=0> mu;
  real tau;
}

transformed parameters{
   vector[N] alpha; // the probability of survior
   alpha = mu+tau*alpha_tilde;
}

model {
  mu ~ normal(0,1);
  tau ~ cauchy(0,1);
  alpha_tilde ~std_normal();
  survivors ~ binomial_logit(sample_sizes,alpha);
}

generated quantities{
  vector [N] log_lik;
  for (i in 1:N) log_lik[i] = binomial_logit_lpmf(survivors[i]|sample_sizes[i],alpha[i]);
}


