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

        let point = cellsData[indexPath.row]
        
        cell.name.text = point.title
        cell.`switch`.isOn = point.enabled
        cell.delegate = self

        return cell
        
    }
    
    // MARK: Load data methods
    
    /**
        Replaces data in the data model
     */
    func loadData(allPoints: [PointOfInterest], usedPoints: [PointOfInterest]) {
        
        cellsData.removeAll()
        
        for point in allPoints {
            let newCell = FilterCellData(title: point.id,
                                         enabled: usedPoints.contains(point))
            
            cellsData.append(newCell)
        }
        
    }
    
    /**
        Selects all items in the table
    */
    func selectAll () {
        
        for cell in cellsData {
            cell.enabled = true
        }
        
        tableView.reloadData()
        
    }
    
    /**
        Unselects all items in the table
     */
    func unselectAll () {
        
        for cell in cellsData {
            cell.enabled = false
        }
        
        tableView.reloadData()
        
    }
    
    func getSelectedPointsIndexes () -> [Int] {
        
        var enabledPointsIndexes = [Int]()
        for (index,cell) in cellsData.enumerated() {
            if cell.enabled {
                enabledPointsIndexes.append(index)
            }
        }
        
        return enabledPointsIndexes
        
    }
    
    // MARK: Switch delegate implementation
    func onSwitchChange(cell: FilterTableViewCell) {
        let index = tableView.indexPath(for: cell)!.row
        cellsData[index].enabled = cell.`switch`.isOn
    }

}
