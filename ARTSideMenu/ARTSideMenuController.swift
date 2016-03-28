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

    private var storyboardCreation = false
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

        ARTSideMenuController.sharedController = self
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        storyboardCreation = true
        ARTSideMenuController.sharedController = self
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if storyboardCreation {
            configureChildControllersAfterStoryboardCreation()
        }
        configureGestureRecognizers()
        configureContainerViews()
        configureShadow()
        hideMenuAnimated(false)
    }

    // MARK: - Configuration

    private func configureChildControllersAfterStoryboardCreation() {
        if let contentController = storyboard?.instantiateViewControllerWithIdentifier("ARTContentController") {
            self.contentController = contentController
        } else {
            assertionFailure("ARTContentController storyboard identifier not defined")
        }

        if let menuController = storyboard?.instantiateViewControllerWithIdentifier("ARTMenuController") {
            self.menuController = menuController
        } else {
            assertionFailure("ARTContentController storyboard identifier not defined")
        }
    }

    private func configureGestureRecognizers() {
        showPanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleShowPan:")
        showPanGestureRecognizer.edges = UIRectEdge.Right
        contentView.addGestureRecognizer(showPanGestureRecognizer)

        hidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleHidePan:")
        view.addGestureRecognizer(hidePanGestureRecognizer)

        outsideTapView.addTarget(self, action: "outsideViewTapped:", forControlEvents: .TouchUpInside)
    }

    private func configureContainerViews() {
        view.addSubview(menuView)
        view.addSubview(contentView)

        addChildViewController(menuController)
        let menuFrame = CGRectMake(view.bounds.width - menuWidth, 0.0, menuWidth, view.bounds.height)
        menuView.frame = menuFrame
        menuController.view.frame = menuView.bounds
        menuView.addSubview(menuController.view)
        menuController.didMoveToParentViewController(self)

        addChildViewController(contentController)
        let contentFrame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        contentView.frame = contentFrame
        contentController.view.frame = contentView.bounds
        contentView.addSubview(contentController.view)
        contentController.didMoveToParentViewController(self)

        outsideTapView.frame = contentView.bounds
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
