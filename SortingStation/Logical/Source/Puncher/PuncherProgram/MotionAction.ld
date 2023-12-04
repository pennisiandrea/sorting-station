ACTION MotionAction: 
<?xml version="1.0"?>
<?AutomationStudio FileVersion="4.9"?>
<!-- Automation Studio Generated XML Section -->
<networks xmlns:dt="urn:schemas-microsoft-com:datatypes" maxcolumn="0">
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<line/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gPuncher.Parameters.Acceleration"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="Internal.Parameters.Deceleration"/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<line/>
			<function position="top" type="MOVE"><input name="EN" extensible="true" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gPuncher.Parameters.Acceleration"/>
			<function position="bottom" type="MOVE"><input name="" extensible="true"/><output name="40"/></function>
			<analog type="output" name="Internal.Parameters.Acceleration"/>
		</row>
	</network>
	<network label="" comment="" row="20" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="Internal.Axis" type="MpAxisBasic"/>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="top" type="MpAxisBasic"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAxisPuncherMpLink"/>
			<functionblock position="middle" type="MpAxisBasic"><input name="MpLink" vardynamic="true"/><output name="Active"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gPuncher.Commands.Enable"/>
			<line/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Enable"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<contact type="open" name="gPuncher.Commands.Reset"/>
			<line/>
			<functionblock position="middle" type="MpAxisBasic"><input name="ErrorReset"/><output name="StatusID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="Internal.Parameters"/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Parameters" vardynamic="true"/><output name="UpdateDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Update"/><output name="Position"/></functionblock>
			<analog type="output" name="gPuncher.Interface.Outputs.SetPosition"/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Power"/><output name="Velocity"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Home"/><output name="CommandBusy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="MoveVelocity"/><output name="CommandAborted"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="MoveAbsolute"/><output name="PowerOn"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="MoveAdditive"/><output name="IsHomed"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Stop"/><output name="InVelocity"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="JogPositive"/><output name="InPosition"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="JogNegative"/><output name="MoveActive"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="LimitLoad"/><output name="MoveDone"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="ReleaseBrake"/><output name="Stopped"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="Simulate"/><output name="LimitLoadReady"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MpAxisBasic"><input name="AutoTune"/><output name="BrakeReleased"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MpAxisBasic"><output name="Info"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="17" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="Internal.Cam" type="MC_BR_CamAutomatCommand"/>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="top" type="MC_BR_CamAutomatCommand"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAxisPuncherMpLink"/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="Slave" vardynamic="true"/><output name="Valid"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="Enable"/><output name="Busy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="Internal.Parameters.Deceleration"/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="Deceleration"/><output name="CommandAborted"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="Start"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="Stop"/><output name="ErrorID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="Restart"/><output name="Running"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="EndAutomat"/><output name="StandBy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="Internal.CamStartTrigger"/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="SetSignal1"/><output name="ActualStateIndex"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="SetSignal2"/><output name="ActualStateCamIndex"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="SetSignal3"/><output name="InCam"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="SetSignal4"/><output name="InCompensation"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="ResetSignal1"/><output name="Ready"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="ResetSignal2"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_CamAutomatCommand"><input name="ResetSignal3"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MC_BR_CamAutomatCommand"><input name="ResetSignal4"/></functionblock>
			<empty/>
		</row>
	</network>
	<network label="" comment="" row="2" column="0" commented="0">
		<row>
			<line/>
			<function position="top" type="REAL_TO_LREAL"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></function>
			<empty/>
		</row>
		<row>
			<analog type="input" name="gPuncher.Parameters.Offset"/>
			<function position="bottom" type="REAL_TO_LREAL"><input name="IN"/><output name="14"/></function>
			<analog type="output" name="Internal.Offset.OffsetShift"/>
		</row>
	</network>
	<network label="" comment="" row="9" column="0" commented="0">
		<row>
			<empty/>
			<empty/>
			<functionblock position="header" name="Internal.Offset" type="MC_BR_Offset"/>
			<empty/>
		</row>
		<row>
			<line/>
			<line/>
			<functionblock position="top" type="MC_BR_Offset"><input name="EN" ENO="true"/><output name="ENO" ENO="true"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<contact type="address" name="gAxisPuncherMpLink"/>
			<functionblock position="middle" type="MC_BR_Offset"><input name="Slave" vardynamic="true"/><output name="Valid"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_Offset"><input name="Enable"/><output name="Busy"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_Offset"><input name="OffsetShift"/><output name="Error"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="Internal.Parameters.Velocity"/>
			<functionblock position="middle" type="MC_BR_Offset"><input name="Velocity"/><output name="ErrorID"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<analog type="input" name="Internal.Parameters.Acceleration"/>
			<functionblock position="middle" type="MC_BR_Offset"><input name="Acceleration"/><output name="ShiftAttained"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="middle" type="MC_BR_Offset"><input name="AdvancedParameters"/><output name="ShiftStarted"/></functionblock>
			<empty/>
		</row>
		<row>
			<empty/>
			<empty/>
			<functionblock position="bottom" type="MC_BR_Offset"><input name="StartShift"/><output name="ActualOffsetShift"/></functionblock>
			<empty/>
		</row>
	</network>
</networks>
END_ACTION































