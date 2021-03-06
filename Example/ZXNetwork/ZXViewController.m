//
//  ZXViewController.m
//  ZXNetwork
//
//  Created by xzx951753 on 04/23/2018.
//  Copyright (c) 2018 xzx951753. All rights reserved.
//

#import "ZXViewController.h"
#import <ZXnetwork/ZXNetwork.h>

@interface ZXViewController ()

@end

@implementation ZXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ZXNetworkManager sendRequestMethod:HTTPMethodGET
                              serverUrl:@"https://www.baidu.com"
                                apiPath:nil
                             parameters:nil
                               progress:nil
                                success:^(BOOL isSuccess, id  _Nullable responseObject) {
                                    NSLog(@"%@",responseObject);
                                }
                                failure:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(failure:) name:ZXNetworkDidFailureNotification object:nil];
}

- (void)failure:(NSNotification*)notic{
    NSLog(@"获取到失败通知!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
