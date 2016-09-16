//
//  Company+CoreDataProperties.h
//  MyStockApp
//
//  Created by chutima mungmee on 9/12/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Company.h"

NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *companyImage;
@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSNumber *stockPrice;
@property (nullable, nonatomic, retain) NSString *companyTicker;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *products;

@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addProductsObject:(NSManagedObject *)value;
- (void)removeProductsObject:(NSManagedObject *)value;
- (void)addProducts:(NSSet<NSManagedObject *> *)values;
- (void)removeProducts:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
