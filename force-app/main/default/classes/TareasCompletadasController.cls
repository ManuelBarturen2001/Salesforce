public with sharing class TareasCompletadasController {
    @AuraEnabled(cacheable=true)
    public static List<Task> getCompletedTasks( String contactId ) {
        return [SELECT Id, Subject, Status, WhoId
            FROM Task
            WHERE WhoId = :contactId];
    }
}