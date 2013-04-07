//
//  ViewController.h
//  Masseuse
//
//  Created by eProximiti on 4/3/13.
//  Copyright (c) 2013 hugey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)intensitySliderValueChanged:(id)sender;
- (IBAction)pulseSliderValueChanged:(id)sender;


@end
