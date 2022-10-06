//
//  SpecificPlanTableViewController.swift
//  PlanMaster
//
//  Created by Jenny Kim on 4/25/22.
//  jkim4020@usc.edu

import UIKit

class DestinationCell: UITableViewCell {}
class TransportationCell: UITableViewCell {}

class SpecificPlanTableViewController: UITableViewController {
    private var thisPlan = PlansModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        navigationItem.rightBarButtonItem = .init(systemItem: .add)
        // configure the menu of the item
        // UIMenu destination
        // localize text
        let destinationTitle = NSLocalizedString("DESTINATION", comment: "Destination")
        let destinationItem = UIAction(title: destinationTitle, image: UIImage(systemName: "building.2")) { _ in
            print("destination action is tapped HEREEEEEEE")
            // if it's tapped, show DestinationViewController
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DestinationViewController") as? DestinationViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        // UIMenu transportation
        // localize text
        let transportationTitle = NSLocalizedString("TRANSPORTATION", comment: "Transportation")
        let transportationItem = UIAction(title: transportationTitle, image: UIImage(systemName: "bus")) { _ in
            // if it's tapped, show TransportationViewController
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TransportationViewController") as? TransportationViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        // set the menu
        // localize text
        let UIMenuTitle = NSLocalizedString("UIMENU_TITLE", comment: "Add a plan")
        let menu = UIMenu(title: UIMenuTitle, options: .displayInline, children: [destinationItem, transportationItem])
        navigationItem.rightBarButtonItem!.menu = menu

        // change the title of VC to name of the selected plan
        navigationItem.title = thisPlan.selectedPlan()!.getTitle()
    }

    @IBOutlet var composeButton: UIBarButtonItem!

    // when cancel is tapped, dismiss the viewcontroller
    @IBAction func cancelButtonDidTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    // set the num of sections as 2 (destination and transportation)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // set the number of rows of section 0 (destination)
        if section == 0 {
            return thisPlan.selectedPlan()!.getDestination().count
        }
        // set the number of rows of section 1 (transportation)
        else {
            return thisPlan.selectedPlan()!.getTransportation().count
        }
    }

    // set the index of selected destination
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        thisPlan.selectedDestinationIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // set the destination cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell")!
            cell.textLabel?.text = "⛳️\(thisPlan.selectedPlan()!.getDestination()[indexPath.row].place)"
            cell.detailTextLabel?.text = "⏰\(thisPlan.selectedPlan()!.getDestination()[indexPath.row].time)"
            return cell
        }
        // set the transportation cell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransportationCell")!
            var icon: String
            // change the icon depending on the chosen transportaion
            if thisPlan.selectedPlan()!.getTransportation()[indexPath.row].type == 0 {
                icon = "🚌"
            }
            else if thisPlan.selectedPlan()!.getTransportation()[indexPath.row].type == 1 {
                icon = "🚈"
            }
            else if thisPlan.selectedPlan()!.getTransportation()[indexPath.row].type == 2 {
                icon = "🚗"
            }
            else {
                icon = "🏃"
            }
            cell.textLabel?.text = "\(icon)\(thisPlan.selectedPlan()!.getTransportation()[indexPath.row].name)"
            cell.detailTextLabel?.text = "\(thisPlan.selectedPlan()!.getTransportation()[indexPath.row].from) → \(thisPlan.selectedPlan()!.getTransportation()[indexPath.row].to)"

            return cell
        }
    }

    // set the header of each section in table
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            // localize text
            let destinationTitle = NSLocalizedString("DESTINATION", comment: "Destination")
            return destinationTitle
        }
        else {
            // localize text
            let transportationTitle = NSLocalizedString("TRANSPORTATION", comment: "Transportation")
            return transportationTitle
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("trying to remove \(indexPath.row)th row in section \(indexPath.section)")
        if editingStyle == .delete {
            // Delete the row from the data source
            // if it's in section 0, remove selected destination
            if indexPath.section == 0 {
                thisPlan.removeDestination(at: indexPath.row)
            }
            // if it's in section 1, remove selected transportation
            else {
                thisPlan.removeTransportation(at: indexPath.row)
            }
            // reload data of tableView after deleting
            self.tableView.reloadData()
        }
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? DestinationViewController {
            vc.onNewDestinationAdded = {
                self.tableView.reloadData()
            }
        }
    }
}
