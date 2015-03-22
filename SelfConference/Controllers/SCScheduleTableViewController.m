//
//  SCDayScheduleTableViewController.m
//  SelfConference
//
//  Created by Jeff Burt on 2/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCScheduleTableViewController.h"
#import "SCSession.h"
#import "SCSessionTableViewCell.h"

@interface SCScheduleTableViewController ()

/** An array of 'SCSession' instances */
@property (nonatomic) NSArray *sessions;

@end

@implementation SCScheduleTableViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 160.0f;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadSessionsLocally)
     name:kSCSessionNotificationNameForInstancesWereUpdatedFromTheServer
     object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    NSAssert(section == 0, @"There's no support for more than one section");
    
    return self.sessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCSessionTableViewCell *cell =
    [tableView
     dequeueReusableCellWithIdentifier:NSStringFromClass([SCSessionTableViewCell class])
     forIndexPath:indexPath];
    
    cell.session = self.sessions[indexPath.row];
    
    return cell;
}

#pragma mark - Other

/** 
 Fetches all of the local 'SCSession' instances, stores them, then  reloads 
 '_tableView'.
 */
- (void)reloadSessionsLocally {
    [SCSession
     getLocalSessionsWithBlock:^(NSArray *sessions, NSError *error) {
         self.sessions = sessions;
         [self.tableView reloadData];
     }];
}

@end