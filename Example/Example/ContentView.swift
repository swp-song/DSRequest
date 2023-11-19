//
//  ContentView.swift
//  Example
//
//  Created by Dream on 2023/11/20.
//

import SwiftUI

import DSRequest
import Combine

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button("Get") {
                 
                let token = AnyCancellable.Token()
                DSRequest.default.ds
                    .get(url: "https://api.vvhan.com/api/love", parameters: ["type":"json"])
                    .sink { complete in
                        if case .failure(let error) = complete {
                            print(error.localizedDescription)
                        }
                        token.unseal()
                    } receiveValue: { data in
                        print(String(data: data, encoding: .utf8)!)
                    }
                    .seal(in: token)

            }
            
            Button("Post") {
                print("POST")
            }
        }
        .padding()
        .font(.title)
        #if os(macOS)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #endif
        
    }
}

#Preview {
    ContentView()
}
