public class CPQ_ChatGPT_Example {

    public static void updateQuoteName(Id quoteId, Date ExpirationDate) {
        try {
            // Step 1: Read the quote model using ServiceRouter
            String quoteJson = SBQQ.ServiceRouter.read('SBQQ.QuoteAPI.QuoteReader', quoteId);
            System.debug('Original Quote JSON: ' + quoteJson);

            // Step 2: Parse the JSON into a map
            Map<String, Object> quoteModel = (Map<String, Object>) JSON.deserializeUntyped(quoteJson);

            // Step 3: Modify the quote name
            quoteModel.put('SBQQ__ExpirationDate__c', ExpirationDate);

            // Step 4: Convert the modified model back to JSON
            String updatedQuoteJson = JSON.serialize(quoteModel);

            // Step 5: Save the updated model back to Salesforce
            String saveResponse = SBQQ.ServiceRouter.save('SBQQ.QuoteAPI.QuoteSaver', updatedQuoteJson);
            System.debug('Save Response: ' + saveResponse);

        } catch (Exception e) {
            System.debug('Error occurred: ' + e.getMessage());
        }
    
}

}