pro maven_data_read_blalock
;=== Significantly Contributed by Dr. John J. Blalock at Hampton University ===;

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

julday_array = julday(date_array[0,*],date_array[1,*],date_array[2,*],date_array[3,*],date_array[4,*],date_array[5,*])

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
hplus_in = fltarr(16)
heplusplus_in = fltarr(16)
oplus_in = fltarr(16)
o2plus_in = fltarr(16)

juldays_start_out = fltarr(16)
hplus_out = fltarr(16)
heplusplus_out = fltarr(16)
oplus_out = fltarr(16)
o2plus_out = fltarr(16)

for i = 0, 15 do begin
  if (i lt 15) then begin
    juldays_start_in(i) = juldays_bin_in(index_in(i))
    hplus_in(i) = avg(hplus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    heplusplus_in(i) = avg(heplusplus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    oplus_in(i) = avg(oplus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    o2plus_in(i) = avg(o2plus_bin_in(index_in(i):(index_in(i+1)-1)), /nan)
    ;outbound
    juldays_start_out(i) = juldays_bin_out(index_out(i))
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

;xTick = ['Cycle-1','Cycle-5','Cycle-9','Cycle-13',' ']
x = indgen(16)

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, hplus_in, $
  color='red', PSym=-13, SymColor='olive', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $
  xrange = [0,15], yrange = [1e5,1e8], $
  ;xticks = 4, xtickname = xTick, $
  ytitle = 'H+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'H+ Flux [INBOUND]', /addcmd

cgControl, output ='hplus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, heplusplus_in, $
  color='blue', PSym=-14, SymColor='olive', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $
  xrange = [0,15], yrange = [1e4,1e8], $
  ;xticks = 4, xtickname = xTick, $
  ytitle = 'He++ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'He++ Flux [INBOUND]', /addcmd

cgControl, output ='heplusplus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, oplus_in, $
  color='green', PSym=-15, SymColor='olive', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $
  xrange = [0,15], yrange = [1e6,1e9], $
  ;xticks = 4, xtickname = xTick, $
  ytitle = 'O+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'O+ Flux [INBOUND]', /addcmd

cgControl, output ='oplus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, o2plus_in, $
  color='black', PSym=-16, SymColor='olive', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $ ;xrange=[2456925,2457338],
  xrange = [0,15], yrange = [1e6,1e9], $
 ; xticks = 4, xtickname = xTick, $
  ytitle = 'O2+ Flux, (cm^2 s)^-1 [INBOUND]', $
  title = 'O2+ Flux [INBOUND]', /addcmd

cgControl, output ='o2plus_flux_in.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, hplus_out, $
  color='red', PSym=-13, SymColor='dodger blue', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $
  xrange = [0,15], yrange = [1e5,1e11], $
  ;xticks = 4, xtickname = xTick, $
  ytitle = 'H+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'H+ Flux [OUTBOUND]', /addcmd

cgControl, output ='hplus_flux_out.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, heplusplus_out, $
  color='blue', PSym=-14, SymColor='dodger blue', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $
  xrange = [0,15], yrange = [1e3,1e8], $
  ;xticks = 4, xtickname = xTick, $
  ytitle = 'He++ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'He++ Flux [OUTBOUND]', /addcmd

cgControl, output ='heplusplus_flux_out.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, oplus_out, $
  color='green', PSym=-15, SymColor='dodger blue', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $
  xrange = [0,15], yrange = [1e5,1e12], $
  ;xticks = 4, xtickname = xTick, $
  ytitle = 'O+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'O+ Flux [OUTBOUND]', /addcmd

cgControl, output ='oplus_flux_out.png'
cgControl, /DESTROY

cgWindow
cgLoadCT, 25, /addcmd

cgPlot, x, o2plus_out, $
  color='black', PSym=-16, SymColor='dodger blue', SymSize=1.5, $
  xtitle = '26-day Cycles (Sep 21, 2014 to Nov 10, 2015)', /ylog, $ ;xrange=[2456925,2457338],
  xrange = [0,15], yrange = [1e5,1e12], $
  ; xticks = 4, xtickname = xTick, $
  ytitle = 'O2+ Flux, (cm^2 s)^-1 [OUTBOUND]', $
  title = 'O2+ Flux [OUTBOUND]', /addcmd

cgControl, output ='o2plus_flux_out.png'
cgControl, /DESTROY

stop

;====================================Plotting Starts========================================;

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
