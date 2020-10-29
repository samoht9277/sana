//
//  sana.h
//
//  Created by Tomi Casagrande on 04/07/2020.
//  Copyright © 2020 Tomi Casagrande. All rights reserved.

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.samoht.sana.plist"

BOOL isEnabled;
BOOL wantsLabelHidden;
BOOL wantsGlyph;
BOOL wantsToChangeAxis;
BOOL wantsToChangeWidth;
int Y;
int glyphSize;

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    isEnabled = [prefs objectForKey:@"isEnabled"] ? [[prefs objectForKey:@"isEnabled"] boolValue] : YES;
    wantsLabelHidden = [prefs objectForKey:@"wantsLabelHidden"] ? [[prefs objectForKey:@"wantsLabelHidden"] boolValue] : YES;
    wantsGlyph = [prefs objectForKey:@"wantsGlyph"] ? [[prefs objectForKey:@"wantsGlyph"] boolValue] : NO;
    wantsToChangeAxis = [prefs objectForKey:@"wantsToChangeAxis"] ? [[prefs objectForKey:@"wantsToChangeAxis"] boolValue] : NO;
    wantsToChangeWidth = [prefs objectForKey:@"wantsToChangeWidth"] ? [[prefs objectForKey:@"wantsToChangeWidth"] boolValue] : NO;
    Y = [[prefs objectForKey:@"Y"] intValue];
    glyphSize = [[prefs objectForKey:@"glyphSize"] intValue];
}
