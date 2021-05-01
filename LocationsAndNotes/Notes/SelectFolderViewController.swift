//
//  SelectFolderViewController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 27.04.21.
//

import UIKit

class SelectFolderViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView = UITableView()
    var note: Note?
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
    }
    
    // MARK: - UI
    
    private func addTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .insetGrouped)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.rowHeight = 72.0
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0)
                
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FolderTableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.view.addSubview(tableView)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension SelectFolderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folders.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? FolderTableViewCell else {
            return dequeuedCell
        }
        if indexPath.row == 0 {
            cell.subtitleLabel.text = "-"
            if note?.folder == nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let folder = folders[indexPath.row-1]
            cell.titleLabel.text = folder.name?.uppercased()
            cell.subtitleLabel.text = "\(folder.notes?.count ?? 0)" + " notes inside".localize()
            if folder == note?.folder {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            note?.folder = nil
        } else {
            let folder = folders[indexPath.row-1]
            note?.folder = folder
        }
        tableView.reloadData()
    }
    
}
