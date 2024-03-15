//
//  BottomSheetViewController.swift
//  TestTask
//
//  Created by Artyom Tabachenko on 14.03.2024.
//

import Foundation
import UIKit

class BottomSheetViewController: UIViewController {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "markerImage") //HardCode
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Илья" //HardCode
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var gpsLabel: UILabel = {
        let label = UILabel()
        label.text = "GPS" //HardCode
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "02.07.17" //HardCode
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "14:00" //HardCode
        return label
    }()
    
    private lazy var statusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var historyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Посмотреть историю", for: .normal) //HardCode
        button.layer.cornerRadius = 20
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constants.ConstraintsConstants.imageViewTopAnchor
            ),
            imageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.ConstraintsConstants.imageViewLeadingAnchor
            ),
            imageView.heightAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.imageViewHeight
            ),
            imageView.widthAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.imageViewWidth
            ),
        ])
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constants.ConstraintsConstants.nameLabelTopAbchor
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: Constants.ConstraintsConstants.nameLabelLeadingAnchor
            )
        ])
        
        view.addSubview(statusStackView)
        statusStackView.addArrangedSubview(gpsLabel)
        statusStackView.addArrangedSubview(dateLabel)
        statusStackView.addArrangedSubview(timeLabel)
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: Constants.ConstraintsConstants.bottomSheetStackViewTopAnchor
            ),
            statusStackView.leadingAnchor.constraint(
                equalTo: imageView.trailingAnchor,
                constant: Constants.ConstraintsConstants.bottomSheetStackViewLeadingAnchor
            ),
        ])
        
        view.addSubview(historyButton)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            historyButton.topAnchor.constraint(
                equalTo: statusStackView.bottomAnchor,
                constant: Constants.ConstraintsConstants.historyButtonTopAnchor
            ),
            historyButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.ConstraintsConstants.historyButtonLeadingAnchor
            ),
            historyButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: Constants.ConstraintsConstants.historyButtonTrailingAnchor
            ),
            historyButton.heightAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.historyButtonHeight
            )
        ])
    }
}
