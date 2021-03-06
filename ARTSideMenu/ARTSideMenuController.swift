//
//  ARTSideMenuController.swift
//  ARTSideMenu
//
//  Created by Artyom Devyatov on 26/03/16.
//
//

import UIKit

public class ARTSideMenuController: UIViewController {

    public static weak var sharedController: ARTSideMenuController!

    @IBInspectable public var contentIdentifier: String = ""
    @IBInspectable public var menuIdentifier: String = ""
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

    private(set) public var contentController: UIViewController!
    private(set) public var menuController: UIViewController!
    private(set) public var contentView = UIView()
    private(set) public var menuView = UIView()

    private var storyboardCreation = false
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

    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animateWithDuration(animationDuration) {
            self.configureForSize(self.view.bounds.size)
        }
    }

    // MARK: - Configuration

    private func configureChildControllersAfterStoryboardCreation() {
        if let contentController = storyboard?.instantiateViewControllerWithIdentifier(contentIdentifier) {
            self.contentController = contentController
        } else {
            assertionFailure("ARTContentController storyboard identifier not defined")
        }

        if let menuController = storyboard?.instantiateViewControllerWithIdentifier(menuIdentifier) {
            self.menuController = menuController
        } else {
            assertionFailure("ARTContentController storyboard identifier not defined")
        }
    }

    private func configureGestureRecognizers() {
        showPanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self,
            action: #selector(ARTSideMenuController.handleShowPan(_:)))
        showPanGestureRecognizer.edges = UIRectEdge.Right
        contentView.addGestureRecognizer(showPanGestureRecognizer)

        hidePanGestureRecognizer = UIPanGestureRecognizer(target: self,
            action: #selector(ARTSideMenuController.handleHidePan(_:)))
        view.addGestureRecognizer(hidePanGestureRecognizer)

        outsideTapView.addTarget(self, action: #selector(ARTSideMenuController.outsideViewTapped(_:)),
            forControlEvents: .TouchUpInside)
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

    private func configureForSize(size: CGSize) {
        self.contentView.frame.size = size
        let menuFrame = CGRectMake(size.width - self.menuWidth, 0.0, self.menuWidth, size.height)
        self.menuView.frame = menuFrame
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

    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        if contentController != nil {
            return contentController.preferredStatusBarStyle()
        } else {
            return .Default
        }
    }

    // MARK: - Other

    public override func viewWillTransitionToSize(size: CGSize,
    withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)

        UIView.animateWithDuration(coordinator.transitionDuration()) {
            self.configureForSize(size)
        }
    }

}
