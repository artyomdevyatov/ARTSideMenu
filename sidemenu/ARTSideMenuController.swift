//
//  ARTSideMenuController.swift
//  ARTSideMenu
//
//  Created by Artyom Devyatov on 26/03/16.
//
//

import UIKit

class ARTSideMenuController: UIViewController {

    var menuWidth: CGFloat = 280.0

    private var contentController: UIViewController!
    private var menuController: UIViewController!
    private var contentView = UIView()
    private var menuView = UIView()
    private var outsideTapView = UIButton()
    private var showPanGestureRecognizer: UIScreenEdgePanGestureRecognizer!
    private var hidePanGestureRecognizer: UIPanGestureRecognizer!

    init(contentController: UIViewController, menuController: UIViewController) {
        super.init(nibName: nil, bundle: nil)

        self.contentController = contentController
        self.menuController = menuController

        showPanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "handleShowPan:")
        showPanGestureRecognizer.edges = UIRectEdge.Right
        contentView.addGestureRecognizer(showPanGestureRecognizer)

        hidePanGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handleHidePan:")
        view.addGestureRecognizer(hidePanGestureRecognizer)

        outsideTapView.addTarget(self, action: "outsideViewTapped:", forControlEvents: .TouchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Creation via Storyboard unavailable. Use init(contentController:menuController) instead.")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(menuView)
        view.addSubview(contentView)

        let contentFrame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        let menuFrame = CGRectMake(view.bounds.width - menuWidth, 0.0, menuWidth, view.bounds.height)

        contentView.frame = contentFrame
        menuView.frame = menuFrame
        outsideTapView.frame = contentView.bounds

        contentView.addSubview(contentController.view)
        menuView.addSubview(menuController.view)

        contentController.view.frame = contentView.bounds
        menuController.view.frame = menuView.bounds

        contentView.layer.shadowColor = UIColor.blackColor().CGColor
        contentView.layer.shadowOpacity = 1.0

        hideMenuAnimated(false)
    }

    func handleShowPan(recognizer: UIScreenEdgePanGestureRecognizer) {
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

    func handleHidePan(recognizer: UIPanGestureRecognizer) {
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

    func showMenuAnimated(animated: Bool) {
        let animationDuration = animated ? 0.1 : 0.0
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.contentView.frame.origin.x = -self.menuWidth
        }
        contentView.addSubview(outsideTapView)
        showPanGestureRecognizer.enabled = false
        hidePanGestureRecognizer.enabled = true
    }

    func hideMenuAnimated(animated: Bool) {
        let animationDuration = animated ? 0.1 : 0.0
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.contentView.frame.origin.x = 0.0
        }
        outsideTapView.removeFromSuperview()
        showPanGestureRecognizer.enabled = true
        hidePanGestureRecognizer.enabled = false
    }

    func outsideViewTapped(sender: UIButton) {
        hideMenuAnimated(true)
    }

}
