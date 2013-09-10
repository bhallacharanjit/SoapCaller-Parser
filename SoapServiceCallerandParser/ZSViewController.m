//
//  ZSViewController.m
//  SoapServiceCallerandParser
//
//  Created by Charanjit Singh Bhalla on 10/09/13.
//  Copyright (c) 2013 ZS. All rights reserved.
//

#import "ZSViewController.h"
#import "ZSWebserviceCallerandparser.h"

@interface ZSViewController ()

@end

@implementation ZSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self callService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)callService {
    
    NSString *servicereq = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
    "<soap:Body>"
    "<CelsiusToFahrenheit xmlns=\"http://tempuri.org/\">"
    "<Celsius>23</Celsius>"
    "</CelsiusToFahrenheit>"
    "</soap:Body>"
    "</soap:Envelope>";
    
    NSString *servicePath = [NSString stringWithFormat:@"http://www.w3schools.com/webservices/tempconvert.asmx"];
    
    
    
    [[ZSWebserviceCallerandparser sharedinstance] setDelegate:self];
    
    [[ZSWebserviceCallerandparser sharedinstance] CallWebServicewithServiceRequest:servicereq withServicepath:servicePath andServiceMethod:@"CelsiusToFahrenheit" andParsingTags:@[@"CelsiusToFahrenheitResult"] andStartingTag:@"CelsiusToFahrenheitResponse"];

}


//implementing the delegate
-(void) processCompleted:(NSArray *)DataArray {
    NSLog(@"The array returned is %@",DataArray);
}





@end
