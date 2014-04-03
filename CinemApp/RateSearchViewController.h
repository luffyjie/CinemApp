#import <UIKit/UIKit.h>
#import "Movie.h"
#import "RateViewController.h"
#import <JLTMDbClient.h>

@interface RateSearchViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *moviesArray;
@property (strong, nonatomic) UITableView *mainTableView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *entries;



#pragma mark - Methods
- (void) retrieveData;

@end
