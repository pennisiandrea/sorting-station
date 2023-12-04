PROGRAM _INIT
           
	EnableModules;
	
    MachineState.NextState := WAITING_MODE_SELECTION;
    
END_PROGRAM

PROGRAM _CYCLIC
	
	// Master communication management
	PickingStationCommunication;
	
	// Alarms
	SetAlarmsAction;
	
	// Check stop reaction
	IF MpAlarmXCheckReaction(gAlarmXCoreMpLink,'STOP') THEN
		MachineState.NextState := ERROR;
	END_IF
		
	// Machine state
	MachineStateManagementAction;
	CASE MachineState.ActualState OF
        
		WAITING_MODE_SELECTION:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				StopModules;
			END_IF
			
			IF gMainMachine.Commands.Automatic.Enable THEN				
				MachineState.NextState := AUTO_WAITING_INIT;			
			
			ELSIF gMainMachine.Commands.Manual.Enable THEN
				MachineState.NextState := MANUAL;
			END_IF 
		
		MANUAL:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state			
			
			gColourSorter.Commands.Manual.Enable := TRUE;
			gConveyor.Commands.Manual.Enable := TRUE;
			gPuncher.Commands.Manual.Enable := TRUE;
					
			IF NOT gMainMachine.Commands.Manual.Enable THEN
				MachineState.NextState := WAITING_MODE_SELECTION;
			END_IF
			
		AUTO_WAITING_INIT:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state			
			IF MachineState.NewTriggerState THEN
				gMainMachine.Feedbacks.InitDone := FALSE;
			END_IF
						
			IF NOT gMainMachine.Commands.Automatic.Enable THEN
				MachineState.NextState := WAITING_MODE_SELECTION;
				
			ELSIF gMainMachine.Commands.Automatic.Init THEN					
				MachineState.NextState := AUTO_INITIALIZING;	
				
			END_IF
		
		AUTO_INITIALIZING:
			MachineState.TimeoutTimer.PT := T#30S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				InitModules;
			END_IF
			
			IF gColourSorter.Feedbacks.InitDone 
				AND gConveyor.Feedbacks.InitDone 
				AND gPuncher.Feedbacks.InitDone 
				AND (gPickingStation.Outputs.InitDone OR NOT gMainMachine.Commands.LinkMode) THEN
					
				gMainMachine.Feedbacks.InitDone := TRUE;
				MachineState.NextState := AUTO_WAITING_START;
				
			END_IF
			
		AUTO_WAITING_START:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				StopModules;
			END_IF
			
			IF NOT gMainMachine.Commands.Automatic.Enable THEN
				MachineState.NextState := WAITING_MODE_SELECTION;
				
			ELSIF gMainMachine.Commands.Automatic.Start THEN				
				MachineState.NextState := AUTO_WAITING_MODULES_READY;
				
			END_IF 
        
		AUTO_WAITING_MODULES_READY:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN	
				StartModules;
				gMainMachine.Feedbacks.NewCapOnWork := FALSE;
			END_IF
			
			IF NOT gMainMachine.Commands.Automatic.Start THEN
				MachineState.NextState := WAITING_MODE_SELECTION;
			
			ELSIF gColourSorter.Feedbacks.WaitingCap 
				AND gConveyor.Feedbacks.WaitingCap
				AND (gPuncher.Feedbacks.WaitingCap OR NOT gPuncher.Commands.Automatic.Start) 
				AND (gPickingStation.Outputs.Started OR NOT gMainMachine.Commands.LinkMode) THEN
				
				MachineState.NextState := AUTO_WAITING_CAP;				
			END_IF
			
		AUTO_WAITING_CAP:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				gConveyor.Commands.Automatic.DeliverCap := TRUE;
			END_IF
			
			IF gConveyor.Feedbacks.NewCapTrigger THEN
				gMainMachine.Feedbacks.NewCapOnWork := TRUE;
				gPuncher.Commands.Automatic.PunchCap := TRUE;
				MachineState.NextState := AUTO_DELIVERING_AND_PUNCHING_CAP;
			END_IF			
			
		AUTO_DELIVERING_AND_PUNCHING_CAP:	
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF NOT gPuncher.Feedbacks.WaitingCap THEN
				gPuncher.Commands.Automatic.PunchCap := FALSE;
			END_IF
							
			IF gPuncher.Commands.Automatic.Start THEN
					
				IF NOT gPuncher.Commands.Automatic.PunchCap AND gPuncher.Feedbacks.PunchCapDone THEN
					MachineState.NextState := AUTO_SORTING_CAP;
				END_IF
			
			ELSE					
				MachineState.NextState := AUTO_SORTING_CAP;
			END_IF
							
		AUTO_SORTING_CAP:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
						
			IF EDGEPOS(gColourSorter.Feedbacks.CapSorted) THEN
				gConveyor.Commands.Automatic.DeliverCap := FALSE;
				MachineState.NextState := AUTO_WAITING_MODULES_READY;
			END_IF
								
		ERROR:
			MachineState.TimeoutTimer.PT := T#0S; // Timeout disabled in this state
			IF MachineState.NewTriggerState THEN
				StopModules;
				gMainMachine.Commands.Reset := FALSE;
			END_IF
			
			IF gMainMachine.Commands.Reset THEN
				ResetModules;
			END_IF
			
			IF NOT MpAlarmXCheckReaction(gAlarmXCoreMpLink,'ERROR') 
				AND NOT gConveyor.Feedbacks.Error  
				AND NOT gColourSorter.Feedbacks.Error  
				AND NOT gPuncher.Feedbacks.Error 
				AND NOT gPickingStation.Outputs.Error THEN
				
				gMainMachine.Commands.Reset := FALSE;
				MachineState.NextState := WAITING_MODE_SELECTION;
			END_IF						 
        
		ELSE
			MachineState.NextState := WAITING_MODE_SELECTION;			
        
	END_CASE
    		
	FeedbacksUpdateAction;
	
	StatisticsAction;
	
END_PROGRAM

PROGRAM _EXIT
    
END_PROGRAM