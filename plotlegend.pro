; docformat = 'rst'
;+
; This is an example program to demonstrate how to create a line plot with a legend
; with Coyote Graphics routines.
;
; :Categories:
;    Graphics
;
; :Examples:
;    Save the program as "plot_with_legend.pro" and run it like this::
;       IDL> .RUN plot_with_legend
;
; :Author:
;    FANNING SOFTWARE CONSULTING::
;       David W. Fanning
;       1645 Sheely Drive
;       Fort Collins, CO 80526 USA
;       Phone: 970-221-0438
;       E-mail: david@idlcoyote.com
;       Coyote's Guide to IDL Programming: http://www.idlcoyote.com
;
; :History:
;     Change History::
;        Written, 24 February 2013 by David W. Fanning.
;
; :Copyright:
;     Copyright (c) 2013, Fanning Software Consulting, Inc.
;-
pro PlotLegend

  ; Set up variables for the plot. Normally, these values would be
  ; passed into the program as positional and keyword parameters.
  
  hplus_bin = [1.43761e+07, 7.72477e+09, 2.48874e+07, 2.53944e+07, $
    1.94353e+07, 1.15783e+07, 1.92838e+07, 2.04033e+07, $
    5.14343e+07, 1.08678e+08, 3.98172e+06, 5.22937e+06, $
    1.38538e+06, 2.66225e+06, 5.50042e+06, 5.98000e+06]
    
  heplusplus_bin = [5.26991e+06, 612306., 3.70116e+06, 639250., $
    199685., 99586.0, 1.02648e+06, 208345., 253006., 1.08822e+07, $
    71090.3, 828445., 142756., 534004., 225682., 0.00000]
  
  oplus_bin = [4.34165e+07, 1.52311e+11, 4.05602e+07, 8.46504e+06, $
    2.53310e+06, 6.00311e+06, 5.48581e+07, 7.37441e+07, $
    8.86156e+07, 1.94655e+08, 5.32070e+06, 2.68456e+06, $
    3.66312e+06, 6.63237e+06, 2.96309e+07, 2.53000e+07]
  
  o2plus_bin = [3.52245e+08, 1.47562e+11, 1.01077e+08, 1.74959e+07, $
      8.22992e+06, 2.40858e+07, 1.39441e+08, 4.51206e+08, $
      2.04107e+08, 4.23015e+08, 1.77938e+07, 4.65330e+06, $  
      1.05043e+07, 1.70850e+07, 8.53148e+07, 7.76000e+07]
 
 
  maxData = Max(oplus_bin) > Max(heplusplus_bin)
  minData = Min(o2plus_bin) > Min(heplusplus_bin)
  dataRange = maxData - minData
  yrange = [(1e-3)*MinData, (1e1)*maxData + (dataRange*0.25)]

  ; Create the plot wth legend
  
  cgPlot, hplus_bin, PSym=-15, Color='red7', YRange=yrange, YStyle=1 , /ylog, $
    XTitle='26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', YTitle='Omni-directional Flux, (cm^2 s)^-1'
  cgPlot, heplusplus_bin, PSym=-16, Color='blu7', /Overplot
  cgPlot, oplus_bin, PSym=-17, Color='grn7', /Overplot
  cgPlot, o2plus_bin, PSym=-18, Color='blk7', /Overplot
  
  items=['H+ Flux', 'He++ Flux', 'O+ Flux', 'O2+ Flux']
  psyms=[-15,-16,-17,-18]
  colors=['red7', 'blu7','grn7','blk7']

  ; Location of legend in data coordinates.
  yloc = (!Y.CRange[1] - !Y.CRange[0]) * 0.95 + !Y.CRange[0]
  xloc = (!X.CRange[1] - !X.CRange[0]) * 0.05 + !X.CRange[0]

  ; Add the legend.
  cgLegend, Title=items, PSym=psyms, Lines=lines, Color=colors,$
    Location=[xloc,yloc], /Box, /Data





end
