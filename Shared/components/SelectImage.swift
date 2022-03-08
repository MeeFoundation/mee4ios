//
//  ImagePicker.swift
//  mee-ios-client
//
//  Created by Anthony Ivanov on 21.02.2022.
//

import SwiftUI
import UIKit

struct LibraryImage: View {

    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false

    @Binding var uiImage: UIImage?

    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Action"),
            message: Text("Quotemark"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.uiImage = nil
                })
            ])

    }


    var body: some View {
        VStack {

            if (uiImage == nil) {
                Image(systemName: "camera.on.rectangle")
                    .foregroundColor(Colors.mainButtonColor)
                    .background(
                        Colors.background
                            .frame(width: 150, height: 150)
                            .cornerRadius(6))
                    .padding(.all, 75.0)
                    .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Colors.mainButtonColor, lineWidth: 2)
                        )
                    .onTapGesture {
                        self.showImagePicker = true
                    }
            } else {
                Image(uiImage: uiImage!)
                    .resizable()
                    .frame(width: 150, height: 150)
                    .cornerRadius(16)
//                    .overlay(
//                            RoundedRectangle(cornerRadius: 16)
//                                .stroke(Colors.mainButtonColor, lineWidth: 2)
//                        )
                    .onTapGesture {
                        self.showAction = true
                    }
            }

        }

        .sheet(isPresented: $showImagePicker, onDismiss: {
            self.showImagePicker = false
        }, content: {
            ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
        })

        .actionSheet(isPresented: $showAction) {
            sheet
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?

        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
            _isShown = isShown
            _uiImage = uiImage
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            uiImage = imagePicked
            isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}
