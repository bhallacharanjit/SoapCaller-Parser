//
//  ZSWebserviceCallerandparser.m
//  SoapServiceCallerandParser
//
//  Created by Charanjit Singh Bhalla on 10/09/13.
//  Copyright (c) 2013 ZS. All rights reserved.
//

#import "ZSWebserviceCallerandparser.h"

static ZSWebserviceCallerandparser * instance;

@implementation ZSWebserviceCallerandparser

@synthesize parsingtags,startingtag,ResultArray;

+(id)sharedinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


-(void)CallWebServicewithServiceRequest:(NSString *)servicerequest withServicepath:(NSString *)servicePath andServiceMethod:(NSString *)serviceMethod andParsingTags:(NSArray *)parsetags andStartingTag:(NSString *) starttag {
    //setting the parsing tags array to parse the objects
    self.parsingtags = parsetags;
    //setting the starting tag of the element
    self.startingtag = starttag;
    //allocating and initailizing the array for result values
    self.ResultArray = [[NSMutableArray alloc] init];
    //allocating and initializing the dictionary
    mutableDictforResult = [[NSMutableDictionary alloc] init];
    //calling the web service
    [self callServicewithServiceRequest:servicerequest withPath:servicePath andMethodName:serviceMethod];
    //returning the result
    return ResultArray;
}



-(void)callServicewithServiceRequest:(NSString *)serviceRequest withPath:(NSString *)servicepath andMethodName:(NSString *)methodName {
    
    NSString *soapMsg = serviceRequest;
    ////NSLog(@"%@",soapMsg);
    NSURL *url = [NSURL URLWithString:servicepath];
    NSMutableURLRequest *req =
    [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength =
    [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString * soapAction = [NSString stringWithFormat:@"http://tempuri.org/%@",methodName];
    [req addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn)
    {
        
        webData = [NSMutableData data];
    }
}

-(void) connection:(NSURLConnection *) connection
didReceiveResponse:(NSURLResponse *) response {
    [webData setLength: 0];
    // //NSLog(@"didReceiveResponse");
}

-(void) connection:(NSURLConnection *) connection
    didReceiveData:(NSData *) data {
    [webData appendData:data];
    ////NSLog(@"didReceiveData");
}

-(void) connection:(NSURLConnection *) connection
  didFailWithError:(NSError *) error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"LpuTouch"
                          message:@"Error Connectiing to server"
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    // Parse tHe XML Data
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities:YES];
    [xmlParser parse];
    [ResultArray addObject:mutableDictforResult];
    if ([self.delegate respondsToSelector:@selector(processCompleted:)]) {
        NSLog(@"%d",
              ResultArray.count);
        [self.delegate processCompleted:ResultArray];
    }
    
    
}


-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict {
    
    if( [elementName isEqualToString:self.startingtag])
    {
        [ResultArray addObject:mutableDictforResult];
        mutableDictforResult = [[NSMutableDictionary alloc] init];
        if (!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        //elementFound = TRUE;
    }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
	soapResults = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    NSLog(@"%@ result-%@",elementName,soapResults);
    
    if ([self.parsingtags containsObject:elementName]) {
        if (soapResults != nil || ![soapResults isEqualToString:@""]) {
            [mutableDictforResult setObject:soapResults forKey:elementName];
        }
    }
    soapResults = nil;
    [soapResults setString:@""];
}







@end
