// DriftAnimationImageView.swift
//
// Copyright (c) 2016 Héctor Marqués Ranea
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/**
 `UIImageView` subclass that performs slow translation and scale animations on its image.
*/
open class DriftAnimationImageView: UIImageView {
    
    /** Drift animations token. */
    var animationsToken: String?
    
    /**
     Traits that define a drift animation.
     */
    public struct DriftAnimationTraits {
        var point: CGPoint
        var zoom: CGFloat = 1.0
        var duration: TimeInterval = 15
        var autoreverses: Bool = true
        var repeatCount: Float = Float.infinity
        var zoomOut: Bool = false
    }
    
    /**
     Perform drift animations on a series of images.
     
     - parameter imageNames: The names of the images.
     - parameter imageIndex: The index of the image that should start animating.
     */
    open func performDriftAnimations(_ imageNames: [String], imageIndex: Int = 0) {
        if (imageNames.count > 0) {
            let currentImageIndex = (imageIndex < imageNames.count ? imageIndex : 0)
            let imageName = imageNames[currentImageIndex]
            if let image = UIImage(named: imageName) {
                let nextImageIndex = currentImageIndex + 1
                self.image = image
                let token = ProcessInfo.processInfo.globallyUniqueString
                self.animationsToken = token
                _ = self.beginDriftAnimations(false) { [weak self] (traits) in
                    if let imageView = self {
                        if (token.isEqual(imageView.animationsToken)) {
                            imageView.performDriftAnimations(imageNames, imageIndex: nextImageIndex)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Begins the drift animation.
     
     - parameter repeats: Whether the animation repeats forever or not.
     - parameter completion: Closure executed when the animation finishes.
     
     - returns: The animation duration.
     */
    open func beginDriftAnimations(_ repeats: Bool = true, completion: ((_ traits: DriftAnimationTraits) -> Void)? = nil) -> TimeInterval {
        
        let zoomOut = (type(of: self).randomValue(signedDistance: 100) % 2 != 0)
        return self.beginDriftAnimations(repeats, zoomOut: zoomOut, completion:completion)
    }
    
    /**
     Begins the drift animation.
     
     - parameter repeats: Whether the animation repeats forever or not.
     - parameter zoomOut: Whether the animation zooms out or in.
     - parameter completion: Closure executed when the animation finishes.
     
     - returns: The animation duration.
     */
    open func beginDriftAnimations(_ repeats: Bool = true, zoomOut: Bool, completion: ((_ traits: DriftAnimationTraits) -> Void)? = nil) -> TimeInterval {
        
        if let block = completion {
            return type(of: self).beginDriftAnimations(self, repeats: repeats, zoomOut: zoomOut) { imageView, traits in
                block(traits)
            }
        } else {
            return type(of: self).beginDriftAnimations(self, repeats: repeats, zoomOut: zoomOut)
        }
        
    }
    
    /**
     Removes any previously added drift animations from the receiver.
     */
    open func removeDriftAnimations() {
        self.animationsToken = nil
        type(of: self).removeDriftAnimations(self)
    }
    
    /**
     Calculates the size of the image as it is displayed by the receiver.
     
     - parameter imageView: The image view from which the actual displayed image size will be calculated.
     
     - returns: The size of the image as it is displayed by the image view.
     */
    open class func actualDisplayedImageSize(_ imageView: UIImageView) -> CGSize {
        
        var size = CGSize()
        if let image = imageView.image {
            let scale = self.displayedImageScale(imageView)
            let originalSize = image.size
            size.width = scale.width*originalSize.width
            size.height = scale.height*originalSize.height
        }
        return size
    }
    
    /**
     Calculates the maximum valid insets for the drift animations.
     
     - parameter imageView: The image view from which insets will be calculated.
     - parameter zoom: The zoom transformation used when calculating the insets.
     
     - returns: The maximum insets that can be used for the animations.
     */
    open class func driftInsets(_ imageView: UIImageView, zoom: CGPoint = CGPoint(x: 1.0, y: 1.0)) -> UIEdgeInsets {
        
        var imageSize = self.actualDisplayedImageSize(imageView)
        imageSize.width = imageSize.width*zoom.x
        imageSize.height = imageSize.height*zoom.y
        let viewSize = imageView.bounds.size
        let contentMode = imageView.contentMode
        
        var insets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let y = imageSize.height - viewSize.height
        switch contentMode {
        case .scaleToFill, .scaleAspectFit, .scaleAspectFill, .redraw, .center, .left, .right:
            insets.top = y/2
            insets.bottom = y/2
        case .top, .topLeft, .topRight:
            insets.bottom = y
        case .bottom, .bottomLeft, .bottomRight:
            insets.top = y
        }
        
        let x = imageSize.width - viewSize.width
        switch contentMode {
        case .scaleToFill, .scaleAspectFit, .scaleAspectFill, .redraw, .center, .top, .bottom:
            insets.left = x/2
            insets.right = x/2
        case  .left, .topLeft, .bottomLeft:
            insets.right = x
        case .right, .topRight, .bottomRight:
            insets.left = x
        }
        
        return insets
    }
    
    /**
     Begins the drift animation. After calculating the parameters for the animations, passes them to `addDriftAnimations(imageView:, traits:, completion:)`.
     
     - parameter imageView: The image view to which animations are added.
     - parameter repeats: Whether the animation repeats forever or not.
     - parameter zoomOut: Whether the animation zooms out or in.
     - parameter minZoom: The minimum zoom value for the animation.
     - parameter maxZoom: The maximum zoom value for the animation.
     - parameter minPointsPerSec: The minimum points per second used for calculating animation duration.
     - parameter maxPointsPerSec: The maximum points per second used for calculating animation duration.
     - parameter completion: Closure executed when the animation finishes.
     
     - returns: The animation duration.
     */
    open class func beginDriftAnimations(_ imageView: UIImageView, repeats: Bool = false, zoomOut: Bool = false, minZoom: CGFloat = 1.0, maxZoom: CGFloat = 2.0, minPointsPerSec: CGFloat = 3.0, maxPointsPerSec: CGFloat = 5.0, completion: ((_ imageView: UIImageView, _ traits: DriftAnimationTraits) -> Void)? = nil) -> TimeInterval {
        
        let traits = self.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        
        self.addDriftAnimations(imageView
            , traits: traits
            , completion: completion)
        return traits.duration
    }

    /**
     Builds the drift animation traits.
     
     - parameter imageView: The image view from which traits are calculted.
     - parameter repeats: Whether the animation repeats forever or not.
     - parameter zoomOut: Whether the animation zooms out or in.
     - parameter minZoom: The minimum zoom value for the animation.
     - parameter maxZoom: The maximum zoom value for the animation.
     - parameter minPointsPerSec: The minimum points per second used for calculating animation duration.
     - parameter maxPointsPerSec: The maximum points per second used for calculating animation duration.
     
     - returns: The drift animation traits.
     */
    open class func buildDriftAnimationTraits(_ imageView: UIImageView, repeats: Bool = false, zoomOut: Bool = false, minZoom f_minZoom: CGFloat = 1.0, maxZoom f_maxZoom: CGFloat = 1.8, minPointsPerSec f_minPointsPerSec: CGFloat = 3.0, maxPointsPerSec f_maxPointsPerSec: CGFloat = 5.0) -> DriftAnimationTraits {
        
        let minZoom = Int(f_minZoom*100)
        let maxZoom = Int(f_maxZoom*100)
        let zoom = CGFloat(self.randomValue(minZoom, signedDistance: maxZoom))/100.0
        
        let insets = self.driftInsets(imageView, zoom: CGPoint(x: zoom, y: zoom))
        
        var maxY: Int = 0
        if (fabs(insets.top) > fabs(insets.bottom)) {
            maxY = Int(-insets.top)
        } else {
            maxY = Int(-insets.bottom)
        }
        var maxX: Int = 0
        if (fabs(insets.left) > fabs(insets.right)) {
            maxX = Int(-insets.left)
        } else {
            maxX = Int(-insets.right)
        }
        
        let minX: Int = 0
        let x = self.randomValue(minX, signedDistance: maxX)
        let minY: Int = 0
        let y = self.randomValue(minY, signedDistance: maxY)
        let point: CGPoint = CGPoint(x: CGFloat(x), y: CGFloat(y))
        
        let minPointsPerSec = Int(f_minPointsPerSec*100)
        let maxPointsPerSec = Int(f_maxPointsPerSec*100)
        let pointsPerSec = TimeInterval(self.randomValue(minPointsPerSec, signedDistance: maxPointsPerSec))/100.0
        let duration = TimeInterval(max(abs(point.x), abs(point.y)))/pointsPerSec
        
        let traits = DriftAnimationTraits(point: point
            , zoom: zoom
            , duration: duration
            , autoreverses: repeats
            , repeatCount: (repeats ? Float.infinity : 1.0)
            , zoomOut: zoomOut)
        return traits
    }
    
    /** The string that identifies the `transform.scale` animation. */
    static let zoomAnimationKey = "DriftAnimationImageView_zoom"
    /** The string that identifies the `position` animation. */
    static let positionAnimationKey = "DriftAnimationImageView_position"
    
    /**
     Removes any previously added drift animations.
     
     - parameter imageView: The image view from which animations will be removed.
     */
    open class func removeDriftAnimations(_ imageView: UIImageView) {
        imageView.layer.removeAnimation(forKey: positionAnimationKey)
        imageView.layer.removeAnimation(forKey: zoomAnimationKey)
    }
    
    /**
     Creates the zoom and position animations and adds them to the layer of the image view.
     
     - parameter imageView: The image view to which animations will be added.
     - parameter traits: The drift animation traits used for creating the layer animations.
     - parameter completion: Closure executed when the animation finishes.
     */
    open class func addDriftAnimations(_ imageView: UIImageView, traits: DriftAnimationTraits, completion: ((_ imageView: UIImageView, _ traits: DriftAnimationTraits) -> Void)? = nil) {
        
        CATransaction.begin()
        if let block = completion {
            CATransaction.setCompletionBlock { () -> Void in
                block(imageView, traits)
            }
        }
        
        let positionAnimation = self.buildDriftPositionAnimation(traits)
        imageView.layer.add(positionAnimation, forKey: positionAnimationKey)
        
        if (traits.zoom != 1.0) {
            let zoomAnimation = self.buildDriftZoomAnimation(traits)
            imageView.layer.add(zoomAnimation, forKey: zoomAnimationKey)
        }
        
        CATransaction.commit()
    }
    
    /**
     Builds the position `CABasicAnimation` used for the drift animation.
     
     - parameter traits: The drift animation traits used for creating the zoom animation.
     
     - returns: The `CABasicAnimation` object.
     */
    open class func buildDriftPositionAnimation(_ traits: DriftAnimationTraits) -> CABasicAnimation {
        
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.isAdditive = true
        if (!traits.zoomOut) {
            positionAnimation.fromValue =  NSValue(cgPoint: CGPoint.zero)
            positionAnimation.toValue =  NSValue(cgPoint: traits.point)
        } else {
            positionAnimation.fromValue =  NSValue(cgPoint: traits.point)
            positionAnimation.toValue =  NSValue(cgPoint: CGPoint.zero)
        }
        positionAnimation.duration = traits.duration
        positionAnimation.autoreverses = traits.autoreverses
        positionAnimation.repeatCount =  traits.repeatCount
        positionAnimation.isRemovedOnCompletion = false
        return positionAnimation
    }
    
    /**
     Builds the zoom `CABasicAnimation` used for the drift animation.
     
     - parameter traits: The drift animation traits used for creating the zoom animation.
     
     - returns: The `CABasicAnimation` object.
     */
    open class func buildDriftZoomAnimation(_ traits: DriftAnimationTraits) -> CABasicAnimation {
        
        let zoomAnimation = CABasicAnimation(keyPath: "transform.scale")
        if (!traits.zoomOut) {
            zoomAnimation.fromValue = 1.0
            zoomAnimation.toValue = traits.zoom
        } else {
            zoomAnimation.fromValue = traits.zoom
            zoomAnimation.toValue = 1.0
        }
        zoomAnimation.duration = traits.duration
        zoomAnimation.autoreverses = traits.autoreverses
        zoomAnimation.repeatCount = traits.repeatCount
        zoomAnimation.isRemovedOnCompletion = false
        return zoomAnimation
    }

    /**
     Calculates a random number between the two parameters.
     
     - parameter shortValue: The minimum absolute value.
     - parameter signedDistance: The signed value used as maximum distance and whose sign is used as the result's sign.
     
     - returns: The random value.
     */
    class func randomValue(_ shortValue: Int = 0, signedDistance: Int) -> Int {
        
        let unsignedDistance = abs(signedDistance)
        let sign = (signedDistance != 0 ? signedDistance/unsignedDistance : 1)
        let random = arc4random_uniform(UInt32(unsignedDistance))
        let x = sign*(shortValue + Int(random))
        NSLog("shortValue \(shortValue)")
        NSLog("signedDistance \(signedDistance)")
        NSLog("unsignedDistance \(unsignedDistance)")
        NSLog("sign \(sign)")
        NSLog("random \(random)")
        NSLog("x \(x)")
        return x
    }
    
    /**
     Calculates the scale of the displayed image of an image view according to its `contentMode`.
     */
    class func displayedImageScale(_ imageView: UIImageView) -> CGSize {
        
        var scale = CGSize()
        if let image = imageView.image {
            let sx = Double(imageView.frame.size.width/image.size.width)
            let sy = Double(imageView.frame.size.height/image.size.height)
            var s = 1.0
            switch (imageView.contentMode) {
            case .scaleAspectFit:
                s = fmin(sx, sy)
                scale = CGSize (width: s, height: s)
            case .scaleAspectFill:
                s = fmax(sx, sy)
                scale = CGSize(width:s, height:s)
            case .scaleToFill:
                scale = CGSize(width:sx, height:sy)
            case .redraw, .center, .left, .right, .top, .topLeft, .topRight, .bottom, .bottomLeft, .bottomRight:
                scale = CGSize(width:s, height:s)
            }
        }
        
        return scale
    }
    
}
