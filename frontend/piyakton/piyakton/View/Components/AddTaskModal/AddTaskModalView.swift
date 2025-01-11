//
//  AddTaskModalView.swift
//  piyakton
//
//  Created by Grace Kim on 1/11/25.
//

import SwiftUI

struct AddTaskModalView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    @Binding var isPresented: Bool
    @State private var isEditing = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                if viewModel.showConfirmation {
                    
                    // 업로드가 되었다는 Confirmation message
                    VStack(spacing: 24) {
                        Text("✅")
                            .font(.system(size: 50))
                        
                        VStack(spacing: 8) {
                            Text("틈새자료가 완료되면 알림을 보내드릴게요")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                            Text("1분에서 5분 정도 소요되어요")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button {
                            Task {
                                //isPresented = false
                                await viewModel.submitTask()
                            }
                        } label: {
                            Text("홈으로 돌아가기")
                                .bold()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(24)
                } else {
                    Text("틈새 시간에 읽고 싶은\n자료를 올려주세요")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.Gray50)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    
                    if !viewModel.uploadedFiles.isEmpty {
                        // 업로드된 파일이 있다면 보여줌
                        HStack(alignment: .top, spacing: 12) {
                            VStack(spacing: 12) {
                                ForEach(viewModel.uploadedFiles.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }, id: \.id) { file in
                                    UploadedFileCell(file: file, onDelete: {
                                        viewModel.removeFile(file)
                                    })
                                }
                            }
                            VStack(spacing: 12) {
                                ForEach(viewModel.uploadedFiles.enumerated().compactMap { $0.offset % 2 != 0 ? $0.element : nil }, id: \.id) { file in
                                    UploadedFileCell(file: file, onDelete: {
                                        viewModel.removeFile(file)
                                    })
                                }
                            }
                        }
                        .padding(.horizontal, 17)
                        .padding(.vertical, 16)
                        .frame(width: 354, height: 420, alignment: .topLeading)
                        .background(Color.WhiteOpacity100)
                        .cornerRadius(16)

                    } else {
                        // Placeholder message
                        VStack(spacing: 10) {
                            Text("⏰")
                                .font(.system(size: 20))
                                .foregroundColor(Color.Gray400)
                            Text("잠깐의 틈도 채워질 수 있습니다.")
                                .foregroundColor(.gray)
                        }
                        .frame(width: 354, height: 420, alignment: .center)
                        .background(Color.WhiteOpacity100)
                        .cornerRadius(16)
                        .padding(.horizontal, 17)
                        .padding(.vertical, 16)
                    }
                    
                    Spacer()
                    
                    // Upload Button
                    Button(action: {
                        viewModel.showFilePicker()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            VStack(alignment: .leading) {
                                Text("파일 업로드")
                                    .bold()
                                Text("PDF, MP4")
                                    .font(.caption)
                            }
                            Spacer()
                            Text("최대 512mb")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Task Description Input
                    if isEditing {
                        VStack(spacing: 0) {
                            Spacer()
                            HStack {
                                Text("⛳️")
                                Text("학습 목적에 맞게 요약해드릴게요")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemBackground))
                            
                            HStack {
                                TextField("시험공부를 위해", text: $viewModel.taskDescription)
                                    .focused($isFocused)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .padding(.horizontal)
                                
                                Button(action: {
                                    isFocused = false
                                    isEditing = false
                                    viewModel.isShowingTimeSelection = true
                                }) {
                                    HStack(spacing: 4) {
                                        Text("완료")
                                        Image(systemName: "chevron.right")
                                    }
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                                }
                                .padding(.trailing)
                            }
                            .padding(.vertical, 8)
                            .background(Color(.systemBackground))
                        }
                    } else {
                        Button(action: {
                            isEditing = true
                            isFocused = true
                        }) {
                            HStack {
                                Text(viewModel.taskDescription.isEmpty ? "배우고 싶은 목적은?" : viewModel.taskDescription)
                                    .foregroundColor(viewModel.taskDescription.isEmpty ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                        .padding()
                    }
                }
            }
            .background(Color(.systemGray6))
            
            if viewModel.isShowingTimeSelection {
                TimeSelectionView(
                    isPresented: $viewModel.isShowingTimeSelection,
                    selectedTime: $viewModel.selectedTime,
                    onTimeSelected: {
                        viewModel.isShowingTimeSelection = false
                        viewModel.showConfirmation = true // Trigger confirmation content
                    }
                )
            }
        }
        .sheet(isPresented: $viewModel.isShowingFilePicker) {
            DocumentPicker(types: [.pdf, .movie]) { urls in
                for url in urls {
                    viewModel.addFile(url)
                }
            }
        }
        .animation(.default, value: isEditing)
    }
}
