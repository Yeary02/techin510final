//
//  LoginViewControllerRepresentable.swift
//  Mindful
//
import SwiftUI

struct LoginViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LoginViewController {
        return LoginViewController()
    }

    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        // Leave this empty for now
    }
}
