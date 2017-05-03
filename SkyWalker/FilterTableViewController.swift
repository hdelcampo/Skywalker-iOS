//
//  FilterTableViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 21/2/17.
//  Copyright © 2017 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

/**
 Filter table controller
*/
class FilterTableViewController: UITableViewController, SwitchCellDelegate {
    
    // MARK: Properties
    var cellsData = [FilterCellData]()
    var delegate: SelectableTableViewDelegate?
    
    /**
        Indicates if maximum elements where exceeded or not.
    */
    var excedeedMax: Bool {
        return OverlayViewController.maxPoints <= selectedItems.count
    }
    
    /**
        A set containing the selected items
    */
    private var selectedItems: Set = Set<PointOfInterest>()

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "FilterTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? FilterTableViewCell
        else {
            fatalError("The dequeued cell is not an instance of FilterTableViewCell")
        }

        let pointCell = cellsData[indexPath.row]
        
        cell.cellData = pointCell
        cell.name.text = pointCell.title
        cell.delegate = self
        if (canBeEnabled(cell)) {
            cell.switch.isOn = pointCell.enabled
            cell.switch.isEnabled = true
            onSwitchChange(cell: cell)
        } else {
            cell.switch.isOn = false
            cell.switch.isEnabled = false
        }

        return cell
        
    }
    
    // MARK: Load data methods
    
    /**
        Replaces data in the data model.
        - Parameters:
            - allPoints: All the avialable points.
            - usedPoints: The already in use points.
     */
    func loadData(allPoints: [PointOfInterest], usedPoints: [PointOfInterest]) {
        
        cellsData.removeAll()
        
        for point in allPoints {
            let newCell = FilterCellData(point: point,
                                         title: point.name,
                                         enabled: usedPoints.contains(point))
            
            cellsData.append(newCell)
        }
        
    }
    
    /**
        Unselects all items in the table.
     */
    func unselectAll () {
        
        for cell in cellsData {
            cell.enabled = false
        }
        
        tableView.reloadData()
        
    }
    
    /**
        Retrieves the selected items.
        - Returns: The selected points.
    */
    func getSelectedItems () -> [PointOfInterest] {
        
        return Array(selectedItems)
        
    }
    
    /**
        Determines whether the cell can be enabled or not.
        - Parameters:
            - cell: The cell on which to decide.
        - Returns: True if can be enabled, false otherwise.
    */
    func canBeEnabled(_ cell: FilterTableViewCell) -> Bool {
      return !excedeedMax ||
        selectedItems.contains(cell.cellData.point)
    }
    
    // MARK: Switch delegate implementation
    func onSwitchChange(cell: FilterTableViewCell) {
                
        if (cell.cellData.enabled) {
            selectedItems.insert(cell.cellData.point)
        } else {
            selectedItems.remove(cell.cellData.point)
        }
        
        if (excedeedMax) {
            for cell in tableView.visibleCells as! [FilterTableViewCell] {
                cell.switch.isEnabled = cell.switch.isOn
            }
        } else {
            for cell in tableView.visibleCells as! [FilterTableViewCell] {
                cell.switch.isEnabled = true
            }
        }
        
        delegate?.onSelectedCountChange(selectedItems.count)
        
    }

}

/**
 Delegate for selectable table.
 */
protocol SelectableTableViewDelegate {
    
    /**
        Called whenever the selected count changed.
        - Parameters:
            - itemCount: The current number of items selecteds.
    */
    func onSelectedCountChange (_ itemCount: Int)
    
}
