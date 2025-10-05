public class CallProductEditApi {
    
    public static void callProductAdder(){
        // Step 1: Read the Quote (replace 'a0kXXXXXXXXXXXX' with your Quote Id)
        String quoteId = 'a0qWU000000Sjz9YAC'; // Example: real Quote Id
        String quoteRequestJSON = JSON.serialize(new Map<String, Object>{ 'ids' => new List<String>{quoteId} });
         // AddProductsContext ctx = new AddProductsContext(quote, products, groupKey);
       // System.debug('quoteRequestJSON:::::'+quoteRequestJSON);
        String quoteResponseJSON = SBQQ.ServiceRouter.load('SBQQ.QuoteAPI.QuoteProductAdder', null, quoteRequestJSON);
        List<QuoteModel> quoteModels = (List<QuoteModel>) JSON.deserialize(quoteResponseJSON, List<QuoteModel>.class);
        QuoteModel quoteModel = quoteModels[0]; // Assuming only one quote is fetched
        
        // Step 2: Read the Product (replace '01tXXXXXXXXXXXX' with your Product Id)
        String productId = '01tWU00000GM9iEYAT'; // Example: real Product Id
        String productRequestJSON = JSON.serialize(new Map<String, Object>{ 'ids' => new List<String>{productId} });
        String productResponseJSON = SBQQ.ServiceRouter.load('SBQQ.ProductAPI.ReadProduct', null, productRequestJSON);
        List<ProductModel> productModels = (List<ProductModel>) JSON.deserialize(productResponseJSON, List<ProductModel>.class);
        ProductModel productModel = productModels[0];
        
        // Step 3: Add the product to the quote
        List<ProductModel> productModelList = new List<ProductModel>();
        productModelList.add(productModel);
        
        ProductAdder adder = new ProductAdder();
        QuoteModel quoteWithProducts = adder.add(quoteModel, productModelList, 0);
        
        // Step 4: Debug the result
        System.debug('Updated Quote with Products: ' + JSON.serializePretty(quoteWithProducts));
        
    }
    
}