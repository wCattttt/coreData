//
//  ViewController.h
//  User_封装
//
//  Created by imac on 15/10/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    
}

@end

