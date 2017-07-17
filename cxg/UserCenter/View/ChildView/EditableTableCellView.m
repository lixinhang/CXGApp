//
//  EditableTableCell.m
//  cxg
//
//  Created by abc on 16/9/9.
//  Copyright © 2016年 changyou. All rights reserved.
//

#import "EditableTableCellView.h"

static NSString * cellIdentifier = @"editableTableCell";
@implementation EditableTableCellView

-(id) initWithTableTitel:(NSString *)titel andDetail:(NSString *)value
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    if(self)
    {
        self.textLabel.text = titel;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.backgroundColor = [UIColor clearColor];
        
        [self setupEditFieldWithContent:value];
    }
    
    return self;
}

-(void) setupEditFieldWithContent:(NSString *)content
{
    CGRect field = CGRectMake(SCREEN_W - EDIT_FIELD_W - 10, (GENERAL_TABLE_CELL_H - EDIT_FIELD_H) / 2, EDIT_FIELD_W, EDIT_FIELD_H);
    UITextField *editField = [[UITextField alloc] initWithFrame:field];
    editField.borderStyle = UITextBorderStyleNone;
    editField.textAlignment = UITextAlignmentRight;
    editField.text = content;
    editField.font = [UIFont systemFontOfSize:15];
    editField.textColor = [UIColor grayColor];
    editField.keyboardType = UIKeyboardTypeNumberPad;
    editField.returnKeyType = UIReturnKeyDone;
    
    _editField = editField;
    [self addSubview:_editField];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
