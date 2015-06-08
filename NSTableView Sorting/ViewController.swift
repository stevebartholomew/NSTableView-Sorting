//
//  ViewController.swift
//  NSTableView Sorting
//
//  Created by Stephen Bartholomew on 08/06/2015.
//  Copyright (c) 2015 bit.boutique. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

  @IBOutlet weak var tableView: NSTableView!
  
  var items = NSMutableArray()
  let MyRowType = "MyRowType"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    items = ["Macbook", "Mac Pro", "iMac"]
    
    tableView.registerForDraggedTypes([MyRowType, NSFilenamesPboardType])
    tableView.setDraggingSourceOperationMask(NSDragOperation.Every, forLocal: true)
  }
  
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return items.count
  }
  
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    var identifier = tableColumn!.identifier
    let cell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
    
    cell.textField?.stringValue = items[row] as! String
    
    return cell
  }
  
  func tableView(tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {

    tableView.setDropRow(row, dropOperation: NSTableViewDropOperation.Above)
    return NSDragOperation.Move
  }
  
  
  func tableView(tableView: NSTableView, writeRowsWithIndexes: NSIndexSet, toPasteboard: NSPasteboard) -> Bool {
    var data = NSKeyedArchiver.archivedDataWithRootObject([writeRowsWithIndexes])
    toPasteboard.declareTypes([MyRowType], owner:self)
    toPasteboard.setData(data, forType:MyRowType)
    
    return true
  }
  
  func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
    var pasteboard = info.draggingPasteboard()
    var rowData = pasteboard.dataForType(MyRowType)
    
    if(rowData != nil) {
      var dataArray = NSKeyedUnarchiver.unarchiveObjectWithData(rowData!) as! Array<NSIndexSet>,
          indexSet = dataArray[0]
      
      var movingFromIndex = indexSet.firstIndex
      var item = items[movingFromIndex] as! String
      
      _moveItem(item, from: movingFromIndex, to: row)
      
      return true
    }
    else {
      return false
    }
  }
  
  func _moveItem(item: String, from: Int, to: Int) {
    items.removeObjectAtIndex(from)
    
    if(to > (items.count - 1)) {
      items.addObject(item)
    }
    else {
      items.insertObject(item, atIndex: to)
    }
    tableView.reloadData()
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }
}

