//
//  ACDateTimePickTextField.m
//  AnyCheckMobile
//
//  Created by IOS－001 on 14-5-7.
//  Copyright (c) 2014年 xxxx All rights reserved.
//

#import "ACDateTimePickTextField.h"

@interface ACDateTimePickTextField ()

@property (nonatomic , strong) UIDatePicker *inputPickerView;
@property (nonatomic , strong) UIToolbar *accessoryToolbarView;
@property (nonatomic , strong) NSDateFormatter *formatter;

@end

@implementation ACDateTimePickTextField

- (UIDatePicker *)inputPickerView
{
    if (!_inputPickerView) {
        _inputPickerView = [[UIDatePicker alloc] init];
        _inputPickerView.datePickerMode = UIDatePickerModeDateAndTime;
        [_inputPickerView addTarget:self action:@selector(datePickValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_inputPickerView sendActionsForControlEvents:UIControlEventValueChanged];
        _inputPickerView.maximumDate = [NSDate date];
    }
    return _inputPickerView;
}

- (void)setPickerMode:(UIDatePickerMode)pickerMode
{
    self.inputPickerView.datePickerMode = pickerMode;
}

- (UIToolbar *)accessoryToolbarView
{
    if (!_accessoryToolbarView) {
        CGFloat screenWidth = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height;
        _accessoryToolbarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonTouchUpInSideAction)];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        _accessoryToolbarView.items = @[flex,rightBarButton];
    }
    return _accessoryToolbarView;
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.locale = [NSLocale currentLocale];
        _formatter.timeZone = [NSTimeZone localTimeZone];
    }
    return _formatter;
}

- (UIView *)inputView
{
    return self.inputPickerView;
}

- (UIView *)inputAccessoryView
{
    return self.accessoryToolbarView;
}

- (id)initWithFrame:(CGRect)frame
     datePickerMode:(UIDatePickerMode)pickermode
configureTimeFormatBlock:(void (^)(NSDateFormatter *))configureBlock
        resultBlock:(void (^)(NSDate *,NSString *))resultBlock{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumFontSize = 0.5;
        self.timeFormatterBlock = configureBlock;
        self.pickerMode = pickermode;
        self.resultBlock = resultBlock;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:14.];
        self.textColor = [UIColor colorWithWhite:75 / 255. alpha:1.0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont boldSystemFontOfSize:14.];
        self.textColor = [UIColor colorWithWhite:75 / 255. alpha:1.0];
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDateTimePickerDidBecomeFirstResponderNotification object:self];
    return [super becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

#pragma mark -
#pragma mark - EventAction

- (void)datePickValueChanged:(UIDatePicker *)datePicker
{
    NSDate *pickedDate = datePicker.date;
//    [self.formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.formatter setDateFormat:@"yyyy-MM-dd"];
    if (self.timeFormatterBlock) {
        self.timeFormatterBlock(self.formatter);
    }
    
    NSTimeInterval second = 0;
    @autoreleasepool {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitSecond;
        comps = [calendar components:unitFlags fromDate:[NSDate date]];
        second = [comps second];
    }
    
    self.text = [self.formatter stringFromDate:[pickedDate dateByAddingTimeInterval:second]];
    if (self.resultBlock) {
        self.resultBlock(pickedDate,self.text);
    }
}

- (void)rightBarButtonTouchUpInSideAction
{
    if (![self resignFirstResponder]) {
        NSLog(@"键盘移除失败");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
