trigger ContactAsyncTrigger on ContactChangeEvent (after insert) {
	System.debug('The Trigger Operations is:'+Trigger.operationType);
}