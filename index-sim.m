load Data_GlobalIdx2
prices  = [Dataset.TSX Dataset.CAC Dataset.DAX ...
    Dataset.NIK Dataset.FTSE Dataset.SP];

returns =  tick2ret(prices);

nVariables  = size(returns,2);
expReturn   = mean(returns);
sigma       = std(returns);
correlation = corrcoef(returns);
t           = 0;
X           = 100;
X           = X(ones(nVariables,1));

F = @(t,X) diag(expReturn)* X;
G = @(t,X) diag(X) * diag(sigma);

SDE = sde(F, G, 'Correlation', ...
    correlation, 'StartState', X);

nPeriods = 249;      % # of simulated observations
dt       =   1;      % time increment = 1 day
rng(142857,'twister')
[S,T] = simulate(SDE, nPeriods, 'DeltaTime', dt);

whos S

plot(T, S), xlabel('Trading Day'), ylabel('Price')
title('Single Path of Multi-Dimensional Market Model')
legend({'Canada' 'France' 'Germany' 'Japan' 'UK' 'US'}, ... 
    'Location', 'Best')