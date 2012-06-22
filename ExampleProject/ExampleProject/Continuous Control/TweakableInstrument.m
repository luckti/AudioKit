//
//  TweakableInstrument.m
//  ExampleProject
//
//  Created by Adam Boulanger on 6/18/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "TweakableInstrument.h"
#import "CSDAssignment.h"

@implementation TweakableInstrument
//@synthesize myPropertyManager;
@synthesize amplitude;
@synthesize frequency;
@synthesize modulation;
@synthesize modIndex;

-(id)initWithOrchestra:(CSDOrchestra *)newOrchestra
{
    self = [super initWithOrchestra:newOrchestra];
    if (self) {
        
        // INPUTS AND CONTROLS =================================================
    
        amplitude  = [[CSDProperty alloc] initWithValue:0.1f    Min:0.0f  Max:1.0f];
        frequency  = [[CSDProperty alloc] init];
        modulation = [[CSDProperty alloc] initWithValue:0.5f    Min:0.25f Max:2.2f];
        modIndex   = [[CSDProperty alloc] initWithValue:1.0f    Min:0.0f  Max:25.0f];
        
        //Optional output string assignment, can make for a nicer to read CSD File
        [amplitude  setOutput:[CSDParamControl paramWithString:@"Amplitude"]]; 
        [frequency  setOutput:[CSDParamControl paramWithString:@"Frequency"]]; 
        [modulation setOutput:[CSDParamControl paramWithString:@"Modulation"]]; 
        [modIndex   setOutput:[CSDParamControl paramWithString:@"ModIndex"]]; 
        
        //[self addProperties:amplitude, frequency, modulation, modIndex, nil];
        [self addProperty:amplitude];
        [self addProperty:frequency];
        [self addProperty:modulation];
        [self addProperty:modIndex];
        
        //[myPropertyManager = [[CSDPropertyManager alloc] init];
        //[myPropertyManager addProperty:amplitude            forControllerNumber:12];
        //[myPropertyManager addProperty:modulationContinuous forControllerNumber:13];
        //[myPropertyManager addProperty:modIndexContinuous   forControllerNumber:14];
        
        // INSTRUMENT DEFINITION ===============================================
        
        CSDSineTable *sineTable = [[CSDSineTable alloc] init];
        [self addFunctionTable:sineTable];
        
        CSDFoscili *myFMOscillator = 
        [[CSDFoscili alloc] initWithAmplitude:[amplitude output]
                                    Frequency:[frequency output]
                                      Carrier:[CSDParamConstant paramWithInt:1] 
                                   Modulation:[modulation output]
                                     ModIndex:[modIndex output]
                                FunctionTable:sineTable 
                             AndOptionalPhase:nil];
        [self addOpcode:myFMOscillator];
        
        // AUDIO OUTPUT ========================================================
        
        CSDOutputStereo *stereoOutput = 
        [[CSDOutputStereo alloc] initWithMonoInput:[myFMOscillator output]];
        [self addOpcode:stereoOutput];
    }
    return self;
}

-(void) playNoteForDuration:(float)dur Frequency:(float)freq {
    frequency.value = freq;
    [self playNoteForDuration:dur];
}


@end
