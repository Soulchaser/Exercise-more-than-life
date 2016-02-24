//
//  Entity+CoreDataProperties.h
//  teamWork
//
//  Created by hanxiaolong on 16/1/29.
//  Copyright © 2016年 hanxiaolong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Entity.h"

NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *startDate;
@property (nullable, nonatomic, retain) NSNumber *movementTime;
@property (nullable, nonatomic, retain) NSNumber *totleTime;
@property (nullable, nonatomic, retain) NSNumber *maxSpeed;
@property (nullable, nonatomic, retain) NSNumber *sportType;
@property (nullable, nonatomic, retain) NSNumber *totleDistance;
@property (nullable, nonatomic, retain) NSData *infoData;

@end

NS_ASSUME_NONNULL_END
