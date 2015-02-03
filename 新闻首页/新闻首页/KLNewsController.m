//
//  KLNewsController.m
//  新闻首页
//
//  Created by kouliang on 15/1/31.
//  Copyright (c) 2015年 kouliang. All rights reserved.
//

#import "KLNewsController.h"

@interface KLNewsController ()

@end

@implementation KLNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

static NSString * const ID = @"newsCell";


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %zd", self.title, indexPath.row];
    
    return cell;
}
@end
