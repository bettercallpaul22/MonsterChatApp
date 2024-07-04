//
//  AuthServices.swift
//  MonsterChat
//
//  Created by Obaro Paul on 19/06/2024.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth
import Combine



class AuthServices:ObservableObject{
    static var instance = AuthServices()
    private var cancellables = Set<AnyCancellable>()
    @Published var isSuccess:Bool = false
    @Published var errorMessage:String = ""
    @Published var email:String = ""
    @Published var password:String = ""
    
    @Published var loginError:String = ""
    @Published var loginSuccess:Bool = false
    @Published var isLoading:Bool = false
    @Published var emailVerifyError:String = ""
    @Published var isLoadingResendEmailVerificationBtn = false
    @Published  var isLoadingResetPassword = false
    @Published var passwordResetMessage:String = ""
    
    
    
    
    
    
    private var validateInput:Bool{
        email.isEmptyOrwithWiteSpace || password.isEmptyOrwithWiteSpace
    }
    
    
    init(){}
    func resetSuccess() {
        self.isSuccess = false
      }
      
      func cancelSuccessPublisher() {
              self.cancellables.forEach { $0.cancel() }
              cancellables.removeAll()
                }
    
    
    func register() async throws{
    
        isLoading = true
        do{
         let response = try await Auth.auth().createUser(withEmail: email, password: password)
            try? await response.user.sendEmailVerification()
            let user = User(id: response.user.uid , email: email, username: email, pushId: "", avatarLink: "", status: "Hey i'm using monster chat")
            let _ =  FirebaseUserReference.instance.saveUser(userData: user)
            isSuccess = true
            isLoading = false

        }catch{
            errorMessage = error.localizedDescription
            print("register error:  \(error.localizedDescription)")
            isLoading = false

        }
    }
    
    
    

    func login(email:String, password:String) async throws{
        isLoading = true
        do {
       
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = authDataResult.user

            if user.isEmailVerified {
                 self.getUser(userId: user.uid)
                isLoading = false

                
            } else {
                errorMessage = "user is yet to be verified, please check your email"
                isLoading = false
                resendEmailVerification(user.email!)
            }
            
            
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print(error.localizedDescription)
        }
    }

    
    
    
    func getUser(userId:String){
        FirebaseUserReference.instance.getUsers(withIds: [userId])
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                    
                case .finished:
                   break
                case .failure(let error):
                    print("\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] user in
                if user.count == 1{
                    User.saveUserLocally(user.first!)
                }
                self?.isSuccess = true
             
            }.store(in: &cancellables)
        
    }
    
    
    
    
    
    func resendEmailVerification(_ email: String) {
        // Check if the email is empty
        if email.isEmpty {
            emailVerifyError = "Please fill in your email address"
            isLoadingResendEmailVerificationBtn = false
            return
        }
        
        isLoadingResendEmailVerificationBtn = true

        
        // Step 1: Check if there is a currently signed-in user
        guard let currentUser = Auth.auth().currentUser else {
            isLoadingResendEmailVerificationBtn = false
            
            emailVerifyError = "No user found"
            return
        }
        
        // Step 2: Reload the user's data to ensure it is up-to-date
        currentUser.reload { reloadError in
            if let reloadError = reloadError {
                // If there is an error reloading the user's data, update the error message
                print("Error reloading user data: \(reloadError.localizedDescription)")
                self.emailVerifyError = "Error reloading user data: \(reloadError.localizedDescription)"
                self.isLoadingResendEmailVerificationBtn = false
                return
            }
            
            // Step 3: Send a verification email to the user
            currentUser.sendEmailVerification { error in
                if let error = error {
                    // Handle error when sending email verification
                    print("Error sending verification email: \(error.localizedDescription)")
                    self.emailVerifyError = "Error sending verification email: \(error.localizedDescription)"
                    self.isLoadingResendEmailVerificationBtn = false
                    return
                }
                self.isLoadingResendEmailVerificationBtn = false
                // Verification email sent successfully
                print("Verification email sent successfully")
            }
        }
    }
    
    
    
    func resetPassword() async throws{
        isLoading = true
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            isLoadingResetPassword = false
            passwordResetMessage = "a reset link has been sent to your email address"
        } catch {
            isLoadingResetPassword = false
            passwordResetMessage = error.localizedDescription
            print("Failed to send password reset email: \(error.localizedDescription)")
        }
    }
    
    
}

