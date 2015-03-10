//
//  LimitedCharacterInputView.m
//  LimitedCharacterInputView
//
//  Created by IOS－001 on 14-5-9.
//  Copyright (c) 2014年 xxxx.com Group. All rights reserved.
//

#import "LengthLimitedInputView.h"
#import "GCPlaceholderTextView.h"

@interface LengthLimitedInputView ()

@property (nonatomic , copy) NSString *notificationName;
@property (nonatomic , strong) UIView *inputEareView;

@end

@implementation LengthLimitedInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.notificationName object:self.inputEareView];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [self.inputEareView setValue:placeholder forKey:@"placeholder"];
}

- (void)setFont:(UIFont *)font
{
    [self.inputEareView setValue:font forKey:@"font"];
}

- (void)setCurrentType:(InputViewType)currentType
{
    if (_currentType != currentType) {
        _currentType = currentType;
        if (self.inputEareView.superview) {
            [self.inputEareView removeFromSuperview];
        }
        self.inputEareView = nil;
        if (_currentType == InputViewTypeTextField) {
            self.inputEareView = [[UITextField alloc] initWithFrame:self.bounds];
            if (self.placeholder.length != 0) {
                ((UITextField *)self.inputEareView).placeholder = self.placeholder;
            }
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputEareViewEditChanged:) name:UITextFieldTextDidChangeNotification object:self.inputEareView];
        } else if (_currentType == InputViewTypeTextView) {
            self.inputEareView = [[GCPlaceholderTextView alloc] initWithFrame:self.bounds];
            if (self.placeholder.length != 0) {
                ((GCPlaceholderTextView *)self.inputEareView).placeholder = self.placeholder;
            }
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputEareViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.inputEareView];
        }
        self.inputEareView.autoresizingMask = 0xFF;
        [self addSubview:self.inputEareView];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _currentType = -1;
        self.autoresizesSubviews = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame inputType:(InputViewType)inputType maxLengthOfInputText:(NSInteger)maxLength outOfLimitBlock:(void (^)(id))limitBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.outOfLimitBlock = limitBlock;
        self.maxLengthOfInputText = maxLength;
        self.autoresizesSubviews = YES;
        self.currentType = inputType;
    }
    return self;
}

- (void)inputEareViewEditChanged:(NSNotification *)object
{
    UITextView *textView = (UITextView *)object.object;
    
    NSString *toBeString = textView.text;
    
    NSString *lang = [[textView textInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            if (toBeString.length > self.maxLengthOfInputText) {
                textView.text = [toBeString substringToIndex:self.maxLengthOfInputText];
                [self outOfLimitWarningAction];
            }
        } else {
            //DO Nothing
        }
    } else {
        if (toBeString.length > self.maxLengthOfInputText) {
            textView.text = [toBeString substringToIndex:self.maxLengthOfInputText];
            [self outOfLimitWarningAction];
        }
    }
}

- (void)outOfLimitWarningAction
{
    if (self.outOfLimitBlock) {
        self.outOfLimitBlock(self.inputEareView);
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
