% 3-EQUATION NK MODEL

// 1. Declare model variables
var y, pi, r, zy, zi, zpi, // model variables
    y_obs, pi_obs, r_obs; // observation variables
varexo epsy epsi epspi; // structural shocks

// 2. Declare parameters
parameters betta sigma psi phiy phipi omega alphha epsilon Omega lambda kappa rhoy rhoi rhopi stdev_ez stdev_ev stdev_ew;

betta=0.99;  % Discount factor - Dynare cannot handle name 'beta'
sigma = 1;    % CRRA parameters, 1=log utility
psi = 1;      % Labor supply parameter (Frisch elasticity)
phiy  =0.5/4;   % Taylor rule: feedback on output gap
phipi =1.5;   % Taylor rule: feedback on expected inflation
omega =2/3;  % Calvo parameter of price stickiness
alphha = 1/3;   % capital share
epsilon = 6;    % demand elasticity
Omega = (1-alphha)/(1-alphha+alphha*epsilon);
lambda = ((1-omega)*(1-betta*omega)/omega)*Omega;
kappa = lambda*(sigma + (psi + alphha)/(1-alphha));
rhoy = 0.8;  % persistence of agg. demand shock
rhopi = 0.8;   %persistence of cost-push shock
rhoi = 0.5;     %persistence of monetary policy shock

// 3. Declare model equations
model(linear);
y = y(+1)-(1/sigma)*(r-pi(+1))+zy;
pi = betta*pi(+1)+kappa*y+zpi;
r = phipi*pi+phiy*y+zi;
zy = rhoy*zy(-1)+epsy;  // aggregate demand shock
zpi = rhopi*zpi(-1)+epspi;  // cost-push shock
zi = rhoi*zi(-1)+epsi;  // monetary policy shock
// Observation equations: match the model variables to the observed series
y_obs=y;
pi_obs=pi;
r_obs=r;
end;

steady;

// 4. Declare observed variables
varobs y_obs, pi_obs, r_obs;

// 5. Declare priors for estimated parameters
estimated_params; 
sigma, NORMAL_PDF,1,0.25;
psi, NORMAL_PDF,1,0.25;
phipi, NORMAL_PDF,1.5,0.1;
phiy, BETA_PDF,0.2,0.01;
omega, BETA_PDF,0.75,0.1;
rhoy, BETA_PDF,0.8,0.1;
rhopi, BETA_PDF,0.8,0.1;
rhoi, BETA_PDF,0.5,0.025;
stderr epsy, INV_GAMMA_PDF,0.005,inf;
stderr epspi, INV_GAMMA_PDF,0.005,inf;
stderr epsi, INV_GAMMA_PDF,0.005,inf;
end;

// 6. Estimation
estimation(datafile=data_for_dynare,mode_compute=4,prefilter=1,mh_replic=20000,mh_jscale=0.7, mh_drop=0.2); 

// 7. Evaluate results
shock_decomposition y_obs pi_obs r_obs;
stoch_simul(irf=16) y pi r;
