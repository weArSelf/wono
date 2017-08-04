//
//  CustomActionSheet.h
//  udo_newSt
//
//  Created by xiaoli on 16/7/1.
//  Copyright © 2016年 HowDo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomActionSheetDelegate;

@interface CustomActionSheet : UIView

/**
 *  遮罩层背景颜色, 默认为blackColor
 */
@property (strong, nonatomic) UIColor *maskBackgroundColor;
/**
 *  遮罩层的alpha值，默认为0.5
 */
@property (nonatomic) CGFloat maskAlpha;

/**
 *  Default: [UIFont systemFontOfSize:20]
 */
@property (strong, nonatomic) UIFont *titleFont;
/**
 *  default: blackColor
 */
@property (strong, nonatomic) UIColor *titleColor;
/**
 *  default: whiteColor
 */
@property (strong, nonatomic) UIColor *titleBackgroundColor;

/**
 *  分割线颜色, default: lightGrayColor
 */
@property (strong, nonatomic) UIColor *lineColor;
/**
 *  按钮高度 默认为49
 */
@property (assign,nonatomic) CGFloat buttonHeight;
/**
 *  标题的高度 默认为49
 */
@property (assign,nonatomic) CGFloat titleHeight;

+ (instancetype)actionSheetWithTitle:(NSString *)title
                        buttonTitles:(NSArray *)buttonTitles
                   cancelButtonTitle:(NSString *)cancelButtonTitle
                            delegate:(id<CustomActionSheetDelegate>)delegate;

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
                     delegate:(id<CustomActionSheetDelegate>)delegate;
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
            cancelButtonTitle:(NSString *)cancelButtonTitle
                     delegate:(id<CustomActionSheetDelegate>)delegate
                       nowSex:(NSString *)sex;

- (void)show;

@end

@protocol CustomActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(CustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (UIFont *)actionSheet:(CustomActionSheet *)actionSheet buttonTextFontAtIndex:(NSInteger)bottonIndex;
- (UIColor *)actionSheet:(CustomActionSheet *)actionSheet buttonTextColorAtIndex:(NSInteger)bottonIndex;
- (UIColor *)actionSheet:(CustomActionSheet *)actionSheet buttonBackgroundColorAtIndex:(NSInteger)bottonIndex;

@end
