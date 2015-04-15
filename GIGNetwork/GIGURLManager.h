//
//  GIGURLManager.h
//  gignetwork
//
//  Created by Judith Medina Gonzalez on 18/3/15.
//  Copyright (c) 2015 Gigigo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GIGURLDomain.h"
#import "GIGURLFixture.h"

@class GIGURLStorage;
@class GIGURLDomainsKeeper;


extern NSString * const GIGURLManagerDidChangeCurrentDomainNotification;
extern NSString * const GIGURLManagerDidChangeDomainsNotification;
extern NSString * const GIGURLManagerDomainUserInfoKey;
extern NSString * const GIGURLManagerDidChangeFixtureNotification;
extern NSString * const GIGURLManagerFixtureUserInfoKey;


@interface GIGURLManager : NSObject

// fixtures
@property (assign, nonatomic) BOOL useFixture;
@property (strong, nonatomic) GIGURLFixture *fixture;
@property (strong, nonatomic) NSArray *fixtures;
@property (strong, nonatomic) NSString *fixtureFilename;

// domains
@property (strong, nonatomic) GIGURLDomain *domain;
@property (strong, nonatomic) NSArray *domains;

+ (instancetype)sharedManager;

- (instancetype)initWithStorage:(GIGURLStorage *)storage notificationCenter:(NSNotificationCenter *)notificationCenter domainsKeeper:(GIGURLDomainsKeeper *)domainsKeeper;

- (NSData *)mockForRequestTag:(NSString *)requestTag;
- (void)showConfig;

- (void)loadDomainFile:(NSString *)domainFilename;
- (void)addDomain:(GIGURLDomain *)domain;
- (void)removeDomain:(GIGURLDomain *)domain;
- (void)moveDomain:(GIGURLDomain *)domain toIndex:(NSInteger)destinationIndex;
- (void)updateDomain:(GIGURLDomain *)domain withDomain:(GIGURLDomain *)newDomain;

@end
