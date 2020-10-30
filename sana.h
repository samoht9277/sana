//
//  sana.h
//
//  Created by Tomi Casagrande on 30/10/2020.
//  Copyright © 2020 Tomi Casagrande. All rights reserved.

#define PLIST @"/var/mobile/Library/Preferences/com.samoht.sana.plist"

BOOL isEnabled;

// Label.
BOOL wantsLabelHidden;

// Y axis.
BOOL wantsToChangeAxis;
int Y;

// Width (only for mini state).
BOOL wantsToChangeWidth;
double width;

// Glyph.
BOOL wantsGlyph;
int glyphSize;

static void loadPreferences() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST];
    
    isEnabled = [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES;
    
    // Label.
    wantsLabelHidden = [prefs objectForKey:@"wantsLabelHidden"] ? [[prefs objectForKey:@"wantsLabelHidden"] boolValue] : YES;
    
    // Y axis.
    wantsToChangeAxis = [prefs objectForKey:@"wantsToChangeAxis"] ? [[prefs objectForKey:@"wantsToChangeAxis"] boolValue] : NO;
    Y = [[prefs objectForKey:@"Y"] intValue];
    
    // Width (only for mini state).
    wantsToChangeWidth = [prefs objectForKey:@"wantsToChangeWidth"] ? [[prefs objectForKey:@"wantsToChangeWidth"] boolValue] : NO;
    width = [[prefs objectForKey:@"width"] doubleValue];
    
    // Glyph.
    wantsGlyph = [prefs objectForKey:@"wantsGlyph"] ? [[prefs objectForKey:@"wantsGlyph"] boolValue] : NO;
    glyphSize = [[prefs objectForKey:@"glyphSize"] intValue];
}
