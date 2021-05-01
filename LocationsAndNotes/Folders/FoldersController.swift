//
//  FoldersController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 25.04.21.
//

import UIKit

class FoldersController: UIViewController {
    
    // MARK: - Properties
    
    var tableView = UITableView()
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView()
        LocationManager.sharedInstance.requestAutorization()
    }
    
    // MARK: - UI
    
    private func addTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableView.rowHeight = 72.0
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 12.0, bottom: 0.0, right: 0.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FolderTableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        self.view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add".localize(), style: .plain, target: self, action: #selector(addFolder))
        
    }
    
    // MARK: - Functions
    
    @objc func addFolder() {
        let alertController = UIAlertController(title: "Create new folder".localize(), message: "", preferredStyle: .alert)
        alertController.addTextField { (text) in
            text.placeholder = "Folder name".localize()
        }
        
        let alertActionAdd = UIAlertAction(title: "Create".localize(), style: .default) { (alert) in
            guard let folderName = alertController.textFields?[0].text else { return }
            if !folderName.isEmpty {
                _ = Folder.newFolder(name: folderName)
                CoreDataManager.sharedInstance.saveContext()
                self.tableView.reloadData()
            }
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel".localize(), style: .default, handler: nil)
        
        alertController.addAction(alertActionAdd)
        alertController.addAction(alertActionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension FoldersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? FolderTableViewCell else {
            return dequeuedCell
        }
        let folder = folders[indexPath.row]
        cell.imagePhoto.image = UIImage(named: "folder")
        cell.titleLabel.text = folder.name?.uppercased()
        cell.subtitleLabel.text = "\(folder.notes?.count ?? 0)" + " notes inside".localize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let folder = folders[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(folder)
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folder = folders[indexPath.row]
        let folderViewController = FolderController()
        folderViewController.folder = folder
        navigationController?.pushViewController(folderViewController, animated: true)
    }
    
}
