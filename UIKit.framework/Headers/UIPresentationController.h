//
//  UIPresentationController.h
//  UIKit
//
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIAppearance.h>
#import <UIKit/UIGeometry.h>
#import <UIKit/UITraitCollection.h>
#import <UIKit/UIViewControllerTransitionCoordinator.h>
#ifndef SDK_HIDE_TIDE
#import <UIKit/UIFocus.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@class UIPresentationController;

@protocol UIAdaptivePresentationControllerDelegate <NSObject>

@optional

/* For iOS8.0, the only supported adaptive presentation styles are UIModalPresentationFullScreen and UIModalPresentationOverFullScreen. */
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller;

// Returning UIModalPresentationNone will indicate that an adaptation should not happen.
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection NS_AVAILABLE_IOS(8_3);

/* If this method is not implemented, or returns nil, then the originally presented view controller is used. */
- (nullable UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style;

// If there is no adaptation happening and an original style is used UIModalPresentationNone will be passed as an argument.
- (void)presentationController:(UIPresentationController *)presentationController willPresentWithAdaptiveStyle:(UIModalPresentationStyle)style transitionCoordinator:(nullable id <UIViewControllerTransitionCoordinator>)transitionCoordinator NS_AVAILABLE_IOS(8_3);


@end

#ifndef SDK_HIDE_TIDE
NS_CLASS_AVAILABLE_IOS(8_0) @interface UIPresentationController : NSObject <UIAppearanceContainer, UITraitEnvironment, UIContentContainer, UIFocusEnvironment>
#else
NS_CLASS_AVAILABLE_IOS(8_0) @interface UIPresentationController : NSObject <UIAppearanceContainer, UITraitEnvironment, UIContentContainer>
#endif

@property(nonatomic, strong, readonly) UIViewController *presentingViewController;
@property(nonatomic, strong, readonly) UIViewController *presentedViewController;

@property(nonatomic, readonly) UIModalPresentationStyle presentationStyle;

// The view in which a presentation occurs. It is an ancestor of both the presenting and presented view controller's views.
// This view is being passed to the animation controller.
@property(nullable, nonatomic, readonly, strong) UIView *containerView;

@property(nullable, nonatomic, weak) id <UIAdaptivePresentationControllerDelegate> delegate;

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController;

// By default this implementation defers to the delegate, if one exists, or returns the current presentation style. UIFormSheetPresentationController, and
// UIPopoverPresentationController override this implementation to return UIModalPresentationStyleFullscreen if the delegate does not provide an
// implementation for adaptivePresentationStyleForPresentationController:
- (UIModalPresentationStyle)adaptivePresentationStyle;
- (UIModalPresentationStyle)adaptivePresentationStyleForTraitCollection:(UITraitCollection *)traitCollection NS_AVAILABLE_IOS(8_3);

- (void)containerViewWillLayoutSubviews;
- (void)containerViewDidLayoutSubviews;

// A view that's going to be animated during the presentation. Must be an ancestor of a presented view controller's view
// or a presented view controller's view itself.
// (Default: presented view controller's view)
- (nullable UIView *)presentedView;

// Position of the presented view in the container view by the end of the presentation transition.
// (Default: container view bounds)
- (CGRect)frameOfPresentedViewInContainerView;

// By default each new presentation is full screen.
// This behavior can be overriden with the following method to force a current context presentation.
// (Default: YES)
- (BOOL)shouldPresentInFullscreen;

// Indicate whether the view controller's view we are transitioning from will be removed from the window in the end of the
// presentation transition
// (Default: NO)
- (BOOL)shouldRemovePresentersView;

- (void)presentationTransitionWillBegin;
- (void)presentationTransitionDidEnd:(BOOL)completed;
- (void)dismissalTransitionWillBegin;
- (void)dismissalTransitionDidEnd:(BOOL)completed;

// Modifies the trait collection for the presentation controller.
@property(nullable, nonatomic, copy) UITraitCollection *overrideTraitCollection;

@end

NS_ASSUME_NONNULL_END

