/*trigger trg2 on Contact (after insert,after update)
{
        List<Contact> acclist = new List<Contact>();
        set<Id> accIdSet = new set<Id>();
        Set<Id> ContactIds = new Set<Id>();
    
        if(Trigger.IsUpdate)
        {
            for ( Contact s : trigger.new )
            {
                    if(s.AccountId != null)
                    accIdSet.add(s.AccountId);   
                    Contact oldcon = Trigger.oldMap.get(s.Id); 
                    if(oldcon.id != null)
                    ContactIds.add(oldcon.id);
                    System.debug('Contact Ids-->'+ContactIds);
                   
            }

            acclist=[select id, name,Account.name,Primary_Contact__c from Contact where AccountId IN : accIdSet AND Id NOT IN : ContactIds];
            
           system.debug('*******Update accList'+acclist);
            
            List<Contact> conlist=new List<Contact>();
            Contact c1=new Contact();

             if(checkRecursive.runOnce())
             {
                    for ( Contact s : Trigger.new)        
                    {         
                        if(s.Primary_Contact__c ==true)
                          {
                              for(Contact a :acclist)
                                  {
                                     a.Primary_Contact__c =false;
                                     c1=a;            
                                  }
                      
                                update c1; 
                          }  
                    }
                    update acclist;
              }
       }
        
        
      ////next is trigger for after insert
        
        
        if(Trigger.isInsert)
        {
             for ( Contact s : trigger.new )
             {
                 if(s.AccountId != null)
                 accIdSet.add(s.AccountId);   
                 Contact oldcon = Trigger.newMap.get(s.Id);       
                 if(oldcon.id != null)
                 ContactIds.add(oldcon.id);
       
             }

        acclist=[select id, name,Account.name,Primary_Contact__c from Contact where AccountId IN : accIdSet AND Id NOT IN : ContactIds];
        
        system.debug('*******AccList-->'+acclist);
        
        List<Contact> conlist=new List<Contact>();
        Contact c1=new Contact();

         if(checkRecursive.runOnce())
         {
            for ( Contact s : Trigger.new)
             {      
                 if(s.Primary_Contact__c ==true)
                  {
                       for(Contact a :acclist)
                          {
                                a.Primary_Contact__c =false;
                                c1=a;            
                          }
                       update c1; 
                    
                   }  
                    
             }
               update acclist;
          } 
        }
}*/
trigger trg2 on Contact(after Update)
{
    Set<Id> accIds = new Set<Id>();
    Set<Id> conIds = new Set<Id>();

    if(trigger.isAfter && trigger.isUpdate)
    {
        for(Contact con : trigger.new)
        {
            if(con.AccountId != null)
            {
                accIds.add(con.AccountId);
            }
            Contact oldCon = trigger.oldMap.get(con.Id);
            if(oldCon.Id != null)
            {
                conIds.add(oldCon.Id);
            }
        }

        List<Contact> conList = [Select Id,AccountId,Primary_Contact__c from Contact where AccountId IN : accIds and Id NOT IN : conIds];
        //Contact c1 = new Contact();
        List<Contact> conList2 = new List<Contact>();

        if(checkRecursive.runOnce())
        {
            for(Contact con : trigger.new)
            {
                if(con.Primary_Contact__c == true)
                {
                    for(Contact co : conList)
                    {
                        co.Primary_Contact__c = false;
                        conList2.add(co);
                    }
                        //update c1;
                }
            }
            update conList2;
        }
    }
}
