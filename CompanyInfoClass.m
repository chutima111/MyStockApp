//
//  CompanyInfoClass.m
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import "CompanyInfoClass.h"

@implementation CompanyInfoClass

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        NSNumber *companyID = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyID"];
        
        if (companyID == nil) {
            companyID = @1;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:companyID forKey:@"companyID"];
            [defaults synchronize];
            
            self.companyID = companyID;
        } else {
            
            self.companyID = @([companyID intValue] + 1);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.companyID forKey:@"companyID"];
            [defaults synchronize];
        }
        
        self.productArray = [[NSMutableArray alloc]init];
        
    }
    
    return self;
}

-(instancetype)initWithId:(NSNumber *)companyID
{
    self = [super init];
    if (self) {
        self.companyID = companyID;
        self.productArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
