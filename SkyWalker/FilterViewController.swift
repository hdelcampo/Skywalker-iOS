//
//  FilterViewController.swift
//  SkyWalker
//
//  Created by Héctor Del Campo Pando on 31/10/16.
//  Copyright © 2016 Héctor Del Campo Pando. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {
    
    //MARK: Properties
    var caller: OverlayViewController?
    var allPoints: [PointOfInterest] = []
    var usedPoints: [PointOfInterest] = []
    
    @IBOutlet weak var pointsTable: UITableView!
    
    var pointsModel = [FilterCellData]()
    
    //MARK: Functions
    override func viewDidLoad() {
        
        super.viewDidLoad()

        loadData()
        pointsTable.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "PointCell")
        pointsTable.delegate = self
        pointsTable.dataSource = self
        
    }
    
    /**
        Fetches data to the data model
    */
    private func loadData() {
        
        pointsModel.removeAll()
        
        for point in allPoints {
            let newCell = FilterCellData(title: point.id,
                                         enabled: usedPoints.contains(point))

            pointsModel.append(newCell)
        }
        
    }
    
    //MARK: Button handlers
    /**
        Cancel handler
    */
    @IBAction func cancel() {
        dismiss(animated: true, completion: {})
    }
    
    /**
        Accept handler
    */
    @IBAction func accept() {
        
        var enabledPoints = [PointOfInterest]()
        for (index,cell) in pointsModel.enumerated() {
            if cell.enabled {
                enabledPoints.append(allPoints[index])
            }
        }
        
        caller?.points = enabledPoints
        dismiss(animated: true, completion: {})
        
    }

    /**
        Select all handler
    */
    @IBAction func selectAll() {
        
        for cell in pointsModel {
            cell.enabled = true
        }
        
        pointsTable.reloadData()
        
    }
    
    /**
        Unselect all handler
    */
    @IBAction func unselectAll() {
        
        for cell in pointsModel {
            cell.enabled = false
        }
        
        pointsTable.reloadData()
    }
    
    //MARK: Table protocol functions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointCell") as! FilterCell
        
        cell.delegate = self
        cell.name.text = pointsModel[indexPath.row].title
        cell.`switch`.isOn = pointsModel[indexPath.row].enabled
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pointsModel.count
    }
    
    //MARK: Switch delegate implementation
    func onSwitchChange(cell: FilterCell) {
        let index = pointsTable.indexPath(for: cell)!.row
        pointsModel[index].enabled = cell.`switch`.isOn
    }

}
