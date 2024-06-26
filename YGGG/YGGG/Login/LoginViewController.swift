//
//  LoginViewController.swift
//  YGGG
//
//  Created by uunwon on 6/4/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn



class LoginViewController: UIViewController {

    let logoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .yggg_app_primary
        
        let logoImage = NSTextAttachment()
        logoImage.image = UIImage(named: "AppIcon")
        logoImage.bounds = CGRect(x: 0, y: -3, width: 20, height: 20)
        
        let attributedString = NSMutableAttributedString(attachment: logoImage)
        let logoText = NSMutableAttributedString(string: "  연지곤지")
        attributedString.append(logoText)
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let loginPageControl: UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .yggg_orange2
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    lazy var googleLoginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        
        let button = UIButton()
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        var titleContainer = AttributeContainer() // Button Custom
        titleContainer.font = UIFont.systemFont(ofSize: 16, weight: .light)
        config.attributedTitle = AttributedString("Google로 시작하기", attributes: titleContainer)
        config.baseForegroundColor = .black
        
        button.configuration = config
        
        button.layer.masksToBounds = true // button rounding
        button.layer.cornerRadius = 6
        
        let leftImage = UIImage(named: "Google Logo")
        let rightImage = UIImage(systemName: "arrow.right")
        button.setImages(leftImage: leftImage, rightImage: rightImage, for: .normal)
        
        let action = UIAction { [weak self] _ in
            self?.handleSignInButton()
        }

        button.addAction(action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var logoLabelConstraints: [NSLayoutConstraint] = {
        let safeArea = view.safeAreaLayoutGuide
        return [
            logoLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            logoLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30)
        ]
    }()
    
    private lazy var loginPageControlConstraints: [NSLayoutConstraint] = {
       return [
            loginPageControl.bottomAnchor.constraint(equalTo: googleLoginButton.topAnchor, constant: -110),
            loginPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
       ]
    }()
    
    private lazy var googleLoginButtonConstraints: [NSLayoutConstraint] = {
        return [
            googleLoginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 53),
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(logoLabel)
        view.addSubview(loginPageControl)
        view.addSubview(googleLoginButton)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateLayout()
        setLoginPageViewController()
    }
    
    // MARK: - Methods
    func updateLayout() {
        NSLayoutConstraint.activate(logoLabelConstraints + loginPageControlConstraints + googleLoginButtonConstraints)
    }
    
    // 로그인 성공 시 메인 화면으로 전환
    func moveToMain() {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
        sceneDelegate.moveToMain()
    }
    
    func handleSignInButton() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration Object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the Sign In Flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                print("Press the cancel Button")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                guard let user = result?.user else { return }
       
                let userRef = RED_USERS.document(user.uid)
                userRef.getDocument { document, error in
                    if let document = document, document.exists {
                        self.moveToMain()
                    } else {
                        // Document does not exist, user is signing up
                        let data: [String: Any] = ["email": user.email as Any,
                                                   "uid": user.uid,
                                                   "snsRoot": "google",
                                                   "userName": user.displayName as Any,
                                                   "userImage": user.photoURL?.absoluteString ?? "",
                                                   "userHashTag": "",
                                                   "userCosmetics": [],
                                                   "bookmarkList": []]
                        
                        userRef.setData(data) { error in
                            if let error = error {
                                print("Error adding document: \(error)")
                            } else {
                                self.moveToMain()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func setLoginPageViewController() {
        let pageViewController = loginPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(pageViewController.view)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 30),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: loginPageControl.topAnchor, constant: -20)
        ])
        
        pageViewController.pageControl = loginPageControl
    }
}
