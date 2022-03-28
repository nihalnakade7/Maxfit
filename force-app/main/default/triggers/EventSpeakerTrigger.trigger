trigger EventSpeakerTrigger on Event_Speaker__c (before insert, before update) {
	Set<Id> speakerIdsSet = new Set<Id>();
    Set<Id> eventIdsSet = new Set<Id>();
    
    for(Event_Speaker__c es: Trigger.New) {
        speakerIdsSet.add(es.Speaker__c);
        eventIdsSet.add(es.Event__c);
    }
    
    Map<Id, DateTime> requestedEvents = new Map<Id, DateTime>();
    List<Event__c> relatedEventList = [Select Id, Start_DateTime_c__c from Event__c where Id IN :eventIdsSet];
    
    for(Event__c evt : relatedEventList) {
        requestedEvents.put(evt.Id, evt.Start_DateTime_c__c);
    }  
    
    List<Event_Speaker__c> relatedEventSpeakerList = [SELECT Id, Event__c,Speaker__c, Event__r.Start_DateTime_c__c
                                                     FROM Event_Speaker__c WHERE Speaker__c IN :speakerIdsSet ];
    
    for(Event_Speaker__c es : Trigger.New) {
        DateTime bookingTime = requestedEvents.get(es.Event__c); 
        for(Event_Speaker__c es1 : relatedEventSpeakerList) {
            if(es1.Speaker__c == es.Speaker__c && es1.Event__r.Start_DateTime_c__c == bookingTime ) {
                es.Speaker__c.addError('The Speaker is already booked at that time');
            }
        }
    }
    
}