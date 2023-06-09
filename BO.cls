public with sharing class LUX_EmailMessageBO {
    private static LUX_EmailMessageBO instance = new LUX_EmailMessageBO();
    public static LUX_EmailMessageBO getInstance(){
        return instance;
    }
    public void verifyTask(List<EmailMessage> listEmailMessage) {
        system.debug('LUX_EmailMessageBO : verifyTask');

        Set<Id> setAccountId = new Set<Id>();
        List<EmailMessage> listEmailMessageAux = new List<EmailMessage>();
        Map<Id,List<Task>> mapListTaskByIdAccount = new Map<Id,List<Task>>();
        String accountKey = Schema.SObjectType.Account.getKeyPrefix();
        system.debug('AccountKey: '+accountKey);
        for (EmailMessage m : listEmailMessage) {
            system.debug('Email.RelatedToId : '+m.relatedtoId);
            if(String.valueOf(m.RelatedToId).startsWith(accountKey)){

                setAccountId.add(m.RelatedToId);
                listEmailMessageAux.add(m);
            }
        }

        if(setAccountId.isEmpty())  return;

        List<Task> listTask = [SELECT Id,WhatId FROM Task where whatId = :setAccountId and Subject like 'Email:%' and Subject like '%new \"Customer\"%'];
        
        if(listTask == null || listTask.isEmpty())  return;

        for(Task t : listTask) {
            if(mapListTaskByIdAccount.get(t.WhatId) == null)
                mapListTaskByIdAccount.put(t.WhatId, new List<Task>());

            mapListTaskByIdAccount.get(t.WhatId).add(t);
        }
        for (EmailMessage m : listEmailMessageAux) {
            if(mapListTaskByIdAccount.get(m.RelatedToId) != null && !mapListTaskByIdAccount.get(m.RelatedToId).isEmpty())
                m.addError('You cannot send this email because it was already sent.');
        }
    }
}
