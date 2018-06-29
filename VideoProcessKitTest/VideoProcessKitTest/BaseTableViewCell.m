//
//  BaseTableViewCell.m
//  YanHuangDLT
//
//  Created by Peter on 14/11/2016.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableview {
    
    NSString *identifier = [[self class] reuserIdentifier];
    id cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if ([BaseTableViewCell isLoadFromNIB]) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identifier owner:self options:nil]lastObject];
            [cell initializationWork];
        }
        else
        {
           cell = [[NSClassFromString(NSStringFromClass([self class])) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell initializationWork];
        }
    }
    return cell;
}



-(void)initializationWork{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


+(NSString *)reuserIdentifier {
   return NSStringFromClass([self class]);
}



+(BOOL)isLoadFromNIB {
    return YES;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)dealloc {
    //NSLog(@"%@ already dealloc",NSStringFromClass([self class]));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
