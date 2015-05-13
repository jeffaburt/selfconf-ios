//
//  Event.m
//  SelfConference
//
//  Created by Jeff Burt on 5/11/15.
//  Copyright (c) 2015 Self Conference. All rights reserved.
//

#import "SCEvent.h"
#import "SCAPIStrings.h"
#import "SCAPIService.h"
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import "SCSpeaker.h"

@implementation SCEvent

@dynamic eventID;
@dynamic name;
@dynamic about;
@dynamic twitterHandle;
@dynamic startDate;
@dynamic endDate;
@dynamic ticketsUrlString;
@dynamic lanyrdPath;
@dynamic isCurrent;
@dynamic sessions;
@dynamic speakers;
@dynamic sponsors;
@dynamic sponsorLevels;
@dynamic organizers;
@dynamic venue;

#pragma mark - URL Strings

+ (NSString *)getAllEventsUrlString {
    return SCAPIRelativeUrlStrings.events;
}

- (NSString *)getSessionsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sessions];
}

- (NSString *)getSpeakersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.speakers];
}

- (NSString *)getSponsorsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsors];
}

- (NSString *)getSponserLevelsUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.sponsorLevels];
}

- (NSString *)getOrganizersUrlString {
    return [self getUrlWithSuffix:SCAPIRelativeUrlStrings.organizers];
}

#pragma mark - Typed API requests

+ (void)getCurrentEventWithCompletionBlock:(SCEventWithErrorBlock)completionBlock {
    [SCAPIService
     getUrlString:[self getAllEventsUrlString]
     completionBlock:^(id responseObject, NSError *error) {
         if (error) {
             [self callSCEventWithErrorBlock:completionBlock
                                       event:nil
                                       error:error];
         }
         else {
             [self
              importFromResponseObject:responseObject
              saveCompletionBlock:^(NSArray *objects, NSError *error) {
                  if (error) {
                      [self callSCEventWithErrorBlock:completionBlock
                                                event:nil
                                                error:error];
                  }
                  else {
                      [self callSCEventWithErrorBlock:completionBlock
                                                event:[self currentEvent]
                                                error:error];
                  }
              }];
         }
     }];
}

- (void)getSpeakersWithCompletionBlock:(SCManagedObjectObjectsWithErrorBlock)completionBlock {
    [SCAPIService
     getUrlString:self.getSpeakersUrlString
     completionBlock:^(id responseObject, NSError *error) {
         if (error) {
             [self.class callSCManagedObjectObjectsWithErrorBlock:completionBlock
                                                          objects:nil
                                                            error:error];
         }
         else {
             [SCSpeaker
              importFromResponseObject:responseObject
              saveCompletionBlock:completionBlock];
         }
     }];
}

#pragma mark - Local fetchers

+ (SCEvent *)currentEvent {
    SCEvent *currentEvent;
    
    NSArray *currentEvents =
    [self MR_findAllWithPredicate:[self isCurrentEventPredicate]
                        inContext:[NSManagedObjectContext MR_defaultContext]];
    
    if (currentEvents.count == 0) {
        NSLog(@"There is no current SCEvent");
    }
    else if (currentEvents.count == 1) {
        currentEvent = currentEvents.firstObject;
    }
    else {
        NSAssert(NO, @"More than 1 current event exists.");
    }
    
    return currentEvent;
}

#pragma mark - Internal

/** Returns a GET url string for 'self' and appends 'suffix'/ */
- (NSString *)getUrlWithSuffix:(NSString *)suffix {
    return [NSString stringWithFormat:@"%@/%@/%@",
            SCAPIRelativeUrlStrings.events,
            [@(self.eventID) stringValue],
            suffix];
}

/** Calls a SCEventWithErrorBlock if it exists with the given parameters. */
+ (void)callSCEventWithErrorBlock:(SCEventWithErrorBlock)block
                            event:(SCEvent *)event
                            error:(NSError *)error {
    if (block) {
        block(event, error);
    }
    else {
        NSLog(@"SCEventWithErrorBlock is nil");
    }
}

/** Returns a 'NSPredicate' that can be used to find the current event. */
+ (NSPredicate *)isCurrentEventPredicate {
    // TODO: Change 'NO' to 'YES' once the API sets 'isCurrent' (currently
    // this is an open issue).
    return [NSPredicate predicateWithFormat:@"%K == NO",
            NSStringFromSelector(@selector(isCurrent))];
}

@end
