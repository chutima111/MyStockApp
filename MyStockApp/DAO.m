//
//  DAO.m
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "DAO.h"


@implementation DAO

+(DAO *)sharedInstance
{
    static DAO *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DAO alloc]init];
    });
    
    return sharedInstance;
    
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        //custom initializer
        [self createCoreData];
    }
    return self;
}

#pragma mark core data

-(void) createCoreData
{
    // 1. Create  ObjectModel
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    
    // 2. Create context
    NSString *path = [self archivePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    
    NSLog(@"%@", path);
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    
    if (error) {
        NSLog(@"%@",error);
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    // Add an undo manager
    _managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    
    // 3. Now the context points to the SQLite store
    [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    
    //try to load from core data
    [self reloadDataFromContext];
}

// Physical storage location in device
-(NSString *)archivePath
{
    NSArray *documentsDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsDirectories objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"NavCtrl.data"];
}

-(void)reloadDataFromContext
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    
    [fetchRequest setEntity:entity];
    //
    //    // Specify criteria for filtering which objects to fetch
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
    //    [fetchRequest setPredicate:predicate];
    //    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"companyName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
   
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    if ([fetchedObjects count] == 0) {
        [self createCompaniesAndProducts];
    }else {
        NSMutableArray *companiesArray = [[NSMutableArray alloc] init];
        for(Company *company in fetchedObjects){
            CompanyInfoClass *tempComp = [self convertManagedCompanyToCIC:company];
            [companiesArray addObject:tempComp];
           
        }
        
        [self setCompanyList:companiesArray];
    
    }
    
}
#pragma mark convenient method

-(CompanyInfoClass *)convertManagedCompanyToCIC:(Company *) company{
    CompanyInfoClass *theCompany = [[CompanyInfoClass alloc]initWithId:company.companyID];
    theCompany.companyName = company.companyName;
    theCompany.companyImage = company.companyImage;
    theCompany.companyTicker = company.companyTicker;
   
    for (Product *product in company.products) {
        ProductInfoClass *product1 = [[ProductInfoClass alloc] init];
        product1.productName = product.productName;
        product1.productImage = product.productImage;
        product1.productUrl = product.productUrl;
        product1.companyID = product.companyID;
        [theCompany.productArray addObject:product1];
       
    }
    return theCompany;
}

-(Company *)convertCompanyInfoClassToManagedCompany:(CompanyInfoClass *)company
{
    Company *theCompany = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    theCompany.companyName = company.companyName;
    theCompany.companyImage = company.companyImage;
    theCompany.companyTicker = company.companyTicker;
    theCompany.companyID = company.companyID;
    //    theCompany.products = [NSSet setWithArray:company.productsArray];
    NSMutableArray *tempProductsArray = [NSMutableArray array];
    for (ProductInfoClass *product in company.productArray)
    {
        Product *theProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
        theProduct.productName = product.productName;
        theProduct.productImage = product.productImage;
        theProduct.productUrl = product.productUrl;
        theProduct.companyID = product.companyID;
        
        [tempProductsArray addObject:theProduct];
        //        [theCompany setProducts:[NSSet setWithObject:theProduct]];
    }
    
    [theCompany setProducts:[NSSet setWithArray:tempProductsArray]];
    return theCompany;
}

#pragma mark create default values

-(void)createCompaniesAndProducts
{
    
    // Create all default value for companies
    CompanyInfoClass *apple = [[CompanyInfoClass alloc]init];
    apple.companyName = @"Apple Inc";
    apple.companyImage = @"Apple Inc";
    apple.companyTicker = @"AAPL";
   
    ProductInfoClass *iPhone = [[ProductInfoClass alloc] initWithCompanyId:apple];
    iPhone.productName = @"iPhone";
    iPhone.productImage = @"iPhoneImage";
    iPhone.productUrl = @"http://www.apple.com/iphone/";
    
    ProductInfoClass *iPad = [[ProductInfoClass alloc] initWithCompanyId:apple];
    iPad.productName = @"iPad";
    iPad.productImage = @"iPadImage";
    iPad.productUrl = @"http://www.apple.com/ipad/";
    
    ProductInfoClass *iPod = [[ProductInfoClass alloc] initWithCompanyId:apple];
    iPod.productName = @"iPod";
    iPod.productImage = @"iPodImage";
    iPod.productUrl = @"http://www.apple.com/ipod/";
    
    // Add product information in the apple company
    [apple.productArray addObject:iPhone];
    [apple.productArray addObject:iPad];
    [apple.productArray addObject:iPod];
    
       // GROUP GOOGLE COMPANY AND ITS PRODUCTS
    CompanyInfoClass *google = [[CompanyInfoClass alloc] init];
    google.companyName = @"Google";
    google.companyImage = @"Google";
    google.companyTicker = @"GOOG";
  
    ProductInfoClass *googleGmail = [[ProductInfoClass alloc]initWithCompanyId:google];
    googleGmail.productName = @"Gmail";
    googleGmail.productImage = @"gmailImage";
    googleGmail.productUrl = @"https://www.google.com/gmail/about/";
    
    ProductInfoClass *googleMaps = [[ProductInfoClass alloc]initWithCompanyId:google];
    googleMaps.productName = @"Google Maps";
    googleMaps.productImage = @"googleMapsImage";
    googleMaps.productUrl = @"https://maps.google.com/";
    
    // Add google products into Google company
    [google.productArray addObject:googleGmail];
    [google.productArray addObject:googleMaps];
   
    // GROUP TESLA COMPANY AND ITS PRODUCTS
    CompanyInfoClass *tesla = [[CompanyInfoClass alloc]init];
    tesla.companyName = @"Tesla";
    tesla.companyImage = @"Tesla";
    tesla.companyTicker = @"TSLA";
   
    ProductInfoClass *teslaModelS = [[ProductInfoClass alloc]initWithCompanyId:tesla];
    teslaModelS.productName = @"Model S";
    teslaModelS.productImage = @"teslaModelSImage";
    teslaModelS.productUrl = @"https://www.tesla.com/models";
    
    ProductInfoClass *teslaModelX = [[ProductInfoClass alloc] initWithCompanyId:tesla];
    teslaModelX.productName = @"Model X";
    teslaModelX.productImage = @"teslaModelXImage";
    teslaModelX.productUrl = @"https://www.tesla.com/modelx";
    
    ProductInfoClass *teslaModel3 = [[ProductInfoClass alloc] initWithCompanyId:tesla];
    teslaModel3.productName = @"Model 3";
    teslaModel3.productImage = @"teslaModel3Image";
    teslaModel3.productUrl = @"https://www.tesla.com/model3";
    
    // Add Tesla products into Tesla company
    [tesla.productArray addObject:teslaModelS];
    [tesla.productArray addObject:teslaModelX];
    [tesla.productArray addObject:teslaModel3];
    
    
    // GROUP FORD COMPANY AND ITS PRODUCTS
    CompanyInfoClass *ford = [[CompanyInfoClass alloc] init];
    ford.companyName = @"Ford";
    ford.companyImage = @"Ford";
    ford.companyTicker = @"F";
 
    ProductInfoClass *fordFiesta = [[ProductInfoClass alloc]initWithCompanyId:ford];
    fordFiesta.productName = @"Fiesta";
    fordFiesta.productImage = @"fordFiestaImage";
    fordFiesta.productUrl = @"http://www.ford.com/cars/fiesta/";
    
    ProductInfoClass *fordFocus = [[ProductInfoClass alloc]initWithCompanyId:ford];
    fordFocus.productName = @"Focus";
    fordFocus.productImage = @"fordFocusImage";
    fordFocus.productUrl = @"http://www.ford.com/cars/focus/";
    
    ProductInfoClass *fordMustang = [[ProductInfoClass alloc]initWithCompanyId:ford];
    fordMustang.productName = @"Mustang";
    fordMustang.productImage = @"fordMustangImage";
    fordMustang.productUrl = @"http://www.ford.com/cars/mustang/";
    
    // Add ford products to the company
    [ford.productArray addObject:fordFiesta];
    [ford.productArray addObject:fordFocus];
    [ford.productArray addObject:fordMustang];
        
    self.companyList = [NSMutableArray new];
    
    // ADD ALL COMPANYS TO COMPANY ARRAY
    [self.companyList addObject:apple];
    [self.companyList addObject:google];
    [self.companyList addObject:tesla];
    [self.companyList addObject:ford];
    
    
    // Create the managed objects and add it in core data
    
    for (CompanyInfoClass *company in self.companyList) {
        Company *theCompany = [self convertCompanyInfoClassToManagedCompany:company];
        
    }
    
    [self saveChanges];
    
}

-(void)saveChanges
{
    NSError *error = nil;
    BOOL successful = [_managedObjectContext save:&error];
    if (!successful)
    {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    NSLog(@"Data saved");
}

-(void)undoLastAction
{
    [_managedObjectContext undo];
    [self reloadDataFromContext];
    
}

-(void)redoLastUndo
{
    [_managedObjectContext redo];
    [self reloadDataFromContext];
}


-(void)addNewCompanyToList:(NSString *)companyName
              companyImage:(NSString *)companyImage
             companyTicker:(NSString *)companyTicker


{
    CompanyInfoClass *newCompany = [[CompanyInfoClass alloc]init];
    newCompany.companyName = companyName;
    newCompany.companyImage = companyImage;
    newCompany.companyTicker = companyTicker;
    
    [self.companyList addObject:newCompany];
    
    // Save to Disk
    Company *company = [self convertCompanyInfoClassToManagedCompany:newCompany];

    
    [self saveChanges];
    
    
}

-(void)updateCompanyInfo:(NSString *)companyName
   updateCompanyImageURL:(NSString *)companyImageURL
     updateCompanyTicker:(NSString *)companyTicker
                 company:(CompanyInfoClass *)company
{
    // Fetch the company from the core data
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"companyID", company.companyID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not fetch the objects");
    }
    
    else {
        if ([fetchedObjects count] > 0) {
            Company *targetCompany = fetchedObjects[0];
            targetCompany.companyName = companyName;
            targetCompany.companyImage = companyImageURL;
            targetCompany.companyTicker = companyTicker;
            
            [self saveChanges];
        }
        
    }
    
    company.companyName = companyName;
    company.companyImage = companyImageURL;
    company.companyTicker = companyTicker;
    
    
    
}

-(void)deleteCompany:(CompanyInfoClass *)company
{
    // Fetch the company from the core data first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fethchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fethchedObjects == nil)
    {
        NSLog(@"Could not delete Entity objects");
    }
    for (Company *targetCompany in fethchedObjects) {
        if ([targetCompany.companyID intValue] == [company.companyID intValue])
            [_managedObjectContext deleteObject:targetCompany];
    }
    
    
    [self.companyList removeObject:company];
    
    
    
}


-(void)addNewProductToList:(NSString *)productName
           productImageURL:(NSString *)productImageURL
                productURL:(NSString *)productURL
               companyInfo:(CompanyInfoClass *)companyInfo
{
    ProductInfoClass *productInfo = [[ProductInfoClass alloc] init];
    productInfo.productName = productName;
    productInfo.productImage = productImageURL;
    productInfo.productUrl = productURL;
    productInfo.companyID = companyInfo.companyID;
    
    [companyInfo.productArray addObject:productInfo];
 
    
    // Create managed object, product in Core data
    Product *newProduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    newProduct.productName = productName;
    newProduct.productImage = productImageURL;
    newProduct.productUrl = productURL;
    newProduct.companyID = companyInfo.companyID;
    
    // Add product to company managed object
    // First, fetch the company from the model
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fethchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fethchedObjects == nil)
    {
        NSLog(@"Could not delete Entity objects");
    }
    for (Company *targetCompany in fethchedObjects) {
        if ([targetCompany.companyID intValue] == [productInfo.companyID intValue])
            
            [targetCompany addProducts:[NSSet setWithObject:newProduct]];
    }
   
    
    [self saveChanges];
    
    
}


-(void)updateProductInfo:(NSString *)productName
        updateProductURL:(NSString *)productURL
   updateProductImageURL:(NSString *)productImageURL
             productInfo:(ProductInfoClass *)productInfo
{
    // Fetch that product from the data first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create Predicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"companyID", productInfo.companyID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not fetch the objects");
    }
    
    else {
        for (Product *targetProduct in fetchedObjects) {
            if ([targetProduct.productName isEqualToString:productInfo.productName]) {
                
                targetProduct.productName = productName;
                targetProduct.productImage = productImageURL;
                targetProduct.productUrl = productURL;
                
            }
        }
        
        [self saveChanges];
    }
    
    // update product info to product object class
    productInfo.productName = productName;
    productInfo.productUrl = productURL;
    productInfo.productImage = productImageURL;
}


-(void)deleteProduct:(ProductInfoClass *)product
{
    // Fetch that product from the data first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Create Predicate, by finding the product id
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d", @"companyID", product.companyID];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    // This fetchedObjects should have all the products that have same id
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not find the product object");
    }
    else {
        for (Product *targetProduct in fetchedObjects) {
            if ([targetProduct.productName isEqualToString:product.productName]) {
                [_managedObjectContext deleteObject:targetProduct];
            }
        }
        [self saveChanges];
    }
    
}



-(void)getStockPrice
{
    NSString *urlStartString = @"http://finance.yahoo.com/d/quotes.csv?s=";
    NSString *urlEndString = @"&f=sl1";
    NSString *tickersString =@"";
    NSString *urlStringWithTickers;
    
    int i = 0;
    for (i = 0; i < [_companyList count]; i++) {
        CompanyInfoClass *temp = _companyList[i];
        NSString *tempTicker = temp.companyTicker;
        
        tickersString = [tickersString stringByAppendingString:tempTicker];
        tickersString = [NSString stringWithFormat:@"%@+", tickersString];
        
    }
    NSString *newTickerString = [tickersString substringToIndex:[tickersString length] -1];
    
    //    NSString *urlStringWithTicker = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+MSFT&f=sl1";
    urlStringWithTickers = [NSString stringWithFormat:@"%@%@%@", urlStartString, newTickerString,urlEndString];
    NSURL *url = [NSURL URLWithString:urlStringWithTickers];
    NSURLSessionDownloadTask *downloadStockTask = [[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (error) {
            
            // get the main thred
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                // Post the notification when the data is done downloading
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"NoInternet"
                 object:self];
            });
            
            
        } else {
            
            NSData *data = [NSData dataWithContentsOfURL:location];
            
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"result = %@", newStr);
            
            // Separate the string to get individual ticker and stock price
            NSString *newStringWithOutQuotation = [newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSLog(@"%@", newStringWithOutQuotation);
            
            // Now put in array
            NSArray *tickerAndPriceArray = [newStringWithOutQuotation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",\n"]];
            
            NSLog(@"%@", tickerAndPriceArray);
           
            for (int i = 0; i < [tickerAndPriceArray count]-1; i = i+2) {
                NSString *ticker = tickerAndPriceArray[i];
                CompanyInfoClass *company = [self findCompanyByTicker:ticker];
                company.stockPrice = tickerAndPriceArray[i + 1];
//                company.stockPrice = [NSNumber numberWithInteger:[tickerAndPriceArray[i+1]integerValue]];
                
                 
            }
            
            // get the main thred
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // Post the notification when the data is done downloading
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"StockDataReceived"
                 object:self];
            });
        }
    }];
    
    [downloadStockTask resume];
    
    
    
    
}

-(CompanyInfoClass *)findCompanyByTicker:(NSString *)ticker
{
    for (CompanyInfoClass *company in self.companyList) {
        if ([company.companyTicker isEqualToString:ticker])
            return company;
    }
    
    return nil;
}


@end
