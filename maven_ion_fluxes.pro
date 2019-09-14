pro maven_ion_fluxes

; restore, 'maven_file_date_list.sav'
; num_dates = n_elements(date_list)


;spawn, 'rm -v *_out.sav'
;for i = 0, num_dates-1 do begin
;  mvn_kp_read, [date_list[i]], insitu_in, /insitu_only, /text_files
;  mvn_kp_insitu_search,  insitu_in,  insitu_out, parameter=[77,80,83,86]
;  mvn_kp_insitu_search,  insitu_in,  insitu_out, min=250, max=300, parameter='spacecraft.altitude'
;  help, insitu_out
;  data_check = isa(insitu_out,/integer)
;  if (data_check eq 0) then begin
;    save, insitu_out, filename='insitu_'+date_list[i]+'_out.sav'
;  endif else begin
;    print, 'NO DATA'
;  endelse
;endfor

spawn, 'ls *out.sav', file_list
num_files = n_elements(file_list)

;=== Create pointers to store data ===;
time_pointer = ptrarr(num_files)
orbit_pointer = ptrarr(num_files)
io_bound_pointer = ptrarr(num_files)
altitude_pointer = ptrarr(num_files)
hplus_flux_pointer = ptrarr(num_files)
heplus_flux_pointer = ptrarr(num_files)
oplus_flux_pointer = ptrarr(num_files)
o2plus_flux_pointer = ptrarr(num_files)

;=== Store data in pointers to retrieve later ===;
for i = 0, num_files-1 do begin
	;=== Restore data file ===;
	
	restore, file_list[i]
	;=== Grab meta data ===;
	time = insitu_out.time_string
	orbit = insitu_out.orbit
	io_bound = insitu_out.io_bound
	altitude = insitu_out.spacecraft.altitude
	
	time_pointer[i] = ptr_new(time)
	orbit_pointer[i] = ptr_new(orbit)
	io_bound_pointer[i] = ptr_new(io_bound)
	altitude_pointer[i] = ptr_new(altitude)
	
	;=== Grab ion fluxes ===;
	hplus_flux = insitu_out.static.HPLUS_OMNI_DIRECTIONAL_FLUX
	heplus_flux = insitu_out.static.HEPLUS_OMNI_DIRECTIONAL_FLUX
	oplus_flux = insitu_out.static.OPLUS_OMNI_DIRECTIONAL_FLUX
	o2plus_flux = insitu_out.static.O2PLUS_OMNI_DIRECTIONAL_FLUX
	
	hplus_flux_pointer[i] = ptr_new(hplus_flux)
	heplus_flux_pointer[i] = ptr_new(heplus_flux)
	oplus_flux_pointer[i] = ptr_new(oplus_flux)
	o2plus_flux_pointer[i] = ptr_new(o2plus_flux)	
endfor

;=== Re-organize pointer data into a list ===;
time_list = []
orbit_list = []
io_bound_list = []
altitude_list = []
hplus_flux_list = []
heplus_flux_list = []
oplus_flux_list = []
o2plus_flux_list = []


for i = 0, num_files-1 do begin
	temp_time = (*time_pointer[i])
	time_list = [time_list,temp_time]
	
	temp_orbit = (*orbit_pointer[i])
	orbit_list = [orbit_list,temp_orbit]
	
	temp_io_bound = (*io_bound_pointer[i])
	io_bound_list = [io_bound_list,temp_io_bound]
	
	temp_altitude = (*altitude_pointer[i])
	altitude_list = [altitude_list,temp_altitude]
	
	temp_hplus_flux = (*hplus_flux_pointer[i])
	hplus_flux_list = [hplus_flux_list,temp_hplus_flux]
	
	temp_heplus_flux = (*heplus_flux_pointer[i])
	heplus_flux_list = [heplus_flux_list,temp_heplus_flux]
	
	temp_oplus_flux = (*oplus_flux_pointer[i])
	oplus_flux_list = [oplus_flux_list,temp_oplus_flux]
	
	temp_o2plus_flux = (*o2plus_flux_pointer[i])
	o2plus_flux_list = [o2plus_flux_list,temp_o2plus_flux]
endfor

save, time_list, orbit_list, altitude_list, io_bound_list, hplus_flux_list, heplus_flux_list, oplus_flux_list, o2plus_flux_list, /compress 
;$, filename = 'time_list.sav', 'orbit_list.sav', 'altitude_list.sav', 'io_bound_list.sav', 'hplus_flux_list.sav',$
;  'heplus_flux_list.sav','oplus_flux_list.sav','o2plus_flux_list.sav'

;hplus_flux = where(hplus_flux_list gt 0d) ;heplus_flux = where(heplus_flux_list gt 0d)
;oplus_flux = where(oplus_flux_list gt 0d) ;o2plus_flux = where(o2plus_flux_list gt 0d)

;for i = 0, io_bound_list-1 do begin
;  if (io_bound_list(i) eq I) then begin
;  inbound_data = io_bound_list(i)  
;  endif else begin
;  outbound_data = io_bound_list(i)    
;  endelse
;endfor

time_array = fltarr(7,n_elements(time_list))
for i = 0, n_elements(time_list)-1 do begin
	time_split = strsplit(time_list[i],'-:T',/extract)
	time_split = fix(time_split)
	for j = 0, 5 do begin
		time_array[j,i] = time_split[j]
	endfor	
endfor

date_array = time_array[0:5,*]

date_array2 = date_array[0,*]
date_array3 = date_array[1,*]
date_array4 = date_array[2,*]
date_array[0,*] = date_array3
date_array[1,*] = date_array4
date_array[2,*] = date_array2

julday_array = julday(date_array[0,*],date_array[1,*],date_array[2,*], $
date_array[3,*],date_array[4,*],date_array[5,*])

index_in = where(strmatch(io_bound_list, 'I', /fold_case) eq 1)
altitudes_bin_in = altitude_list(index_in)
juldays_bin_in = julday_array(index_in)
hplus_bin_in = hplus_flux_list(index_in)
heplusplus_bin_in = heplus_flux_list(index_in)
oplus_bin_in = oplus_flux_list(index_in)
o2plus_bin_in = o2plus_flux_list(index_in)

index_out = where( strmatch(io_bound_list, 'O', /fold_case) eq 1)
altitudes_bin_out = altitude_list(index_out)
juldays_bin_out = julday_array(index_out)
hplus_bin_out = hplus_flux_list(index_out)
heplusplus_bin_out = heplus_flux_list(index_out)
oplus_bin_out = oplus_flux_list(index_out)
o2plus_bin_out = o2plus_flux_list(index_out)

start_day_in = fltarr(16)
index_in = fltarr(16)
start_day_out = fltarr(16)
index_out = fltarr(16)

for i = 0, 15 do begin
  start_day_in(i) = juldays_bin_in(0) + 26.0*(i)
  index_in(i) = closest(juldays_bin_in,start_day_in(i))
  start_day_out(i) = juldays_bin_out(0) + 26.0*(i)
  index_out(i) = closest(juldays_bin_out,start_day_out(i))
endfor

juldays_start_in = fltarr(16)
ls_in_julday = fltarr(16)
hplus_in = fltarr(16)
heplusplus_in = fltarr(16)
oplus_in = fltarr(16)
o2plus_in = fltarr(16)

juldays_start_out = fltarr(16)
ls_out_julday = fltarr(16)
hplus_out = fltarr(16)
heplusplus_out = fltarr(16)
oplus_out = fltarr(16)
o2plus_out = fltarr(16)

juldays_med_out = fltarr(16)

for i = 0, 15 do begin
  if (i lt 15) then begin
    juldays_start_in(i) = juldays_bin_in(index_in(i))
    ls_in_julday(i) = median(juldays_bin_in(index_in(i):(index_in(i+1)-1)))
    hplus_in(i) = avg(hplus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    heplusplus_in(i) = avg(heplusplus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    oplus_in(i) = avg(oplus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    o2plus_in(i) = avg(o2plus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    ;outbound
    juldays_start_out(i) = juldays_bin_out(index_out(i))
    ls_out_julday(i) = median(juldays_bin_out(index_out(i):(index_out(i+1)-1)))
    hplus_out(i) = avg(hplus_bin_out(index_out(i):(index_out(i+1)-1)), /nan)
    heplusplus_out(i) = avg(heplusplus_bin_out(index_out(i):(index_out(i+1)-1)), /nan)
    oplus_out(i) = avg(oplus_bin_out(index_out(i):(index_out(i+1)-1)), /nan)
    o2plus_out(i) = avg(o2plus_bin_out(index_out(i):(index_out(i+1)-1)), /nan)
    endif else begin    
      juldays_start_in(i) = juldays_bin_in(index_in(i))
      hplus_in(i) = hplus_bin_in(39332)
      heplusplus_in(i) = heplusplus_bin_in(39332)
      oplus_in(i) = oplus_bin_in(39332)
      o2plus_in(i) = o2plus_bin_in(39332)
      
      ;outbound
      juldays_start_out(i) = juldays_bin_out(index_out(i))
      hplus_out(i) = hplus_bin_out(39219)
      heplusplus_out(i) = heplusplus_bin_out(39219)
      oplus_out(i) = oplus_bin_out(39219)
      o2plus_out(i) = o2plus_bin_out(39219)
      
    endelse
endfor

caldat, ls_in_julday, m, d, y
caldat, ls_out_julday, m, d, y

; 01. (NOV 28, 2014) 11/28/2014 : 242.1
; 02. (DEC 25, 2014) 12/25/2014 : 259.3
; 03. (JAN 20, 2015) 01/20/2015 : 275.6
; 04. (FEB 15, 2015) 02/15/2015 : 291.7
; 05. (MAR 13, 2015) 03/13/2015 : 307.2
; 06. (APR 07, 2015) 04/07/2015 : 321.6
; 07. (MAY 04, 2015) 05/04/2015 : 336.5
; 08. (MAY 30, 2015) 05/30/2015 : 350.2
; 09. (JUN 24, 2015) 06/24/2015 : 2.9
; 10. (JUL 21, 2015) 07/21/2015 : 15.9
; 11. (AUG 10, 2015) 08/10/2015 : 25.3
; 12. (SEP 13, 2015) 09/13/2015 : 40.8
; 13. (OCT 10, 2015) 10/10/2015 : 52.8

;=======================FFT============================;
;n = 16
;x_fft = findgen((n-1)/2)+1
;frequency = [0.0, x_fft, n/2, -n/2 + x_fft]/(n/26.4)
;fft_hplus_in = fft(hplus_in)


replacement_value = 1e-9
hplus_r = hplus_in/hplus_out
heplusplus1_r = (heplusplus_in[0:14]+ replacement_value * (heplusplus_in eq 0))/(heplusplus_out[0:14] + replacement_value * (heplusplus_out eq 0))
heplusplus_r = [0.0824314, 0.0377712, 0.0704128, 0.175125, 0.280420, $
   1.03939, 0.307059, 0.0328810, 2.32151, 0.0778948, 0.0995589, 1.47777]
oplus_r = oplus_in/oplus_out
o2plus_r = o2plus_in/o2plus_out

;H_to_He_in = hplus_in/(heplusplus_in + replacement_value * (heplusplus_in eq 0))
;hplus_to_heplusplus_in = [2.70850, 0.0, 15.1241, 49.9227, 129.899, 381.611, 37.4467, 15.5343, 437.331, $
;  50.4771, 41.6713, 9.50675, 155.385, 7.92096, 19.7090, 0.0]
;H_to_He_out = hplus_out/(heplusplus_out + replacement_value * (heplusplus_out eq 0))
;hplus_to_heplusplus_out = [26.3993, 12613.3, 5.89489, 38.9599, 95.1284, 83.9728, 11.5927, 198.421, $
;  76.2753, 8.89738, 72.2546, 6.10537, 3.59737, 3.40977, 0.0, 0.0]
;O_to_He_in = oplus_in/(heplusplus_in + replacement_value * (heplusplus_in eq 0))
;oplus_to_heplusplus_in = [8.19765, 0.0, 6.98912, 28.5896, 76.0581, 380.351, 70.6385, 73.4083, 750.177, $
;  111.154, 66.6439, 25.2588, 564.500, 24.7540, 113.505, 0.0]
;O_to_He_out = oplus_out/(heplusplus_out + replacement_value * (heplusplus_out eq 0))
;oplus_to_heplusplus_out = [58.0484, 248734., 11.3507, 12.0900, 8.38720, 21.3459, 46.8137, 696.104, $
;  133.183, 15.3770, 84.1354, 1.81461, 3.06917, 5.79958, 0.0, 0.0]
;O2_to_He_in = o2plus_in/(heplusplus_in + replacement_value * (heplusplus_in eq 0))
;o2plus_to_heplusplus_in = [66.8315, 0.0, 8.72689, 112.202, 314.766, 1888.19, 246.750, 145.589, 1827.63, $
;  286.511, 50.3190, 53.5441, 1695.23, 63.768, 309.653, 0.0]
;O2_to_He_out = o2plus_out/(heplusplus_out + replacement_value * (heplusplus_out eq 0))
;o2plus_to_heplusplus_out = [78.1726, 240904., 29.1443, 21.0011, 22.6573, 41.5974, 93.0881, 4629.36, $
;  252.491, 32.2095, 476.881, 2.51320, 5.59455, 14.9388, 0.0, 0.0]

;cgWindow
;cgPlot, frequency[1:8], fft_hplus_in[1:15,*], $
  ;color='red', PSym=-13, SymColor='olive', SymSize=1.5, $
;  xtitle = 'Frequency', $
 ; xrange = [0,15], yrange = [1e5,1e8], $
  ;xticks = 4, xtickname = xTick, $
;  ytitle = 'H+ Flux, (cm^2 s)^-1 [INBOUND]', $
;  title = 'FFT of H+ Flux Between 250 and 300 km [INBOUND]', /addcmd

;cgControl, output ='FFT_hplus_flux_in.png'
;cgControl, /DESTROY

;cgWindow
;cgPlot, frequency[1:8], abs(fft_hplus_in[1:15,*])^2, $
;  title = 'Power vs Frequency Plot of H+ Flux Between 250 and 300 km [INBOUND]', $
;  ytitle = 'Power', xtitle = 'Frequency', /addcmd
;cgControl, output = 'power_spectrum_hplus_flux_in.png'
;cgControl, /DESTROY
;=======================================================================================;

;xTick = ['Nov 28, 2014', 'Feb15/15', 'May04/15', 'Jul21/15', 'Oct10/15'] ; Earthday
 xTick = ['242.1','291.7','336.5','15.9','52.8']
;        [32-09-472, 32-10-549, 32-12-625, 33-01-32, 33-02-111]
x = indgen(13)
ya = [2.45699e+06, 2.45702e+06, 2.45704e+06, 2.45707e+06, 2.45709e+06, $
      2.45712e+06, 2.45715e+06, 2.45717e+06, 2.45720e+06, 2.45722e+06, $
      2.45724e+06, 2.45728e+06, 2.45731e+06]
    
; Ls = [242.1, 259.3, 275.6, 291.7, 307.2, 321.6, 336.5, 350.2, 2.9, 15.9, 25.3, 40.8, 52.8]

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, x, hplus_to_heplusplus_in, $
;  color='blue', PSym=-12, SymColor='olive', SymSize=1.5, $
;  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', $
;  xrange = [0,15], yrange = [1e-1,3e5], /ylog, $
;  xticks = 5, xtickname = xTick, $
;  ytitle = 'H+ to He++ Ratio [IN]', $
;  title = 'H+ to He++ [IN] Between 250 and 300 km', /addcmd

;cgControl, output ='hplus_to_heplusplus_in.png'
;cgControl, /DESTROY
 
;cgWindow
;cgLoadCT, 25, /addcmd;

;cgPlot, x, hplus_to_heplusplus_out, $
;  color='blue', PSym=-12, SymColor='olive', SymSize=1.5, $
;  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', $
;  xrange = [0,15], yrange = [1e-1,3e5], /ylog, $
;  xticks = 5, xtickname = xTick, $
;  ytitle = 'H+ to He++ Ratio [OUT]', $
;  title = 'H+ to He++ [OUT] Between 250 and 300 km', /addcmd

;cgControl, output ='hplus_to_heplusplus_out.png'
;cgControl, /DESTROY 
 
;cgWindow
;cgLoadCT, 25, /addcmd

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, x, oplus_to_heplusplus_in, $
;  color='blue', PSym=-12, SymColor='olive', SymSize=1.5, $
;  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', $
;  xrange = [0,15], yrange = [1e-1,3e5], /ylog, $
;  xticks = 5, xtickname = xTick, $
;  ytitle = 'O+ to He++ Ratio [IN]', $
;  title = 'O+ to He++ [IN] Between 250 and 300 km', /addcmd

;cgControl, output ='oplus_to_heplusplus_in.png'
;cgControl, /DESTROY

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, x, oplus_to_heplusplus_out, $
;  color='blue', PSym=-12, SymColor='olive', SymSize=1.5, $
;  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', $
;  xrange = [0,15], yrange = [1e-1,3e5], /ylog, $
;  xticks = 5, xtickname = xTick, $
;  ytitle = 'O+ to He++ Ratio [OUT]', $
;  title = 'O+ to He++ [OUT] Between 250 and 300 km', /addcmd;

;cgControl, output ='oplus_to_heplusplus_out.png'
;cgControl, /DESTROY

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, x, o2plus_to_heplusplus_in, $
;  color='blue', PSym=-12, SymColor='olive', SymSize=1.5, $
;  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', $
;  xrange = [0,15], yrange = [1e-1,3e5], /ylog, $
;  xticks = 5, xtickname = xTick, $
;  ytitle = 'O2+ to He++ Ratio [IN]', $
;  title = 'O2+ to He++ [IN] Between 250 and 300 km', /addcmd

;cgControl, output ='o2plus_to_heplusplus_in.png'
;cgControl, /DESTROY

;cgWindow
;cgLoadCT, 25, /addcmd
;
;cgPlot, x, o2plus_to_heplusplus_out, $
;  color='blue', PSym=-12, SymColor='olive', SymSize=1.5, $
;  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', $
;  xrange = [0,15], yrange = [1e-1,3e5], /ylog, $
;  xticks = 5, xtickname = xTick, $
;  ytitle = 'O2+ to He++ Ratio [OUT]', $
;  title = 'O2+ to He++ [OUT] Between 250 and 300 km', /addcmd

;cgControl, output ='o2plus_to_heplusplus_out.png'
;cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], hplus_r[2:14], $
  color='blue', PSym=-13, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e-2,1e2], /ylog, xticks = 8, xtickname = xTick, $
  ytitle = 'H+ Flux Ratio (I/O)', $
  title = 'H+ Flux Ratio (I/O) Between 250 and 300 km', /addcmd

cgControl, output ='hplus_r.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], heplusplus_r, $
  color='blue', PSym=-14, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e-2,1e2], /ylog, xticks = 8, xtickname = xTick, $
  ytitle = 'He+ Flux Ratio (I/O)', $
  title = 'He++ Flux Ratio (I/O) Between 250 and 300 km', /addcmd

cgControl, output ='heplusplus_r.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], oplus_r[2:14], $
  color='blue', PSym=-15, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e-2,1e2], /ylog, xticks = 8, xtickname = xTick, $
  ytitle = 'O+ Flux Ratio (I/O)', $
  title = 'O+ Flux Ratio (I/O) Between 250 and 300 km', /addcmd

cgControl, output ='oplus_r.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], o2plus_r[2:14], $
  color='blue', PSym=-16, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e-2,1e2], /ylog, xticks = 8, xtickname = xTick, $
  ytitle = 'O2+ Flux Ratio (I/O)', $
  title = 'O2+ Flux Ratio (I/O) Between 250 and 300 km', /addcmd

cgControl, output ='o2plus_r.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], hplus_in[2:14], $
  color='red', PSym=-13, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e5,1e8], xticks = 8, xtickname = xTick, $
  ytitle = 'H+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'H+ Flux Between 250 and 300 km [INBOUND]', /addcmd

cgControl, output ='hplus_flux_in.png'
cgControl, /DESTROY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], hplus_in[2:14], $
  color='red', PSym=-13, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $ 
  yrange = [1e5,1e8], xticks = 8, xtickname = xTick, $
  ytitle = 'H+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'H+ Flux Between 250 and 300 km [INBOUND]', /addcmd

cgControl, output ='hplus_flux_inDate.png'
cgControl, /DESTROY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], heplusplus_in[2:14], $
  color='blue', PSym=-14, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e4,1e6], xticks = 8, xtickname = xTick, $
  ytitle = 'He++ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'He++ Flux Between 250 and 300 km [INBOUND]', /addcmd

cgControl, output ='heplusplus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], oplus_in[2:14], $
  color='green', PSym=-15, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e6,1e9], xticks = 8, xtickname = xTick, $
  ytitle = 'O+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'O+ Flux Between 250 and 300 km [INBOUND]', /addcmd

cgControl, output ='oplus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], o2plus_in[2:14], $
  color='black', PSym=-16, SymColor='olive', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $ ;xrange=[2456925,2457338],
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e6,1e9], xticks = 8, xtickname = xTick, $
  ytitle = 'O2+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'O2+ Flux Between 250 and 300 km [INBOUND]', /addcmd

cgControl, output ='o2plus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], hplus_out[2:14], $
  color='red', PSym=-13, SymColor='dodger blue', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e5,1e9], xticks = 8, xtickname = xTick, $
  ytitle = 'H+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'H+ Flux Between 250 and 300 km [OUTBOUND]', /addcmd

cgControl, output ='hplus_flux_out.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], heplusplus_out[2:14], $
  color='blue', PSym=-14, SymColor='dodger blue', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e3,1e8], xticks = 8, xtickname = xTick, $
  ytitle = 'He++ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'He++ Flux Between 250 and 300 km [OUTBOUND]', /addcmd

cgControl, output ='heplusplus_flux_out.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], oplus_out[2:14], $
  color='green', PSym=-15, SymColor='dodger blue', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e4,1e9], xticks = 8, xtickname = xTick, $
  ytitle = 'O+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'O+ Flux Between 250 and 300 km [OUTBOUND]', /addcmd

cgControl, output ='oplus_flux_out.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, ls_out_julday[2:14], o2plus_out[2:14], $
  color='black', PSym=-16, SymColor='dodger blue', SymSize=1.5, $
  xtitle = 'Martian Solar Longitude, Ls', /ylog, $ ;xrange=[2456925,2457338],
  xrange = [min(ls_out_julday[2:14]), max(ls_out_julday[2:14])], $
  yrange = [1e5,1e10], xticks = 8, xtickname = xTick, $
  ytitle = 'O2+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'O2+ Flux Between 250 and 300 km [OUTBOUND]', /addcmd

cgControl, output ='o2plus_flux_out.png'
cgControl, /DESTROY

stop

;====================================Plotting Starts======================================;

;xTick = ['Jan (2014)','July (2014)','Jan (2015)','July (2015)','Jan (2016)']

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, julday_array, hplus_flux_list, $
;  xrange=[2014,2015], xtitle = 'Year', /ylog, $
;  yrange = [min(hplus_flux_list),max(hplus_flux_list)], $
;  xticks = 4, xtickname = xTick, ytitle = 'H+ Flux', $
;  title = 'hplus_flux', /addcmd
;cgControl, output ='hplus_flux2.png'
;cgControl, /DESTROY

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, julday_array, heplus_flux_list, $
;  xrange=[2014,2015], xtitle = 'Year', /ylog, $
;  yrange = [min(heplus_flux_list),max(heplus_flux_list)], $ 
;  xticks = 4, xtickname = xTick, ytitle = 'He+ Flux', $
;  title = 'heplus_flux', /addcmd
;cgControl, output ='heplus_flux2.png'
;cgControl, /DESTROY

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, julday_array, oplus_flux_list, $
;  xrange=[2014,2015], xtitle = 'Year', /ylog, $
;  yrange = [min(oplus_flux_list),max(oplus_flux_list)], $
;  xticks = 4, xtickname = xTick, ytitle = 'O+ Flux',$
;  title = 'oplus_flux', /addcmd
;cgControl, output ='oplus_flux2.png'
;cgControl, /DESTROY

;cgWindow
;cgLoadCT, 25, /addcmd

;cgPlot, julday_array, o2plus_flux_list, $
;  xrange=[2014,2015], xtitle = 'Year', /ylog, $
;  yrange = [min(o2plus_flux_list),max(o2plus_flux_list)], $
;  xticks = 4, xtickname = xTick, ytitle = 'o2+ Flux', $
;  title = 'o2plus_flux', /addcmd
;cgControl, output ='o2plus_flux2.png'
;cgControl, /DESTROY
;====================================Plotting Starts========================================; 

end
