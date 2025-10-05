public class CPQ_API_Handler {
    
    // Method to make a POST request to Salesforce REST API to edit a quote
    public static string editAPI(String quoteId, String productId) {
        
        // Create HTTP request object
        HttpRequest req = new HttpRequest();
        
        // Set HTTP method to POST
        req.setMethod('POST');
        
        // Set the endpoint URL for the Salesforce REST API  "https://nextracker-dev-ed.develop.my.salesforce.com",
        req.setEndpoint('https://nextracker-dev-ed.develop.my.salesforce.com/services/apexrest/SBQQ/ServiceRouter');
        
        // Set request headers
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Authorization','Bearer '+'00DWU00000Mrwai!AQEAQHhVrwb7NbnRxiGB0JIfWMJyxb6vg_CZAItCfvpFjJR6IQToU.yUV3D6Lzi21Qs9.F9ooS4Wh20Cd6JX0Ej8ZjKjN37p');
        
        Map<String, Object> quoteRecord = new Map<String, Object>{
            'attributes' => new Map<String, Object>{
                'type' => 'SBQQ__Quote__c',
                    'url' => '/services/data/v59.0/sobjects/SBQQ__Quote__c/' + productId
                    },
                        'Name' => 'Q-00013',
                        'Id' => quoteId
                        };
                            
                            Map<String, Object> quoteLine = new Map<String, Object>{
                                'record' => new Map<String, Object>{
                                    'attributes' => new Map<String, Object>{
                                        'type' => 'SBQQ__QuoteLine__c'
                                            },
                                                'SBQQ__Product__c' => productId
                                                },
                                                    'productQuantityEditable' => true,
                                                    'productHasDimensions' => false,
                                                    'key' => 1,
                                                    'descriptionLocked' => false
                                                    };
                                                        
                                                        Map<String, Object> model = new Map<String, Object>{
                                                            'record' => quoteRecord,
                                                                'nextKey' => 2,
                                                                'netTotal' => 0.00,
                                                                'lineItems' => new List<Object>{ quoteLine }
                                                                   
                                                                    };
                                                                        
                                                                        Map<String, Object> finalPayload = new Map<String, Object>{
                                                                            'saver' => 'SBQQ.QuoteAPI.QuoteSaver',
                                                                                'model' => model
                                                                                };
                                                                                    
        String jsonBody = JSON.serialize(finalPayload);
        req.setBody(jsonBody);
        
        // Set the request body with the required parameters for quote modification
        // Set the timeout for the HTTP request
        req.setTimeout(120000);
        
        // Send the HTTP request and capture the response
        HttpResponse res = new Http().send(req);
        
        // Debug statements for response details
        System.debug(res.toString());
        System.debug(res.getBody());
        System.debug('res' + res);
        System.debug('Response body: ' + res.getBody());
        
        // Save the callout response to a custom field on the quote (Optional)
        SBQQ__Quote__c quote = [SELECT Id FROM SBQQ__Quote__c WHERE Id =: quoteId]; 
        //quote.ResponseRecieved__c = res.getBody();
        //quote.CPQ_API_Response__c = res.getBody();
        update quote;
        
        // Return the response body
        return res.getBody();
    }
    
}