//
//  ViewController.m
//  Masseuse
//
//  Created by eProximiti on 4/3/13.
//  Copyright (c) 2013 hugey. All rights reserved.
//

#import "ViewController.h"
#import "AudioServices.h"
#import <float.h>

@interface ViewController () {
    BOOL isVibrating;
    BOOL resetNextFire;
    // timer is used for rescheduling the vibration. only in the case we reach a length too long
    NSTimer *timer;
    
    float intensityLevel;
    float pulseInterval;
    
    BOOL isTapped;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    isVibrating = NO;
    pulseInterval = 0.5;
    intensityLevel = 0.5;
    timer = [NSTimer scheduledTimerWithTimeInterval:2 * pulseInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
    // set up gesture recognizers
    isTapped = NO;

}

-(void)timerFired {
    if (!isTapped) {
        AudioServicesStopSystemSound(4095);
    }
    
    if (isVibrating || resetNextFire) {
        resetNextFire = NO;

        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSMutableArray* arr = [NSMutableArray array ];
        
        [arr addObject:[NSNumber numberWithBool:YES]];
        
        if ((int)pulseInterval == 300) {
            [arr addObject:[NSNumber numberWithFloat:300 * 1000]];
        } else {

            // make the length 1ms shorter than timer
            [arr addObject:[NSNumber numberWithFloat:1000 * pulseInterval]];
        }
             
    
        [dict setObject:arr forKey:@"VibePattern"];
        // looks like the intensity is between 0 and 1
        [dict setObject:[NSNumber numberWithFloat:intensityLevel] forKey:@"Intensity"];
        AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);


    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleValueChanged:(id)sender {
    UISwitch *sw = (UISwitch*)sender;
    isVibrating = sw.isOn;
    if (isVibrating) {
        
        //timer = [NSTimer scheduledTimerWithTimeInterval:2 * pulseInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    } else {
        [timer invalidate];
        timer = [NSTimer scheduledTimerWithTimeInterval:2 * pulseInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    }

}

- (IBAction)intensitySliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;

    intensityLevel = slider.value;
    
    if (isVibrating) {
        resetNextFire = YES;
    }
    
}

- (IBAction)pulseSliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;

    // slider is always value 0 to 1
    // interval mapping algorithm.
    if ((int)slider.value == 1) {
        pulseInterval = 300;
        [self timerFired];
    } else if (slider.value == 0) {
        pulseInterval = 0.1;
    } else {
        pulseInterval = slider.value;
    }

    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:2 * pulseInterval target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}

#pragma mark - UIGestureRecognizer methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isTapped = YES;
    
    if (!isVibrating) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        NSMutableArray* arr = [NSMutableArray array ];
        
        [arr addObject:[NSNumber numberWithBool:YES]];
        

        [arr addObject:[NSNumber numberWithFloat:FLT_MAX]];
        
        [dict setObject:arr forKey:@"VibePattern"];
        // looks like the intensity is between 0 and 1
        [dict setObject:[NSNumber numberWithFloat:intensityLevel] forKey:@"Intensity"];
        
        AudioServicesPlaySystemSoundWithVibration(4095,nil,dict);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isTapped = NO;
    
    if (!isVibrating) {
        AudioServicesStopSystemSound(4095);
    }
}


@end
