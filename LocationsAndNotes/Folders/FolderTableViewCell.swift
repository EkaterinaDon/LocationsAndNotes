//
//  FolderTableViewCell.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 26.04.21.
//

import UIKit

class FolderTableViewCell: UITableViewCell {

    // MARK: - Subviews
    
    private(set) lazy var imagePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16.0)
        return label
    }()
    
    private(set) lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    // MARK: - UI
    
    override func prepareForReuse() {
        [self.titleLabel, self.subtitleLabel].forEach { $0.text = nil }
    }
    
    private func configureUI() {
        self.addImagePhoto()
        self.addTitleLabel()
        self.addSubtitleLabel()
        
    }
    
    private func addImagePhoto() {
        self.contentView.addSubview(self.imagePhoto)
        NSLayoutConstraint.activate([
            self.imagePhoto.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imagePhoto.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 2.0),
            self.imagePhoto.heightAnchor.constraint(equalToConstant: 72.0),
            self.imagePhoto.widthAnchor.constraint(equalToConstant: 72.0)
            ])
    }
    
    private func addTitleLabel() {
        self.contentView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.imagePhoto.trailingAnchor, constant: 5.0),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40.0)
            ])
    }
    
    private func addSubtitleLabel() {
        self.contentView.addSubview(self.subtitleLabel)
        NSLayoutConstraint.activate([
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4.0),
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.imagePhoto.trailingAnchor, constant: 5.0),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -40.0)
            ])
    }
}

