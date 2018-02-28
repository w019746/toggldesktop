//
//  AutoCompleteTable.m
//  LiteComplete
//
//  Created by Indrek Vändrik on 21/02/2018.
//  Copyright © 2018 Toggl. All rights reserved.
//

#import "AutoCompleteTable.h"
#include <Carbon/Carbon.h>

@implementation AutoCompleteTable

- (instancetype)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.lastSelected = -1;
		NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column"];
		column.width = 400;
		[self addTableColumn:column];
		[self setHeaderView:nil];
		[self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleNone];
		[self setIntercellSpacing:NSMakeSize(0, 0)];
	}
	return self;
}

- (void)drawGridInClipRect:(NSRect)clipRect
{
	NSRect lastRowRect = [self rectOfRow:[self numberOfRows] - 1];
	NSRect myClipRect = NSMakeRect(0, 0, lastRowRect.size.width, NSMaxY(lastRowRect));
	NSRect finalClipRect = NSIntersectionRect(clipRect, myClipRect);

	[super drawGridInClipRect:finalClipRect];
}

- (void)keyDown:(NSEvent *)event
{
	if (event.keyCode == kVK_UpArrow && self.selectedRow == 0)
	{
		// Focus input
	}
	else if ((event.keyCode == kVK_Return) || (event.keyCode == kVK_ANSI_KeypadEnter))
	{
		/*
		 * TimeEntryCell *cell = [self getSelectedEntryCell];
		 * if (cell != nil)
		 * {
		 *  [cell openEdit];
		 * }
		 */
	}
	else if (event.keyCode == kVK_Escape)
	{
		// Hide autocomplete list
		// [self.autocompleteTableContainer removeFromSuperview];
		// self.listVisible = NO;

		/*
		 * [[NSNotificationCenter defaultCenter] postNotificationName:kEscapeListing
		 *                                                  object:nil
		 *                                                userInfo:nil];
		 */
	}
	/*
	 * else if (event.keyCode == kVK_RightArrow)
	 * {
	 *  TimeEntryCell *cell = [self getSelectedEntryCell];
	 *  if (cell != nil && cell.GroupName.length && !cell.GroupOpen)
	 *  {
	 *      toggl_toggle_entries_group(ctx, [cell.GroupName UTF8String]);
	 *  }
	 * }
	 * else if (event.keyCode == kVK_LeftArrow)
	 * {
	 *  TimeEntryCell *cell = [self getSelectedEntryCell];
	 *  if (cell != nil && cell.GroupName.length && cell.GroupOpen)
	 *  {
	 *      toggl_toggle_entries_group(ctx, [cell.GroupName UTF8String]);
	 *  }
	 * }
	 */
	else
	{
		[super keyDown:event];
	}
}

/*
 * - (TimeEntryCell *)getSelectedCell
 * {
 *
 *  if (self.selectedRow != -1)
 *  {
 *      self.latestSelectedRow = self.selectedRow;
 *  }
 *  NSView *latestView = [self rowViewAtRow:[self latestSelectedRow]
 *                        makeIfNecessary  :NO];
 *
 *  for (NSView *subview in [latestView subviews])
 *  {
 *      if ([subview isKindOfClass:[TimeEntryCell class]] || [subview isKindOfClass:[TimeEntryCellWithHeader class]])
 *      {
 *          return (TimeEntryCell *)subview;
 *      }
 *  }
 *  return nil;
 * }
 */

- (void)setFirstRowAsSelected
{
	[self deselectAll:nil];

	NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
	[self selectRowIndexes:indexSet byExtendingSelection:NO];

	[self setCurrentSelected:0];

	/*
	 * TimeEntryCell *cell = [self getSelectedCell];
	 * if (cell != nil)
	 * {
	 *  [cell setFocused];
	 * }
	 */
}

- (void)setCurrentSelected:(NSInteger)index
{
	if (self.lastSelected != -1)
	{
		AutoCompleteTableCell *cell = [self getSelectedCell:self.lastSelected];
		[cell setFocused:NO];
	}

	self.lastSelected = index;
	AutoCompleteTableCell *cell = [self getSelectedCell:index];
	if (cell != nil)
	{
		[cell setFocused:YES];
	}
}

- (AutoCompleteTableCell *)getSelectedCell:(NSInteger)row
{
	if (row < 0)
	{
		return nil;
	}

	NSView *latestView = [self rowViewAtRow:row makeIfNecessary:YES];

	if (latestView == nil)
	{
		return nil;
	}

	for (NSView *subview in [latestView subviews])
	{
		if ([subview isKindOfClass:[AutoCompleteTableCell class]])
		{
			return (AutoCompleteTableCell *)subview;
		}
	}

	return nil;
}

@end

