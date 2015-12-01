classdef StimulusLibraryBasicTestCase < ws.test.StimulusLibraryTestCase
    
    methods (Test)
        function testConstructor(self)
            library = ws.stimulus.StimulusLibrary();
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEmptyLibrary(library);
        end
        
        function testRemoveStimulus(self)
            library = self.createPopulatedStimulusLibrary();
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEqual(numel(library.Stimuli), 5);
            
            % Safe remove, item that is not referenced.  Should delete one
            % stimulus.
            stimulus = library.stimulusWithName('Unreferenced Stimulus');
            isInUse=library.isInUse(stimulus);
            self.verifyFalse(isInUse);
            if all(~isInUse) ,
                library.deleteItems({stimulus});
            end
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEqual(numel(library.Stimuli), 4);
            
            % Safe remove, item that is in use.  Should not delete
            % anything.
            stimulus = library.stimulusWithName('Melvin');
            isInUse=library.isInUse(stimulus);
            self.verifyTrue(isInUse);
            if all(~isInUse) ,
                library.deleteItems({stimulus});
            end
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEqual(numel(library.Stimuli), 4);

            % Force remove, item that is in use.  Should work.
            stimulus = library.stimulusWithName('Melvin');
            isInUse=library.isInUse(stimulus);
            self.verifyTrue(isInUse);
            library.deleteItems({stimulus});  % Remove it anyway
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEqual(numel(library.Stimuli), 3);
        end
        
        function testRemoveSequence(self)
            library = self.createPopulatedStimulusLibrary();
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEqual(numel(library.Sequences), 2, 'Wrong number of initial cycles.');
            
            % Remove cycle.  Should work.
            sequence = library.sequenceWithName('Cyclotron');
            library.deleteItems({sequence});
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyEqual(numel(library.Sequences), 1);
        end
        
        function testRemovalOfSelectedOutputable(self)
            library = ws.stimulus.StimulusLibrary([]);
            outputChannelNames={'ao0' 'ao1'};
            library.setToSimpleLibraryWithUnitPulse(outputChannelNames);
            self.verifyTrue(library.isSelfConsistent()) ;
            library.addNewSequence();  % the simple lib has no sequences in it
            self.verifyTrue(library.isSelfConsistent()) ;
            % There should be one cycle (with no maps in it) and one map.
            library.SelectedOutputable=library.Sequences{1};
            self.verifyTrue(library.isSelfConsistent()) ;
            library.deleteItems(library.Sequences(1));  % this should cause the map (the only other outputable) to be selected
            self.verifyTrue(library.isSelfConsistent()) ;
            self.verifyTrue(library.SelectedOutputable==library.Maps{1});
        end
        
        function testRemoveEverything(self)
            library = self.createPopulatedStimulusLibrary();
            self.verifyTrue(library.isSelfConsistent()) ;
            
            % Remove all the sequences
            nSequencesLeft = length(library.Sequences) ;
            while nSequencesLeft>0 ,
                lastSequence = library.Sequences{end} ;
                library.deleteItem(lastSequence) ;
                self.verifyTrue(library.isSelfConsistent()) ;
                nSequencesLeft = length(library.Sequences) ;                
            end
            
            % Remove all the maps
            nMapsLeft = length(library.Maps) ;
            while nMapsLeft>0 ,
                lastMap = library.Maps{end} ;
                library.deleteItem(lastMap) ;
                self.verifyTrue(library.isSelfConsistent()) ;
                nMapsLeft = length(library.Maps) ;                
            end
            
            % Remove all the stimuli
            nStimuliLeft = length(library.Stimuli) ;
            while nStimuliLeft>0 ,
                lastStimulus = library.Stimuli{end} ;
                library.deleteItem(lastStimulus) ;
                self.verifyTrue(library.isSelfConsistent()) ;
                nStimuliLeft = length(library.Stimuli) ;                
            end            
        end  % function
        
        function testRemoveEverythingInOtherOrder(self)
            library = self.createPopulatedStimulusLibrary();
            self.verifyTrue(library.isSelfConsistent()) ;
            
            % Remove all the sequences
            nSequencesLeft = length(library.Sequences) ;
            while nSequencesLeft>0 ,
                sequence = library.Sequences{1} ;
                library.deleteItem(sequence) ;
                self.verifyTrue(library.isSelfConsistent()) ;
                nSequencesLeft = length(library.Sequences) ;                
            end
            
            % Remove all the maps
            nMapsLeft = length(library.Maps) ;
            while nMapsLeft>0 ,
                map = library.Maps{1} ;
                library.deleteItem(map) ;
                self.verifyTrue(library.isSelfConsistent()) ;
                nMapsLeft = length(library.Maps) ;                
            end
            
            % Remove all the stimuli
            nStimuliLeft = length(library.Stimuli) ;
            while nStimuliLeft>0 ,
                stimulus = library.Stimuli{1} ;
                library.deleteItem(stimulus) ;
                self.verifyTrue(library.isSelfConsistent()) ;
                nStimuliLeft = length(library.Stimuli) ;                
            end            
        end  % function
    end  % test methods
    
    methods (Access = protected)
        function verifyEmptyLibrary(self, library)
            self.verifyEmpty(library.Sequences, 'The ''Sequences'' property should be empty.');
            self.verifyEmpty(library.Maps, 'The ''Maps'' property should be empty.');
            self.verifyEmpty(library.Stimuli, 'The ''Stimuli'' property should be empty.');
        end        
    end
end
