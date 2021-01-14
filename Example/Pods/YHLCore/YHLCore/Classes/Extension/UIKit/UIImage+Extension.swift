//
//  UIImage.swift
//  GWUtilCore
//
//  Created by 刘岩 on 2020/2/12.
//

import Foundation
import CoreGraphics
#if os(macOS)
import AppKit.NSScreen
#endif

extension UIImage {
    
    convenience public init?(inUtilCore imageName: String) {
        let bundle = Bundle.utilCoreBundle
        self.init(named: imageName, in: bundle, compatibleWith: nil)
    }
    
}

private var staticColorSpace: CGColorSpace?

extension UIImage {
    
    public var containsAlphaChannel: Bool? {
        if let image = cgImage {
            return UIImage.containsAlphaChannel(by: image)
        }
        return nil
    }
    
    public class func containsAlphaChannel(by image: CGImage) -> Bool {
        let alphaInfo = CGImageAlphaInfo(rawValue: image.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue)
        var hasAlpha = false
        if alphaInfo == .premultipliedLast || alphaInfo == .premultipliedFirst || alphaInfo == .last || alphaInfo == .first {
            hasAlpha = true
        }
        return hasAlpha
    }
    
    public class var colorSpace: CGColorSpace {
        #if os(macOS)
        if let screenColorSpace = NSScreen.main?.colorSpace?.cgColorSpace {
            return screenColorSpace
        }
        #endif
        func getColorSpace() -> CGColorSpace {
            var colorSpace: CGColorSpace
            #if os(iOS) || os(watchOS) || os(tvOS)
            if #available(iOS 9.0, tvOS 9.0, *) {
                colorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
            } else {
                colorSpace = CGColorSpaceCreateDeviceRGB()
            }
            #else
            colorSpace = CGColorSpaceCreateDeviceRGB()
            #endif
            return colorSpace
        }
        if staticColorSpace == nil {
            staticColorSpace = getColorSpace()
        }
        return staticColorSpace!
    }
    
    public func unzip() -> UIImage? {
        guard let imageRef = cgImage else {
            return nil
        }
        let width = imageRef.width
        let height = imageRef.height
        let hasAlpha = containsAlphaChannel ?? false
        var bitmapInfo = CGBitmapInfo.byteOrder32Little
        let value = bitmapInfo.rawValue | (hasAlpha ? CGImageAlphaInfo.premultipliedFirst.rawValue : CGImageAlphaInfo.noneSkipFirst.rawValue)
        bitmapInfo = CGBitmapInfo(rawValue: value)
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: UIImage.colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(imageRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let newImageRef = context?.makeImage() else {
            return nil
        }
        return UIImage(cgImage: newImageRef)
    }
    
    
}

extension UIImage {
    // 修复图片旋转
    public func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
            
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
            
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
            
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
            
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
    }
}
