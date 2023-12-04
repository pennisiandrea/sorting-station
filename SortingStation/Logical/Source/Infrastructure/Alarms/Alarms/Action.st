
ACTION AcknowledgeManagement: 
	
	IF gAlarms.Commands.Acknowledge THEN
		MpAlarmXAcknowledgeID(gAlarmXCoreMpLink, gAlarms.Commands.AlarmID);
	END_IF
	
	MpAlarmXListUIConnect.AcknowledgeAll := gAlarms.Commands.AcknowledgeAll;
		
	IF gAlarms.Commands.Acknowledge OR gAlarms.Commands.AcknowledgeAll THEN
		gMainMachine.Commands.Reset := TRUE;
		gPickingStation.Inputs.Reset := gMainMachine.Feedbacks.LinkOk;
		gAlarms.Commands.AcknowledgeAll := FALSE;
		gAlarms.Commands.Acknowledge := FALSE;
	END_IF
	
END_ACTION
