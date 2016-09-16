//
//  ProductInfoClass.h
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyInfoClass.h"

@interface ProductInfoClass : NSObject

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImage;
@property (nonatomic, strong) NSString *productUrl;
@property (nonatomic, strong) NSNumber * companyID;

-(instancetype)initWithCompanyId:(CompanyInfoClass *)company;

@end
