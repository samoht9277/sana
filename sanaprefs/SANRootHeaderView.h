#import <Preferences/PSHeaderFooterView.h>

@interface SANRootHeaderView : UITableViewHeaderFooterView <PSHeaderFooterView>
{
	UIImageView* _headerImageView;
	CGFloat _currentWidth;
	CGFloat _aspectRatio;
}

@end
