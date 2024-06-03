//
//  LoginViewController.swift
//  Mindful
//

import UIKit
//import FirebaseAuth


class LoginViewController: UIViewController {

    let logoImageView = UIImageView()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()
    let productName = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = []
        view.backgroundColor = UIColor.black
        setupViews()
    }

    private func setupViews() {
        // Set up the logo image view
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        // Set up name
        productName.text = "Mindful"
        productName.textAlignment = .center
        productName.textColor = UIColor.white
        productName.font = UIFont(name: "DINAlternate-Bold", size: 24.0)
        view.addSubview(productName)

        // Set up the email text field
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.lightGray
        ]
        
        emailTextField.placeholder = "Enter Your Email"
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes: attributes)
        emailTextField.textColor = UIColor.white
        emailTextField.font = UIFont.systemFont(ofSize: 13)
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = UIColor(hex: "292929")
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTextField.frame.height)) // Left padding
        emailTextField.leftViewMode = .always
        emailTextField.layer.cornerRadius = 20
        emailTextField.clipsToBounds = true
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        view.addSubview(emailTextField)

        // Set up the password text field
        passwordTextField.placeholder = "Enter Your Password"
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes: attributes)
        passwordTextField.textColor = UIColor.white
        passwordTextField.font = UIFont.systemFont(ofSize: 13)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = UIColor(hex: "292929")
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: emailTextField.frame.height)) // Left padding
        passwordTextField.leftViewMode = .always
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)

        // Set up the login button
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .orange
        loginButton.layer.cornerRadius = 20
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        // Add constraints
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        productName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            
            productName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productName.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            productName.heightAnchor.constraint(equalToConstant: 30),
            productName.widthAnchor.constraint(equalToConstant: 80),

            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 100),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 60),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func loginButtonTapped() {
        // Handle login button tap
        let chatVC = ChatViewController()
        let navigationController = UINavigationController(rootViewController: chatVC)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true)
    }
//    @objc private func loginButtonTapped() {
//        let email = emailTextField.text ?? ""
//        let password = passwordTextField.text ?? ""

        // Firebase登录逻辑
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//            if let error = error {
//                print("Login error: \(error.localizedDescription)")
//                // 可以在这里更新UI，提示用户登录错误
//                return
//            }
//            // 登录成功，跳转到聊天界面或其他页面
//            let chatVC = ChatViewController()
//            let navigationController = UINavigationController(rootViewController: chatVC)
//            navigationController.modalPresentationStyle = .fullScreen
//            self?.present(navigationController, animated: true)
//        }
//    }

}
