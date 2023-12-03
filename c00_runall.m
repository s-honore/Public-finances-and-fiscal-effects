
clear all; clc;

cd(strcat[ 'INSERT YOUR PATH OR SET DIRECTORY ','macrometrics_codes'])

addpath('./_tbx') 
addpath('./_tbx/supportfct') 


%% 1. Preliminary data stuff
c01_prepare_data_m;
c01_prepare_data_q;


%% 2. Linear local projection
cc02_show_lplininst;


%% 3. Linear VAR: the ancient case (Cholesky)
c03_show_varchol;


%% 4. Linear VAR: sign restrictions
c04_show_varsign;


%% 5. Linear VAR: IV identification
c05_show_proxyvar; % Gertler & Karadi


%% 6. Smooth-transition VAR: zero lower bound
c06_show_stvar;
c06_show_stvarFiscal;


%% 7. IVAR: zero lower bound / interest rate level
c07_show_ivar;


%% 8. Linear NK-DSGE: Gali textbook version
c08_show_dsge_nk; % Gali textbook model
c08_show_dsge_sw; % Smets & Wouters: 2007 and update


