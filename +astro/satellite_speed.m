function arcsec_per_sec = satellite_speed(height_km, varargin)
% usage: arcsec_per_sec = satellite_speed(height_km, varargin)
% calculate the angular speed of a satellite, assuming circular orbit, and
% assuming it goes right above you. 
% 
% OPTIONAL ARGUMENTS:

    if nargin==0, help('util.astro.satellite_speed'); return; end
    
    G = 6.674e-11; % MKS!
    M = 5.972e24; % kilograms
    R_earth = 6371; % km
    
    R = R_earth + height_km;
    
    V = sqrt(G*M./(R*1000))/1000; % km/sec
    
    omega = V./height_km;
    
    arcsec_per_sec = omega.*206265; 

end