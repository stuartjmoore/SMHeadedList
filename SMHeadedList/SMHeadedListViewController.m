//
//  SMHeadedListViewController.m
//  SMHeadedList
//
//  Created by Stuart Moore on 9/20/11.
//  Copyright 2011 Stuart Moore. All rights reserved.
//

#import "SMHeadedListViewController.h"

#define threshold 20
#define header_height 100
#define items_height 480-20-30

@implementation SMHeadedListViewController

@synthesize headerTable = _headerTable, itemsTable = _itemsTable;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headerTable = self.tableView;
    self.headerTable.scrollEnabled = NO;
    
    self.itemsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, items_height)];
    self.itemsTable.dataSource = self;
    self.itemsTable.delegate = self;
    
    [self.itemsTable addObserver:self forKeyPath:@"contentOffset"
                          options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                          context:NULL];
}

#pragma mark - Sync Tables

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context 
{
    CGPoint newPoint = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
    CGPoint oldPoint = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
    
    if(oldPoint.y > newPoint.y)
        direction = YES;
    else
        direction = NO;
    
    if(self.headerTable.contentOffset.y < header_height)
    {
        if(newPoint.y > 0)
        {
            if(self.itemsTable.contentOffset.y != 0)
                [self.itemsTable setContentOffset:CGPointMake(0, 0)];
            
            if(self.headerTable.contentOffset.y+newPoint.y < header_height)
                [self.headerTable setContentOffset:CGPointMake(0, self.headerTable.contentOffset.y+newPoint.y)];
            else
                [self.headerTable setContentOffset:CGPointMake(0, header_height)];
        }
    }
    
    if(self.headerTable.contentOffset.y <= header_height && self.itemsTable.contentOffset.y < 0)
    {
        if(self.headerTable.contentOffset.y > 0)
        {        
            if(self.itemsTable.contentOffset.y != 0)
                [self.itemsTable setContentOffset:CGPointMake(0, 0)];
            
            if(self.headerTable.contentOffset.y+newPoint.y > 0)
                [self.headerTable setContentOffset:CGPointMake(0, self.headerTable.contentOffset.y+newPoint.y)];
            else
                [self.headerTable setContentOffset:CGPointMake(0, 0)];
        }
    }
}

#pragma mark - Elastic Header

- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        if(self.headerTable.contentOffset.y < threshold)
            [self.headerTable setContentOffset:CGPointMake(0, 0) animated:YES];
        else if(self.headerTable.contentOffset.y > header_height-threshold)
            [self.headerTable setContentOffset:CGPointMake(0, header_height) animated:YES];
        else if(direction)
            [self.headerTable setContentOffset:CGPointMake(0, header_height) animated:YES];
        else
            [self.headerTable setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    if(direction || self.headerTable.contentOffset.y == header_height)
        [self.headerTable setContentOffset:CGPointMake(0, header_height) animated:YES];
    else
        [self.headerTable setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - Number of items

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if(tableView == self.headerTable)
        return 2;
    else if(tableView == self.itemsTable)
        return 1;
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.headerTable)
    {
        if(section == 0)
            return 1;
        else if(section == 1)
            return 1;
    }
    else if(tableView == self.itemsTable)
    {
        return 45;
    }
    return 0;
}

#pragma mark - Height of rows

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == self.headerTable)
    {
        if(section == 0)
            return 0;
        else if(section == 1)
            return 30;
    }
    else if(tableView == self.itemsTable)
    {
        return 0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.headerTable)
    {
        if(indexPath.section == 0)
            return header_height;
        else if(indexPath.section == 1)
            return items_height;
    }
    else if(tableView == self.itemsTable)
    {
        return 44;
    }
    return 0;
}

#pragma mark - Data

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if(tableView == self.headerTable && section == 1)
        return @"Title";

    return nil;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(tableView == self.headerTable)
    {
        if(indexPath.section == 0)
        {
            SMHeaderCellView *cell = (SMHeaderCellView*)[self.headerTable dequeueReusableCellWithIdentifier:@"header"];
            
            if(cell == nil) 
            {
                cell = [[[SMHeaderCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"header"] autorelease];
                cell.itemsTable = self.itemsTable;
            }
            
            cell.textLabel.text = @"header";
            
            return cell;
        }
        else if(indexPath.section == 1)
        {
            UITableViewCell *cell = [self.headerTable dequeueReusableCellWithIdentifier:@"items"];
            
            if(cell == nil) 
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"items"] autorelease];
                [cell addSubview:self.itemsTable];
            }
            
            return cell;
        }
    }
    else if(tableView == self.itemsTable)
    {
        UITableViewCell *cell = [self.itemsTable dequeueReusableCellWithIdentifier:@"single-item"];
        
        if(cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"single-item"] autorelease];
        }
        
        cell.textLabel.text = @"single-item";
        
        return cell;
    }
    return nil;
}

@end
