function out_filename = extension(input_filename, new_ext)
% Usage: extension(input_filename, new_ext)
% Overrides the extension of a filename, adding a period '.' if needed. 

    [path, filename] = fileparts(input_filename);
    
    if new_ext(1)~='.'
        new_ext = ['.' new_ext];
    end
    
    out_filename = fullfile(path, [filename, new_ext]);
    
end