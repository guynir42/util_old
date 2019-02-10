function height_km = satellite_height(arcsec_per_sec, varargin)
% Usage: height_km = satellite_height(arcsec_per_sec, varargin)
% Calculate the height of a circular, Earth orbiting satellite, 
% assuming it is moving right above you at some angular speed. 

    if nargin==0, help('util.astro.satellite_height'); return; end
    
    G = 6.674e-11; % MKS!
    M = 5.972e24; % kilograms
    R_earth = 6371000; % meters
    
    omega = arcsec_per_sec./206265;
    
    % omega = V / h; 
    % V^2 = GM/(h+R_earth)
    % omega^2 = 1/h^2 * GM / (h+R_earth)
    % h^3 + R_earth*h^2 + 0*h - GM/omega^2 = 0 --> polynomial
    
    coeffs = [1 R_earth 0 -G*M./omega.^2];
    
    height_m = roots(coeffs);
    
    [~,idx ]= min(abs(height_m)-real(height_m));
    
    height_m = height_m(idx);
    
    height_km = height_m/1000;
    

end