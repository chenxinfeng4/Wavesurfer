classdef NumberOfElectrodesTestCase < matlab.unittest.TestCase
    % To run these tests, need to have an NI daq attached, pointed to by
    % the MDF.  (Can be a simulated daq board.)
    
    methods (TestMethodSetup)
        function setup(self) %#ok<MANU>
            daqSystem = ws.dabs.ni.daqmx.System();
            ws.deleteIfValidHandle(daqSystem.tasks);
        end
    end
    
    methods (TestMethodTeardown)
        function teardown(self) %#ok<MANU>
            daqSystem = ws.dabs.ni.daqmx.System();
            ws.deleteIfValidHandle(daqSystem.tasks);
        end
    end
    
    methods (Test)
        function testCorrectNumberOfElectrodes(self)
            isCommandLineOnly=false;
            thisDirName=fileparts(mfilename('fullpath'));
            [wsModel,wsController]=wavesurfer(fullfile(thisDirName,'Machine_Data_File_WS_Test_with_DO.m'), ...
                isCommandLineOnly);
            wsModel.loadUserFileForRealsSrsly('c:/Users/ackermand/Google Drive/Janelia/ScientificComputing/Test Protocols/unnamed.usr');
            storeNumberOfElectrodesInFigure = zeros(1,5);
            storeNumberOfElectrodesInModel = zeros(1,5);
            index=1;
            for currentButton=[(1:4),3] % Check through 4 buttons, then return to 3 which contains 6 electrodes
                pressedButtonHandle = wsController.Figure.FastProtocolButtons(currentButton);
                wsController.FastProtocolButtonsActuated(pressedButtonHandle);
                currentController=1;
                while  ~isa(wsController.ChildControllers{currentController},'ws.ElectrodeManagerController')
                    currentController=currentController+1;
                end
                
                electrodeManagerController = wsController.ChildControllers{currentController};
                storeNumberOfElectrodesInFigure(index) = length(electrodeManagerController.Figure.LabelEdits);
                storeNumberOfElectrodesInModel(index) = wsModel.Ephys.ElectrodeManager.NElectrodes;
                index = index + 1;
            end
%            disp([storeNumberOfElectrodesInFigure; storeNumberOfElectrodesInModel]);
%            disp(isequal(storeNumberOfElectrodesInFigure, storeNumberOfElectrodesInModel));
            self.verifyEqual( storeNumberOfElectrodesInFigure,storeNumberOfElectrodesInModel);
            ws.clear();
        end  % function
        
    end  % test methods
    
end  % classdef