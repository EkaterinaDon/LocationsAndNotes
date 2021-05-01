//
//  NoteView.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 26.04.21.
//

import UIKit

class NoteView: UIView {
    
    // MARK: - Properties
    
    private lazy var contentViewSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 800)
    
    // MARK: - ScrollView
    
    private(set) lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.bounces = true
        scrollView.contentSize = contentViewSize
        return scrollView
    }()

    private(set) lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame.size = contentViewSize
        contentView.isUserInteractionEnabled = true
        return contentView
    }()
    
    // MARK: - Subviews
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private(set) lazy var defoultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private(set) lazy var imageViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 30.0
        button.layer.masksToBounds = true
        button.backgroundColor = .clear
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private(set) lazy var textName: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 20.0)
        textField.placeholder = "Note name".localize()
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    private(set) lazy var textDiscription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 14.0)
        return textView
    }()
        
    private(set) lazy var locationButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.setTitle("Location".localize(), for: .normal)
        return button
    }()
    
    private(set) lazy var folderNameLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .black
        textLabel.font = UIFont.systemFont(ofSize: 20.0)
        textLabel.layer.cornerRadius = 5
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = UIColor.lightGray.cgColor
        return textLabel
    }()
    
    private(set) lazy var selectFolderButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Select folder".localize(), for: .normal)
        return button
    }()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.addSubview(self.defoultImageView)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.imageViewButton)
        self.contentView.addSubview(self.textName)
        self.contentView.addSubview(self.textDiscription)
        self.contentView.addSubview(self.locationButton)
        self.contentView.addSubview(self.folderNameLabel)
        self.contentView.addSubview(self.selectFolderButton)
        
        setupConstraintsScrollView()
        setupConstraints()
    }
    
    // MARK: - Constraints
    
    private func setupConstraintsScrollView() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.scrollView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            self.scrollView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, constant: 400.0),
            
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
        ])
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            self.defoultImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.defoultImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.defoultImageView.heightAnchor.constraint(equalToConstant: 200.0),
            self.defoultImageView.widthAnchor.constraint(equalToConstant: 200.0),
            
            self.imageView.topAnchor.constraint(equalTo: self.defoultImageView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.defoultImageView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.defoultImageView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.defoultImageView.bottomAnchor),
            
            self.imageViewButton.topAnchor.constraint(equalTo: self.imageView.topAnchor),
            self.imageViewButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor),
            self.imageViewButton.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor),
            self.imageViewButton.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            
            self.textName.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 8.0),
            self.textName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5.0),
            self.textName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0),
            
            self.textDiscription.topAnchor.constraint(equalTo: self.textName.bottomAnchor, constant: 8.0),
            self.textDiscription.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5.0),
            self.textDiscription.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0),
            self.textDiscription.heightAnchor.constraint(equalToConstant: 350.0),
            
            self.locationButton.topAnchor.constraint(equalTo: self.textDiscription.bottomAnchor, constant: 8.0),
            self.locationButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5.0),
            self.locationButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0),
            
            self.folderNameLabel.topAnchor.constraint(equalTo: self.locationButton.bottomAnchor, constant: 8.0),
            self.folderNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5.0),
            self.folderNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5.0),
            
            self.selectFolderButton.topAnchor.constraint(equalTo: self.folderNameLabel.topAnchor),
            self.selectFolderButton.trailingAnchor.constraint(equalTo: self.folderNameLabel.trailingAnchor),
            self.selectFolderButton.bottomAnchor.constraint(equalTo: self.folderNameLabel.bottomAnchor),
            self.selectFolderButton.widthAnchor.constraint(equalToConstant: 170.0)
        ])
    }
}
