classdef (Abstract) Subsystem < ws.Model
    %Subsystem Default base class for Wavesurfer subsystem implementations
    %
    %   The Subsystem class defines the Wavesurfer subsystem API and defines default
    %   (no-op) implementations for each API method and property.
    
    properties (Dependent = true)
        IsEnabled
    end
    
    properties (Access = protected)
        IsEnabled_ = false
    end
    
    events 
        DidSetIsEnabled
    end
    
    methods
        function self = Subsystem(parent)
            self@ws.Model(parent) ;
        end
                
        function out = get.IsEnabled(self)
            out = self.getIsEnabledImplementation();
            % out = self.IsIsEnabled_ && self.CanEnable;
        end
        
        function set.IsEnabled(self, value)
            self.setIsEnabledImplementation_(value);            
        end
        
        function startingRun(self) %#ok<MANU>
        end
        
        function completingRun(self) %#ok<MANU>
        end
        
        function stoppingRun(self) %#ok<MANU>
        end
        
        function abortingRun(self) %#ok<MANU>
            % Called if a failure occurred during startingRun() for subsystems
            % that have already passed startingRun() to clean up, and called fater
            % abortingSweep().
            
            % This code MUST be exception free.
        end
        
        function startingSweep(~)          % self
        end
        
        function completingSweep(~)           % self
        end
        
        function stoppingSweep(~)           % self
        end
        
        function abortingSweep(~)              % self
            % Called when a sweep is interrupted, either unexpectedly because of an error,
            % or intentionally such as stopping preview mode or stopping an ephys test
            % pulse.
            
            % This code MUST be exception free.
        end
        
%         function dataAvailable(self, isSweepBased, t, scaledAnalogData, rawAnalogData, rawDigitalData, timeSinceRunStartAtStartOfData) %#ok<INUSD>
%         end

        function mimicWavesurferModel_(self, other)
            % This is only every called when self is a subsystem of a
            % Looper or Refiller object, and other is the corresponding
            % subsystem of a WavesurferModel object.  It is used to sync
            % the satellite settings to the WavesurferModel settings.
            self.mimic(other) ;
        end

    end  % methods block
    
    methods (Access = protected)
%         function defineDefaultPropertyTags_(self)
%             defineDefaultPropertyTags_@ws.Model(self);
%             self.setPropertyTags('Parent', 'ExcludeFromFileTypes', {'header'});
%         end
        
        function out = getIsEnabledImplementation(self)
            out = self.IsEnabled_;
        end
        
        function setIsEnabledImplementation_(self, newValue)
            if isscalar(newValue) && (islogical(newValue) || (isnumeric(newValue) && (newValue==1 || newValue==0))) ,
                self.IsEnabled_ = logical(newValue) ;
                didSucceed = true ;
            else
                didSucceed = false ;
            end
            self.broadcast('DidSetIsEnabled') ;
            if ~didSucceed ,
                error('most:Model:invalidPropVal', ...
                      'IsEnabled must be a scalar, and must be logical, 0, or 1') ;
            end
        end  % function
    end  % protected methods block            
    
end  % classdef
