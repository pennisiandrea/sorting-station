
TYPE
	AlarmsType : 	STRUCT 
		Commands : AlarmsCommandsType;
		Feedbacks : AlarmsFeedbacksType;
	END_STRUCT;
	AlarmsFeedbacksType : 	STRUCT 
		Pendings : UDINT;
	END_STRUCT;
	AlarmsCommandsType : 	STRUCT 
		Acknowledge : BOOL;
		AcknowledgeAll : BOOL;
		AlarmID : UINT;
	END_STRUCT;
END_TYPE
