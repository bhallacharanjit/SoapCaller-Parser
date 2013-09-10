//
//  ZSWebserviceCallerandparser.h
//  SoapServiceCallerandParser
//
//  Created by Charanjit Singh Bhalla on 10/09/13.
//  Copyright (c) 2013 ZS. All rights reserved.
//

#import <Foundation/Foundation.h>


// Protocol definition starts here
@protocol ServiceCallingDelegate <NSObject>
@required
//array of dictionaries
- (void) processCompleted :(NSArray *) DataArray;
@end


@interface ZSWebserviceCallerandparser : NSObject <NSXMLParserDelegate>
{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    //XML Parser
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL *elementFound;
    NSMutableDictionary * mutableDictforResult;
    // Delegate to respond back
    id <ServiceCallingDelegate> _delegate;
    
    
}

@property (nonatomic,strong) id delegate;
//tags for parsing
@property (nonatomic , retain) NSArray * parsingtags;
//for allocating the dictionary when the new starting tag appears
@property (nonatomic , retain) NSString * startingtag;
//this contains the dictionary of all the resultsets thus found.
@property (nonatomic , retain) NSMutableArray * ResultArray;


//shared instance of the class
+(id)sharedinstance;


//calling services.
-(void)CallWebServicewithServiceRequest:(NSString *)servicerequest withServicepath:(NSString *)servicePath andServiceMethod:(NSString *)serviceMethod andParsingTags:(NSArray *)parsingtags andStartingTag:(NSString *) starttag;

@end
