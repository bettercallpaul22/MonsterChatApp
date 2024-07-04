//
//  LoginViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 05/06/2024.
//

import Foundation
import FirebaseAuth
import Combine

class SignInViewModel:ObservableObject{
    private var cancellables = Set<AnyCancellable>()
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var isLoading:Bool = false
    @Published var isSuccess:Bool = false
    @Published var errorMessage:String = ""
   
    
    let combinedPublisher = Publishers.CombineLatest(
        AuthServices.instance.$isSuccess,
        AuthServices.instance.$isLoading

    )
    

    private var validateInput:Bool{
        email.isEmptyOrwithWiteSpace || password.isEmptyOrwithWiteSpace
    }
    
    
    init(){

        AuthServices.instance.cancelSuccessPublisher()
        AuthServices.instance.resetSuccess()

    }
    func resetSuccess() {
          isSuccess = false
      }
      
      func cancelSuccessPublisher() {
          print("SignView omn appear before  --> \(isSuccess)")

          DispatchQueue.main.async { [self] in
              print("cancelSuccessPublisher")
              self.cancellables.forEach { $0.cancel() }
              cancellables.removeAll()
              print("SignView omn appear after  --> \(isSuccess)")

          }

          
      }
    
    func subscription(){
        combinedPublisher
            
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccessStatus, isLoadingStatus in
                self?.isSuccess = isSuccessStatus
                self?.isLoading = isLoadingStatus
                
            }.store(in: &cancellables)
        
        AuthServices.instance.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink {[weak self] erroMsg in
                self?.errorMessage = erroMsg
            }.store(in: &cancellables)
    }
    
    func login() async throws{
        if validateInput {
            errorMessage = "please fill in all fields"
            return
        }
     subscription()
        try await AuthServices.instance.login(email: email, password: password)
        
    }
    
    
    func resendEmailVerification(email_:String) {
        if validateInput {
            errorMessage = "please fill in all fields"
            return
        }
        subscription()
       AuthServices.instance.resendEmailVerification(email_)
        
    }
    
    func resetPassword() async throws{
        if validateInput {
            errorMessage = "please fill in all fields"
            return
        }
        subscription()
        try await AuthServices.instance.resetPassword()
    }
}
