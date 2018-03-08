classdef TimingData < handle

    properties % timing data
        
        start_dict@containers.Map; % start times for different parts
        batch_dict@containers.Map; % runtime for the latest batch
        total_dict@containers.Map; % runtime for the entire run
        
        total_runtime = 0;
        batch_runtime = 0;
        
    end
    
    properties % inputs/outputs
        
    end
    
    properties % switches/controls
        
        name = '';
        debug_bit = 1;
        
    end
    
    properties(Dependent=true)
        
        
        
    end
    
    properties(Hidden=true)
       
        version = 1.00;
        
    end
    
    methods % constructor
        
        function obj = TimingData(other)
            
            if nargin>0 && ~isempty(other) && isa(other, 'util.TimingData')
                
                if obj.debug_bit, fprintf('TimingData copy-constructor v%4.2f\n', obj.version); end
                
                obj.start_dict = containers.Map(other.start_dict.keys, other.start_dict.values);
                obj.batch_dict = containers.Map(other.batch_dict.keys, other.batch_dict.values);
                obj.total_dict = containers.Map(other.total_dict.keys, other.batch_dict.values);
                
                obj.total_runtime = other.total_runtime;
                obj.batch_runtime = other.batch_runtime;
                
                obj.name = other.name;
                obj.debug_bit = other.debug_bit;
                
            else

                if obj.debug_bit, fprintf('TimingData constructor v%4.2f\n', obj.version); end

                obj.start_dict = containers.Map;            
                obj.batch_dict = containers.Map;
                obj.total_dict = containers.Map;
                
            end
                
        end
        
    end
    
    methods % reset/clear
        
        function initialize(obj)
                        
            obj.start_dict = containers.Map;
            obj.batch_dict = containers.Map;
            obj.total_dict = containers.Map;
            
            obj.reset;
            
        end
        
        function reset(obj, key)
            
            if nargin<2 || isempty(key)
                k = obj.total_dict.keys;
            else
                k{1} = key;
            end
            
            for ii = 1:length(k)
                if obj.total_dict.isKey(k{ii})
                    obj.total_dict(k{ii}) = 0;
                end
            end
            
            obj.total_runtime = 0;
            
            obj.clear;
            
        end
        
        function clear(obj, key)
            
            if nargin<2 || isempty(key)
                k = obj.batch_dict.keys;
            else
                k{1} = key;
            end
            
            for ii = 1:length(k)
                if obj.batch_dict.isKey(k{ii})
                    obj.batch_dict(k{ii}) = 0;
                end
            end
            
            obj.batch_runtime = 0;
            
        end
        
    end
    
    methods % getters
        
        function print(obj)
            
            import util.text.*;
            
            k = obj.batch_dict.keys;
            
            fprintf('% 15s |  batch  |  total  \n', '');
            fprintf('   -------------+---------+---------\n');
            
%             batch_t = 0;
%             total_t = 0;
            
            for ii = 1:length(k)
                
                fprintf('% 15s | %7.2f | %7.2f \n', k{ii}, obj.batch_dict(k{ii}), obj.total_dict(k{ii}));
%                 batch_t = batch_t + obj.batch_dict(k{ii});
%                 total_t = total_t + obj.total_dict(k{ii});
                
            end
            
            fprintf('   -------------+---------+---------\n');
            
            fprintf('% 15s | %7.2f | %7.2f \n', 'total', obj.batch_runtime, obj.total_runtime);
            
        end
        
    end
    
    methods % setters
        
    end
    
    methods % calculations
        
        function start(obj, key)
            
            obj.start_dict(key) = tic;
            
        end
        
        function finish(obj, key)
            
            if ~obj.start_dict.isKey(key)
                error(['unknown key "' key '" in timing_data... use TimingData.start with the same keyword!']);
            end
            
            dt = toc(obj.start_dict(key));
            
            if obj.batch_dict.isKey(key)
                t = obj.batch_dict(key);
            else
                t = 0;
            end
            
            obj.batch_runtime = obj.batch_runtime + dt;
            
            obj.batch_dict(key) = t + dt;
                        
            if obj.total_dict.isKey(key)
                t = obj.total_dict(key);
            else
                t = 0;
            end
            
            obj.total_dict(key) = t + dt;
            
            obj.total_runtime = obj.total_runtime + dt;
            
        end
        
    end
    
    methods % plotting tools / GUI
        
    end    
    
end

