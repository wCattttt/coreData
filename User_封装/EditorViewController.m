//
//  EditorViewController.m
//  User_封装
//
//  Created by imac on 15/10/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "EditorViewController.h"
#import "User.h"
#import "DBManager.h"
@interface EditorViewController ()

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.isModify){
        _usernameTextField.placeholder = self.modifyUser.username;
        _passwordTextField.placeholder = self.modifyUser.password;
        _ageTextField.placeholder = [self.modifyUser.age stringValue];
        self.title = @"修改用户";
    }else{
        self.title = @"添加用户";
    }
    
}

- (IBAction)Save:(id)sender {
    DBManager *managed = [DBManager shareManager];
    if(self.isModify){
        // 修改
        self.modifyUser.username = _usernameTextField.text;
        self.modifyUser.password = _passwordTextField.text;
        self.modifyUser.age = @([_ageTextField.text integerValue]);
        [managed update:nil];
    }else{
        // 保存
        User *user = [managed createMO:@"User"];
        user.username = _usernameTextField.text;
        user.password = _passwordTextField.text;
        user.age = @([_ageTextField.text integerValue]);
        [managed save:user];
    }
    [self.refreshDelegate refreshData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
