import UIKit

class CustomViewController: UIViewController {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let aboutMeLabel: UILabel = {
        let label = UILabel()
        label.text = "About me"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor.white
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What would you like the assistant to know about you?"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    let aboutMeTextField: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(hex: "292929")
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .white
        textView.layer.cornerRadius = 15
        textView.clipsToBounds = true
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(profileImageView)
        view.addSubview(userNameLabel)
        view.addSubview(aboutMeLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(aboutMeTextField)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            aboutMeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 50),
            aboutMeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            aboutMeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            aboutMeTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            aboutMeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            aboutMeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            aboutMeTextField.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

// Color extension
extension UIColor {
    convenience init(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexAsInt = Int(hexSanitized, radix: 16) ?? 0
        let red = CGFloat((hexAsInt >> 16) & 0xFF) / 255.0
        let green = CGFloat((hexAsInt >> 8) & 0xFF) / 255.0
        let blue = CGFloat(hexAsInt & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
