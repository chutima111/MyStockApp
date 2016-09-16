//
//  CompanyTableViewCell.h
//  MyStockApp
//
//  Created by chutima mungmee on 9/11/16.
//  Copyright © 2016 chutima mungmee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCompany;
@property (weak, nonatomic) IBOutlet UILabel *lblCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *lblStockPrice;

@end
