ACTION AutomaticPageAction: 
			
	// Link button
	IF gMainMachine.Feedbacks.WaitModeSelection 
		OR gMainMachine.Feedbacks.Error 
		OR gMainMachine.Feedbacks.WaitingInit 
		OR gMainMachine.Feedbacks.WaitingStart 
		OR gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.AutomaticPage.LinkButtonEnable := TRUE;
		gMainMachine.Commands.LinkMode := gHMI.AutomaticPage.LinkButton;
	ELSE
		gHMI.AutomaticPage.LinkButtonEnable := FALSE;
	END_IF	
		
	// Recipes
	IF gMainMachine.Feedbacks.WaitModeSelection 
		OR gMainMachine.Feedbacks.Error 
		OR gMainMachine.Feedbacks.WaitingInit 
		OR gMainMachine.Feedbacks.WaitingStart 
		OR gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.AutomaticPage.RecipesEnable := TRUE; 
	
	ELSE
		gHMI.AutomaticPage.RecipesEnable := FALSE; 
	END_IF
	
	// Auto button
	IF gMainMachine.Feedbacks.WaitModeSelection OR NOT gMainMachine.Feedbacks.Started THEN
	
		gHMI.AutomaticPage.AutoButtonEnable := TRUE;
		gMainMachine.Commands.Automatic.Enable := gHMI.AutomaticPage.AutoButton;
	ELSE
		gHMI.AutomaticPage.AutoButtonEnable := FALSE;
	END_IF
	IF EDGEPOS(gMainMachine.Commands.Automatic.Enable) THEN
		gHMI.ManualPage.ManualButton := FALSE;
	END_IF
	
	// Init button
	IF gMainMachine.Feedbacks.WaitingInit THEN
	
		gHMI.AutomaticPage.InitButtonEnable := TRUE;
	ELSE
		gHMI.AutomaticPage.InitButtonEnable := FALSE;
		gHMI.AutomaticPage.InitButton := FALSE;
	END_IF
	gMainMachine.Commands.Automatic.Init := gHMI.AutomaticPage.InitButton;

		
	// Start button
	IF gMainMachine.Feedbacks.WaitingStart THEN
		
		gHMI.AutomaticPage.StartButtonEnable := TRUE;
		gHMI.AutomaticPage.StopButtonVisibility := FALSE;		
		
	ELSIF gMainMachine.Feedbacks.Started AND gMainMachine.Commands.Automatic.Start THEN		
	
		gHMI.AutomaticPage.StartButtonEnable := FALSE;
		gHMI.AutomaticPage.StopButtonVisibility := TRUE;			
	ELSE
		gHMI.AutomaticPage.StartButtonEnable := FALSE;
		gHMI.AutomaticPage.StopButtonVisibility := FALSE;
		gHMI.AutomaticPage.StartButton := FALSE;
	END_IF	
	gMainMachine.Commands.Automatic.Start := gHMI.AutomaticPage.StartButton;

	
	// Conveyor speed slider button
	IF gHMI.AutomaticPage.ConveyorSpeed = 0 THEN
		gHMI.AutomaticPage.ConveyorSpeed := gConveyor.Parameters.TargetSpeed;
	END_IF
	IF NOT gMainMachine.Feedbacks.Started THEN
		gHMI.AutomaticPage.ConveyorSpeedEnable := TRUE;
		gConveyor.Parameters.TargetSpeed := gHMI.AutomaticPage.ConveyorSpeed;
		gPickingStation.Inputs.ConveyorSpeed := gHMI.AutomaticPage.ConveyorSpeed; 
	ELSE
		gHMI.AutomaticPage.ConveyorSpeedEnable := FALSE;
	END_IF
	
	// Ready to start
	gHMI.AutomaticPage.ReadyToStartVisibility := gMainMachine.Feedbacks.WaitingStart AND gPickingStation.Outputs.WaitingStart;
	
	// Clear statistics button	
	IF NOT gMainMachine.Feedbacks.ClearStatsDone THEN
		gMainMachine.Commands.ClearStats := gHMI.AutomaticPage.ClearStats;
	ELSE
		gMainMachine.Commands.ClearStats := FALSE;
		gHMI.AutomaticPage.ClearStats := FALSE;
	END_IF
	IF NOT gPickingStation.Outputs.ClearStatsDone THEN
		gPickingStation.Inputs.ClearStats := gHMI.AutomaticPage.ClearStats;
	ELSE
		gPickingStation.Inputs.ClearStats := FALSE;
	END_IF
	
	// Statistics	
	gHMI.AutomaticPage.CapsCounter := gMainMachine.Statistics.CapsCounter;
	gHMI.AutomaticPage.CurrentCapWorkingTime := TIME_TO_UDINT(gMainMachine.Statistics.CurrentCapWorkingTime);
	gHMI.AutomaticPage.LastCapWorkedTime := TIME_TO_UDINT(gMainMachine.Statistics.LastCapWorkingTime);
	gHMI.AutomaticPage.AvgCapWorkTime := TIME_TO_UDINT(gMainMachine.Statistics.AverageCapWorkingTime);
		
	// Puncher offset slider button
	gHMI.AutomaticPage.PuncherOffsetEnable := TRUE;
	gPuncher.Parameters.Offset := gHMI.AutomaticPage.PuncherOffset;
			
	// Puncher inclusion
	gHMI.AutomaticPage.PuncherIncludedCheckboxEnable := TRUE;
	gMainMachine.Parameters.PuncherEnable := gHMI.AutomaticPage.PuncherIncludedCheckbox;
	
	// Stamper offset slider button
	gHMI.AutomaticPage.StamperOffsetEnable := gMainMachine.Feedbacks.LinkOk;
	gPickingStation.Inputs.StampOffset := gHMI.AutomaticPage.StamperOffset;
		
	// Stamper inclusion
	gHMI.AutomaticPage.StamperIncludedCheckboxEnable := gMainMachine.Feedbacks.LinkOk;
	gPickingStation.Inputs.StampIncluded := gHMI.AutomaticPage.StamperIncludedCheckbox;
	
END_ACTION

	
ACTION HeaderContentAction: 
	
	gHMI.HeaderContent.PendingAlarms := UDINT_TO_STRING(MIN(999,gAlarms.Feedbacks.Pendings));
	
	gHMI.HeaderContent.SlaveConnectionOk := gMainMachine.Feedbacks.LinkOk;
	
	gHMI.HeaderContent.StateWaitModeSelection := gMainMachine.Feedbacks.WaitModeSelection;
	gHMI.HeaderContent.StateManual := gMainMachine.Feedbacks.ManualMode;
	gHMI.HeaderContent.StatePunchingCap := gMainMachine.Feedbacks.PunchingCap;
	gHMI.HeaderContent.StateDeliveringCap := gMainMachine.Feedbacks.DeliveringCap AND NOT gMainMachine.Feedbacks.PunchingCap;
	gHMI.HeaderContent.StateError := gMainMachine.Feedbacks.Error;
	gHMI.HeaderContent.StateInitializing := gMainMachine.Feedbacks.Initializing;
	gHMI.HeaderContent.StateWaitingModulesReady := gMainMachine.Feedbacks.WaitingModulesReady;
	gHMI.HeaderContent.StateWaitingStart := gMainMachine.Feedbacks.WaitingStart;
	gHMI.HeaderContent.StateWaitingInit := gMainMachine.Feedbacks.WaitingInit;
	gHMI.HeaderContent.StateWaitingCap := gMainMachine.Feedbacks.WaitingCap;
	
END_ACTION

ACTION ManualPageAction: 
	
	// Manual button
	IF gMainMachine.Feedbacks.WaitModeSelection OR NOT gMainMachine.Feedbacks.Started THEN
	
		gHMI.ManualPage.ManualButtonEnable := TRUE;
		gMainMachine.Commands.Manual.Enable := gHMI.ManualPage.ManualButton;
	ELSE
		gHMI.ManualPage.ManualButtonEnable := FALSE;
	END_IF
	IF EDGEPOS(gMainMachine.Commands.Manual.Enable) THEN
		gHMI.AutomaticPage.AutoButton := FALSE;
	END_IF
	
	// Stopper forward button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.StopperForwardButtonEnable := NOT gColourSorter.Interface.Inputs.CapAtExitPosition;
		gColourSorter.Commands.Manual.StopperForward := gHMI.ManualPage.StopperForwardButton;

	ELSE
		gHMI.ManualPage.StopperForwardButtonEnable := FALSE;
		gHMI.ManualPage.StopperForwardButton := FALSE;
	END_IF
	
	// Lane 1 forward button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.Lane1ForwardButtonEnable := TRUE;
		gColourSorter.Commands.Manual.Lane1Forward := gHMI.ManualPage.Lane1ForwardButton;

	ELSE
		gHMI.ManualPage.Lane1ForwardButtonEnable := FALSE;
		gHMI.ManualPage.Lane1ForwardButton := FALSE;
	END_IF
	
	// Lane 2 forward button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.Lane2ForwardButtonEnable := TRUE;
		gColourSorter.Commands.Manual.Lane2Forward := gHMI.ManualPage.Lane2ForwardButton;

	ELSE
		gHMI.ManualPage.Lane2ForwardButtonEnable := FALSE;
		gHMI.ManualPage.Lane2ForwardButton := FALSE;
	END_IF
	
	// Conveyor home button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.ConveyorHomeButtonEnable := TRUE;
		gConveyor.Commands.Manual.Home := gHMI.ManualPage.ConveyorHomeButton;

	ELSE
		gHMI.ManualPage.ConveyorHomeButtonEnable := FALSE;
		gHMI.ManualPage.ConveyorHomeButton := FALSE;
	END_IF
	gHMI.ManualPage.ConveyorAxisHomed := gConveyor.Feedbacks.AxisHomed;
	
	// Conveyor power button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.ConveyorPowerButtonEnable := gConveyor.Feedbacks.AxisHomed;
		gConveyor.Commands.Manual.PowerOn := gHMI.ManualPage.ConveyorPowerButton;

	ELSE
		gHMI.ManualPage.ConveyorPowerButtonEnable := FALSE;
		gHMI.ManualPage.ConveyorPowerButton := FALSE;
	END_IF
	gHMI.ManualPage.ConveyorAxisPowered := gConveyor.Feedbacks.AxisPowered;
	
	// Conveyor move button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.ConveyorMoveButtonEnable := gConveyor.Feedbacks.AxisHomed AND gConveyor.Feedbacks.AxisPowered AND (gConveyor.Commands.Manual.Speed>0 OR NOT gConveyor.Interface.Inputs.CapInStartPosition);
		gConveyor.Commands.Manual.Move := gHMI.ManualPage.ConveyorMoveButton;

	ELSE
		gHMI.ManualPage.ConveyorMoveButtonEnable := FALSE;
		gHMI.ManualPage.ConveyorMoveButton := FALSE;
	END_IF
		
	// Conveyor speed
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.ConveyorSpeedEnable := NOT gConveyor.Commands.Manual.Move;
		gConveyor.Commands.Manual.Speed := gHMI.ManualPage.ConveyorSpeed;
		
	ELSE
		gHMI.ManualPage.ConveyorSpeedEnable := FALSE;
		gHMI.ManualPage.ConveyorSpeed := gConveyor.Commands.Manual.Speed;
	END_IF
		
	// Conveyor acceleration
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.ConveyorAccelerationEnable := NOT gConveyor.Commands.Manual.Move;
		gConveyor.Parameters.Acceleration := gHMI.ManualPage.ConveyorAcceleration;
	ELSE
		gHMI.ManualPage.ConveyorAccelerationEnable := FALSE;
		gHMI.ManualPage.ConveyorAcceleration := gConveyor.Parameters.Acceleration;
	END_IF
	
	// Puncher home button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherHomeButtonEnable := TRUE;
		gPuncher.Commands.Manual.Home := gHMI.ManualPage.PuncherHomeButton;

	ELSE
		gHMI.ManualPage.PuncherHomeButtonEnable := FALSE;
		gHMI.ManualPage.PuncherHomeButton := FALSE;
	END_IF
	gHMI.ManualPage.PuncherAxisHomed := gPuncher.Feedbacks.AxisHomed;
	
	// Puncher power button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherPowerButtonEnable := gPuncher.Feedbacks.AxisHomed;
		gPuncher.Commands.Manual.PowerOn := gHMI.ManualPage.PuncherPowerButton;

	ELSE
		gHMI.ManualPage.PuncherPowerButtonEnable := FALSE;
		gHMI.ManualPage.PuncherPowerButton := FALSE;
	END_IF
	gHMI.ManualPage.PuncherAxisPowered := gPuncher.Feedbacks.AxisPowered;
	
	// Puncher move button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherMoveButtonEnable := gPuncher.Feedbacks.AxisHomed AND gPuncher.Feedbacks.AxisPowered;
		gPuncher.Commands.Manual.Move := gHMI.ManualPage.PuncherMoveButton;

	ELSE
		gHMI.ManualPage.PuncherMoveButtonEnable := FALSE;
		gHMI.ManualPage.PuncherMoveButton := FALSE;
	END_IF
		
	// Puncher speed 
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherSpeedEnable := NOT gPuncher.Commands.Manual.Move;
		gPuncher.Commands.Manual.Speed := gHMI.ManualPage.PuncherSpeed;
		
	ELSE
		gHMI.ManualPage.PuncherSpeedEnable := FALSE;
		gHMI.ManualPage.PuncherSpeed := gPuncher.Commands.Manual.Speed;
	END_IF
				
	// Puncher acceleration
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherAccelerationEnable := NOT gConveyor.Commands.Manual.Move;
		gPuncher.Parameters.Acceleration := gHMI.ManualPage.PuncherAcceleration;
	ELSE
		gHMI.ManualPage.PuncherAccelerationEnable := FALSE;
		gHMI.ManualPage.PuncherAcceleration := gPuncher.Parameters.Acceleration;
	END_IF
	
	// Puncher position slider button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherPositionEnable := NOT gPuncher.Commands.Manual.Move;
		gPuncher.Commands.Manual.Position := gHMI.ManualPage.PuncherPosition;
		
	ELSE
		gHMI.ManualPage.PuncherPositionEnable := FALSE;
		gHMI.ManualPage.PuncherPosition := gPuncher.Commands.Manual.Position;
	END_IF
	
	// Puncher punch button
	IF gMainMachine.Feedbacks.ManualMode THEN
		
		gHMI.ManualPage.PuncherForwardButtonEnable := TRUE;
		gPuncher.Commands.Manual.PuncherForward := gHMI.ManualPage.PuncherForwardButton;
		
	ELSE
		gHMI.ManualPage.PuncherForwardButtonEnable := FALSE;
	END_IF
	
	// Sensors
	gHMI.ManualPage.ColourSorterInterface:= gColourSorter.Interface;
	gHMI.ManualPage.ConveyorInterface := gConveyor.Interface;
	gHMI.ManualPage.PuncherInterface := gPuncher.Interface;
	
	// Motion Feedback
	gHMI.ManualPage.ConveyorActPosition := gConveyor.Feedbacks.AxisPosition;
	gHMI.ManualPage.ConveyorActSpeed := gConveyor.Feedbacks.AxisSpeed;
	
	gHMI.ManualPage.PuncherActPosition := gPuncher.Feedbacks.AxisPosition;
	gHMI.ManualPage.PuncherActSpeed := gPuncher.Feedbacks.AxisSpeed;
	
END_ACTION
