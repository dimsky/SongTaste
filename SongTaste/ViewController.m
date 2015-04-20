//
//  ViewController.m
//  SongTaste
//
//  Created by William on 15/4/18.
//  Copyright (c) 2015年 dimsky. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking/AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    
    NSURL *url=[[NSURL alloc]initWithString:@"http://2012.songtaste.com/act"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[@"op=dmlogin&f=st&user=dimsky%40163.com&pass=xiaotian02&rmbr=true" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url
                                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                         timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"结果：%@",result);
    [[urlResponse allHeaderFields] valueForKey:@"Set-Cookie"];
    
//    [[AFHTTPSessionManager manager] POST:@"" parameters:@"" constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"ddd");
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error");
//    }];
    
}
- (IBAction)requestAction:(id)sender {
    NSURL *url=[[NSURL alloc]initWithString:@"http://2012.songtaste.com/act"];
    
    NSMutableData *postBody=[NSMutableData data];
    [postBody appendData:[@"op=dmlogin&f=st&user=dimsky%40163.com&pass=xiaotian02&rmbr=true&tmp=0.5915272135753185" dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url
                                                             cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                         timeoutInterval:20.0f];
    [request setHTTPMethod: @"POST"];
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postBody];
    NSError *error = nil;
    NSHTTPURLResponse* urlResponse = nil;
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//   [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       NSLog(@"%@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error);
//    }];
    
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData
                                             encoding:NSUTF8StringEncoding];
    NSLog(@"结果：%@",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
