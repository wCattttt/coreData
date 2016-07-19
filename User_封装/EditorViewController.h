//
//  EditorViewController.h
//  User_封装
//
//  Created by imac on 15/10/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol saveDelegate <NSObject>

- (void)refreshData;

@end

@class User;
@interface EditorViewController : UIViewController
{
    __weak IBOutlet UITextField *_usernameTextField;
    __weak IBOutlet UITextField *_passwordTextField;
    __weak IBOutlet UITextField *_ageTextField;
    
}
@property (nonatomic, assign) BOOL isModify;
@property (nonatomic,retain) User *modifyUser;

@property (nonatomic, assign) id<saveDelegate> refreshDelegate;

@end
