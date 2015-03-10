//
//  PikerTextField.m
//  PikerView
//
//  Created by IOS－001 on 14-7-14.
//  Copyright (c) 2014年 xxxx Information Technologies Co., LTD. All rights reserved.
//

#import "PickerTextField.h"

@interface PickerTextField () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic , strong) UIPickerView *inputPickerView;
@property (nonatomic , strong) UIToolbar *accessoryToolbarView;
@property (nonatomic , assign) NSInteger lastPickedRow;

@end

@implementation PickerTextField

#pragma mark -
#pragma mark - getter

- (NSInteger)currentSeletedIndex
{
    return self.lastPickedRow;
}

- (UIPickerView *)inputPickerView
{
    if (!_inputPickerView) {
        _inputPickerView = [[UIPickerView alloc] init];
        _inputPickerView.delegate = self;
        _inputPickerView.dataSource = self;
    }
    return _inputPickerView;
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

#pragma mark - 
#pragma mark - 重写

- (BOOL)becomeFirstResponder
{
    if (self.didSelectedResult && self.dataSource.count != 0) {
        if (self.lastPickedRow >= 0) {
            [self didSelectedAtRow:self.lastPickedRow];
        } else {
            [self didSelectedAtRow:0];
        }
    }
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

- (UIView *)inputView
{
    return self.inputPickerView;
}

- (UIView *)inputAccessoryView
{
    return self.accessoryToolbarView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textAlignment = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumFontSize = 10.;
        self.lastPickedRow = -1;
        self.currentSeletedIndex = -1;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumFontSize = 10.;
        self.lastPickedRow = -1;
        self.currentSeletedIndex = -1;
    }
    return self;
}

#pragma mark -
#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.dataSource count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.dataSource[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.lastPickedRow = row;
    [self didSelectedAtRow:row];
}

#pragma mark - 
#pragma mark - Inner

- (void)didSelectedAtRow:(NSInteger)row
{
    self.text = self.dataSource[row];
    self.lastPickedRow = row;
    if (self.didSelectedResult) {
        self.didSelectedResult(self.dataSource[row],row);
    }
}

#pragma mark - 
#pragma mark - UI Event

- (void)rightBarButtonTouchUpInSideAction
{
    if (![self resignFirstResponder]) {
        NSLog(@"键盘移除失败");
    }
}

@end
