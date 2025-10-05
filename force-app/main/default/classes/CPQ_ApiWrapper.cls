public class CPQ_ApiWrapper {
    
      public static Boolean debug = true;

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
    
    
    /** Mini Wrapper around SBQQ API METHODS */
    public static String read(String name, String uid) {
        return SBQQ.ServiceRouter.read(name, uid);
    }
    public static String load(String name, String uid, Object payload) {
        return loadStr(name, uid, JSON.serialize(payload));
    }
    public static String loadStr(String name, String uid, String payloadJson) {
        return SBQQ.ServiceRouter.load(name, uid, payloadJson);
    }
    public static String save(String name, Object model) {
        return saveStr(name, JSON.serialize(model));
    }
    public static String saveStr(String name, String modelJson) {
        return SBQQ.ServiceRouter.save(name, modelJson);
    }


}