//
//  Template+EntityWorker.m
//  AllMine
//
//  Created by Allgoritm LLC on 01.11.12.
//  Copyright (c) 2012 Allgoritm LLC. All rights reserved.
//

#import "Template+EntityWorker.h"
#import "AGDBWorker.h"

static NSString *entityName = @"Template";

@implementation Template (EntityWorker)

+ (Template*) insertTemplateWithUser:(User*)user
                               title:(NSString*)title
                             account:(Account*)account
                            category:(Category*)category
                   accountAsCategory:(Account*)accountAsCategory
                             comment:(NSString*)comment
                                save:(BOOL)save{
    
    return [Template insertTemplateWithUser:user
                                      title:title
                                    account:account
                                   category:category
                          accountAsCategory:accountAsCategory
                                    comment:comment
                                       save:save
                                    context:[AGDBWorker sharedWorker].managedObjectContext];
}

+ (Template*) insertTemplateWithUser:(User*)user
                               title:(NSString*)title
                             account:(Account*)account
                            category:(Category*)category
                   accountAsCategory:(Account*)accountAsCategory
                             comment:(NSString*)comment
                                save:(BOOL)save
                             context:(NSManagedObjectContext*)context{

    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    
    Template* tmpl = (Template*)[NSEntityDescription insertNewObjectForEntityForName:entityName
                                                    inManagedObjectContext:context];
    tmpl.title = title;
    tmpl.account = account;
    tmpl.category = category;
    tmpl.accountAsCategory = accountAsCategory;
    tmpl.comment = comment;
    tmpl.user = user;
    tmpl.idTemplate = [NSNumber numberWithInt:-1];
    tmpl.modifiedDate = [NSDate date];
    tmpl.removed = [NSNumber numberWithBool:NO];
    
    if (save) {
        [dbw saveContext:context];
    }
    
    return tmpl;
}

+ (Template*) templateWithTitle:(NSString*)title{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Template *tmpl = (Template *) [dbw fetchManagedObjectWithEntityName:entityName
                                                      predicate:predicate
                                                sortDescriptors:nil];
    return tmpl;
}

+ (Template*) templateWithId:(int)idTemplate
                     context:(NSManagedObjectContext*)context{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idTemplate == %d", idTemplate];
    
    AGDBWorker* dbw = [AGDBWorker sharedWorker];
    Template *tmpl = (Template*) [dbw fetchManagedObjectWithEntityName:entityName
                                                                predicate:predicate
                                                          sortDescriptors:nil
                                                               context:context];
    return tmpl;
}

+ (NSString*)entityName{
    return entityName;
}

- (void) markRemovedSave:(BOOL)save{
    [self markRemovedSave:save
                  context:[AGDBWorker sharedWorker].managedObjectContext];
}
- (void) markRemovedSave:(BOOL)save
                 context:(NSManagedObjectContext*)context{
    self.removed = [NSNumber numberWithBool:YES];
    if (save) {
        [[AGDBWorker sharedWorker] saveContext:context];
    }
}

@end
