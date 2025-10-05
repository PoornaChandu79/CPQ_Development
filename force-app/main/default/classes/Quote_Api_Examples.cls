public class Quote_Api_Examples {
    
    public static Boolean debug = false;
    
    /** CPQ API METHODS */
        public static final String CONTRACT_RENEWER = 'SBQQ.ContractManipulationAPI.ContractRenewer';
        public static final String CONTRACT_AMENDER = 'SBQQ.ContractManipulationAPI.ContractAmender';
        
        public static final String CONFIG_LOADER = 'SBQQ.ConfigAPI.ConfigLoader';
        public static final String LOAD_RULE_EXECUTOR = 'SBQQ.ConfigAPI.LoadRuleExecutor';
        public static final String CONFIGURATION_VALIDATOR = 'SBQQ.ConfigAPI.ConfigurationValidator';
        
        public static final String PRODUCT_LOADER = 'SBQQ.ProductAPI.ProductLoader';
        public static final String PRODUCT_SUGGESTER = 'SBQQ.ProductAPI.ProductSuggester';
        public static final String PRODUCT_SEARCHER = 'SBQQ.ProductAPI.ProductSearcher';
        
        public static final String QUOTE_READER = 'SBQQ.QuoteAPI.QuoteReader';
        public static final String QUOTE_PRODUCT_ADDER = 'SBQQ.QuoteAPI.QuoteProductAdder';
        public static final String QUOTE_CALCULATOR = 'SBQQ.QuoteAPI.QuoteCalculator';
        public static final String QUOTE_SAVER = 'SBQQ.QuoteAPI.QuoteSaver';
        
        
    
    // get QuoteModel using QuoteId
    public static CPQ_ApiDataModels.QuoteModel getQuoteModel(Id QuoteId){
        String jsonResult = CPQ_ApiWrapper.read(CPQ_ApiWrapper.QUOTE_READER, (String) quoteId);
        System.debug('jsonResult:::'+jsonResult);
        CPQ_ApiDataModels.QuoteModel quoteModel = (CPQ_ApiDataModels.QuoteModel)JSON.deserialize(jsonResult,CPQ_ApiDataModels.QuoteModel.class);
        System.debug('::::quoteModel:::'+ quoteModel);
       
        return quoteModel;
    }
    
    
    
    
    
    // load or get product using productid,pricebookid,currencyCode
    public static CPQ_ApiDataModels.ProductModel loadProduct(id productId, id pricebookId, String currencyCode){
        CPQ_ApiDataModels.ProductLoadContext productLoadPayLoad   = new CPQ_ApiDataModels.ProductLoadContext(pricebookId,currencyCode);
        System.debug('::::productLoadPayLoad::::::'+productLoadPayLoad);
       
        String jsonResult = CPQ_ApiWrapper.load(CPQ_ApiWrapper.PRODUCT_LOADER, (String)productId, productLoadPayLoad); 
       CPQ_ApiDataModels.ProductModel productModel = (CPQ_ApiDataModels.ProductModel)JSON.deserialize(jsonResult,CPQ_ApiDataModels.ProductModel.class);
        
        System.debug('::::jsonResult::::::'+jsonResult);
        return productModel;
    }
    
    public static CPQ_ApiDataModels.ProductModel setOptionsConfigured(CPQ_ApiDataModels.ProductModel productModel) {
        if(productModel.configuration != null){
            productModel.configuration.configured = true;
            productModel.configuration.configurationEntered = true;
            for(CPQ_ApiDataModels.ConfigurationModel configModel : productModel.configuration.optionConfigurations) {
                configModel.configured = true;
                configModel.configurationEntered = true;
            }
            return productModel;
        }else{return productModel;}
        
    }
    
    ///// Addproduct to existing Quote
    public static CPQ_ApiDataModels.QuoteModel addProducts(Id productId, Id QuoteId, Id PriceBookId, string currencyCode, Boolean skipCalculateQuote){
        CPQ_ApiDataModels.productModel productModel =loadProduct(productId,PriceBookId,currencyCode);
        setOptionsConfigured(productModel);
        // just to read quote data
         String jsonResultQuote = CPQ_ApiWrapper.read(CPQ_ApiWrapper.QUOTE_READER, (String) quoteId);
        CPQ_ApiDataModels.QuoteModel initialQuoteModel = (CPQ_ApiDataModels.QuoteModel) JSON.deserialize(jsonResultQuote, CPQ_ApiDataModels.QuoteModel.class);
        if(debug) {
            System.debug(LoggingLevel.WARN, 'jsonResultQuote: ' + jsonResultQuote);
            System.debug(LoggingLevel.WARN, 'initialQuoteModel: ' + initialQuoteModel);
        }

        CPQ_ApiDataModels.ProductAddContext productAddPayload = new CPQ_ApiDataModels.ProductAddContext(skipCalculateQuote, initialQuoteModel, new List<CPQ_ApiDataModels.ProductModel>{productModel});
        System.debug('::::productAddPayload 91:::: ' + productAddPayload);

        return addProductsToQuote(productAddPayload);
    }
    
    public static CPQ_ApiDataModels.QuoteModel addProductsToQuote(CPQ_ApiDataModels.ProductAddContext productAddPayload) {
        
        if(debug) {
            System.debug(LoggingLevel.WARN, 'productAddPayloadJSON: ' + JSON.serialize(productAddPayload));
        }
        String updatedQuoteJSON = CPQ_ApiWrapper.load(CPQ_ApiWrapper.QUOTE_PRODUCT_ADDER, null, productAddPayload);
        CPQ_ApiDataModels.QuoteModel updatedQuoteModel = (CPQ_ApiDataModels.QuoteModel) JSON.deserialize(updatedQuoteJSON, CPQ_ApiDataModels.QuoteModel.class);
        if(debug) {
            System.debug(LoggingLevel.WARN, 'updatedQuoteJSON: ' + updatedQuoteJSON);
            System.debug(LoggingLevel.WARN, 'updatedQuoteModel: ' + updatedQuoteModel);
        }
        // calcualte quote
        CPQ_ApiDataModels.QuoteModel quoteModelCal = calculateQuote(updatedQuoteModel);
        // save quote to db
        CPQ_ApiDataModels.QuoteModel savedQuoteModel = saveQuote(quoteModelCal);
        return savedQuoteModel;
    }

     public static CPQ_ApiDataModels.QuoteModel calculateQuote(CPQ_ApiDataModels.QuoteModel quoteModel) {
        CPQ_ApiDataModels.CalculatorContext calculatorPayload = new CPQ_ApiDataModels.CalculatorContext(quoteModel);

        String updatedQuoteJSON =  CPQ_ApiWrapper.load(QUOTE_CALCULATOR, null, calculatorPayload);
                  System.debug('::::updatedQuoteJSON:::: ' + updatedQuoteJSON);

        CPQ_ApiDataModels.QuoteModel updatedQuoteModel = (CPQ_ApiDataModels.QuoteModel) JSON.deserialize(updatedQuoteJSON, CPQ_ApiDataModels.QuoteModel.class);
        if(debug) {
            System.debug(LoggingLevel.WARN, 'updatedQuoteJSON: ' + updatedQuoteJSON);
            System.debug(LoggingLevel.WARN, 'updatedQuoteModel: ' + updatedQuoteModel);
        }
        
         System.debug('::::updatedQuoteModel:::: ' + updatedQuoteModel);

        return updatedQuoteModel;
    }


    public static CPQ_ApiDataModels.QuoteModel saveQuote(CPQ_ApiDataModels.QuoteModel quoteModel) {
        String savedQuoteJSON =  CPQ_ApiWrapper.save(QUOTE_SAVER, quoteModel);

        CPQ_ApiDataModels.QuoteModel updatedQuoteModel = (CPQ_ApiDataModels.QuoteModel) JSON.deserialize(savedQuoteJSON, CPQ_ApiDataModels.QuoteModel.class);
        if(debug) {
            System.debug(LoggingLevel.WARN, 'updatedQuoteModel: ' + updatedQuoteModel);
        }

        return updatedQuoteModel;
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}