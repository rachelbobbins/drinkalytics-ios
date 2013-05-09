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
- (void)postDrinkWithType:(NSString *)name andDetails:(NSString *)detail
{
    //posts a drink
    NSURL *url = [[NSURL alloc] initWithString:@"http://drinkalytics.herokuapp.com/api/drinks"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *postString = [[NSMutableString alloc]init];
    [postString appendFormat:@"drink=%@:%@", name, detail];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *conn = [[NSURLConnection alloc] init];
    (void)[conn initWithRequest:request delegate:self];

}

- (NSDictionary *)getRankings
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://drinkalytics.herokuapp.com/api/rankings"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSMutableDictionary *rankings = [[NSMutableDictionary alloc] init];
    if ([response statusCode] == 200) {
        //give drinkalytics permission to use the session cookie
        NSError *jsonReadError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonReadError];
        
        for (int i=0; i < [responseArray count]; i++) {
            NSString *nameId = [(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"id"];
            NSString *rank = [[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"rank"] stringValue];
            
            Person *person = [[Person alloc] init];
            [person setUserId:nameId];
            [person setRank:[[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"rank"] integerValue]];
            [person setNumberOfDrinks:[[(NSDictionary *)[responseArray objectAtIndex:i] objectForKey:@"drinks"] integerValue]];

            [rankings setObject:person forKey:rank];
        }
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
        NSMutableArray *drinkArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *drinkDict in responseArray) {
            long long ms = [[drinkDict valueForKey:@"date"] longLongValue];
            long long s = ms / 1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:s];
            
            Drink *drink = [[Drink alloc] init];
            [drink setType:[drinkDict valueForKey:@"drink"]];
            [drink setTimestamp:date];
            [drinkArray addObject:drink];
        }
        return drinkArray;
    } else {
        NSLog(@"response status code: %i", [response statusCode]);
    }
    
}

- (BOOL)loginWithUsername:(NSString *)username andPassword:(NSString *)password
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
    NSLog(@"fetched user id: %@", userId);
    
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
        [[NSUserDefaults standardUserDefaults] synchronize];

        return YES;
    } else {
        return NO;
    }

}

- (void)getEveryonesDrinks
{
//    NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:3000/api/drinks"];
    NSURL *url = [[NSURL alloc] initWithString:@"http://drinkalytics.herokuapp.com/api/drinks"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *postString = [[NSMutableString alloc]init];
//    [postString appendFormat:@"user=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"]];
    [postString appendFormat:@"sessionID=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"sessionid"]];

    NSURLConnection *conn = [[NSURLConnection alloc] init];
//    [self setC]
    (void)[conn initWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate Methods
    
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
        // A response has been received, this is where we initialize the instance var you created
        // so that we can append data to it in the didReceiveData method
        // Furthermore, this method is called each time there is a redirect so reinitializing it
        // also serves to clear it
    NSLog(@"connection did respond");
    _responseData = [[NSMutableData alloc] init];
}
    
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
        // Append the new data to the instance variable you declared
        [_responseData appendData:data];
}
    
- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                    willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}
    
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"response data: %@", _responseData);
    
}
    
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"connection failed with error: %@", error);
}
    
@end
