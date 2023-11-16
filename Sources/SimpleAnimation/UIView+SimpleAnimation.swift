// swiftlint:disable all

//
//  UIView+SimpleAnimation.swift
//  SimpleAnimation.swift
//
//  Created by Keith Ito on 4/19/16.
//

import UIKit

/// Edge of the view's parent that the animation should involve
/// - none: involves no edge
/// - top: involves the top edge of the parent
/// - bottom: involves the bottom edge of the parent
/// - left: involves the left edge of the parent
/// - right: involves the right edge of the parent
 public enum SimpleAnimationEdge {
  case none
  case top
  case bottom
  case left
  case right
 }

/// A UIView extension that makes adding basic animations, like fades and bounces, simple.
 extension UIView {
  /// Fades this view in. This method can be chained with other animations to combine a fade with
  /// the other animation, for instance:
  /// ```
  /// view.fadeIn().slideIn(from: .left)
  /// ```
  /// - Parameters:
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func fadeIn(
    duration: TimeInterval = 0.25,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    isHidden = false
    alpha = 0
    UIView.animate(
      withDuration: duration, delay: delay, options: .curveEaseInOut, animations: {
        self.alpha = 1
      }, completion: completion
    )
    return self
  }

  /// Fades this view out. This method can be chained with other animations to combine a fade with
  /// the other animation, for instance:
  /// ```
  /// view.fadeOut().slideOut(to: .right)
  /// ```
  /// - Parameters:
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func fadeOut(
    duration: TimeInterval = 0.25,
    delay: TimeInterval = 0,
    completionHandler: ((Bool) -> Void)? = nil
  ) -> UIView {
    UIView.animate(
      withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
        self.alpha = 0
      }, completion: completionHandler
    )
    return self
  }

  /// Fades the background color of a view from existing bg color to a specified color without
  /// using alpha values.
  ///
  /// - Parameters:
  /// - toColor: the final color you want to fade to
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func fadeColor(
    toColor: UIColor,
    duration: TimeInterval = 0.25,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    UIView.animate(
      withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
        self.backgroundColor = toColor
      }, completion: completion
    )
    return self
  }

  /// Slides this view into position, from an edge of the parent (if "from" is set) or a fixed
  /// offset
  /// away from its position (if "x" and "y" are set).
  /// - Parameters:
  /// - from: edge of the parent view that should be used as the starting point of the animation
  /// - x: horizontal offset that should be used for the starting point of the animation
  /// - y: vertical offset that should be used for the starting point of the animation
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func slideIn(
    from edge: SimpleAnimationEdge = .none,
    x: CGFloat = 0,
    y: CGFloat = 0,
    duration: TimeInterval = 0.4,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    let offset = offsetFor(edge: edge)
    transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
    isHidden = false
    UIView.animate(
      withDuration: duration, delay: delay, usingSpringWithDamping: 1,
      initialSpringVelocity: 2,
      options: .curveEaseOut, animations: {
        self.transform = .identity
        self.alpha = 1
      }, completion: completion
    )
    return self
  }

  /// Slides this view out of its position, toward an edge of the parent (if "to" is set) or a
  /// fixed
  /// offset away from its position (if "x" and "y" are set).
  /// - Parameters:
  /// - to: edge of the parent view that should be used as the ending point of the animation
  /// - x: horizontal offset that should be used for the ending point of the animation
  /// - y: vertical offset that should be used for the ending point of the animation
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func slideOut(
    to edge: SimpleAnimationEdge = .none,
    x: CGFloat = 0,
    y: CGFloat = 0,
    duration: TimeInterval = 0.25,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    let offset = offsetFor(edge: edge)
    let endTransform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
    UIView.animate(
      withDuration: duration, delay: delay, options: .curveEaseOut, animations: {
        self.transform = endTransform
      }, completion: completion
    )
    return self
  }

  /// Moves this view into position, with a bounce at the end, either from an edge of the parent
  /// (if "from" is set) or a fixed offset away from its position (if "x" and "y" are set).
  /// - Parameters:
  /// - from: edge of the parent view that should be used as the starting point of the animation
  /// - x: horizontal offset that should be used for the starting point of the animation
  /// - y: vertical offset that should be used for the starting point of the animation
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func bounceIn(
    from edge: SimpleAnimationEdge = .none,
    x: CGFloat = 0,
    y: CGFloat = 0,
    duration: TimeInterval = 0.5,
    referenceView: UIView? = nil,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    let offset = offsetFor(edge: edge, referenceView: referenceView)
    transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
    isHidden = false
    UIView.animate(
      withDuration: duration, delay: delay, usingSpringWithDamping: 0.58,
      initialSpringVelocity: 3,
      options: .curveEaseOut, animations: {
        self.transform = .identity
        self.alpha = 1
      }, completion: completion
    )
    return self
  }

  /// Moves this view out of its position, starting with a bounce. The view moves toward an edge
  /// of the parent (if "to" is set) or a fixed offset away from its position (if "x" and "y" are
  /// set).
  /// - Parameters:
  /// - to: edge of the parent view that should be used as the ending point of the animation
  /// - x: horizontal offset that should be used for the ending point of the animation
  /// - y: vertical offset that should be used for the ending point of the animation
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func bounceOut(
    to edge: SimpleAnimationEdge = .none,
    x: CGFloat = 0,
    y: CGFloat = 0,
    duration: TimeInterval = 0.35,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    let offset = offsetFor(edge: edge)
    let delta = CGPoint(x: offset.x + x, y: offset.y + y)
    let endTransform = CGAffineTransform(translationX: delta.x, y: delta.y)
    let prepareTransform = CGAffineTransform(translationX: -delta.x * 0.2, y: -delta.y * 0.2)
    UIView.animateKeyframes(
      withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
          self.transform = prepareTransform
        }
        UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
          self.transform = prepareTransform
        }
        UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
          self.transform = endTransform
        }
      }, completion: completion
    )
    return self
  }

  /// Moves this view into position, as though it were popping out of the screen.
  /// - Parameters:
  /// - fromScale: starting scale for the view, should be between 0 and 1
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func popIn(
    fromScale: CGFloat = 0.5,
    duration: TimeInterval = 0.5,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    isHidden = false
    alpha = 0
    transform = CGAffineTransform(scaleX: fromScale, y: fromScale)
    UIView.animate(
      withDuration: duration, delay: delay, usingSpringWithDamping: 0.55,
      initialSpringVelocity: 3,
      options: .curveEaseOut, animations: {
        self.transform = .identity
        self.alpha = 1
      }, completion: completion
    )
    return self
  }

  /// Moves this view out of position, as though it were withdrawing into the screen.
  /// - Parameters:
  /// - toScale: ending scale for the view, should be between 0 and 1
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func popOut(
    toScale: CGFloat = 0.5,
    duration: TimeInterval = 0.3,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    let endTransform = CGAffineTransform(scaleX: toScale, y: toScale)
    let prepareTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    UIView.animateKeyframes(
      withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
          self.transform = prepareTransform
        }
        UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
          self.transform = prepareTransform
        }
        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
          self.transform = endTransform
          self.alpha = 0
        }
      }, completion: completion
    )
    return self
  }

  /// Causes the view to hop, either toward a particular edge or out of the screen (if "toward" is
  /// .None).
  /// - Parameters:
  /// - toward: the edge to hop toward, or .None to hop out
  /// - amount: distance to hop, expressed as a fraction of the view's size
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func hop(
    toward edge: SimpleAnimationEdge = .none,
    amount: CGFloat = 0.4,
    duration: TimeInterval = 0.6,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    var dx: CGFloat = 0, dy: CGFloat = 0, ds: CGFloat = 0
    if edge == .none {
      ds = amount / 2
    } else if edge == .left || edge == .right {
      dx = (edge == .left ? -1 : 1) * bounds.size.width * amount
      dy = 0
    } else {
      dx = 0
      dy = (edge == .top ? -1 : 1) * bounds.size.height * amount
    }
    UIView.animateKeyframes(
      withDuration: duration, delay: delay, options: .calculationModeLinear, animations: {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.28) {
          let t = CGAffineTransform(translationX: dx, y: dy)
          self.transform = t.scaledBy(x: 1 + ds, y: 1 + ds)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.28, relativeDuration: 0.28) {
          self.transform = .identity
        }
        UIView.addKeyframe(withRelativeStartTime: 0.56, relativeDuration: 0.28) {
          let t = CGAffineTransform(translationX: dx * 0.5, y: dy * 0.5)
          self.transform = t.scaledBy(x: 1 + ds * 0.5, y: 1 + ds * 0.5)
        }
        UIView.addKeyframe(withRelativeStartTime: 0.84, relativeDuration: 0.16) {
          self.transform = .identity
        }
      }, completion: completion
    )
    return self
  }

  /// Causes the view to shake, either toward a particular edge or in all directions (if "toward"
  /// is .None).
  /// - Parameters:
  /// - toward: the edge to shake toward, or .None to shake in all directions
  /// - amount: distance to shake, expressed as a fraction of the view's size
  /// - duration: duration of the animation, in seconds
  /// - delay: delay before the animation starts, in seconds
  /// - completion: block executed when the animation ends
  @discardableResult public func shake(
    toward edge: SimpleAnimationEdge = .none,
    amount: CGFloat = 0.15,
    duration: TimeInterval = 0.6,
    delay: TimeInterval = 0,
    completion: ((Bool) -> Void)? = nil
  ) -> UIView {
    let steps = 8
    let timeStep = 1.0 / Double(steps)
    var dx: CGFloat, dy: CGFloat
    if edge == .left || edge == .right {
      dx = (edge == .left ? -1 : 1) * bounds.size.width * amount
      dy = 0
    } else {
      dx = 0
      dy = (edge == .top ? -1 : 1) * bounds.size.height * amount
    }
    UIView.animateKeyframes(
      withDuration: duration, delay: delay, options: .calculationModeCubic, animations: {
        var start = 0.0
        for i in 0..<(steps - 1) {
          UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
            self.transform = CGAffineTransform(translationX: dx, y: dy)
          }
          if edge == .none && i % 2 == 0 {
            swap(&dx, &dy) // Change direction
            dy *= -1
          }
          dx *= -0.85
          dy *= -0.85
          start += timeStep
        }
        UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: timeStep) {
          self.transform = .identity
        }
      }, completion: completion
    )
    return self
  }

  private func offsetFor(
    edge: SimpleAnimationEdge,
    referenceView passedView: UIView? = nil
  ) -> CGPoint {
    let referencedView: UIView = passedView != nil ? passedView! : superview!
    if let parentView = referencedView.superview {
      // Setup frames with respect to the global coordinate system
      let referencedFrame: CGRect = parentView.convert(referencedView.frame, to: nil)
      let currentFrame: CGRect = superview!.convert(frame, to: nil)

      // Find offset values
      var xOffset: CGFloat = 0.0
      var yOffset: CGFloat = 0.0
      switch edge {
      case .top:
        yOffset = -frame.height - currentFrame.minY + referencedFrame.minY
      case .bottom:
        yOffset = frame.height + referencedFrame.maxY - currentFrame.maxY
      case .left:
        xOffset = -frame.width - currentFrame.minX + referencedFrame.minX
      case .right:
        xOffset = frame.width + referencedFrame.maxX - currentFrame.maxX
      default:
        break
      }
      return CGPoint(x: xOffset, y: yOffset)
    }
    return .zero
  }

  public func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.2
    pulse.fromValue = 0.95
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = 2
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0

    layer.add(pulse, forKey: "pulse")
  }

  public func flash(repeatTimes: Float = 1.0) {
    let flash = CABasicAnimation(keyPath: "opacity")
    flash.duration = 0.24
    flash.fromValue = 1
    flash.toValue = 0.0
    flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    flash.autoreverses = true
    flash.repeatCount = repeatTimes

    layer.add(flash, forKey: nil)
  }

  public func rumble(repeatTimes: Float = 2.0) {
    let shake = CABasicAnimation(keyPath: "position")
    shake.duration = 0.05
    shake.repeatCount = repeatTimes
    shake.autoreverses = true

    let fromPoint = CGPoint(x: center.x - 5, y: center.y)
    let fromValue = NSValue(cgPoint: fromPoint)

    let toPoint = CGPoint(x: center.x + 5, y: center.y)
    let toValue = NSValue(cgPoint: toPoint)

    shake.fromValue = fromValue
    shake.toValue = toValue

    layer.add(shake, forKey: "position")
  }

  public func blink() {
    alpha = 1.0
    UIView.animate(
      withDuration: 0.6,
      delay: 1.0,
      options: [.curveEaseInOut, .autoreverse, .repeat],
      animations: { [weak self] in
        self?.alpha = 0.0
      },
      completion: { [weak self] _ in
        self?.alpha = 1.0
      }
    )
  }
 }

// swiftlint:enable all

