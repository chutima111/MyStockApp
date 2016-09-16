//
//  Product+CoreDataProperties.h
//  MyStockApp
//
//  Created by chutima mungmee on 9/12/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) NSString *productImage;
@property (nullable, nonatomic, retain) NSString *productUrl;
@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) Company *company;

@end

NS_ASSUME_NONNULL_END
