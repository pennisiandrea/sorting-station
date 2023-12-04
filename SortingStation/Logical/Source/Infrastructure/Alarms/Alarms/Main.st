
PROGRAM _INIT
	// This program is used to manage the machine alarms. Alarms are set/reset in the modules.
	
	MpAlarmXCoreFB(MpLink := ADR(gAlarmXCoreMpLink), Enable := TRUE);	
	
	MpAlarmXHistoryFB(MpLink := ADR(gAlarmXHistoryMpLink), Enable := TRUE, DeviceName := ADR('ALARMS'));
	
	MpAlarmXListUIFB(MpLink :=  ADR(gAlarmXCoreMpLink), Enable := TRUE, UIConnect := ADR(MpAlarmXListUIConnect));
	
END_PROGRAM

PROGRAM _CYCLIC
	MpAlarmXCoreFB();
			
	MpAlarmXHistoryFB();
	
	MpAlarmXListUIConnect.AcknowledgeAll := gMainMachine.Commands.Reset;
	MpAlarmXListUIFB();
	
	gAlarms.Feedbacks.Pendings := MpAlarmXCoreFB.PendingAlarms;
			
END_PROGRAM

PROGRAM _EXIT
	MpAlarmXCoreFB.Enable := FALSE;
	MpAlarmXCoreFB();
		
	MpAlarmXHistoryFB.Enable := FALSE;
	MpAlarmXHistoryFB();
		
	MpAlarmXListUIFB.Enable := FALSE;
	MpAlarmXListUIFB();
			 
END_PROGRAM

