//
//  NoteController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 26.04.21.
//

import UIKit

class NoteController: UIViewController {
    
    // MARK: - Properties
    
    var note: Note?
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    private var noteView: NoteView {
        return self.view as! NoteView
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNote()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let folder = note?.folder {
            noteView.folderNameLabel.text = folder.name
        } else {
            noteView.folderNameLabel.text = "-"
        }
    }
    
    override func loadView() {
        self.view = NoteView()
    }
    
    // MARK: - UI
    
    func configureNote() {
        noteView.textName.text = note?.name
        noteView.imageView.image = note?.imageActual
        noteView.textDiscription.text = note?.textDescription
        noteView.folderNameLabel.text = "Folder".localize()
        navigationItem.title = note?.name
        
        if note?.imageActual != nil {
            noteView.defoultImageView.image = nil
        } else {
            noteView.defoultImageView.image = UIImage(named: "note")
        }
              
        noteView.imageViewButton.addTarget(self, action: #selector(imageButtonDidTap(sender:)), for: .touchUpInside)
        noteView.selectFolderButton.addTarget(self, action: #selector(selectFolderButtonDidTap(sender:)), for: .touchUpInside)
        noteView.locationButton.addTarget(self, action: #selector(locationButtonDidTap(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done".localize(), style: .plain, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share".localize(), style: .plain, target: self, action: #selector(shareNote))
    }
    
    // MARK: - Functions
    
    @objc func saveNote() {
        guard let note = note else { return }
        if noteView.textName.text == "" && noteView.textDiscription.text == "" && noteView.imageView.image == nil {
            CoreDataManager.sharedInstance.managedObjectContext.delete(note)
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        
        if note.name != noteView.textName.text || note.textDescription != noteView.textDiscription.text {
            note.dateUpdate = Date()
        }
        note.name = noteView.textName.text
        note.textDescription = noteView.textDiscription.text
        note.imageActual = noteView.imageView.image
        CoreDataManager.sharedInstance.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func shareNote() {
        var activities: [Any] = []
        if let pictureForShare = note?.imageActual {
            activities.append(pictureForShare)
        }
        if let nameForShare = note?.name {
            activities.append(nameForShare)
        }
        if let descriptionForShare = note?.description {
            activities.append(descriptionForShare)
        }
        
        let activityController = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @objc func imageButtonDidTap(sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let a1Camera = UIAlertAction(title: "Make a photo".localize(), style: .default) { [self] (alert) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(a1Camera)
        
        let a2Photo = UIAlertAction(title: "Select from library".localize(), style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(a2Photo)
        
        if noteView.imageView.image != nil {
            let a3Delete = UIAlertAction(title: "Delete".localize(), style: .destructive) { (alert) in
                self.noteView.imageView.image = nil
            }
            alertController.addAction(a3Delete)
        }
        
        let a4Cancel = UIAlertAction(title: "Cancel".localize(), style: .cancel) { (alert) in
        }
        alertController.addAction(a4Cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func selectFolderButtonDidTap(sender: UIButton) {
        let selectFolderViewController = SelectFolderViewController()
        selectFolderViewController.note = note
        selectFolderViewController.navigationItem.title = note?.name
        navigationController?.pushViewController(selectFolderViewController, animated: true)
    }
    
    @objc func locationButtonDidTap(sender: UIButton) {
        let noteMapViewController = NoteMapViewController()
        noteMapViewController.note = note
        navigationController?.pushViewController(noteMapViewController, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension NoteController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        noteView.imageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
