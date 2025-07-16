public with sharing class SeguimientoController {
    @AuraEnabled
    public static Map<String, Object> obtenerResumenSeguimientos(String contactoId) {
        Map<String, Object> resultado = new Map<String, Object>();

        // Seguimientos por etapa
        List<AggregateResult> etapas = [
            SELECT Etapa__c etapa, COUNT(Id) total
            FROM Seguimiento__c
            WHERE Contact__c = :contactoId
            GROUP BY Etapa__c
        ];

        Map<String, Integer> conteoEtapas = new Map<String, Integer>();
        for (AggregateResult ar : etapas) {
            String etapa = (String) ar.get('etapa');
            Integer total = (Integer) ar.get('total');
            conteoEtapas.put(etapa, total);
        }

        // Último seguimiento
        Seguimiento__c ultimo = [
            SELECT Name, Clima_Actual__c
            FROM Seguimiento__c
            WHERE Contact__c = :contactoId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        resultado.put('etapas', conteoEtapas);
        resultado.put('nombreUltimoSeguimiento', ultimo.Name);
        resultado.put('clima', ultimo.Clima_Actual__c);

        return resultado;
    }
}
