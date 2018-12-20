function [residual, pars, model_data] = lscov_sinus(time, data, freq, weights)

    import util.vec.tocolumn;

    if nargin<4 || isempty(weights)
        weights = [];
    end

    time = tocolumn(time);
    data = tocolumn(data);
    weights = tocolumn(weights);

    design_matrix = [ones(length(time),1), time, sin(2.*pi.*freq.*time), cos(2.*pi.*freq.*time)];

    if isempty(weights)
        pars = lscov(design_matrix, data);
    else
        pars = lscov(design_matrix, data, weights);
    end

    model_data = design_matrix*pars;

    residual = sum((data-model_data).^2);

end