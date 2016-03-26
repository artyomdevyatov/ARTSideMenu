//
//  ARTSideMenuController.swift
//  ARTSideMenu
//
//  Created by Artyom Devyatov on 26/03/16.
//
//

import UIKit

public class ARTSideMenuController: UIViewController {

    public static var sharedController: ARTSideMenuController!

    public var menuWidth: CGFloat = 280.0 {
        didSet {
            menuView.frame = CGRectMake(view.bounds.width - menuWidth, 0.0, menuWidth, view.bounds.height)
        }
    }
    public var animationDuration = 0.3
    public var animationOptions = UIViewAnimationOptions.CurveEaseOut
    public var ignoreGestures = false
    public var shadowRadius: CGFloat = 3.0 {
        didSet {
            contentView.layer.shadowRadius = shadowRadius
        }
    }
    public var shadowOpacity: Float = 0.5 {
        didSet {
            contentView.layer.shadowOpacity = shadowOpacity
        }
    }
    public var shadowOffset = CGSize(width: 0.0, height: -3.0) {
        didSet {
            contentView.layer.shadowOffset = shadowOffset
        }
    }
    public var shadowColor = UIColor.blackColor() {
        didSet {
            contentView.layer.shadowColor = shadowColor.CGColor
        }
    }

    private var contentController: UIViewController!
    private var menuController: UIViewController!
    private var contentView = UIView()
    private var menuView = UIView()
    private var outsideTapView = UIButton()
    private var showPanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var hidePanGestureRecognizer: UIPanGestureRecognizer!

    public init(contentController: UIViewController, menuController: UIViewController) {
        super.init(nibName: nil, bundle: nil)

        self.contentController = contentController
        self.menuController = menuController

        showPanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleShowPan:")
        showPanGestureRecognizer.edges = UIRectEdge.Right
        contentView.addGestureRecognizer(showPanGestureRecognizer)

        hidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleHidePan:")
        view.addGestureRecognizer(hidePanGestureRecognizer)

        outsideTapView.addTarget(self, action: "outsideViewTapped:", forControlEvents: .TouchUpInside)

        ARTSideMenuController.sharedController = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Creation via Storyboard unavailable. Use init(contentController:menuController) instead.")
    }


    public override func viewDidLoad() {
        super.viewDidLoad()

        configureContainerViews()
        configureShadow()
        hideMenuAnimated(false)
    }

    // MARK: - Configuration

    private func configureContainerViews() {
        let contentFrame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        let menuFrame = CGRectMake(view.bounds.width - menuWidth, 0.0, menuWidth, view.bounds.height)

        contentView.frame = contentFrame
        menuView.frame = menuFrame
        outsideTapView.frame = contentView.bounds

        contentView.addSubview(contentController.view)
        menuView.addSubview(menuController.view)

        contentController.view.frame = contentView.bounds
        menuController.view.frame = menuView.bounds

        view.addSubview(menuView)
        view.addSubview(contentView)
    }

    private func configureShadow() {
        contentView.layer.shadowRadius = shadowRadius
        contentView.layer.shadowOpacity = shadowOpacity
        contentView.layer.shadowOffset = shadowOffset
        contentView.layer.shadowColor = shadowColor.CGColor
    }

    // MARK: - Events

    internal func handleShowPan(recognizer: UIScreenEdgePanGestureRecognizer) {
        if ignoreGestures {
            return
        }

        let translation = recognizer.translationInView(contentView)
        switch recognizer.state {
        case .Began, .Changed:
            var originX = translation.x
            originX = originX >= -menuWidth ? originX : -menuWidth
            contentView.frame.origin.x = originX
        case .Ended:
            if abs(translation.x) < menuWidth / 3 {
                hideMenuAnimated(true)
            } else {
                showMenuAnimated(true)
            }
        default:
            break
        }
    }

    internal func handleHidePan(recognizer: UIPanGestureRecognizer) {
        if ignoreGestures {
            return
        }

        let translation = recognizer.translationInView(contentView)
        switch recognizer.state {
        case .Began, .Changed:
            var originX = -menuWidth + translation.x
            originX = originX >= -menuWidth ? originX : -menuWidth
            contentView.frame.origin.x = originX
        case .Ended:
            if abs(translation.x) < menuWidth / 3 {
                showMenuAnimated(true)
            } else {
                hideMenuAnimated(true)
            }
        default:
            break
        }
    }

    public func showMenuAnimated(animated: Bool) {
        let duration = animated ? animationDuration : 0.0
        UIView.animateWithDuration(duration, delay: 0.0, options: animationOptions, animations: { () -> Void in
            self.contentView.frame.origin.x = -self.menuWidth
        }, completion: nil)
        contentView.addSubview(outsideTapView)
        showPanGestureRecognizer.enabled = false
        hidePanGestureRecognizer.enabled = true
    }

    public func hideMenuAnimated(animated: Bool) {
        let duration = animated ? animationDuration : 0.0
        UIView.animateWithDuration(duration, delay: 0.0, options: animationOptions, animations: { () -> Void in
            self.contentView.frame.origin.x = 0.0
        }, completion: nil)
        outsideTapView.removeFromSuperview()
        showPanGestureRecognizer.enabled = true
        hidePanGestureRecognizer.enabled = false
    }

    internal func outsideViewTapped(sender: UIButton) {
        hideMenuAnimated(true)
    }

}
