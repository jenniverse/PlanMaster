//
//  PlansTableViewController.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/18/22.
//  jkim4020@usc.edu

import UIKit

class PlansTableViewController: UITableViewController {
    private var tablePlans = PlansModel.shared

    @IBOutlet var myTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.myTableView.dataSource = self
        self.myTableView.delegate = self
        // register custom table view cells
        self.registerTableViewCells()

        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    private func registerTableViewCells() {
        // change the height of custom cells
        self.myTableView.rowHeight = UITableView.automaticDimension
        let planCell = UINib(nibName: "PlansTableViewCell", bundle: nil)
        self.myTableView.register(planCell, forCellReuseIdentifier: "PlansTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // set the number of rows in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tablePlans.numberOfPlans()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row: \(indexPath.row)")
        self.tablePlans.selectedIndex = indexPath.row
        // when the cell is tapped, open another view controller
        self.performSegue(withIdentifier: "CellDidTapped", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create the cell
        let cell = self.myTableView.dequeueReusableCell(withIdentifier: "PlansTableViewCell", for: indexPath) as! PlansTableViewCell
        // modify the cell
        let thisplan = self.tablePlans.plan(at: indexPath.row)
        cell.iconLabel?.text = thisplan?.getIcon()
        cell.titleLabel?.text = thisplan?.getTitle()
        cell.withLabel?.text = thisplan?.getWith()
        // change Date data to String
        // localize text
        cell.dateLabel?.text = DateFormatter.localizedString(from: (thisplan?.getDate())!, dateStyle: .medium, timeStyle: .none)
        // rounded corner
        cell.iconLabel?.layer.masksToBounds = true
        cell.iconLabel?.layer.cornerRadius = 30

        return cell
    }

    // change the height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.tablePlans.removePlan(at: indexPath.row)
            self.myTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        self.tablePlans.rearrangePlans(from: fromIndexPath.row, to: to.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? NewPlanViewController {
            vc.onNewPlanAdded = {
                self.tableView.reloadData()
            }
        }
    }
}
