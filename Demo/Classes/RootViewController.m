//
//  RootViewController.m
//  Couchbase Mobile
//
//  Created by Jan Lehnardt on 27/11/2010.
//  Copyright 2011 Couchbase, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.
//

#import "RootViewController.h"
#import "NewServerController.h"
#import "CCouchDBServer.h"
#import "CCouchDBDatabase.h"
#import "NewItemViewController.h"
#import "DatabaseManager.h"
#import "CouchDBClientTypes.h"
#import "CURLOperation.h"




@implementation RootViewController
@synthesize items;
@synthesize checked;
@synthesize syncItem;
@synthesize activityButtonItem;
@synthesize couchbaseURL;
@synthesize delegate;

//NSMutableArray * checked = [NSMutableArray arrayWithObjects: @"",nil ];

#pragma mark -
#pragma mark View lifecycle

-(NSURL *)getCouchbaseURL {
	return self.couchbaseURL;
}



-(void)couchbaseDidStart:(NSURL *)serverURL {
	self.couchbaseURL = serverURL;
	[self loadItemsIntoView];
	NSLog(@"serverURL %@",serverURL);
	self.syncItem = [[[UIBarButtonItem alloc] 
					  initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered
					  target:self 
					  action:@selector(sync) 
					  ] autorelease];
	self.navigationItem.rightBarButtonItem = self.syncItem;
	self.navigationItem.leftBarButtonItem.enabled = YES;
	self.navigationItem.rightBarButtonItem.enabled = YES;
    
    //_checkboxSelections =0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
	// setup buttons
//	UIBarButtonItem *addButtonItem = [[[UIBarButtonItem alloc] 
//									   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
//                                       target:self 
//                                       action:@selector(addItem) 
//                                       ] autorelease];
//	addButtonItem.enabled = NO;
//	self.navigationItem.leftBarButtonItem = addButtonItem;
    
    // create a toolbar to have two buttons in the right
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 133, 44.01)];
    
    // create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a standard "add" button
    UIBarButtonItem* bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    [bi release];
    
    // create a spacer
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [buttons addObject:bi];
    [bi release];
    
    // create a standard "refresh" button
    bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(addServer)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    [bi release];
    
    // stick the buttons in the toolbar
    [tools setItems:buttons animated:NO];
    
    [buttons release];
    
    // and put the toolbar in the nav bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];
    
	UIActivityIndicatorView *activity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
	[activity startAnimating];
	self.activityButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:activity] autorelease];
	self.activityButtonItem.enabled = NO;
	self.navigationItem.rightBarButtonItem = activityButtonItem;
}

-(void)sync
{
	self.syncItem = self.navigationItem.rightBarButtonItem;
	[self.navigationItem setRightBarButtonItem: self.activityButtonItem animated:YES];
    //cell.textLabel.text = [items objectAtIndex:indexPath.row];
	DatabaseManager *manager = [DatabaseManager sharedManager:self.couchbaseURL];
	DatabaseManagerSuccessHandler successHandler = ^() {
  	    //woot	
		NSLog(@"success handler called!");
		[self loadItemsIntoView];
	};
    
	DatabaseManagerErrorHandler errorHandler = ^(id error) {
		// doh	
	};
	
	[manager syncFrom:@"http://subarvind.iriscouch.com/demo/" to:@"demo" onSuccess:successHandler onError:errorHandler];
	[manager syncFrom:@"demo" to:@"http://subarvind.iriscouch.com/demo/" onSuccess:^() {} onError:^(id error) {}];
}

-(void)loadItemsIntoView
{
	if(self.navigationItem.rightBarButtonItem       != syncItem) {
		[self.navigationItem setRightBarButtonItem: syncItem animated:YES];
	}
    
	DatabaseManager *sharedManager = [DatabaseManager sharedManager:self.couchbaseURL];
	CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
        //		NSLog(@"RVC Wooohooo! %@: %@", [inParameter class], inParameter);
		self.items = inParameter;
        NSLog(@"%@",self.items);
        
		[self.tableView reloadData];
	};
	
	CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
		NSLog(@"RVC D'OH! %@", error);
	};
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"true", @"descending", @"true", @"include_docs", nil];
	CURLOperation *op = [sharedManager.database operationToFetchAllDocumentsWithOptions:options 
																	 withSuccessHandler:inSuccessHandler 
																		 failureHandler:inFailureHandler];
	[op start];
}	


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
	// Configure the cell.
	CCouchDBDocument *doc = [self.items objectAtIndex:indexPath.row];
    id check = [NSNumber numberWithInteger: 1];
    
    if ([[doc valueForKey:@"content"] valueForKey:@"check"] == check) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [[doc valueForKey:@"content"] valueForKey:@"text"];
    
    //arvind - get the indexpath.row bit
    int flag = (1 << indexPath.row);
    
    
    //arvind - update row's accessory if it's "turned on"
    //arvind - here changes are made to local db only when a row is checked, a similar code could be added to update db when row is unchecked
    if (_checkboxSelections & flag) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        int x = 1;
        
        //arvind - creatinf the updated doc
        NSDictionary *inDocument = [NSDictionary dictionaryWithObjectsAndKeys:[[doc valueForKey:@"content"] valueForKey:@"text"], @"text"
                                    , [[NSDate date] description], @"created_at"
                                    , [NSNumber numberWithInt:x],@"check", nil];
        
        
        DatabaseManager *sharedManager = [DatabaseManager sharedManager:[delegate getCouchbaseURL]];
        
        
        CouchDBSuccessHandler inSuccessHandler = ^(id inParameter) {
            NSLog(@"Wooohooo! %@", inParameter);
            [delegate performSelector:@selector(newItemAdded)];
        };
        
        CouchDBFailureHandler inFailureHandler = ^(NSError *error) {
            NSLog(@"D'OH! %@", error);
        };            
        // NSString *updateid = [[doc valueForKey:@"content"] valueForKey:@"_id"];
        
        
        //deleting content of the old doc, had to do this as update was failing, have to try and get update to work
        NSUInteger position = [indexPath indexAtPosition:1]; // indexPath is [0, idx]
        [[DatabaseManager sharedManager:self.couchbaseURL] deleteDocument: [items objectAtIndex:position]];
       
        
        CURLOperation *op = [sharedManager.database operationToCreateDocument:inDocument 
                                                                   identifier:[[doc valueForKey:@"content"]valueForKey:@"_id"]
                                                               successHandler:inSuccessHandler 
                                                               failureHandler:inFailureHandler];

        
        [op start];
        
    };
    return cell;
    
}

-(void)newItemAdded
{
	[self loadItemsIntoView];
	[self dismissModalViewControllerAnimated:YES];
}


-(void)addServer
{
    NewServerController *newServerVC = [[NewServerController alloc] initWithNibName:@"NewServerController" bundle:nil];
    newServerVC.delegate = self;
    UINavigationController *newServerNC = [[UINavigationController alloc] initWithRootViewController:newServerVC];
    [self presentModalViewController:newServerNC animated:YES];
    [newServerNC release];
    [newServerVC release];
}

-(void)addItem
{
	// TBD
	NewItemViewController *newItemVC = [[NewItemViewController alloc] initWithNibName:@"NewItemViewController" bundle:nil];
	newItemVC.delegate = self;
	UINavigationController *newItemNC = [[UINavigationController alloc] initWithRootViewController:newItemVC];
	[self presentModalViewController:newItemNC animated:YES];
	[newItemVC release];
	[newItemNC release];
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
		NSUInteger position = [indexPath indexAtPosition:1]; // indexPath is [0, idx]
		[[DatabaseManager sharedManager:self.couchbaseURL] deleteDocument: [items objectAtIndex:position]];
		[items removeObjectAtIndex: position];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //arvind - toggle the indexpath.row bit, to have the ability to check / uncheck
	_checkboxSelections ^= (1 << indexPath.row);
    [tableView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [items release];
    [checked release];
    [super dealloc];
}


@end

