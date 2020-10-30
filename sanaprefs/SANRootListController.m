#include "SANRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <AudioToolbox/AudioServices.h>
#import <Preferences/PSSwitchTableCell.h>
#import <SpringBoardServices/SBSRestartRenderServerAction.h>
#import <FrontBoardServices/FBSSystemService.h>

// Cell Coloring
@interface SANSwitchCell : PSSwitchTableCell
- (UIColor *)colorFromHex:(NSString *)hex withAlpha:(CGFloat)alpha;
@end

@implementation SANSwitchCell {
  UIColor *_switchColor;
}

  - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if (self) {
      ((UISwitch *)self.control).onTintColor = [self colorFromHex:[specifier propertyForKey:@"switchColor"] withAlpha:[[specifier propertyForKey:@"switchColorAlpha"] floatValue]];
    }

    return self;
  }

  - (UIColor *)colorFromHex:(NSString *)hex withAlpha:(CGFloat)alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0 blue:((float)((rgbValue & 0x0000FF) >> 0)) / 255.0 alpha:alpha];
  }
@end

@implementation SANRootListController

- (id)readPreferenceValue:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    [settings setObject:value forKey:specifier.properties[@"key"]];
    [settings writeToFile:path atomically:YES];
    CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
    if (notificationName) {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
    }
}

// Apply button coloring
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIColor *tintColor = [UIColor colorWithRed: 0.74 green: 0.54 blue: 0.98 alpha: 1.00]; // uicolor.io
    [[[[self navigationController] navigationController] navigationBar] setTintColor:tintColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:1.0 animations:^{
        [[[[self navigationController] navigationController] navigationBar] setTintColor:nil];
    }];
}

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    
    return _specifiers;
}

// Links
- (void)sourceLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/samoht9277/sana"] options:@{} completionHandler:nil];
    AudioServicesPlaySystemSound(1519);
}

- (void)redditLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/user/bobbyboys301"] options:@{} completionHandler:nil];
    AudioServicesPlaySystemSound(1519);
}

// Respring
- (void)respring {
    // Brings user back to the preferences.
    NSURL *returnURL = [NSURL URLWithString:@"prefs:root=Sana"];
    SBSRelaunchAction *restartAction;
    restartAction = [NSClassFromString(@"SBSRelaunchAction") actionWithReason:@"RestartRenderServer" options:SBSRelaunchActionOptionsFadeToBlackTransition targetURL:returnURL];
    [[NSClassFromString(@"FBSSystemService") sharedService] sendActions:[NSSet setWithObject:restartAction] withResult:nil];
}

- (void)respringPrompt {
    AudioServicesPlaySystemSound(1520);
    
    // UIAlertController that shows when the Apply button is hit.
    UIAlertController *respringAlert = [UIAlertController alertControllerWithTitle:@"Sana"
    message:@"Sana needs a respring to apply changes."
    preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self respring];
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Decline" style:UIAlertActionStyleCancel handler:nil];

    [respringAlert addAction:confirmAction];
    [respringAlert addAction:cancelAction];

    [self presentViewController:respringAlert animated:YES completion:nil];
}

// Apply Button
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *respringButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Respring"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(respringPrompt)];
    self.navigationItem.rightBarButtonItem = respringButton;
    
    // Check if user has opened prefs before.
    NSString *path = @"/var/mobile/Library/Preferences/com.samoht.sana.plist";
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    NSNumber *didShowAlert = [settings valueForKey:@"didShowAlert"] ?: @0;

    if ([didShowAlert isEqual:@0]) {
        [self showAlert];
    }
 }

- (void)showAlert {
    NSString *path = @"/var/mobile/Library/Preferences/com.samoht.sana.plist";
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
    
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:@"Sana 1.1 Update"
    message:@"\nWider Y axis range! \n\nSlider for mini HUD state width. \n\nCleaner settings and code."
    preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Enjoy!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [confirmAlert addAction:confirmAction];

    [self presentViewController:confirmAlert animated:YES completion:nil];
    
    [settings setObject:@1 forKey:@"didShowAlert"];
    [settings writeToFile:path atomically:YES];
}

@end
