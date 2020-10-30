//
//  Sana.
//
//  Created by Tomi Casagrande on 04/07/2020.
//  Copyright © 2020 Tomi Casagrande. All rights reserved.

#import "sana.h"

%group Tweak
%hook SBElasticVolumeViewController

- (int)axis {
    return 1;
}

%end
%end

%group HUDLabel
%hook SBElasticVolumeViewController

- (void)_updateLabelsForAxis:(int)arg1 containerViewSize:(CGSize)arg2 state:(long long)arg3 animated:(BOOL)arg4 {
    return;
}

%end
%end

%group HUDGlyph
%hook SBElasticVolumeViewController

- (double)glyphScaleForState:(long long)arg1 {
    return (glyphSize);
}

%end
%end

%group HUDAxis
%hook SBVolumeHUDSettings

- (void)setOnscreenTopMargin:(double)arg1 {
    double axis = (Y);
    return %orig(axis);
}

%end
%end

%group HUDWidth
%hook SBVolumeHUDSettings

- (void)setLandscapeState2Width:(double)arg1 {
    double w = (width);
    return %orig(w);
}

%end
%end

%ctor {
    loadPreferences();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPreferences, CFSTR("com.samoht.sana.changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
        
    if (isEnabled) {
        %init (Tweak);
    
        if (wantsLabelHidden) %init (HUDLabel);
        if (wantsGlyph) %init (HUDGlyph);
        if (wantsToChangeAxis) %init (HUDAxis);
        if (wantsToChangeWidth) %init (HUDWidth);
    }
}
