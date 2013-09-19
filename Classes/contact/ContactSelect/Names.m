//
//  Names.m
//  TokenFieldExample
//
//  Created by Tom on 06/03/2010.
//  Copyright 2010 Tom Irving. All rights reserved.
//

#import "Names.h"


@implementation Names

+ (NSArray *)listOfNames {
	
	// Generated with http://www.kleimo.com/random/name.cfm
	
//	return [NSArray arrayWithObjects:
//			@"Samuel Prescott",
//			@"Grace Mcburney", 
//			@"Rosemary Sells",
//			@"Janet Canady",
//			@"Gregory Leech",
//			@"Geneva Mcguinness",
//			@"Billy Shin",
//			@"Douglass Fostlick",
//			@"Roberta Pedersen",
//			@"Earl Rashid",
//			@"Matthew Hooks",
//			@"Regina Toombs",
//			@"Victor Sisneros",
//			@"Beverly Covington",
//			@"Steve Crews",
//			@"Carlos Trejo",
//			@"Victoria Delgadillo",
//			@"Leah Greenberg",
//			@"Deborah Depew",
//			@"Jeffery Khoury",
//			@"Kathryn Worsham",
//			@"Olivia Brownell",
//			@"Gary Pritchard",
//			@"Susan Cervantes",
//			@"Olvera Nipplehead",
//			@"Debra Graves",
//			@"Albert Deltoro",
//			@"Carole Flatt",
//			@"Philip Vo",
//			@"Phillip Wagstaff",
//			@"Xiao Jacquay",
//			@"Cleotilde Vondrak",
//			@"Carter Redepenning",
//			@"Kaycee Wintersmith",
//			@"Collin Tick",
//			@"Peg Yore",
//			@"Cruz Buziak",
//			@"Ardath Osle",
//			@"Frederic Manusyants",
//			@"Collin Politowski",
//			@"Hunter Wollyung",
//			@"Cruz Gurke",
//			@"Sulema Sholette",
//			@"Denver Goetter",
//			@"Chantay Phothirath",
//			@"Arlean Must",
//			@"Carlo Henggeler",
//			@"Daughrity Maichle",
//			@"Zada Wintermantel",
//			@"Denver Kubu",
//			@"Carlo Guzma",
//			@"Emory Swires",
//			@"Kirby Manas",
//			@"Tobie Spirito",
//			@"Lane Defaber",
//			@"Sparkle Mousa",
//			@"Chantay Palczynski",
//			@"Denver Perfater",
//			@"Tom Irving",
//			nil];
	
	NSMutableArray *datasource = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
	
	NSMutableDictionary *dic = nil;
	
	dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
		   @"301",	@"ID",				// ID
		   @"김경철", @"NAME",			// 이름
		   @"팀장", @"POSITION",			// 직급
		   @"개발", @"DEPARTMENT",		// 부서
		   @"모바일 1팀", @"ETC",			// 기타
		   @"N", @"SELECTED",	nil];	// 선택여부
	[datasource addObject:dic];
	[dic release];
	
	dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
		   @"302",	@"ID",				// ID
		   @"김함철", @"NAME",			// 이름
		   @"팀장", @"POSITION",			// 직급
		   @"개발", @"DEPARTMENT",		// 부서
		   @"모바일 1팀", @"ETC",			// 기타
		   @"N", @"SELECTED",	nil];	// 선택여부
	[datasource addObject:dic];
	[dic release];
	
	dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
		   @"303",	@"ID",				// ID
		   @"김승철", @"NAME",			// 이름
		   @"팀장", @"POSITION",			// 직급
		   @"개발", @"DEPARTMENT",		// 부서
		   @"모바일 1팀", @"ETC",			// 기타
		   @"N", @"SELECTED",	nil];	// 선택여부
	[datasource addObject:dic];
	[dic release];
	
	dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
		   @"304",	@"ID",				// ID
		   @"김명철", @"NAME",			// 이름
		   @"팀장", @"POSITION",			// 직급
		   @"개발", @"DEPARTMENT",		// 부서
		   @"모바일 1팀", @"ETC",			// 기타
		   @"N", @"SELECTED",	nil];	// 선택여부
	[datasource addObject:dic];
	[dic release];
	
	return datasource;
}

@end
