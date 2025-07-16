public with sharing class ClimaController {
    @future(callout=true)
    public static void obtenerClimaAsync(Id seguimientoId, String ciudad) {
        try {
            String apiKey = 'be851db2baf0b3a595341e9d27493b55'; 
            String ciudadEncoded = EncodingUtil.urlEncode(ciudad, 'UTF-8');
            String endpoint = 'https://api.openweathermap.org/data/2.5/weather?q=' + ciudadEncoded + '&appid=' + apiKey + '&units=metric&lang=es';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> resultado = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> main = (Map<String, Object>) resultado.get('main');
                Decimal temperatura = (Decimal) main.get('temp');

                List<Object> weatherList = (List<Object>) resultado.get('weather');
                Map<String, Object> weather = (Map<String, Object>) weatherList[0];
                String descripcion = ((String) weather.get('description')).toLowerCase();

                // 🌤️ Añadir emoji según descripción
                String icono = '';
                if (descripcion.contains('nube')) icono = '☁️';
                else if (descripcion.contains('lluvia')) icono = '🌧️';
                else if (descripcion.contains('tormenta')) icono = '⛈️';
                else if (descripcion.contains('despejado')) icono = '☀️';
                else if (descripcion.contains('niebla')) icono = '🌫️';
                else icono = '🌡️';

                String climaCompleto = icono + ' ' + temperatura + '°C - ' + descripcion;

                Seguimiento__c s = [SELECT Id FROM Seguimiento__c WHERE Id = :seguimientoId LIMIT 1];
                s.Clima_Actual__c = climaCompleto;
                update s;
            }
        } catch (Exception e) {
            System.debug('Error al obtener clima: ' + e.getMessage());
        }
    }

}
