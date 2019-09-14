close all;
clc;

hplus_in = [9.22960e+06, 3.34963e+06, ...
    3.35678e+06, 1.00542e+07, 1.84749e+07, 3.29394e+06, 6.09618e+07,...
    3.19887e+07, 4.79778e+06, 1.05557e+06, 3.00958e+06, 5.54485e+06,...
    6.52368e+06];

heplusplus_in = [610260., 67096.3, 25841.4, 26346.6,...
    493364., 212043., 139395., 633727., 115134., 111034., 19368.6, 700023.,...
    331000.];

oplus_in = [4.26518e+06, 1.91826e+06, 1.96545e+06,...
    1.00210e+07, 3.48505e+07, 1.55657e+07, 1.04571e+08, 7.04411e+07,...
    7.67298e+06, 2.80459e+06, 1.09335e+07, 1.73284e+07, 3.75700e+07];
  
o2plus_in = [5.32567e+06, 7.52832e+06,...
    8.13400e+06, 4.97474e+07, 1.21738e+08, 3.08711e+07, 2.54762e+08,...
    1.81570e+08, 5.79343e+06, 5.94523e+06, 3.28342e+07, 4.46391e+07,...
    1.02495e+08];
  
hplus_out = [4.36413e+07, 6.92078e+07, 3.49120e+07,...
    1.26333e+07, 2.03959e+07, 4.04792e+07, 3.46265e+07, 1.71482e+08,...
    3.58343e+06, 8.70282e+06, 699846., 1.61521e+06, 3.30771e+06];
  
heplusplus_out = [7.40325e+06, 1.77639e+06, 366998.,...
    150445., 1.75938e+06, 204007., 453968., 1.92734e+07, 49594.5,...
    1.42544e+06, 194544., 473701., 0.00000];
     
oplus_out = [8.40322e+07, 2.14766e+07, 3.07809e+06,...
    3.21139e+06, 8.23629e+07, 1.42010e+08, 6.04606e+07, 2.96367e+08,...
    4.17266e+06, 2.58662e+06, 597087., 2.74726e+06, 1.26186e+07];

o2plus_out = [2.15762e+08, 3.73061e+07, 8.31518e+06,...
    6.25813e+06, 1.63777e+08, 9.44422e+08, 1.14623e+08, 6.20786e+08,...
    2.36507e+07, 3.58240e+06, 1.08839e+06, 7.07652e+06, 4.85000e+07];

hplus_r = [0.211488, 0.0483995, 0.0961499, 0.795846, 0.905814,...
    0.081373, 1.76055, 0.186542, 1.33888, 0.121291, 4.30035, 3.43289, 1.97227];
     
heplusplus_r = [0.0824314, 0.0377712, 0.0704128, 0.175125, 0.280420,...
    1.03939, 0.307059, 0.0328810, 2.32151, 0.0778948, 0.0995589, 1.47777, 0.00000];

oplus_r = [0.0507565, 0.0893186, 0.638529, 3.12045, 0.423134,...
    0.109610, 1.72957, 0.237682, 1.83887, 1.08427, 18.3115, 6.30751, 2.97736];
     
o2plus_r = [0.0246831, 0.201799, 0.978212, 7.94924, 0.743314,...
    0.0326878, 2.22261, 0.292484, 0.244958, 1.65956, 30.1678, 6.30806, 2.11330];

ya = [2.45699e+06, 2.45702e+06, 2.45704e+06, 2.45707e+06, 2.45709e+06,...
      2.45712e+06, 2.45715e+06, 2.45717e+06, 2.45720e+06, 2.45722e+06,...
      2.45724e+06, 2.45728e+06, 2.45731e+06];

ya2 = [2.45699e+06, 2.45702e+06, 2.45704e+06, 2.45707e+06, 2.45709e+06,...
      2.45712e+06, 2.45715e+06, 2.45717e+06, 2.45720e+06, 2.45722e+06,...
      2.45724e+06, 2.45728e+06];
  
x = linspace(1,13,13);
Y =  {'180', '(Autumn)','270', '(Winter)', '360','(Spring)', '90', '(Summer)', '180'};

% axes1 = axes(figure(1),...
% 'XTick', (1:1:16), 'XTickLabel', {'Oct10/14','Dec25/14','Mar13/15','My30/15','Aug10/15','Nov10/15'}); 

figure(1)

semilogy(ya, hplus_in, '-*', ya, heplusplus_in,'-d', ya, oplus_in, '-o', ya, o2plus_in,'-s');
axis([2456887.0 2457574.0 1e4 1e9]);
set(gca,'XTick', 2456887.0:85.875:2457574.0) % This automatically sets 
%labels = {'242.1','291.7','336.5','15.9','52.8'};
labels = Y;
set(gca,'XTickLabel',labels)
xlabel('Martian Solar Longitude, Ls');
title('Omni-Directional Ion Fluxes Between 250 and 300 km [INBOUND]');
ylabel('Omni-Directional Flux, (cm^2 s)^-1 [INBOUND]');
legend('H+ Flux [INBOUND]', 'He++ Flux [INBOUND]', 'O+ Flux [INBOUND]',...
    'O2+ Flux [INBOUND]','Location','NorthWest');

figure(2)

semilogy(ya, hplus_out, '-*', ya, heplusplus_out,'-d', ya, oplus_out, '-o', ya, o2plus_out,'-s');
axis([2456887.0 2457574.0 1e4 1e10]);
legend('H+ Flux [OUTBOUND]', 'He++ Flux [OUTBOUND]', 'O+ Flux [OUTBOUND]',...
    'O2+ Flux [OUTBOUND]','Location','NorthWest');
set(gca,'XTick', 2456887.0:85.875:2457574.0) % This automatically sets 
labels = Y;
set(gca,'XTickLabel',labels)
xlabel('Martian Solar Longitude, Ls');
title('Omni-Directional Ion Fluxes Between 250 and 300 km [OUTBOUND]');
ylabel('Omni-Directional Flux, (cm^2 s)^-1 [OUTBOUND]');
  
figure(3)

semilogy(ya, hplus_r, '-*', ya, heplusplus_r,'-d', ya, oplus_r, '-o', ya, o2plus_r,'-s');
axis([2456887.0 2457574.0 1e-2 35]);
legend('H+ Flux [INBOUND/OUTBOUND]', 'He++ Flux [INBOUND/OUTBOUND]', 'O+ Flux [INBOUND/OUTBOUND]',...
    'O2+ Flux [INBOUND/OUTBOUND]','Location','NorthWest');
set(gca,'XTick', 2456887.0:85.875:2457574.0) % This automatically sets 
labels = Y;
set(gca,'XTickLabel',labels)
xlabel('Martian Solar Longitude, Ls');
title('Ratio Between Inbound and Outbound Ion Fluxes Between 250 and 300 km');
ylabel('Inbound/Outbound Ratio');