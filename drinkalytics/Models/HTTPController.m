//
//  HTTPController.m
//  drinkalytics
//
//  Created by Rachel Bobbins on 5/5/13.
//  Copyright (c) 2013 bobbypins. All rights reserved.
//

#import "HTTPController.h"
#import "Person.h"
#import "Drink.h"

@implementation HTTPController
- (void)postDrinkWithType:(NSString *)name andDetails:(NSString *)detail andServings:(NSInteger)servings
{
    //posts a drink
    NSURL *url = [[NSURL alloc] initWithString:@"http://drinkalytics.herokuapp.com/api/drinks"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *postString = [[NSMutableString alloc]init];
    [postString appendFormat:@"drink=%@&servings=%i", name, servings];
    if (detail != nil && ![detail isEqualToString:@""]) {
        [postString appendFormat:@"&details=%@", detail];
    }

    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSHTTPURLResponse *response;
    NSError *error;
    (void)[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];


}

- (NSDictionary *)getRankings
{
    NSArray *responseArray = [self api_rankings];
    NSMutableDictionary *rankings = [[NSMutableDictionary alloc] init];
    for (int i=0; i < [responseArray count]; i++) {
        NSString *nameId = [(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"id"];
        NSString *rank = [[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"rank"] stringValue];
        
        Person *person = [[Person alloc] init];
        [person setUserId:nameId];
        [person setRank:[[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"rank"] integerValue]];
        [person setNumberOfServings:[[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"drinks"] integerValue]];

        [rankings setObject:person forKey:rank];
    }
    return rankings;

}

- (NSArray *)getMyDrinks:(NSString *)userId
{
    NSString *urlString = [NSString stringWithFormat:@"http://drinkalytics.herokuapp.com/api/drinks?student=%@", userId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 200) {
        NSError *jsonReadError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        //drinks are in chronological order
        NSMutableArray *reverseDrinkArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *drinkDict in responseArray) {    
            long long ms = [[drinkDict valueForKey:@"date"] longLongValue];
            long long s = ms / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:s];
            
            Drink *drink = [[Drink alloc] init];
            [drink setType:[drinkDict valueForKey:@"drink"]];
            [drink setTimestamp:date];
            [drink setDetails:[drinkDict valueForKey:@"details"]];
            [drink setServings:[[drinkDict valueForKey:@"servings"] integerValue]];
            [reverseDrinkArray addObject:drink];
        }
        
        //we want reverse chronological order
        NSMutableArray *drinkArray = [[NSMutableArray alloc] init];
        for (Drink *drink in [reverseDrinkArray reverseObjectEnumerator]) {
            [drinkArray addObject:drink];
        }
        
        return drinkArray;
    } else {
        NSLog(@"response status code: %i", [response statusCode]);
    }
    
}

- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password andSaveCredentials:(BOOL)shouldSave
{
    //obtain session cookie
    NSURL *url = [[NSURL alloc] initWithString:@"https://olinapps.herokuapp.com/api/exchangelogin"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *postString = [[NSMutableString alloc]init];
    [postString appendFormat:@"username=%@&password=%@", username, password];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSError *jsonReadError;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];

    NSString *userId = [(NSDictionary *)[responseDict objectForKey:@"user"] objectForKey: @"id"];
    
    if ([response statusCode] == 200) {
        //give drinkalytics permission to use the session cookie
        NSError *jsonReadError = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        NSString *sessionid = [responseDict objectForKey:@"sessionid"];
        
        NSURL *newurl = [[NSURL alloc] initWithString:@"http://drinkalytics.herokuapp.com/login"];
        NSMutableURLRequest *newrequest = [NSMutableURLRequest requestWithURL:newurl];
        [newrequest setHTTPMethod:@"POST"];
        [newrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSMutableString *newpostString = [[NSMutableString alloc]init];
        [newpostString appendFormat:@"sessionid=%@",sessionid];
        [newrequest setHTTPBody:[newpostString dataUsingEncoding:NSUTF8StringEncoding]];
        NSHTTPURLResponse *response;
        NSError *error;
        (void)[NSURLConnection sendSynchronousRequest:newrequest returningResponse:&response error:&error];

        
        //save the session cookie
        NSArray *keys = [[NSArray alloc] initWithObjects:@"sessionid", @"userid", nil];
        NSArray * values = [[NSArray alloc] initWithObjects:sessionid, username, nil];
        NSDictionary *properties = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        
        //save cookie for next time so user doesn't have to log in again.
        [[NSUserDefaults standardUserDefaults] setValue:
         [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]]
                                                 forKey:@"savedCookies"];
        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] setValue:sessionid forKey:@"sessionid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //save login/password, if selected (enables multiple users on device). delete if was checked, but no longer is
        
        NSMutableDictionary *savedCredentials = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedUsers"] mutableCopy];
        if (shouldSave) {
            [savedCredentials setValue:password forKey:username];
        } else {
            [savedCredentials removeObjectForKey:username];
        }
        [[NSUserDefaults standardUserDefaults] setObject:savedCredentials forKey:@"savedUsers"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        return YES;
    } else {
        return NO;
    }

}

- (Person *)getMyPerson
{
    NSArray *responseArray = [self api_rankings];
    Person *person = [[Person alloc] init];
    
    for (int i=0; i < [responseArray count]; i++) {
        NSString *nameId = [(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"id"];
        
        if ([nameId isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]]) {
            NSInteger rank = [[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"rank"] integerValue];
            NSInteger servings = [[(NSDictionary *) [responseArray objectAtIndex:i] objectForKey:@"drinks"] integerValue];

            [person setNumberOfServings:servings];
            [person setRank:rank];
            return person;            
        }
    }
    
    [person setNumberOfServings:0];
    [person setRank:100];
    return person;
}

- (NSArray *)api_rankings
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://drinkalytics.herokuapp.com/api/rankings"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 200) {
        NSError *jsonReadError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        return responseArray;
    } else {
        NSLog(@"error: %i, %@", [response statusCode], error);
    }

}

- (BOOL) userIsSenior
{
    NSString *urlstring = [NSString stringWithFormat:@"http://directory.olinapps.com/api/me?sessionid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"sessionid"]];
    NSURL *url = [[NSURL alloc] initWithString:urlstring];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if ([response statusCode] == 200) {
        NSError *jsonReadError = nil;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        NSInteger year = [[responseDict valueForKey:@"year"] integerValue];
        if (year == 2013) {
            return YES;
        } else {
            return NO;
        };
    } else {
        NSLog(@"error: %@", error);
    }
}


    
@end
