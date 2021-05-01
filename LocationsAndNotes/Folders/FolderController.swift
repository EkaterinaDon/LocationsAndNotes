//
//  FolderController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 26.04.21.
//

import UIKit

class FolderController: UIViewController {
    
    // MARK: - Properties
    
    var tableView = UITableView()
    var folder: Folder?
    var selectedNote: Note?
    var notesActual: [Note] {
        if let folder = folder {
            return folder.notesSorted
        } else {
            return notes
        }
    }
    
    var buyingForm = BuyingForm()
    
    private struct Constants {
        static let reuseIdentifier = "reuseId"
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let folder = folder {
            navigationItem.title = folder.name
        } else {
            navigationItem.title = "All notes".localize()
        }
        addTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add".localize(), style: .plain, target: self, action: #selector(addNote))
        
    }
    
    // MARK: - Functions
    
    @objc func addNote() {
        if buyingForm.isNeedToShow {
            buyingForm.showForm(inController: self)
            return
        }
        selectedNote = Note.newNote(name: "New Name".localize(), inFolder: folder)
        selectedNote?.addCurrentLocation()
        let noteController = NoteController()
        noteController.note = selectedNote
        navigationController?.pushViewController(noteController, animated: true)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension FolderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesActual.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        guard let cell = dequeuedCell as? FolderTableViewCell else {
            return dequeuedCell
        }
        let noteForCell = notesActual[indexPath.row]
        cell.titleLabel.text = noteForCell.name
        cell.subtitleLabel.text = noteForCell.dateUpdateString
        if noteForCell.imageSmall != nil {
            cell.imagePhoto.image = UIImage(data: noteForCell.imageSmall!)
        } else {
            cell.imagePhoto.image = UIImage(named: "note")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteForCell = notesActual[indexPath.row]
        let noteController = NoteController()
        noteController.note = noteForCell
        navigationController?.pushViewController(noteController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteForCell = notesActual[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(noteForCell)
            CoreDataManager.sharedInstance.saveContext()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
