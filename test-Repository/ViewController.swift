//
//  ViewController.swift
//  test-Repository
//
//  Created by Maks Valeev on 26.10.2024.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    // MARK: UI elements settings
    
    let activitiIndicator = UIActivityIndicatorView()
    
    lazy var userInputViewField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "тут пользовательствий текст"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var urlSessionButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.backgroundColor = .blue
        button.setTitle("URLSession", for: .normal)
        button.addTarget(self, action: #selector(actionButtonUrlSession), for: .touchUpInside)
        return button
    }()
    
    lazy var alomofireButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.tintColor = .white
        button.backgroundColor = .blue
        button.setTitle("Alomofire", for: .normal)
        button.addTarget(self, action: #selector(actionAlamafire), for: .touchUpInside)
        return button
    }()
    
    lazy var resultTextView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.text = "тут результат"
        textView.layer.borderWidth = 1
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        resultTextView.addSubview(activitiIndicator)
        view.addSubview(userInputViewField)
        view.addSubview(urlSessionButton)
        view.addSubview(alomofireButton)
        view.addSubview(resultTextView)
        setConstraints()
    }
    
    // MARK: Setting View Function
    
    func setConstraints() {
        activitiIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(resultTextView)
        }
        userInputViewField.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(50)
        }
        urlSessionButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.top.equalTo(userInputViewField.snp.bottom).offset(30)
            make.leading.equalTo(view.snp.leading).inset(50)
        }
        alomofireButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(40)
            make.top.equalTo(userInputViewField.snp.bottom).offset(30)
            make.trailing.equalTo(view.snp.trailing).inset(50)
        }
        resultTextView.snp.makeConstraints { make in
            make.top.equalTo(urlSessionButton.snp.bottom).offset(50)
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    @objc func actionButtonUrlSession() {
        resultTextView.text = ""
        activitiIndicator.startAnimating()
        getNetworkData(is: userInputViewField.text ?? "")
    }
    
    @objc func actionAlamafire() {
        resultTextView.text = ""
        activitiIndicator.startAnimating()
        alomofireGetNetwork(is: userInputViewField.text ?? "")
    }
}

    // MARK: Network

extension ViewController {
    func getNetworkData(is filmName: String) {
        let queue = DispatchQueue.global()
        queue.async {
            sleep(5)
        print ("ressed button")
        let url = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(filmName)")
        guard let url = url else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-API-KEY": "2305503a-691d-448f-bc66-5ab5fd23ffff"]
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let convertedString = String(data: data, encoding: .utf8)
            DispatchQueue.main.async {
                self.activitiIndicator.stopAnimating()
                self.resultTextView.text = convertedString
            }
        }
        task.resume()
        }
    }
    
    func alomofireGetNetwork(is filmName: String) {
        print ("ressed button")
        let queue = DispatchQueue.global()
        queue.async {
            sleep(3)
            AF.request("https://kinopoiskapiunofficial.tech/api/v2.1/films/search-by-keyword?keyword=\(filmName)",
                       method: .get,
                       headers: ["X-API-KEY": "2305503a-691d-448f-bc66-5ab5fd23ffff"]).response { response in
                guard let data = response.data else { return }
                let convertedString = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    self.activitiIndicator.stopAnimating()
                    self.resultTextView.text = convertedString
                }
            }
        }
    }
}

