//
//  Cropper.m
//  react-native-jjkit
//
//  Created by Juan J LF on 5/5/20.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface

RCT_EXTERN_MODULE(Cropper,NSObject)

RCT_EXTERN_METHOD(makeCrop:(NSDictionary)request resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)


@end

