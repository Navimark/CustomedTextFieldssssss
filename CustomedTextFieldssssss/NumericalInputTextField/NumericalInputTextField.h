//
//  NumericalInputTextField.h
//  ModernizationNumberInput
//
//  Created by IOS－001 on 15/1/26.
//  Copyright (c) 2015年 xxxx Information Technologies Co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kFractionalPartDataSource;
UIKIT_EXTERN NSString *const kIntegralPartDataSource;

UIKIT_EXTERN NSString *const kNumericalPickerDidBecomeFirstResponderNotification;

@interface NumericalInputTextField : UITextField

@property (readwrite , strong) UIView *inputView;
@property (readwrite , strong) UIView *inputAccessoryView;


@property (nonatomic , strong) NSNumber *currentPickedNumber;
@property (nonatomic , copy) NSString *inputTitle;
@property (nonatomic , copy) void(^cancelBarButtonAction)();
@property (nonatomic , copy) void(^finishBarButtonAction)(NSNumber *inputResult);

@property (nonatomic , strong) NSDictionary *dataSourceDict;

@end
