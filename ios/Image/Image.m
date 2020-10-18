//
//  Image.m
//  react-native-jjkit
//
//  Created by Juan J LF on 4/20/20.
//

#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"
#import <React/RCTBridgeModule.h>


@interface


RCT_EXTERN_MODULE(Image,RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(scaleType, NSString)

RCT_EXPORT_VIEW_PROPERTY(onLoadStart, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadError, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadSuccess, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onLoadEnd, RCTDirectEventBlock)

@end
