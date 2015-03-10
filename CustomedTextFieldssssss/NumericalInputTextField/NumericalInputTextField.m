//
//  NumericalInputTextField.m
//  ModernizationNumberInput
//
//  Created by IOS－001 on 15/1/26.
//  Copyright (c) 2015年 xxxx Information Technologies Co., LTD. All rights reserved.
//

#import "NumericalInputTextField.h"

@interface NumericalInputTextField () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic , strong) UIPickerView *inputPickerView;
@property (nonatomic , strong) UIToolbar *accessoryToolbarView;
@property (nonatomic , strong) UILabel *titleLabel;

@property (nonatomic , strong) NSMutableArray *integrcalParts;
@property (nonatomic , strong) NSMutableArray *fractionalParts;

@end

@implementation NumericalInputTextField

- (NSMutableArray *)integrcalParts
{
    if (!_integrcalParts) {
        NSArray *integralDatas = self.dataSourceDict[kIntegralPartDataSource];
        _integrcalParts = [NSMutableArray array];
        for (NSInteger i = 0; i != integralDatas.count; ++ i) {
            [_integrcalParts addObject:@""];
        }
    }
    return _integrcalParts;
}

- (NSMutableArray *)fractionalParts
{
    if (!_fractionalParts) {
        NSArray *fractionalDatas = self.dataSourceDict[kFractionalPartDataSource];
        _fractionalParts = [NSMutableArray array];
        for (NSInteger i = 0; i != fractionalDatas.count; ++ i) {
            [_fractionalParts addObject:@""];
        }
    }
    return _fractionalParts;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, self.accessoryToolbarView.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        if (self.inputTitle.length != 0) {
            _titleLabel.text = self.inputTitle;
            [_titleLabel sizeToFit];
        }
    }
    return _titleLabel;
}

- (UIView *)inputView
{
    return self.inputPickerView;
}

- (UIView *)inputAccessoryView
{
    return self.accessoryToolbarView;
}

- (UIToolbar *)accessoryToolbarView
{
    if (!_accessoryToolbarView) {
        _accessoryToolbarView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelBarButtonTouchUpInSideAction)];
        
        UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *titleView = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
        UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        UIBarButtonItem *finishBarButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishBarButtonTouchUpInSideAction)];
        
        finishBarButton.tintColor = cancelBarButton.tintColor = [UIColor colorWithRed:0 green:83 / 255. blue:2 / 255. alpha:1.0];
        
        _accessoryToolbarView.items = @[cancelBarButton,flex1,titleView,flex2,finishBarButton];
    }
    return _accessoryToolbarView;
}

- (UIPickerView *)inputPickerView
{
    if (!_inputPickerView) {
        _inputPickerView = [[UIPickerView alloc] init];
        _inputPickerView.showsSelectionIndicator = NO;
        _inputPickerView.delegate = self;
        _inputPickerView.dataSource = self;
    }
    return _inputPickerView;
}

- (void)setDataSourceDict:(NSDictionary *)dataSourceDict
{
    if (_dataSourceDict != dataSourceDict) {
        _dataSourceDict = dataSourceDict;
        [self.inputPickerView reloadAllComponents];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (BOOL)becomeFirstResponder
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNumericalPickerDidBecomeFirstResponderNotification object:self];
    return [super becomeFirstResponder];
}

#pragma mark -
#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSArray *integralDatas = self.dataSourceDict[kIntegralPartDataSource];
    NSArray *fractionalDatas = self.dataSourceDict[kFractionalPartDataSource];
    
    if (fractionalDatas.count != 0 ) {
        return integralDatas.count + fractionalDatas.count + 1;
    } else {
        return integralDatas.count;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *integralDatas = self.dataSourceDict[kIntegralPartDataSource];
    NSArray *fractionalDatas = self.dataSourceDict[kFractionalPartDataSource];
    
    if (component < integralDatas.count) {
        NSArray *targetArray = integralDatas[component];
        return targetArray.count;
    }
    if (component == integralDatas.count) {
        return 1;
    }
    if (component > integralDatas.count) {
        NSArray *targetArray = fractionalDatas[component - integralDatas.count - 1];
        return targetArray.count;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == [self.dataSourceDict[kIntegralPartDataSource] count]) {
        return 10;
    } else {
        NSArray *integralDatas = self.dataSourceDict[kIntegralPartDataSource];
        NSArray *fractionalDatas = self.dataSourceDict[kFractionalPartDataSource];
        NSInteger total = integralDatas.count + fractionalDatas.count;
        return (((UIWindow *)[UIApplication sharedApplication].windows.firstObject).frame.size.width - 35) / total;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel *)view;
    if (!tView) {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont boldSystemFontOfSize:30]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    NSString *plainTitle = @"";
    NSArray *integralDatas = self.dataSourceDict[kIntegralPartDataSource];
    NSArray *fractionalDatas = self.dataSourceDict[kFractionalPartDataSource];
    
    if (component < integralDatas.count) {
        NSArray *targetArray = integralDatas[component];
        plainTitle = targetArray[row];
    }
    if (component == integralDatas.count) {
        plainTitle = @".";
    }
    if (component > integralDatas.count) {
        NSArray *targetArray = fractionalDatas[component - integralDatas.count - 1];
        plainTitle = targetArray[row];
    }
    
    tView.text = plainTitle;
    return tView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *plainTitle = @"";
    NSArray *integralDatas = self.dataSourceDict[kIntegralPartDataSource];
    NSArray *fractionalDatas = self.dataSourceDict[kFractionalPartDataSource];
    
    if (component < integralDatas.count) {
        NSArray *targetArray = integralDatas[component];
        plainTitle = targetArray[row];
    }
    if (component == integralDatas.count) {
        plainTitle = @".";
    }
    if (component > integralDatas.count) {
        NSArray *targetArray = fractionalDatas[component - integralDatas.count - 1];
        plainTitle = targetArray[row];
    }
    NSInteger integral = 0;
    NSInteger fractional = 0;
    
    for (NSInteger i = 0; i != pickerView.numberOfComponents; ++ i) {
        if (i == component) {
            if (i < integralDatas.count) {
                self.integrcalParts[i] = plainTitle;
            } else if (i > integralDatas.count) {
                self.fractionalParts[i - (integralDatas.count + 1)] = plainTitle;
            }
        }
    }
    for (NSInteger i = 0; i != self.integrcalParts.count; ++ i) {
        integral += pow(10, self.integrcalParts.count - i - 1) * [self.integrcalParts[i] integerValue];
    }
    
    for (NSInteger i = 0; i != self.fractionalParts.count; ++ i) {
        fractional += pow(10, self.fractionalParts.count - i - 1) * [self.fractionalParts[i] integerValue];
    }
    
    CGFloat result = integral + fractional * pow(0.1, fractionalDatas.count);
    self.currentPickedNumber = @(result);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:fractionalDatas.count];
    [formatter setMinimumFractionDigits:fractionalDatas.count];
    [formatter setMinimumIntegerDigits:1];
    self.text = [formatter stringFromNumber:self.currentPickedNumber];
}

#pragma mark -
#pragma mark - ReWrite

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
#pragma mark - Action

- (void)cancelBarButtonTouchUpInSideAction
{
    if (![self resignFirstResponder]) {
        NSLog(@"键盘移除失败");
    }
    if (self.cancelBarButtonAction) {
        self.cancelBarButtonAction();
    }
}

- (void)finishBarButtonTouchUpInSideAction
{
    if (![self resignFirstResponder]) {
        NSLog(@"键盘移除失败");
    }
    if (self.finishBarButtonAction) {
        self.finishBarButtonAction(self.currentPickedNumber);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

NSString *const kFractionalPartDataSource                           = @"kFractionalPartDataSource";
NSString *const kIntegralPartDataSource                             = @"kIntegralPartDataSource";
NSString *const kNumericalPickerDidBecomeFirstResponderNotification = @"kNumericalPickerDidBecomeFirstResponderNotification";
@end
