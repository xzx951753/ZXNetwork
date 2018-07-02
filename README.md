# ZXNetwork
AFNetworking的简单封装

## Example

```Objective-C

    [ZXNetworkManager sendRequestMethod:HTTPMethodGET
                              serverUrl:@"http://192.168.88.249:20000"
                                apiPath:@"index"
                             parameters:nil
                               progress:nil
                                success:^(BOOL isSuccess, id  _Nullable responseObject) {
                                    NSLog(@"%@",responseObject);
                              } failure:^(NSString * _Nullable errorMessage) {
                                    NSLog(@"%@",errorMessage);
                              }];
```


## Updated  
0.1.3 ：针对服务器status 500+ 和400+ 错误发送相应的通知  
0.1.4 ：修复当出现400+错误时，导致崩溃.  
0.1.5 :  修复url拼接bug  
0.1.6 :  声明返回数据结果为json格式

## Installation

```ruby
pod 'ZXNetwork'
```

## Author

xzx951753, 285644797@qq.com

## License

ZXNetwork is available under the MIT license. See the LICENSE file for more info.
