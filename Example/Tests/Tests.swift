import UIKit
import XCTest
@testable import DriftAnimationImageView

class Tests: XCTestCase {
    
    func testRandomValue() {
        let shortValue = 5
        let signedDistance = 10
        let value = DriftAnimationImageView.randomValue(shortValue, signedDistance:signedDistance)
        XCTAssertGreaterThanOrEqual(value, shortValue)
        XCTAssertLessThanOrEqual(value, (shortValue + signedDistance))
    }

    func testRandomNegativeValue() {
        let shortValue = 5
        let signedDistance = -10
        let value = DriftAnimationImageView.randomValue(shortValue, signedDistance:signedDistance)
        XCTAssertLessThanOrEqual(value, shortValue)
        XCTAssertGreaterThanOrEqual(value, signedDistance - shortValue)
    }

    func testBuildAnimationTraits() {
        let imageView = UIImageView()
        let repeats = true
        let zoomOut = true
        let minZoom: CGFloat = 0.5
        let maxZoom: CGFloat = 1.5
        let minPointsPerSec: CGFloat = 1.0
        let maxPointsPerSec: CGFloat = 4.0
        let traits = DriftAnimationImageView.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        XCTAssertTrue(traits.autoreverses)
        XCTAssertGreaterThan(traits.repeatCount, 1)
        XCTAssertGreaterThanOrEqual(traits.zoom, minZoom)
        XCTAssertLessThanOrEqual(traits.zoom, maxZoom + minZoom)
        let minDuration = NSTimeInterval(max(abs(traits.point.x), abs(traits.point.y))/minPointsPerSec)
        let maxDuration = NSTimeInterval(max(abs(traits.point.x), abs(traits.point.y))/maxPointsPerSec)
        XCTAssertGreaterThanOrEqual(traits.duration, minDuration)
        XCTAssertLessThanOrEqual(traits.duration, maxDuration)
    }
    
    func testBuildAnimationTraitsForSingleAnimation() {
        let imageView = UIImageView()
        let repeats = false
        let zoomOut = false
        let minZoom: CGFloat = 2.0
        let maxZoom: CGFloat = 4.5
        let minPointsPerSec: CGFloat = 18.0
        let maxPointsPerSec: CGFloat = 24.0
        let traits = DriftAnimationImageView.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        XCTAssertFalse(traits.autoreverses)
        XCTAssertEqual(traits.repeatCount, 1)
        XCTAssertGreaterThanOrEqual(traits.zoom, minZoom)
        XCTAssertLessThanOrEqual(traits.zoom, maxZoom + minZoom)
        let minDuration = NSTimeInterval(max(abs(traits.point.x), abs(traits.point.y))/minPointsPerSec)
        let maxDuration = NSTimeInterval(max(abs(traits.point.x), abs(traits.point.y))/maxPointsPerSec)
        XCTAssertGreaterThanOrEqual(traits.duration, minDuration)
        XCTAssertLessThanOrEqual(traits.duration, maxDuration)
    }
    
    func testBuildDriftPositionAnimation() {
        let imageView = UIImageView()
        let repeats = false
        let zoomOut = false
        let minZoom: CGFloat = 2.0
        let maxZoom: CGFloat = 4.5
        let minPointsPerSec: CGFloat = 18.0
        let maxPointsPerSec: CGFloat = 24.0
        let traits = DriftAnimationImageView.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        let animation = DriftAnimationImageView.buildDriftPositionAnimation(traits)
        XCTAssertTrue(animation.additive)
        XCTAssertEqual(animation.repeatCount, traits.repeatCount)
        XCTAssertNotEqual((animation.fromValue!.isEqual(NSValue(CGPoint: CGPointZero))), traits.zoomOut)
        XCTAssertNotEqual((animation.toValue!.isEqual(NSValue(CGPoint: traits.point))), traits.zoomOut)
        XCTAssertNotEqual((animation.fromValue!.isEqual(NSValue(CGPoint: traits.point))), traits.zoomOut)
        XCTAssertNotEqual((animation.toValue!.isEqual(NSValue(CGPoint: CGPointZero))), traits.zoomOut)
        XCTAssertEqual(animation.duration, traits.duration)
        XCTAssertEqual(animation.autoreverses, traits.autoreverses)
        XCTAssertEqual(animation.repeatCount, traits.repeatCount)
        XCTAssertFalse(animation.removedOnCompletion)
    }
    
    func testBuildZoomOutDriftPositionAnimation() {
        let imageView = UIImageView()
        let repeats = true
        let zoomOut = true
        let minZoom: CGFloat = 2.0
        let maxZoom: CGFloat = 4.5
        let minPointsPerSec: CGFloat = 18.0
        let maxPointsPerSec: CGFloat = 24.0
        let traits = DriftAnimationImageView.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        let animation = DriftAnimationImageView.buildDriftPositionAnimation(traits)
        XCTAssertTrue(animation.additive)
        XCTAssertEqual(animation.beginTime, 0.0)
        XCTAssertEqual((animation.fromValue!.isEqual(NSValue(CGPoint: CGPointZero))), traits.zoomOut)
        XCTAssertEqual((animation.toValue!.isEqual(NSValue(CGPoint: traits.point))), traits.zoomOut)
        XCTAssertEqual((animation.fromValue!.isEqual(NSValue(CGPoint: traits.point))), traits.zoomOut)
        XCTAssertEqual((animation.toValue!.isEqual(NSValue(CGPoint: CGPointZero))), traits.zoomOut)
        XCTAssertEqual(animation.duration, traits.duration)
        XCTAssertEqual(animation.autoreverses, traits.autoreverses)
        XCTAssertEqual(animation.repeatCount, traits.repeatCount)
        XCTAssertFalse(animation.removedOnCompletion)
    }
    
    func testBuildDriftZoomAnimation() {
        let imageView = UIImageView()
        let repeats = false
        let zoomOut = false
        let minZoom: CGFloat = 2.0
        let maxZoom: CGFloat = 4.5
        let minPointsPerSec: CGFloat = 18.0
        let maxPointsPerSec: CGFloat = 24.0
        let traits = DriftAnimationImageView.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        let animation = DriftAnimationImageView.buildDriftZoomAnimation(traits)
        XCTAssertEqual(animation.beginTime, 0.0)
        XCTAssertEqual(animation.duration, traits.duration)
        XCTAssertEqual(animation.autoreverses, traits.autoreverses)
        XCTAssertEqual(animation.repeatCount, traits.repeatCount)
        XCTAssertFalse(animation.removedOnCompletion)
    }
    
    func testBuildZoomOutDriftZoomAnimation() {
        let imageView = UIImageView()
        let repeats = false
        let zoomOut = false
        let minZoom: CGFloat = 2.0
        let maxZoom: CGFloat = 4.5
        let minPointsPerSec: CGFloat = 18.0
        let maxPointsPerSec: CGFloat = 24.0
        let traits = DriftAnimationImageView.buildDriftAnimationTraits(imageView
            , repeats: repeats
            , zoomOut: zoomOut
            , minZoom: minZoom
            , maxZoom: maxZoom
            , minPointsPerSec: minPointsPerSec
            , maxPointsPerSec: maxPointsPerSec)
        let animation = DriftAnimationImageView.buildDriftZoomAnimation(traits)
        XCTAssertEqual(animation.beginTime, 0.0)
        XCTAssertEqual(animation.duration, traits.duration)
        XCTAssertEqual(animation.autoreverses, traits.autoreverses)
        XCTAssertEqual(animation.repeatCount, traits.repeatCount)
        XCTAssertFalse(animation.removedOnCompletion)
    }

    func testDisplayedImageScale() {
        let imageView = UIImageView()
        XCTAssertEqual(DriftAnimationImageView.displayedImageScale(imageView),CGSizeZero)
    }
    
}
