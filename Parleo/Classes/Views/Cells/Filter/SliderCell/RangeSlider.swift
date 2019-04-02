//
//  RangeSlider.swift
//  Parleo
//
//  Created by Alex Azarov on 3/24/19.
//  Copyright © 2019 LeatherSoft. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @IBInspectable
    var minValue: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }

    @IBInspectable
    var maxValue: CGFloat = 100.0 {
        didSet {
            refresh()
        }
    }

    @IBInspectable
    var selectedMinValue: CGFloat = 0.0 {
        didSet {
            if selectedMinValue < minValue {
                selectedMinValue = minValue
            }
        }
    }

    @IBInspectable
    var selectedMaxValue: CGFloat = 100.0 {
        didSet {
            if selectedMaxValue > maxValue {
                selectedMaxValue = maxValue
            }
        }
    }

    /// The font of the minimum value text label. If not set, the default is system font size 12.0.
    var minLabelFont: UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            minLabel.font = minLabelFont as CFTypeRef
            minLabel.fontSize = minLabelFont.pointSize
        }
    }

    /// The font of the maximum value text label. If not set, the default is system font size 12.0.
    var maxLabelFont: UIFont = UIFont.systemFont(ofSize: 12.0) {
        didSet {
            maxLabel.font = maxLabelFont as CFTypeRef
            maxLabel.fontSize = maxLabelFont.pointSize
        }
    }

    var numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    @IBInspectable
    var hideLabels: Bool = false {
        didSet {
            minLabel.isHidden = hideLabels
            maxLabel.isHidden = hideLabels
        }
    }

    @IBInspectable
    var labelsFixed: Bool = false

    @IBInspectable
    var minLabelColor: UIColor?

    @IBInspectable
    var maxLabelColor: UIColor?

    @IBInspectable
    var handleColor: UIColor?

    /// Handle slider with custom border color, you can set custom border color for your handle
    @IBInspectable
    var handleBorderColor: UIColor?

    /// Set slider line tint color between handles
    @IBInspectable
    var colorBetweenHandles: UIColor?

    /// The color of the entire slider when the handle is set to the minimum value and the maximum value. Default is nil.
    @IBInspectable var initialColor: UIColor?

    @IBInspectable var disableRange: Bool = false {
        didSet {
            leftHandle.isHidden = disableRange
            minLabel.isHidden = disableRange
        }
    }

    /// If true the control will snap to point at each step between minValue and maxValue. Default is false.
    @IBInspectable var enableStep: Bool = false

    /// The step value, this control the value of each step. If not set the default is 0.0.
    /// (note: this is ignored if <= 0.0)
    @IBInspectable var step: CGFloat = 0.0
    
    /// Handle slider with custom image, you can set custom image for your handle
    @IBInspectable var handleImage: UIImage? {
        didSet {
            guard let image = handleImage else {
                return
            }

            var handleFrame = CGRect.zero
            handleFrame.size = image.size

            leftHandle.frame = handleFrame
            leftHandle.contents = image.cgImage

            rightHandle.frame = handleFrame
            rightHandle.contents = image.cgImage
        }
    }

    /// Handle diameter (default 16.0)
    @IBInspectable var handleDiameter: CGFloat = 16.0 {
        didSet {
            leftHandle.cornerRadius = handleDiameter / 2.0
            rightHandle.cornerRadius = handleDiameter / 2.0
            leftHandle.frame = CGRect(x: 0.0, y: 0.0, width: handleDiameter, height: handleDiameter)
            rightHandle.frame = CGRect(x: 0.0, y: 0.0, width: handleDiameter, height: handleDiameter)
        }
    }

    /// Set the slider line height (default 1.0)
    @IBInspectable var lineHeight: CGFloat = 1.0 {
        didSet {
            updateLineHeight()
        }
    }

    /// Handle border width (default 0.0)
    @IBInspectable var handleBorderWidth: CGFloat = 0.0 {
        didSet {
            leftHandle.borderWidth = handleBorderWidth
            rightHandle.borderWidth = handleBorderWidth
        }
    }

    /// Set padding between label and handle (default 8.0)
    @IBInspectable var labelPadding: CGFloat = 8.0 {
        didSet {
            updateLabelPositions()
        }
    }


    // MARK: - private stored properties

    private enum HandleTracking { case none, left, right }
    private var handleTracking: HandleTracking = .none

    private let sliderLine: CALayer = CALayer()
    private let sliderLineBetweenHandles: CALayer = CALayer()

    private let leftHandle: CALayer = CALayer()
    private let rightHandle: CALayer = CALayer()

    fileprivate let minLabel: CATextLayer = CATextLayer()
    fileprivate let maxLabel: CATextLayer = CATextLayer()

    private var minLabelTextSize: CGSize = .zero
    private var maxLabelTextSize: CGSize = .zero

    // UIFeedbackGenerator
    private var previousStepMinValue: CGFloat?
    private var previousStepMaxValue: CGFloat?

    // strong reference needed for UIAccessibilityContainer
    // see http://stackoverflow.com/questions/13462046/custom-uiview-not-showing-accessibility-on-voice-over
    private var accessibleElements: [UIAccessibilityElement] = []


    // MARK: - private computed properties

    private var leftHandleAccessibilityElement: UIAccessibilityElement {
        let element: RangeSeekSliderLeftElement = RangeSeekSliderLeftElement(accessibilityContainer: self)
        element.isAccessibilityElement = true
        element.accessibilityValue = minLabel.string as? String
        element.accessibilityFrame = convert(leftHandle.frame, to: nil)
        element.accessibilityTraits = UIAccessibilityTraits.adjustable
        return element
    }

    private var rightHandleAccessibilityElement: UIAccessibilityElement {
        let element: RangeSeekSliderRightElement = RangeSeekSliderRightElement(accessibilityContainer: self)
        element.isAccessibilityElement = true
        element.accessibilityValue = maxLabel.string as? String
        element.accessibilityFrame = convert(rightHandle.frame, to: nil)
        element.accessibilityTraits = UIAccessibilityTraits.adjustable
        return element
    }


    // MARK: - UIView

    override func layoutSubviews() {
        super.layoutSubviews()

        if handleTracking == .none {
            updateLineHeight()
            updateLabelValues()
            updateColors()
            updateHandlePositions()
            updateLabelPositions()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 65.0)
    }


    // MARK: - UIControl

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchLocation: CGPoint = touch.location(in: self)
        let insetExpansion: CGFloat = -30.0
        let isTouchingLeftHandle: Bool = leftHandle.frame.insetBy(dx: insetExpansion, dy: insetExpansion).contains(touchLocation)
        let isTouchingRightHandle: Bool = rightHandle.frame.insetBy(dx: insetExpansion, dy: insetExpansion).contains(touchLocation)

        guard isTouchingLeftHandle || isTouchingRightHandle else { return false }


        // the touch was inside one of the handles so we're definitely going to start movign one of them. But the handles might be quite close to each other, so now we need to find out which handle the touch was closest too, and activate that one.
        let distanceFromLeftHandle: CGFloat = touchLocation.distance(to: leftHandle.frame.center)
        let distanceFromRightHandle: CGFloat = touchLocation.distance(to: rightHandle.frame.center)

        if distanceFromLeftHandle < distanceFromRightHandle && !disableRange {
            handleTracking = .left
        } else if selectedMaxValue == maxValue && leftHandle.frame.midX == rightHandle.frame.midX {
            handleTracking = .left
        } else {
            handleTracking = .right
        }
        let handle: CALayer = (handleTracking == .left) ? leftHandle : rightHandle
        animate(handle: handle, selected: true)

//        delegate?.didStartTouches(in: self)

        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard handleTracking != .none else { return false }

        let location: CGPoint = touch.location(in: self)

        // find out the percentage along the line we are in x coordinate terms (subtracting half the frames width to account for moving the middle of the handle, not the left hand side)
        let percentage: CGFloat = (location.x - sliderLine.frame.minX - handleDiameter / 2.0) / (sliderLine.frame.maxX - sliderLine.frame.minX)

        // multiply that percentage by self.maxValue to get the new selected minimum value
        let selectedValue: CGFloat = percentage * (maxValue - minValue) + minValue

        switch handleTracking {
        case .left:
            selectedMinValue = min(selectedValue, selectedMaxValue)
        case .right:
            // don't let the dots cross over, (unless range is disabled, in which case just dont let the dot fall off the end of the screen)
            if disableRange && selectedValue >= minValue {
                selectedMaxValue = selectedValue
            } else {
                selectedMaxValue = max(selectedValue, selectedMinValue)
            }
        case .none:
            // no need to refresh the view because it is done as a side-effect of setting the property
            break
        }

        refresh()

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        let handle: CALayer = (handleTracking == .left) ? leftHandle : rightHandle
        animate(handle: handle, selected: false)
        handleTracking = .none

//        delegate?.didEndTouches(in: self)
    }


    // MARK: - UIAccessibility

    override func accessibilityElementCount() -> Int {
        return accessibleElements.count
    }

    override func accessibilityElement(at index: Int) -> Any? {
        return accessibleElements[index]
    }

    override func index(ofAccessibilityElement element: Any) -> Int {
        guard let element = element as? UIAccessibilityElement else { return 0 }
        return accessibleElements.index(of: element) ?? 0
    }


    // MARK: - methods

    /// When subclassing **RangeSeekSlider** and setting each item in **setupStyle()**, the design is reflected in Interface Builder as well.
    func setupStyle() {}


    // MARK: - private methods

    private func setup() {
        isAccessibilityElement = false
        accessibleElements = [leftHandleAccessibilityElement, rightHandleAccessibilityElement]

        // draw the slider line
        layer.addSublayer(sliderLine)

        // draw the track distline
        layer.addSublayer(sliderLineBetweenHandles)

        // draw the minimum slider handle
        leftHandle.cornerRadius = handleDiameter / 2.0
        leftHandle.borderWidth = handleBorderWidth
        layer.addSublayer(leftHandle)

        // draw the maximum slider handle
        rightHandle.cornerRadius = handleDiameter / 2.0
        rightHandle.borderWidth = handleBorderWidth
        layer.addSublayer(rightHandle)

        let handleFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: handleDiameter, height: handleDiameter)
        leftHandle.frame = handleFrame
        rightHandle.frame = handleFrame

        // draw the text labels
        let labelFontSize: CGFloat = 12.0
        let labelFrame: CGRect = CGRect(x: 0.0, y: 0.0, width: 75.0, height: 14.0)

        minLabelFont = UIFont.systemFont(ofSize: labelFontSize)
        minLabel.alignmentMode = .center
        minLabel.frame = labelFrame
        minLabel.contentsScale = UIScreen.main.scale
        layer.addSublayer(minLabel)

        maxLabelFont = UIFont.systemFont(ofSize: labelFontSize)
        maxLabel.alignmentMode = .center
        maxLabel.frame = labelFrame
        maxLabel.contentsScale = UIScreen.main.scale
        layer.addSublayer(maxLabel)

        setupStyle()

        refresh()
    }

    private func percentageAlongLine(for value: CGFloat) -> CGFloat {
        // stops divide by zero errors where maxMinDif would be zero. If the min and max are the same the percentage has no point.
        guard minValue < maxValue else { return 0.0 }

        // get the difference between the maximum and minimum values (e.g if max was 100, and min was 50, difference is 50)
        let maxMinDif: CGFloat = maxValue - minValue

        // now subtract value from the minValue (e.g if value is 75, then 75-50 = 25)
        let valueSubtracted: CGFloat = value - minValue

        // now divide valueSubtracted by maxMinDif to get the percentage (e.g 25/50 = 0.5)
        return valueSubtracted / maxMinDif
    }

    private func xPositionAlongLine(for value: CGFloat) -> CGFloat {
        // first get the percentage along the line for the value
        let percentage: CGFloat = percentageAlongLine(for: value)

        // get the difference between the maximum and minimum coordinate position x values (e.g if max was x = 310, and min was x=10, difference is 300)
        let maxMinDif: CGFloat = sliderLine.frame.maxX - sliderLine.frame.minX

        // now multiply the percentage by the minMaxDif to see how far along the line the point should be, and add it onto the minimum x position.
        let offset: CGFloat = percentage * maxMinDif

        return sliderLine.frame.minX + offset
    }

    private func updateLineHeight() {
        let barSidePadding: CGFloat = 16.0
        let yMiddle: CGFloat = frame.height / 2.0
        let lineLeftSide: CGPoint = CGPoint(x: barSidePadding, y: yMiddle)
        let lineRightSide: CGPoint = CGPoint(x: frame.width - barSidePadding,
                                             y: yMiddle)
        sliderLine.frame = CGRect(x: lineLeftSide.x,
                                  y: lineLeftSide.y,
                                  width: lineRightSide.x - lineLeftSide.x,
                                  height: lineHeight)
        sliderLine.cornerRadius = lineHeight / 2.0
        sliderLineBetweenHandles.cornerRadius = sliderLine.cornerRadius
    }

    private func updateLabelValues() {
        minLabel.isHidden = hideLabels || disableRange
        maxLabel.isHidden = hideLabels

//        if let replacedString = delegate?.rangeSeekSlider(self, stringForMinValue: selectedMinValue) {
//            minLabel.string = replacedString
//        } else {
            minLabel.string = numberFormatter.string(from: selectedMinValue as NSNumber)
//        }

//        if let replacedString = delegate?.rangeSeekSlider(self, stringForMaxValue: selectedMaxValue) {
//            maxLabel.string = replacedString
//        } else {
            maxLabel.string = numberFormatter.string(from: selectedMaxValue as NSNumber)
//        }

        if let nsstring = minLabel.string as? NSString {
            minLabelTextSize = nsstring.size(withAttributes: [.font: minLabelFont])
        }

        if let nsstring = maxLabel.string as? NSString {
            maxLabelTextSize = nsstring.size(withAttributes: [.font: maxLabelFont])
        }
    }

    private func updateColors() {
        let isInitial: Bool = selectedMinValue == minValue && selectedMaxValue == maxValue
        if let initialColor = initialColor?.cgColor, isInitial {
            minLabel.foregroundColor = initialColor
            maxLabel.foregroundColor = initialColor
            sliderLineBetweenHandles.backgroundColor = initialColor
            sliderLine.backgroundColor = initialColor

            let color: CGColor = (handleImage == nil) ? initialColor : UIColor.clear.cgColor
            leftHandle.backgroundColor = color
            leftHandle.borderColor = color
            rightHandle.backgroundColor = color
            rightHandle.borderColor = color
        } else {
            let tintCGColor: CGColor = tintColor.cgColor
            minLabel.foregroundColor = minLabelColor?.cgColor ?? tintCGColor
            maxLabel.foregroundColor = maxLabelColor?.cgColor ?? tintCGColor
            sliderLineBetweenHandles.backgroundColor = colorBetweenHandles?.cgColor ?? tintCGColor
            sliderLine.backgroundColor = tintCGColor

            let color: CGColor
            if let _ = handleImage {
                color = UIColor.clear.cgColor
            } else {
                color = handleColor?.cgColor ?? tintCGColor
            }
            leftHandle.backgroundColor = color
            leftHandle.borderColor = handleBorderColor.map { $0.cgColor }
            rightHandle.backgroundColor = color
            rightHandle.borderColor = handleBorderColor.map { $0.cgColor }
        }
    }

    private func updateAccessibilityElements() {
        accessibleElements = [leftHandleAccessibilityElement, rightHandleAccessibilityElement]
    }

    private func updateHandlePositions() {
        leftHandle.position = CGPoint(x: xPositionAlongLine(for: selectedMinValue),
                                      y: sliderLine.frame.midY)

        rightHandle.position = CGPoint(x: xPositionAlongLine(for: selectedMaxValue),
                                       y: sliderLine.frame.midY)

        // positioning for the dist slider line
        sliderLineBetweenHandles.frame = CGRect(x: leftHandle.position.x,
                                                y: sliderLine.frame.minY,
                                                width: rightHandle.position.x - leftHandle.position.x,
                                                height: lineHeight)
    }

    private func updateLabelPositions() {
        // the center points for the labels are X = the same x position as the relevant handle. Y = the y position of the handle minus half the height of the text label, minus some padding.

        minLabel.frame.size = minLabelTextSize
        maxLabel.frame.size = maxLabelTextSize

        if labelsFixed {
            updateFixedLabelPositions()
            return
        }

        let minSpacingBetweenLabels: CGFloat = 8.0

        let newMinLabelCenter: CGPoint = CGPoint(x: leftHandle.frame.midX,
                                                 y: leftHandle.frame.minY - (minLabelTextSize.height / 2.0) - labelPadding)

        let newMaxLabelCenter: CGPoint = CGPoint(x: rightHandle.frame.midX,
                                                 y: rightHandle.frame.minY - (maxLabelTextSize.height / 2.0) - labelPadding)

        let newLeftMostXInMaxLabel: CGFloat = newMaxLabelCenter.x - maxLabelTextSize.width / 2.0
        let newRightMostXInMinLabel: CGFloat = newMinLabelCenter.x + minLabelTextSize.width / 2.0
        let newSpacingBetweenTextLabels: CGFloat = newLeftMostXInMaxLabel - newRightMostXInMinLabel

        if disableRange || newSpacingBetweenTextLabels > minSpacingBetweenLabels {
            minLabel.position = newMinLabelCenter
            maxLabel.position = newMaxLabelCenter

            if minLabel.frame.minX < 0.0 {
                minLabel.frame.origin.x = 0.0
            }

            if maxLabel.frame.maxX > frame.width {
                maxLabel.frame.origin.x = frame.width - maxLabel.frame.width
            }
        } else {
            let increaseAmount: CGFloat = minSpacingBetweenLabels - newSpacingBetweenTextLabels
            minLabel.position = CGPoint(x: newMinLabelCenter.x - increaseAmount / 2.0, y: newMinLabelCenter.y)
            maxLabel.position = CGPoint(x: newMaxLabelCenter.x + increaseAmount / 2.0, y: newMaxLabelCenter.y)

            // Update x if they are still in the original position
            if minLabel.position.x == maxLabel.position.x {
                minLabel.position.x = leftHandle.frame.midX
                maxLabel.position.x = leftHandle.frame.midX + minLabel.frame.width / 2.0 + minSpacingBetweenLabels + maxLabel.frame.width / 2.0
            }

            if minLabel.frame.minX < 0.0 {
                minLabel.frame.origin.x = 0.0
                maxLabel.frame.origin.x = minSpacingBetweenLabels + minLabel.frame.width
            }

            if maxLabel.frame.maxX > frame.width {
                maxLabel.frame.origin.x = frame.width - maxLabel.frame.width
                minLabel.frame.origin.x = maxLabel.frame.origin.x - minSpacingBetweenLabels - minLabel.frame.width
            }
        }
    }

    private func updateFixedLabelPositions() {
        minLabel.position = CGPoint(x: xPositionAlongLine(for: minValue),
                                    y: sliderLine.frame.minY - (minLabelTextSize.height / 2.0) - (handleDiameter / 2.0) - labelPadding)
        maxLabel.position = CGPoint(x: xPositionAlongLine(for: maxValue),
                                    y: sliderLine.frame.minY - (maxLabelTextSize.height / 2.0) - (handleDiameter / 2.0) - labelPadding)
        if minLabel.frame.minX < 0.0 {
            minLabel.frame.origin.x = 0.0
        }

        if maxLabel.frame.maxX > frame.width {
            maxLabel.frame.origin.x = frame.width - maxLabel.frame.width
        }
    }

    fileprivate func refresh() {
        if enableStep && step > 0.0 {
            selectedMinValue = CGFloat(roundf(Float(selectedMinValue / step))) * step
            if let previousStepMinValue = previousStepMinValue, previousStepMinValue != selectedMinValue {
                TapticEngine.selection.feedback()
            }
            previousStepMinValue = selectedMinValue

            selectedMaxValue = CGFloat(roundf(Float(selectedMaxValue / step))) * step
            if let previousStepMaxValue = previousStepMaxValue, previousStepMaxValue != selectedMaxValue {
                TapticEngine.selection.feedback()
            }
            previousStepMaxValue = selectedMaxValue
        }

        // ensure the minimum and maximum selected values are within range. Access the values directly so we don't cause this refresh method to be called again (otherwise changing the properties causes a refresh)
        if selectedMinValue < minValue {
            selectedMinValue = minValue
        }
        if selectedMaxValue > maxValue {
            selectedMaxValue = maxValue
        }

        // update the frames in a transaction so that the tracking doesn't continue until the frame has moved.
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateHandlePositions()
        updateLabelPositions()
        CATransaction.commit()

        updateLabelValues()
        updateColors()
        updateAccessibilityElements()
    }

    private func animate(handle: CALayer, selected: Bool) {

        CATransaction.begin()
        CATransaction.setAnimationDuration(0.3)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))

        // the label above the handle will need to move too if the handle changes size
        updateLabelPositions()

        CATransaction.commit()
    }
}


// MARK: - RangeSeekSliderLeftElement

private final class RangeSeekSliderLeftElement: UIAccessibilityElement {

    override func accessibilityIncrement() {
        guard let slider = accessibilityContainer as? RangeSlider else { return }
        slider.selectedMinValue += slider.step
        accessibilityValue = slider.minLabel.string as? String
    }

    override func accessibilityDecrement() {
        guard let slider = accessibilityContainer as? RangeSlider else { return }
        slider.selectedMinValue -= slider.step
        accessibilityValue = slider.minLabel.string as? String
    }
}


// MARK: - RangeSeekSliderRightElement

private final class RangeSeekSliderRightElement: UIAccessibilityElement {

    override func accessibilityIncrement() {
        guard let slider = accessibilityContainer as? RangeSlider else { return }
        slider.selectedMaxValue += slider.step
        slider.refresh()
        accessibilityValue = slider.maxLabel.string as? String
    }

    override func accessibilityDecrement() {
        guard let slider = accessibilityContainer as? RangeSlider else { return }
        slider.selectedMaxValue -= slider.step
        slider.refresh()
        accessibilityValue = slider.maxLabel.string as? String
    }
}


// MARK: - CGRect

private extension CGRect {

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}


// MARK: - CGPoint

private extension CGPoint {

    func distance(to: CGPoint) -> CGFloat {
        let distX: CGFloat = to.x - x
        let distY: CGFloat = to.y - y
        return sqrt(distX * distX + distY * distY)
    }
}
