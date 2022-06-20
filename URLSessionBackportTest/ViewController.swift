//
//  ViewController.swift
//  URLSessionBackportTest
//
//  Created by Alexander Weiß on 20.06.22.
//

import UIKit
import URLSessionBackport

class ViewController: UIViewController {

    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction { _ in self.loadImage() })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load image", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
            
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.contentMode = .scaleAspectFill
        
        return uiImageView
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(actionButton)
        
        NSLayoutConstraint.activate([
            
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            containerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }


}



extension ViewController {
    private func loadImage() {
        Task {
            do {
                let urlSession = URLSession.backport(configuration: .default)
                
                let request = URLRequest(url: URL(string: "https://images.unsplash.com/photo-1648644351235-1b9df31fa9d0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3387&q=100")!)
                let (asyncBytes, response) = try await urlSession.backport.bytes(for: request)
                
                var data = Data()
                data.reserveCapacity(Int(response.expectedContentLength))
                
                for try await byte in asyncBytes {
                    data.append(byte)
                }
                
                let image = UIImage(data: data)
                self.imageView.image = image
                
            } catch {
                print(error)
            }
        }
    }
}
