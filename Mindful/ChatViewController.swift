import UIKit
import OpenAIKit
import Alamofire
import SwiftyJSON

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var openAI: OpenAIKit?
    private var AlamofireManager: Session? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20000
        let alamofireManager = Session(configuration: configuration)
        return alamofireManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.titleView = assistantLabel
        messageInputField.delegate = self
        layoutViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "...",
            style: .plain,
            target: self,
            action: #selector(presentCustomViewController)
        )
        
        
        // Initialize OpenAI
        let apiToken = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
        if let filePath = Bundle.main.path(forResource: "MyCert", ofType: "cer") {
            openAI = OpenAIKit(apiToken: apiToken!, organization: nil, customOpenAIURL: "https://openai.ianchen.io/v1", sslCerificatePath: filePath)
        } else {
            print("Certificate file not found.")
        }
    }
    
    private let assistantLabel: UILabel = {
        let label = UILabel()
        label.text = "Mindful"
//        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont(name: "DINAlternate-Bold", size: 20.0)
        label.sizeToFit()
        return label
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "292929")
        view.layer.cornerRadius = 36
        return view
    }()
    
    let linkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "link"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    let messageInputField: UITextField = {
        let textField = UITextField()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.lightGray
        ]
        textField.placeholder = "Write your message here"
        textField.attributedPlaceholder = NSAttributedString(string: "Write your message here", attributes: attributes)
        textField.textColor = UIColor.white
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.black
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height)) // Left padding
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 20
        textField.clipsToBounds = true
        textField.returnKeyType = .send
        return textField
    }()
    
    // Voice button on the right
    let voiceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "mic"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private var messages: [ChatMessage] = []
    
    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatBubbleCell.self, forCellReuseIdentifier: "chatBubbleCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    @objc private func presentCustomViewController() {
        let customVC = CustomViewController()
        navigationController?.pushViewController(customVC, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        messageInputField.resignFirstResponder()
    }
    
    private func layoutViews() {
        // Add subviews
        view.addSubview(assistantLabel)
        view.addSubview(chatTableView)
        view.addSubview(bottomContainerView)
        view.addSubview(linkButton)
        view.addSubview(messageInputField)
        view.addSubview(voiceButton)
        
        // Disable autoresizing masks
        assistantLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        linkButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        voiceButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for the chatTableView
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -30)
        ])
        
        // Constraints for the bottomContainerView
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 100),
        ])
         
        // Add constraints for linkButton
        NSLayoutConstraint.activate([
            linkButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            linkButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            linkButton.widthAnchor.constraint(equalToConstant: 70),
            linkButton.heightAnchor.constraint(equalToConstant: 70),
        ])
         
        // Add constraints for messageInputField
        NSLayoutConstraint.activate([
            messageInputField.leadingAnchor.constraint(equalTo: linkButton.trailingAnchor, constant: 2),
            messageInputField.trailingAnchor.constraint(equalTo: voiceButton.leadingAnchor, constant: -2),
            messageInputField.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            messageInputField.heightAnchor.constraint(equalToConstant: 40),
        ])
         
         // Constraints for the voiceButton
        NSLayoutConstraint.activate([
            voiceButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            voiceButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            voiceButton.widthAnchor.constraint(equalToConstant: 80),
            voiceButton.heightAnchor.constraint(equalToConstant: 80),
        ])
    }
    
    @objc private func sendMessage() {
        if let text = messageInputField.text, !text.isEmpty {
            let newMessage = ChatMessage(text: text, isIncoming: false)
            messages.append(newMessage)
//            let autoReplyMessage = ChatMessage(text: "Hi", isIncoming: true)
//            messages.append(autoReplyMessage)
            messageInputField.text = ""
            chatTableView.reloadData()
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            generateResponse(for: text)
        }
    }
    
    private func generateResponse(for text: String) {
//        guard let openAI = openAI else {
//            print("OpenAI is not initialized.")
//            return
//        }
        
        let url = "https://openai.ianchen.io/v1/chat/completions"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer uRQUfY06pO60wEOzgUhkJMHOjTcU5Qii7gLKM1WEiJo",
            "Content-Type": "application/json"
        ]
        
        // Convert ChatMessage array to the format expected by the API
        var messagesToSend = messages.map { message -> [String: String] in
            return ["role": message.isIncoming ? "user" : "assistant", "content": message.text]
        }
        
        messagesToSend.append(["role": "system", "content": """
                    # Your Profile

                    You are Mindful, an AI assistant specialized in helping users manage and plan their daily tasks. Your role involves clarifying questions at appropriate moments, breaking down and planning tasks, and aiding users in time management.

                    ---

                    ## Workflow for Planning

                    0. Introduce Yourself
                    You are Mindful. Your purpose is to assist users in navigating their daily schedules and tasks with ease and efficiency.

                    1. Defining the Core Problem
                    1.1 Upon receiving information from the user, ask a few critical questions related to time management and planning to define a well-rounded problem. For example, inquire about the time remaining until a deadline (DDL) or the user's level of engagement.
                    1.2 Remind the user that if they choose not to answer any of the questions, you will either make assumptions or set a broad, general scenario by default. Wait for the user's response.

                    2. Problem Definition and Decomposition
                    2.1 Based on the information received, identify and clearly define the core problem.
                    2.1.1 Describe the core problem using "background" and the "OKR tool". The OKR should include one Objective and at least three Key Results.
                    2.1.2 Measure the total time required to address the problem using time as a scale.

                    2.2 Break down the original problem into several smaller, more manageable independent sub-problems.
                    - While breaking down the problem, assess the workload of each sub-problem using time as a scale.
                    - You are supposed to use the Eisenhower Matrix to prioritize sub-problems based on their importance and urgency.
                    - The layout should be elegant, making it immediately clear how time is allocated.

                    Let's think step by step.
                    In your upcoming interactions, users will communicate with you, potentially presenting tasks for you to plan. Regardless of what users ask you to do next, they are seeking your assistance in managing and planning daily tasks. Please strictly follow the **Workflow for Planning**, starting with Step 0: **Introduce Yourself**.
                """])

        // Append the new message as a user role
        messagesToSend.append(["role": "user", "content": text])


//        let messages: [[String: String]] = [
//                ["role": "user", "content": text]
//            ]
        print(messages)
        let parameters: [String: Any] = [
//            "prompt": "User: \(text)\nAssistant:",
            "max_tokens": 2048,
            "model": "gpt-3.5-turbo",
            "messages": messagesToSend
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("success")
                let json = JSON(value)
                print(json)
                if let generatedText = json["choices"][0]["message"]["content"].string?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    print("Generated text: \(generatedText)")
                    DispatchQueue.main.async {
                        let assistantMessage = ChatMessage(text: generatedText, isIncoming: true)
                        self.messages.append(assistantMessage)
                        self.chatTableView.reloadData()
                        let indexPath = IndexPath(row: (self.messages.count ?? 0) - 1, section: 0)
                        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatBubbleCell", for: indexPath) as! ChatBubbleCell
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        dismissKeyboard()
        return true
    }

}

struct ChatMessage {
    let text: String
    let isIncoming: Bool // Determine if the message is incoming or outgoing
}

class ChatBubbleCell: UITableViewCell {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor(red: 0.12, green: 0.55, blue: 0.84, alpha: 1)
        return view
    }()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.text
        
        if message.isIncoming {
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
            bubbleBackgroundView.backgroundColor = UIColor.orange
        } else {
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
            bubbleBackgroundView.backgroundColor = UIColor.darkGray
        }
    }
}
