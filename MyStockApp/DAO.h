//
//  DAO.h
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CompanyInfoClass.h"
#import "ProductInfoClass.h"

#import "Company.h"
#import "Product.h"

@interface DAO : NSObject

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) NSMutableArray *companyList;

-(void)createCompaniesAndProducts;

-(void)addNewCompanyToList:(NSString *)companyName
              companyImage:(NSString *)companyImage
             companyTicker:(NSString *)companyTicker;


-(void)updateCompanyInfo:(NSString *)companyName
   updateCompanyImageURL:(NSString *)companyImageURL
     updateCompanyTicker:(NSString *)companyTicker
                 company:(CompanyInfoClass *)company;

-(void)addNewProductToList:(NSString *)productName
           productImageURL:(NSString *)productImageURL
                productURL:(NSString *)productURL
               companyInfo:(CompanyInfoClass *)companyInfo;

-(void)deleteProduct:(ProductInfoClass *)product;



-(void)updateProductInfo:(NSString *)productName
        updateProductURL:(NSString *)productURL
   updateProductImageURL:(NSString *)productImageURL
             productInfo:(ProductInfoClass *)productInfo;

-(void)getStockPrice;

-(void)deleteCompany:(CompanyInfoClass *)company;


+(DAO *)sharedInstance;

-(NSString *)archivePath;

-(void)reloadDataFromContext;

-(void)saveChanges;

-(void)undoLastAction;

-(void)redoLastUndo;



@end
