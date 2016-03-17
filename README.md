# DriftAnimationImageView

[![Version](https://img.shields.io/cocoapods/v/DriftAnimationImageView.svg?style=flat)](http://cocoapods.org/pods/DriftAnimationImageView)
[![License](https://img.shields.io/cocoapods/l/DriftAnimationImageView.svg?style=flat)](http://cocoapods.org/pods/DriftAnimationImageView)
[![Platform](https://img.shields.io/cocoapods/p/DriftAnimationImageView.svg?style=flat)](http://cocoapods.org/pods/DriftAnimationImageView)

![Demo 0](https://raw.githubusercontent.com/hectr/DriftAnimationImageView/master/demo0.gif "Demo 0")
![Demo 1](https://raw.githubusercontent.com/hectr/DriftAnimationImageView/master/demo1.gif "Demo 1")

## Introduction

`UIImageView` subclass that performs slow translation and scale animations on its image.

You perform random translation and scale animations with `beginDriftAnimations()`:

```swift
imageView.beginDriftAnimations()
```

You perform a custom animation by using the `DriftAnimationTraits` struct:

```swift
let traits = self.buildDriftAnimationTraits(imageView
    , repeats: true
    , zoomOut: false
    , minZoom: 1.0
    , maxZoom: 2.0
    , minPointsPerSec: 4
    , maxPointsPerSec: 5)
DriftAnimationImageView.addDriftAnimations(imageView, traits: traits, completion: nil)
```

You perform random translation and scale animations on a series of images with `performDriftAnimations()`:

```swift
imageView.performDriftAnimations(["image0", "image1"])
```

You remove an ongoing animation with `removeDriftAnimations()`:

```swift
imageView.removeDriftAnimations()
```

## Usage

To run the example project, clone the repo, and run `pod install` from the *Example* directory first.

## Installation

**DriftAnimationImageView** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DriftAnimationImageView"
```

## License

**DriftAnimationImageView** is available under the MIT license. See the *LICENSE* file for more info.
