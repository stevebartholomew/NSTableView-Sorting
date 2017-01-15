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
  
  var items: [String] = []
  let MyRowType = "MyRowType"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    items = ["Macbook", "Mac Pro", "iMac"]
    
    tableView.register(forDraggedTypes: [MyRowType, NSFilenamesPboardType])
  }
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    var identifier = tableColumn!.identifier
    let cell = tableView.make(withIdentifier: tableColumn!.identifier, owner: self) as! NSTableCellView
    
    cell.textField?.stringValue = items[row]
    
    return cell
  }
  
  func tableView(_ tableView: NSTableView, writeRowsWith writeRowsWithIndexes: IndexSet, to toPasteboard: NSPasteboard) -> Bool {
    let data = NSKeyedArchiver.archivedData(withRootObject: [writeRowsWithIndexes])
    toPasteboard.declareTypes([MyRowType], owner:self)
    toPasteboard.setData(data, forType:MyRowType)
    
    return true
  }
  
  func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableViewDropOperation) -> NSDragOperation {

    tableView.setDropRow(row, dropOperation: NSTableViewDropOperation.above)
    return NSDragOperation.move
  }

  
  func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool {
    let pasteboard = info.draggingPasteboard()
    let rowData = pasteboard.data(forType: MyRowType)
    
    if(rowData != nil) {
      var dataArray = NSKeyedUnarchiver.unarchiveObject(with: rowData!) as! Array<IndexSet>,
          indexSet = dataArray[0]
      
      let movingFromIndex = indexSet.first
      let item = items[movingFromIndex!]
      
      _moveItem(item, from: movingFromIndex!, to: row)
      
      return true
    }
    else {
      return false
    }
  }
  
  func _moveItem(_ item: String, from: Int, to: Int) {
    items.remove(at: from)
    
    if(to > items.endIndex) {
      items.append(item)
    }
    else {
      items.insert(item, at: to)
    }
    tableView.reloadData()
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
}

