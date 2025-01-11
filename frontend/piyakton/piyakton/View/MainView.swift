//
//  MainView.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @State private var isAddTaskModalPresented = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    // edit action
                } label: {
                    Text("편집")
                        .font(.body1Medium)
                        .foregroundStyle(Color.whiteOpacity700)
                        .padding(.vertical, 4)
                }
                
                Spacer()
                
                Button {
                    isAddTaskModalPresented = true
                } label: {
                    Image("plus-lime")
                        .resizable()
                        .frame(width: 28, height: 28)
                }
            }
            .padding(.horizontal, 24)
            .frame(height: 44)
            
            Image("logo-text-short")
                .padding(24)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.todoGroupList, id: \.id) {
                        TaskCardView(todoGroup: $0)
                    }
                }
            }
        }
        .sheet(isPresented: $isAddTaskModalPresented) {
            AddTaskModalView(isPresented: $isAddTaskModalPresented)
                .presentationDetents([.height(1000)])
                .presentationDragIndicator(.visible)
        }
        .background(Color.darkBackground.ignoresSafeArea(.all))
    }
}

extension DIContainer {
    static var preview: DIContainer {
        DIContainer(/* add your dependencies here */)
    }
}

#Preview {
    MainView(viewModel: MainViewModel(container: .preview))
}