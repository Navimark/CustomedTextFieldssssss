//
//  ACDateTimePickTextField.h
//  AnyCheckMobile
//
//  Created by IOS－001 on 14-5-7.
//  Copyright (c) 2014年 xxxx All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDateTimePickerDidBecomeFirstResponderNotification  @"kDateTimePickerDidBecomeFirstResponderNotification"

@interface ACDateTimePickTextField : UITextField

- (id)initWithFrame:(CGRect)frame datePickerMode:(UIDatePickerMode)pickermode configureTimeFormatBlock:(void(^)(NSDateFormatter *formatter))configureBlock resultBlock:(void(^)(NSDate *pickedDate,NSString *timeResult))resultBlock;

@property (readwrite , strong) UIView *inputView;
@property (readwrite , strong) UIView *inputAccessoryView;
@property (nonatomic , readonly) UIDatePicker *inputPickerView;

@property (nonatomic , assign) UIDatePickerMode pickerMode;
@property (nonatomic , copy) void (^resultBlock)(NSDate *pickedDate,NSString *timeResult);
@property (nonatomic , copy) void (^timeFormatterBlock)(NSDateFormatter *formatter);

@end
