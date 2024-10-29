//
//  ViewController.swift
//  test-Repository
//
//  Created by Maks Valeev on 26.10.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var activitiIndicator = UIActivityIndicatorView(style: .large)
    
    var service = Service()
    
    var images: [Data] = []
    
    var funcFunc: ((Data?, (any Error)?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        activitiIndicator.startAnimating()
        stackView.addArrangedSubview(activitiIndicator)
        view.backgroundColor = .white
        setConstraints()
        addImages()
    }
    
    func setConstraints() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.height.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.centerX.centerY.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
    }
    
    
    func addImages() {
        let dispatchGroup = DispatchGroup()
                for _ in 0...4 {
                    dispatchGroup.enter()
                self.service.getImageURL { url, error in
                    guard let urlString = url else { return }
                    self.resultData(url: URL(string: urlString)!,
                                    globalQueue: DispatchQueue.global(),
                                    mainQueue: DispatchQueue.main) { data, error in
                    guard let data = data else { return }
                    self.images.append(data)
                        dispatchGroup.leave()
                    }
                }
            }
        
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            activitiIndicator.stopAnimating()
            self.stackView.removeArrangedSubview(activitiIndicator)
            for i in 0..<images.count {
                let imageView = UIImageView(image: UIImage(data: images[i]))
                imageView.contentMode = .scaleAspectFit
                stackView.addArrangedSubview(imageView)
                }
            }
        }
    }

extension ViewController {
    func resultData(
        url: URL,
        globalQueue: DispatchQueue,
        mainQueue: DispatchQueue,
        result: @escaping (Data?, Error?) -> ()) {
            globalQueue.async {
                do {
                    let data = try Data(contentsOf: url)
                    mainQueue.async {
                        result(data, nil)
                    }
                } catch let error {
                    mainQueue.async {
                        result(nil, error)
                    }
                }
            }
    }
}

