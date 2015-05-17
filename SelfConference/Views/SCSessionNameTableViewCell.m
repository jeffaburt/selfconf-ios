//
//  SCSessionNameTableViewCell.m
//  SelfConference
//
//  Created by Jeff Burt on 3/21/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCSessionNameTableViewCell.h"
#import "SCSession.h"
#import <MTDates/NSDate+MTDates.h>
#import "SCRoom.h"
#import "SCSpeaker.h"

@interface SCSessionNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *slotAndRoomLabel;

@end

@implementation SCSessionNameTableViewCell

#pragma mark - Overrides

- (void)setSession:(SCSession *)session {
    self.nameLabel.text = [NSString stringWithFormat:@"%@: %@",
                           session.joinedSpeakerNamesOrderedByName,
                           session.name];
    
    self.slotAndRoomLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                  [session.slot
                                   mt_stringFromDateWithFormat:@"EEEE ha"
                                   localized:YES],
                                  session.room.name];
    
    _session = session;
}

@end
