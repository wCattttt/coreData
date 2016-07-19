//
//  ViewController.m
//  User_封装
//
//  Created by imac on 15/10/14.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "EditorViewController.h"

@interface ViewController ()<saveDelegate>
{
    NSMutableArray *_data;
    NSMutableArray *_nameData;
    UITextField *textField;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createSearchTextField];
    _nameData = [self _getNameData];
    
    [self Refresh:nil];
}

- (void)_createSearchTextField{
    textField = [[UITextField alloc]initWithFrame:CGRectMake(self.navigationController.view.bounds.size.width/2-100, 0, 200, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.navigationItem.titleView = textField;
}

- (NSMutableArray *)_getNameData{
    NSMutableArray *names = [NSMutableArray array];
    for (User *user in _data) {
        [names addObject:user.username];
    }
    return names;
}

- (IBAction)Refresh:(id)sender {
    textField.text = nil;
    _data = [[DBManager shareManager] query:@"User" predicate:nil].mutableCopy;
    [_tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditorViewController *editorVC = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"push_tableviewcell"]){
        editorVC.isModify = YES;
        
        NSIndexPath *indexPath = [_tableView indexPathForCell:sender];
        editorVC.modifyUser = _data[indexPath.row];
    }
    editorVC.refreshDelegate = self;
}

#pragma mark --- UITableDataSource/ Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
    UILabel *usernameLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *ageLabel = (UILabel *)[cell.contentView viewWithTag:200];
    User *user = _data[indexPath.row];
    usernameLabel.text = user.username;
    ageLabel.text = [user.age stringValue];
    return  cell;
}
// 设置删除或增加的事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        User *user = _data[indexPath.row];
        [[DBManager shareManager] remove:user];
        [_data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
//        [_data insertObject:[NSString stringWithFormat:@"第%ld行插入", indexPath.row] atIndex:indexPath.row];
//        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"插入数据");
    }
}
// 设置单元格的编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
// 实现此方法，单元格就可以移动
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
}


// SearchTextField 添加的方法
- (void)textChange:(UITextField *)textfield{
    // 在每次TexField改变触发该方法时，将dataArray数据重置
    _data = [[DBManager shareManager] query:@"User" predicate:nil].mutableCopy;
    [_tableView reloadData];
    _nameData = [self _getNameData];
    NSString *text = textfield.text;
    if([text length] == 0){
        [_tableView reloadData];
        return;
    }
    
    // 过滤条件
    NSString *p = [NSString stringWithFormat:@"SELF LIKE[c] '%@*' ", text];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:p];
    NSArray *names = [NSArray arrayWithArray:_nameData];
    _nameData = [names filteredArrayUsingPredicate:predicate].mutableCopy;
    // 根据过滤后的数据与数据库查询的数据进行匹配
    NSMutableArray *searchData = [NSMutableArray array];
    for (NSString *name in _nameData) {
        for(User *user in _data){
            NSString *userName = user.username;
            if([userName isEqualToString:name]){
                [searchData addObject:user];
            }
        }
    }
    _data = searchData;
    [_tableView reloadData];
    
}

#pragma mark 新增数据协议
- (void)refreshData{
    [self Refresh:nil];
}

@end
