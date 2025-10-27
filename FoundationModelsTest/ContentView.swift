//
//  ContentView.swift
//  FoundationModelsTest
//
//  Created by Enzo Henrique Botelho Romão on 27/10/25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    
    @State private var question = ""
    @State private var reply = ""
    @State private var isLoading = false
    
    private let session = LanguageModelSession(
        instructions: """
        Você é um assistente que entende e responde apenas em português do Brasil. \
        Mesmo que a pergunta venha em outro idioma, responda em português brasileiro com clareza, naturalidade e cordialidade.
        """
    )
    
    var body: some View {
        VStack(spacing: 36) {
            VStack(spacing: 24) {
                Text("LLM On-Device")
                    .font(.headline)
                
                TextField("Digite a pergunta", text: $question)
                    .padding(12)
                    .background(.gray.opacity(0.3))
                    .cornerRadius(12)
                
                Button("Enviar") {
                    Task {
                        isLoading = true
                        reply = ""
                        do {
                            let response = try await session.respond(to: question)
                            reply = response.content
                        } catch {
                            print(error.localizedDescription)
                        }
                        question = ""
                        isLoading = false
                    }
                }
                .disabled(isLoading)
                .buttonStyle(.borderedProminent)
                
                if isLoading {
                    ProgressView()
                }
            }
            
            Text(reply)
            
            Spacer()
        }
        .padding(24)
    }
}

#Preview {
    ContentView()
}
