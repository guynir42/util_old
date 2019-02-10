function N_per_degree_sq = star_density(mag, galactic_lat_deg)
    
    if nargin<2 || isempty(galactic_lat_deg)
        galactic_lat_deg = [];
    end
    
    if isempty(galactic_lat_deg)
        
        A = -0.006993;
        B = 0.5744;
        C = -4.058;
        
    elseif galactic_lat_deg==0
        
        A = -0.01045;
        B = 0.6787;
        C = -4.688;
        
    elseif galactic_lat_deg==90
        
        A = -0.0117;
        B = 0.6034;
        C = -4.586;
        
    end
    
    N_per_degree_sq = 10.^(A.*mag.^2 + B.*mag + C);
    
end

function fit_all_sky
    
    % from http://www.hnsky.org/star_count.htm
    M = (0:16)';
    N = [0.000072722 0.000339369 0.001333236 0.004629966 0.013526289 0.042275713 0.129105762 0.400043633 1.177102271 3.378542167 9.282355223 25.40624924 71.65420697 178.0897147 417.2815553 954.7861974 2154.900589]';
    LN = log10(N);
    
    fr = fit(M,LN, 'poly2');
    
    % from http://www.astro.rug.nl/~ahelmi/galaxies_course/class_IV/class_IV-2005.pdf 
    % they take it from Mihalas & Binney: http://adsabs.harvard.edu/abs/1981gask.book.....M
    
    % for latitude==0
    M = (8:21)';
    LN = [0.1 0.58 1.04 1.5 1.94 2.35 2.76 3.15 3.46 3.84 4.2 4.5 4.7 4.9]';
    
    fr = fit(M,LN,'poly2');
    
    % for latitude==90
    M = (10:21)';
    LN = [0.28 0.63 0.98 1.29 1.57 1.8 2.06 2.28 2.5 2.7 2.8 2.9]';
    
    fr = fit(M,LN,'poly2');
    
    
end