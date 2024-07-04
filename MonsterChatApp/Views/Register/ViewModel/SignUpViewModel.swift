//
//  RegisterViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 05/06/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

class SignUpViewModel:ObservableObject{
    @Published var email:String = ""
    @Published var password:String = ""
    @Published var isLoading:Bool = false
    @Published var isSuccess:Bool = false
    @Published var errorMessage:String = ""
    private var cancellables = Set<AnyCancellable>()

    let combinedPublisher = Publishers.CombineLatest(
        AuthServices.instance.$isLoading,
        AuthServices.instance.$isSuccess

    )
    
    
    private var validateInput:Bool{
        email.isEmptyOrwithWiteSpace || password.isEmptyOrwithWiteSpace
    }
    
    
    init(){
        AuthServices.instance.cancelSuccessPublisher()
        AuthServices.instance.resetSuccess()
    }
    
    
    func subscription(){
        combinedPublisher
            .sink { [weak self] isLoadingStatus, isSuccessStatus in
                self?.isLoading = isLoadingStatus
                self?.isSuccess = isSuccessStatus
                
            }.store(in: &cancellables)
        
        AuthServices.instance.$errorMessage
            .sink {[weak self] erroMsg in
                self?.errorMessage = erroMsg
            }.store(in: &cancellables)
    }
    

    func register() async throws{
        if validateInput {
            errorMessage = "please fill in all fields"
            return
        }
        subscription()
        try await AuthServices.instance.register()
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
