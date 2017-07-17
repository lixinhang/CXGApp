//
//  EditableTableCell.h
//  cxg
//
//  Created by abc on 16/9/9.
//  Copyright © 2016年 changyou. All rights reserved.
//

#define EDIT_FIELD_W        150
#define EDIT_FIELD_H        25

@interface EditableTableCellView : UITableViewCell

@property (nonatomic,weak) UITextField *editField;

-(id) initWithTableTitel:(NSString *)titel andDetail:(NSString *)value;

@end
