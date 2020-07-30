//
//  ChatInputContainerView.swift
//  Pet Records
//
//  Created by Aaron Fulwider on 4/18/20.
//  Copyright © 2020 Aaron Fulwider. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    weak var sendMessageController:SendMessagesViewController? {
        didSet {
            sendButton.addTarget(sendMessageController, action: #selector(SendMessagesViewController.handleSend), for: .touchUpInside)
            uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: sendMessageController, action: #selector(SendMessagesViewController.handleUploadTap)))
        }
    }
    
    let sendButton = UIButton(type: .system)
    let separatorLineView = UIView()
    let uploadImageView = UIImageView()
    lazy var inputTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(uploadImageView)
        addSubview(sendButton)
        addSubview(inputTextField)
        addSubview(separatorLineView)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.isUserInteractionEnabled = true
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        sendButton.setTitle("Send", for: .normal)
        
        inputTextField.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        inputTextField.placeholder = "Enter message..."
        inputTextField.delegate = self
        
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLineView.backgroundColor = .cyan
        backgroundColor = .white
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
