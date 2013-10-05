//
//  Template+EntityWorker.h
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Template.h"

@interface Template (EntityWorker)

+ (Template*) insertTemplateWithUser:(User*)user
                               title:(NSString*)title
                             account:(Account*)account
                            category:(Category*)category
                   accountAsCategory:(Account*)accountAsCategory
                             comment:(NSString*)comment
                                save:(BOOL)save;

+ (Template*) insertTemplateWithUser:(User*)user
                               title:(NSString*)title
                             account:(Account*)account
                            category:(Category*)category
                   accountAsCategory:(Account*)accountAsCategory
                             comment:(NSString*)comment
                                save:(BOOL)save
                             context:(NSManagedObjectContext*)context;

+ (Template*) templateWithTitle:(NSString*)title;

+ (Template*) templateWithId:(int)idTemplate
                     context:(NSManagedObjectContext*)context;

+ (NSString*)entityName;

- (void) markRemovedSave:(BOOL)save;
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context;

@end
