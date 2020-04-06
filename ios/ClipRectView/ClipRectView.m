//
//  ClipRectView.m
//  react-native-jjkit
//
//  Created by Juan J LF on 4/5/20.
//

#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"
#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>


@interface
RCT_EXTERN_MODULE(ClipRectView,RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(gravity, NSString)

RCT_EXPORT_VIEW_PROPERTY(inset, CGFloat)

RCT_EXPORT_VIEW_PROPERTY(progress, CGFloat)



@end
