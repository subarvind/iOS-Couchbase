#import "NewItemViewController.h"
#import "NewServerController.h"
#import "RootViewController.h"
#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "CouchDBClientTypes.h"
#import "DatabaseManager.h"
#import "CouchDBClientTypes.h"
#import "CURLOperation.h"
#import "Server.h"



@implementation NewServerController
@synthesize textView;
@synthesize delegate;
@synthesize couchbaseURL;
@synthesize items;


-(NSURL *)getCouchbaseURL {
	return self.couchbaseURL;
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *doneButtonItem = [[[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                        target:self 
                                        action:@selector(done) 
                                        ] autorelease];
	self.navigationItem.rightBarButtonItem = doneButtonItem;
    
	UIBarButtonItem *cancelButtonItem = [[[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                          target:self
                                          action:@selector(cancel)
                                          ] autorelease];
	self.navigationItem.leftBarButtonItem = cancelButtonItem;
}

-(void)cancel
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)done
{
	NSString *text = textView.text;
    
    //int new = 0;
    
    Server *myserver = [Server sharedInstance];
//    
    [myserver setServerName:text];
    
    NSString * haw = [myserver getServerName];
    NSLog(@"%@", haw);
    
    //[Server sharedInstance].servername = text;
    [self.navigationController dismissModalViewControllerAnimated:YES];
    
	
//	NSDictionary *inDocument = [NSDictionary dictionaryWithObjectsAndKeys:text, @"text"
//                                , [[NSDate date] description], @"created_at"
//                                , [NSNumber numberWithInt:new],@"check", nil];
//	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
//		NSLog(@"Wooohooo! %@", inParameter);
//		[delegate performSelector:@selector(newItemAdded)];
//	};
//    
//	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
//		NSLog(@"D'OH! %@", error);
//	};
//	CFUUIDRef uuid = CFUUIDCreate(nil);
//    NSString *guid = (NSString*)CFUUIDCreateString(nil, uuid);
//    CFRelease(uuid);
//	NSString *docId = [NSString stringWithFormat:@"%f-%@", CFAbsoluteTimeGetCurrent(), guid];
//	DatabaseManager *sharedManager = [DatabaseManager sharedManager:[delegate getCouchbaseURL]];
//	CURLOperation *op = [sharedManager.database operationToCreateDocument:inDocument 
//															   identifier:docId
//														   successHandler:inSuccessHandler 
//														   failureHandler:inFailureHandler];
//    
//    
//    //CURLOperation *op = [sharedManager.database operationToCreateDocument:inDocument
//    
//	[op start];
}

//-(void)loadItemsIntoView
//{
//	    
//	DatabaseManager *sharedManager = [DatabaseManager sharedManager:self.couchbaseURL];
//	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
//        //		NSLog(@"RVC Wooohooo! %@: %@", [inParameter class], inParameter);
//        //NSMutableArray * mutableArray = [NSMutableArray arrayWithObjects:@"blah", nil ];
//		self.items = inParameter;
//        NSLog(@"%@",self.items);
//        
//        
//        // int ifcheck = 
//        //self.checked = inParameter; //ARVIND
//        //self.checked = inParameter;
//        //int k=0;
//        // int i=1;
//        //int j=1;
//        
//        // int m=[self.checked count];
//        //printf int m;
//        /*    for (int i=1; i<=[checked count]; i++) {
//         for (int j=1; j<=[self.items count]; j++) {
//         // printf("[checked count]");
//         NSString *item = [self.items objectAtIndex:j];
//         NSString *obj = [checked objectAtIndex:i];
//         
//         if([item isEqualToString: obj]){
//         //cell.accessoryType = UITableViewCellAccessoryCheckmark;
//         k=56;
//         exit(1);
//         }else{
//         // cell.accessoryType = UITableViewCellAccessoryNone;
//         k = 57;
//         exit(1);
//         }
//         j=1;	
//         }
//         i=1;
//         }
//         */
//        
//		//[self.tableView reloadData];
//	};
//	
//	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
//		NSLog(@"RVC D'OH! %@", error);
//	};
//	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"descending", @"true", @"include_docs", nil];
//	CURLOperation *op = [sharedManager.database operationToFetchAllDocumentsWithOptions:options 
//																	 withSuccessHandler:inSuccessHandler 
//																		 failureHandler:inFailureHandler];
//	[op start];
//}	



-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[textView becomeFirstResponder];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [items release];
    [super dealloc];
}


@end
