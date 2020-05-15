//
//  PhotoKit.m
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface

RCT_EXTERN_MODULE(PhotoKit,NSObject)

RCT_EXTERN_METHOD(isPermissionGranted:
(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(clearMemoryCache:
(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(requestPermission:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchPhotos:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchVideos:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchAll:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(fetchAlbums:(NSArray)names media:(NSString)media resolve:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(requestRaw:(NSString)identifier resolve:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(requestImage:(NSDictionary)data resolve:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)


@end

