//
//  PikerTextField.h
//  PikerView
//
//  Created by IOS－001 on 14-7-14.
//  Copyright (c) 2014年 xxxx Information Technologies Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerTextField : UITextField

@property (readwrite , strong) UIView *inputView;
@property (readwrite , strong) UIView *inputAccessoryView;

@property (nonatomic , assign) NSInteger currentSeletedIndex;
@property (nonatomic , copy) void (^didSelectedResult)(NSString *title,NSInteger index);
@property (nonatomic , strong) NSArray *dataSource;

@end
