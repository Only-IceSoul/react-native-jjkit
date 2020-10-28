//
//  GuisoWebPDecoder.swift
//  JJGuiso
//
//  Created by Juan J LF on 10/24/20.
//

import UIKit
import WebP
import WebPDemux

public class GuisoWebPDecoder : AnimatedImageDecoderProtocol {
    
    public init() {}
    private var demuxer: OpaquePointer?
    
    
    public func getFirstFrame(data: Data) -> CGImage? {
        
        var webPDataP :UnsafePointer<UInt8>?
        
        data.withUnsafeBytes({ (ptr)  in
            if let ptrAddress = ptr.baseAddress, ptr.count > 0 {
                  webPDataP = ptrAddress.assumingMemoryBound(to: UInt8.self)
               }
        })
     
        if webPDataP == nil { return nil }
      
        var webPData = WebPData(bytes: webPDataP!, size: data.count)
         demuxer  = WebPDemux(&webPData)
        
        defer {
            WebPDemuxDelete(demuxer)
        }
        let frameCount = Int(WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT))
        let width      = Int(WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH))
        let height     = Int(WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT))
        
        guard frameCount > 0 && width > 0 && height > 0 else {
            return nil
        }
        var iter = WebPIterator()
        
        if WebPDemuxGetFrame(demuxer, 1, &iter) != 0 {
            if let img = decodeImage(iter: &iter){
                return img
            }else { return nil}
         
        }else{
            return nil
        }
    }

    public func decode(data:Data) -> AnimatedImage? {
      
        let gif = AnimatedImage()
        var webPDataP :UnsafePointer<UInt8>?
        
        data.withUnsafeBytes({ (ptr)  in
            if let ptrAddress = ptr.baseAddress, ptr.count > 0 {
                  webPDataP = ptrAddress.assumingMemoryBound(to: UInt8.self)
               }
        })
      
        if webPDataP == nil { return nil }
        var webPData = WebPData(bytes: webPDataP!, size: data.count)
         demuxer  = WebPDemux(&webPData)
        
        defer {
            WebPDemuxDelete(demuxer)
        }
        let frameCount = Int(WebPDemuxGetI(demuxer, WEBP_FF_FRAME_COUNT))
        let loopCount  = Int(WebPDemuxGetI(demuxer, WEBP_FF_LOOP_COUNT))
        let width      = Int(WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_WIDTH))
        let height     = Int(WebPDemuxGetI(demuxer, WEBP_FF_CANVAS_HEIGHT))
        
        guard frameCount > 0 && width > 0 && height > 0 else {
            return nil
        }
        gif.loopCount = loopCount
       
        
    
        var iter = WebPIterator()
        if WebPDemuxGetFrame(demuxer, 1, &iter) != 0 {
            defer {
                WebPDemuxReleaseIterator(&iter)
            }
            repeat {
              
                var duration = Double(iter.duration) / 1000.0
                if (duration <= 0.01) {duration = 0.1}
                gif.delays.append(duration)
                if let img = decodeImage(iter: &iter){
                    gif.frames.append(img)
                }else{
                    return nil
                }
                

            } while (WebPDemuxNextFrame(&iter) != 0)
        }
        
        let durationTotal: Double = {
        var sum : Double = 0
         
        for val in gif.delays {
             sum += val
         }
         
         return sum
        }()
        
        gif.duration = durationTotal
        
//        let gcd = gcdForDelays(gif.delays.map({ (d) -> Int in
//            Int(d * 1000)
//        }))
//        
       
//       var frameCountGcd: Int
//        var framesGcd = [CGImage]()
//        for i in 0..<gif.frames.count {
//
//            frameCountGcd = Int(Int(gif.delays[Int(i)] * 1000) / gcd)
//
//           for _ in 0..<frameCountGcd {
//            framesGcd.append(gif.frames[Int(i)])
//           }
//       }
//
//        gif.frames = framesGcd
        
      
        return gif
    }
    
    func decodeImage(iter: inout WebPIterator) -> CGImage? {

        var config   = WebPDecoderConfig()
        let data     = iter.fragment.bytes
        let dataSize = iter.fragment.size
        let width = Int(iter.width)
        let height = Int(iter.height)

        if WebPInitDecoderConfig(&config) == 0 ||
            WebPGetFeatures(data, dataSize, &config.input) != VP8_STATUS_OK {
            return nil
        }

        let components: size_t = config.input.has_alpha != 0 ? 4 : 3
        let bitsPerComponent   = 8
        let bitsPerPixel       = bitsPerComponent * components
        let bytesPerRow        = width * components


        config.output.colorspace = config.input.has_alpha != 0 ? MODE_rgbA : MODE_RGB
        config.options.use_threads = 1

        let decodeStatus = WebPDecode(data, dataSize, &config)
        if decodeStatus != VP8_STATUS_OK && decodeStatus != VP8_STATUS_NOT_ENOUGH_DATA {
            return nil
        }

        let provider = CGDataProvider(dataInfo: nil,
                                      data: config.output.u.RGBA.rgba,
                                      size: config.output.u.RGBA.size,
                                      releaseData: { (info: UnsafeMutableRawPointer?, data: UnsafeRawPointer, size: Int) -> Void in
                                        free(UnsafeMutableRawPointer(mutating: data))
        })
        guard let wrappedProvider = provider else {
            return nil
        }

        let bitmapInfo: CGBitmapInfo = config.input.has_alpha != 0 ?
            [CGBitmapInfo.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)] : CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)

        return CGImage(width: width,
                              height: height,
                              bitsPerComponent: bitsPerComponent,
                              bitsPerPixel: bitsPerPixel,
                              bytesPerRow: bytesPerRow,
                              space: CGColorSpaceCreateDeviceRGB(),
                              bitmapInfo: bitmapInfo,
                              provider: wrappedProvider,
                              decode: nil,
                              shouldInterpolate: false,
                              intent: .defaultIntent)
    }
    
    func gcdForDelays(_ millis: Array<Int>) -> Int {
       if millis.isEmpty {
        return 1
       }
       var gcd = millis[0]
    
       for val in millis {
           gcd = gcdForPair(val, gcd)
          
       }
       
       return gcd
    }

    func gcdForPair(_ a: Int, _ b: Int) -> Int {
         var a = a
         var b = b

         if a < b {
             let c = a
             a = b
             b = c
         }
         var rest: Int
         while true {
             rest = a % b
             
             if rest == 0 {
                 return b
             } else {
                 a = b
                 b = rest
             }
         }
     }
}
