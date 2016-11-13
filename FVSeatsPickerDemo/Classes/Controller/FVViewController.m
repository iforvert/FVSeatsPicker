//
//  FVViewController.m
//  FVSeatsPicker
//
//  Created by iforvert on 2016/11/13.
//  Copyright © 2016年 iforvert. All rights reserved.
//

#import "FVViewController.h"

typedef NS_ENUM(NSInteger, TableViewSection){
    TableViewSectionA,
    TableViewSectionB
};

static NSString * const kSeatsDisplaySegue = @"SeatsDisplaySegue";

@interface FVViewController ()

@property (nonatomic, assign) TableViewSection selectSection;

@end

@implementation FVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    switch (self.selectSection) {
        case TableViewSectionA: {
            [segue.destinationViewController setValue:@(TableViewSectionA) forKey:@"district"];
            break;
        }
        case TableViewSectionB: {
            [segue.destinationViewController setValue:@(TableViewSectionB) forKey:@"district"];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectSection = (indexPath.section == 0) ? TableViewSectionA : TableViewSectionB;
    [self performSegueWithIdentifier:kSeatsDisplaySegue sender:self];
}

@end
