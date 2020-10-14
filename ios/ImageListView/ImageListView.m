//
//  ImageListView.m
//  CocoaAsyncSocket
//
//  Created by Juan J LF on 10/9/20.
//

#import <Foundation/Foundation.h>
#import "React/RCTViewManager.h"
#import <React/RCTUIManager.h>


@interface


RCT_EXTERN_MODULE(ImageListView,RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
RCT_EXPORT_VIEW_PROPERTY(onEndReached, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onItemClicked, RCTDirectEventBlock)


RCT_EXTERN_METHOD(getSelectedItems:(nonnull NSNumber)tag resolve:(RCTPromiseResolveBlock)resolve
rejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(addItems:(nonnull NSNumber)tag items:(NSArray)items)

@end

