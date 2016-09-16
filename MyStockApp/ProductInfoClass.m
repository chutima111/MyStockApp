//
//  ProductInfoClass.m
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "ProductInfoClass.h"

@implementation ProductInfoClass

-(instancetype)initWithCompanyId:(CompanyInfoClass *)company
{
    self = [super init];
    if (self) {
        self.companyID = company.companyID;
    }
    
    return self;
}

@end
