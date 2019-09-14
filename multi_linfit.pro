; Multiple Linear Least Squares Fit

function svdfit_func, X, M

	 ;return, [ [1.0], [sin(X)], [cos(X)], [sin((2.0/1)*X)], [cos((2.0/1)*X)] ]
         return, [ [1.0], [sin((2.0/1)*!const.pi*X)], [cos((2.0/1)*!const.pi*X)], $
		 [sin((4.0/1)*!const.pi*X)], [cos((4.0/1)*!const.pi*X)] ]
end

pro multi_linfit

hplus_in = [9.22960e+06, 3.34963e+06, 3.35678e+06, 1.00542e+07, $
            1.84749e+07, 3.29394e+06, 6.09618e+07, 3.19887e+07, $
            4.79778e+06, 1.05557e+06, 3.00958e+06, 5.54485e+06, 6.52368e+06]

heplusplus_in = [610260.0, 67096.3, 25841.4, 26346.6,  493364.0, $
                 212043.0, 139395.0, 633727.0, 115134.0, 111034.0, $
                 19368.6, 700023.0, 331000.0]

oplus_in = [4.26518e+06, 1.91826e+06, 1.96545e+06, 1.00210e+07, $
            3.48505e+07, 1.55657e+07, 1.04571e+08, 7.04411e+07, $
            7.67298e+06, 2.80459e+06, 1.09335e+07, 1.73284e+07, 3.75700e+07]
  
o2plus_in = [5.32567e+06, 7.52832e+06, 8.13400e+06, 4.97474e+07, $
             1.21738e+08, 3.08711e+07, 2.54762e+08, 1.81570e+08, $
             5.79343e+06, 5.94523e+06, 3.28342e+07, 4.46391e+07, 1.02495e+08]
  
hplus_out = [4.36413e+07, 6.92078e+07, 3.49120e+07, 1.26333e+07, $
             2.03959e+07, 4.04792e+07, 3.46265e+07, 1.71482e+08, $
             3.58343e+06, 8.70282e+06, 699846., 1.61521e+06, 3.30771e+06]
  
heplusplus_out = [7.40325e+06, 1.77639e+06, 366998.0, 150445.0, $
                  1.75938e+06, 204007.0, 453968.0, 1.92734e+07, $
                  49594.5, 1.42544e+06, 194544.0, 473701.0]
     
oplus_out = [8.40322e+07, 2.14766e+07, 3.07809e+06, 3.21139e+06, $
             8.23629e+07, 1.42010e+08, 6.04606e+07, 2.96367e+08, $
             4.17266e+06, 2.58662e+06, 597087.0, 2.74726e+06, 1.26186e+07]

o2plus_out = [2.15762e+08, 3.73061e+07, 8.31518e+06, 6.25813e+06, $
              1.63777e+08, 9.44422e+08, 1.14623e+08, 6.20786e+08, $
              2.36507e+07, 3.58240e+06, 1.08839e+06, 7.07652e+06, 4.85e+07]

hplus_r = [0.211488, 0.0483995, 0.0961499, 0.795846, 0.905814, 0.081373, $
           1.76055, 0.186542, 1.33888, 0.121291, 4.30035, 3.43289, 1.97227] 
     
;heplusplus_r = [0.0824314, 0.0377712, 0.0704128, 0.175125, 0.280420, $
;                1.03939, 0.307059, 0.0328810, 2.32151, 0.0778948, $
;                0.0995589, 1.47777, 0.00000] 

heplusplus_r = [0.0824314, 0.0377712, 0.0704128, 0.175125, 0.280420, $
                1.03939, 0.307059, 0.0328810, 2.32151, 0.0778948, $
                0.0995589, 1.47777] 

oplus_r = [0.0507565, 0.0893186, 0.638529, 3.12045, 0.423134, 0.109610, $
           1.72957, 0.237682, 1.83887, 1.08427, 18.3115, 6.30751, 2.97736]
     
o2plus_r = [0.0246831, 0.201799, 0.978212, 7.94924, 0.743314, 0.0326878, $
            2.22261, 0.292484, 0.244958, 1.65956, 30.1678, 6.30806, 2.11330]


A = [1, 1, 1, 1, 1]

;Ls = [242.1, 259.3, 275.6, 291.7, 307.2, 321.6, 336.5, 350.2, $
;      2.9, 15.9, 25.3, 40.8, 52.8]

Ls = [242.1, 259.3, 275.6, 291.7, 307.2, 321.6, 336.5, 350.2, $
      362.9, 375.9, 385.3, 400.8, 412.8]

Ls2 = [242.1, 259.3, 275.6, 291.7, 307.2, 321.6, 336.5, 350.2, $
      362.9, 375.9, 385.3, 400.8]

ya = [2.45699e+06, 2.45702e+06, 2.45704e+06, 2.45707e+06, 2.45709e+06, $
      2.45712e+06, 2.45715e+06, 2.45717e+06, 2.45720e+06, 2.45722e+06, $
      2.45724e+06, 2.45728e+06, 2.45731e+06]

ya2 = [2.45699e+06, 2.45702e+06, 2.45704e+06, 2.45707e+06, 2.45709e+06, $
      2.45712e+06, 2.45715e+06, 2.45717e+06, 2.45720e+06, 2.45722e+06, $
      2.45724e+06, 2.45728e+06]

Xtick =  ['180', '(Autumn)','270', '(Winter)', '360','(Spring)', '90', '(Summer)', '180']

hplus_inLLS = poly_fit(ya, hplus_in, 1, chisq=hplus_inCHI)
heplusplus_inLLS = poly_fit(ya, heplusplus_in, 1, chisq=heplusplus_inCHI)
oplus_inLLS = poly_fit(ya, oplus_in, 1, chisq=oplus_inCHI)
o2plus_inLLS = poly_fit(ya, o2plus_in, 1, chisq=o2plus_inCHI)
hplus_outLLS = poly_fit(ya, hplus_out, 1, chisq=hplus_outCHI)
heplusplus_outLLS = poly_fit(ya2, heplusplus_out, 1, chisq=heplusplus_outCHI)
oplus_outLLS = poly_fit(ya, oplus_out, 1, chisq=oplus_outCHI)
o2plus_outLLS = poly_fit(ya, o2plus_out, 1, chisq=o2plus_outCHI)
hplus_rLLS = poly_fit(ya, hplus_r, 1, chisq=hplus_rCHI)
heplusplus_rLLS = poly_fit(ya2, heplusplus_r, 1, chisq=heplusplus_rCHI)
oplus_rLLS = poly_fit(ya, oplus_r, 1, chisq=oplus_rCHI)
o2plus_rLLS = poly_fit(ya, o2plus_r, 1, chisq=o2plus_rCHI)


hplus_inC = svdfit(Ls, hplus_in, A=A, chisq=ChiSq_hplusin, $
                 sigma=sigma_hplusin, function_name='svdfit_func', $
                 yfit=Y_hplusin)

;;;;;;;;;;;;;;;;;;;;;;
;hplus_inDC = svdfit(ya, hplus_in, A=A, chisq=ChiSq_hplusinD, $
;                 sigma=sigma_hplusinD, function_name='svdfit_func', $
;                 yfit=Y_hplusinD)
;;;;;;;;;;;;;;;;;;;;;

heplusplus_inC = svdfit(Ls, heplusplus_in, A=A, chisq=ChiSq_heplusplusin, $
                 sigma=sigma_heplusplusin, function_name='svdfit_func', $
                 yfit=Y_heplusplusin)

oplus_inC = svdfit(Ls, oplus_in, A=A, chisq=ChiSq_oplusin, $
                 sigma=sigma_hplusin, function_name='svdfit_func', $
                 yfit=Y_oplusin)

o2plus_inC = svdfit(Ls, o2plus_in, A=A, chisq=ChiSq_o2plusin, $
                 sigma=sigma_hplusin, function_name='svdfit_func', $
                 yfit=Y_o2plusin)

hplus_outC = svdfit(Ls, hplus_out, A=A, chisq=ChiSq_hplusout, $
                 sigma=sigma_hplusout, function_name='svdfit_func', $
                 yfit=Y_hplusout)

heplusplus_outC = svdfit(Ls2, heplusplus_out, A=A, chisq=ChiSq_heplusplusout, $
                 sigma=sigma_heplusplusout, function_name='svdfit_func', $
                 yfit=Y_heplusplusout)

oplus_outC = svdfit(Ls, oplus_out, A=A, chisq=ChiSq_oplusout, $
                 sigma=sigma_o2plusout, function_name='svdfit_func', $
                 yfit=Y_oplusout)

o2plus_outC = svdfit(Ls, o2plus_out, A=A, chisq=ChiSq_o2plusout, $
                 sigma=sigma_o2plusout, function_name='svdfit_func', $
                 yfit=Y_o2plusout)

hplus_rC = svdfit(Ls, hplus_r, A=A, chisq=ChiSq_hplusr, $
                 sigma=sigma_hplusr, function_name='svdfit_func', $
                 yfit=Y_hplusr)

heplusplus_rC = svdfit(Ls2, heplusplus_r, A=A, chisq=ChiSq_heplusplusr, $
                 sigma=sigma_heplusplusr, function_name='svdfit_func', $
                 yfit=Y_heplusplusr)

oplus_rC = svdfit(Ls, oplus_r, A=A, chisq=ChiSq_oplusr, $
                 sigma=sigma_o2plusr, function_name='svdfit_func', $
                 yfit=Y_oplusr)

o2plus_rC = svdfit(Ls, o2plus_r, A=A, chisq=ChiSq_o2plusr, $
                 sigma=sigma_o2plusr, function_name='svdfit_func', $
                 yfit=Y_o2plusr)




print, hplus_inCHI
print, heplusplus_inCHI
print, oplus_inCHI
print, o2plus_inCHI
print, hplus_outCHI
print, heplusplus_outCHI
print, oplus_outCHI
print, o2plus_outCHI

print, 'multifit starts'

print, ChiSq_hplusin
print, ChiSq_heplusplusin
print, ChiSq_oplusin
print, ChiSq_o2plusin
print, ChiSq_hplusout
print, ChiSq_heplusplusout
print, ChiSq_oplusout
print, ChiSq_o2plusout


;cgWindow, wxsize=800, wysize=500
;cgPlot, ya, hplus_in, xtitle='Solar Longitude, Ls', /ylog, $
;        PSym=-13, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
;        ytitle='H+ Flux, (cm^2 s)^-1 [INBOUND]', $
;        title = 'Omnidirectional H+ Flux vs Ls [INBOUND]', $
;        xstyle=1, xrange=[180,540], /window
;cgPlot, ya, Y_hplusin, color='red', /overplot, /addcmd
; yrange=[min(hplus_in), max(hplus_in)]

;cgControl, output='Multi_hplusin.png'
;cgControl, /DESTROY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
cgWindow, wxsize=800, wysize=500
cgPlot, ya, hplus_in, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-13, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='H+ Flux, (cm^2 s)^-1 [INBOUND]', $
        title = 'Omnidirectional H+ Flux vs Ls [INBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_hplusin, color='red', /overplot, /addcmd

cgOPlot, ya, hplus_inLLS[0]+hplus_inLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_hplusin.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, heplusplus_in, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-14, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='He++ Flux, (cm^2 s)^-1 [INBOUND]', $
        title = 'Omnidirectional He++ Flux vs Ls [INBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_heplusplusin, color='red', /overplot, /addcmd

cgOPlot, ya, heplusplus_inLLS[0]+heplusplus_inLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_heplusplusin.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, oplus_in, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-15, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='0+ Flux, (cm^2 s)^-1 [INBOUND]', $
        title = 'Omnidirectional O+ Flux vs Ls [INBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_oplusin, color='red', /overplot, /addcmd

cgOPlot, ya, oplus_inLLS[0]+oplus_inLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_oplusin.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, o2plus_in, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-16, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='O2+ Flux, (cm^2 s)^-1 [INBOUND]', $
        title = 'Omnidirectional O2+ Flux vs Ls [INBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_O2plusin, color='red', /overplot, /addcmd

cgOPlot, ya, o2plus_inLLS[0]+o2plus_inLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_o2plusin.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, hplus_out, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-13, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='H+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
        title = 'Omnidirectional H+ Flux vs Ls [OUTBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_hplusout, color='red', /overplot, /addcmd

cgOPlot, ya, hplus_outLLS[0]+hplus_outLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_hplusout.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya2, heplusplus_out, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-14, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='He++ Flux, (cm^2 s)^-1 [OUTBOUND]', $
        title = 'Omnidirectional He++ Flux vs Ls [OUTBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya2, Y_heplusplusout, color='red', /overplot, /addcmd

cgOPlot, ya2, heplusplus_outLLS[0]+heplusplus_outLLS[1]*ya2, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_heplusplusout.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, oplus_out, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-15, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='O+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
        title = 'Omnidirectional O+ Flux vs Ls [OUTBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_oplusout, color='red', /overplot, /addcmd

cgOPlot, ya, oplus_outLLS[0]+oplus_outLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_oplusout.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, o2plus_out, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-16, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='O2+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
        title = 'Omnidirectional O2+ Flux vs Ls [OUTBOUND]', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_o2plusout, color='red', /overplot, /addcmd

cgOPlot, ya, o2plus_outLLS[0]+o2plus_outLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_o2plusout.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, hplus_r, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-13, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='H+ Inbound/Outbound Ratio', $
        title = 'Inbound/Outbound H+ Fluxes, 250-300 km', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya, Y_hplusr, color='red', /overplot, /addcmd

cgOPlot, ya, hplus_rLLS[0]+hplus_rLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_hplusr.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya2, heplusplus_r, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-14, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='He++ Inbound/Outbound Ratio', $
        title = 'Inbound/Outbound He++ Fluxes, 250-300 km', $
        xstyle=1, xrange=[2456887.0,2457574.0], /window
cgPlot, ya2, Y_heplusplusr, color='red', /overplot, /addcmd

cgOPlot, ya2, heplusplus_rLLS[0]+heplusplus_rLLS[1]*ya2, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_heplusplusr.png'
cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, oplus_r, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-15, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='O+ Inbound/Outbound Ratio', $
        title = 'Inbound/Outbound O+ Fluxes, 250-300 km', $
        xstyle=1, xrange=[2456887.0,2457574.0], /addcmd
cgPlot, ya, Y_oplusr, color='red', /overplot, /addcmd

cgOPlot, ya, oplus_rLLS[0]+oplus_rLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_oplusr.png'
;cgControl, /DESTROY

cgWindow, wxsize=800, wysize=500
cgPlot, ya, o2plus_r, xtitle='Solar Longitude, Ls', /ylog, $
        PSym=-16, SymColor='grn6', SymSize=2, xticks=8, xtickname=Xtick, $
        ytitle='O2+ Inbound/Outbound Ratio', $
        title = 'Inbound/Outbound O2+ Fluxes, 250-300 km', $
        xstyle=1, xrange=[2456887.0,2457574.0], /addcmd
cgPlot, ya, Y_o2plusr, color='red', /overplot, /addcmd

cgOPlot, ya, o2plus_rLLS[0]+o2plus_rLLS[1]*ya, color = 'blue', $
         thick = 3, /overplot, /addcmd

cgControl, output='Multi_o2plusr.png'
;cgControl, /DESTROY


;  maxData = Max(o2plus_out) > Max(heplusplus_bin)
;  minData = Min(o2plus_out) > Min(heplusplus_bin)
;  dataRange = maxData - minData
;  yrange = [(1e-3)*MinData, (1e1)*maxData + (dataRange*0.25)]

  ; Create the plot wth legend
;  p1 = PLOT(hplus_bin, '-r+', Name='hplus', YRange=yrange, YStyle=1 ,/ylog, $
;    XTitle='26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', YTitle='Omni-directional Flux, (cm^2 s)^-1') 
;  p2 = PLOT( heplusplus_bin, Name='heplusplus', '-b*', /overplot)
;  p3 = PLOT(oplus_bin, name='oplus', '-gD',/overplot)
;  p4 = PLOT(o2plus_bin, name='o2plus', '-ktu', /overplot)
  
;  l = LEGEND(TARGET=[p1,p2,p3,p4], POSITION=[0.75,0.75])

end
