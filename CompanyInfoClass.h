//
//  CompanyInfoClass.h
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyInfoClass : NSObject

@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyImage;
@property (nonatomic, strong) NSString *companyTicker;
@property (nonatomic, strong) NSString *stockPrice;
@property (nonatomic, strong) NSNumber *companyID;
@property (nonatomic, strong) NSMutableArray *productArray;

-(instancetype)init;
-(instancetype)initWithId:(NSNumber *)companyID;



@end
