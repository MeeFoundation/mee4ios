//
//  HashTagView.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 13.5.24..
//

import SwiftUI

struct HashtagView<Selectable: Identifiable & Hashable>: View {
    var tags: [Selectable]
    let optionToString: (Selectable) -> String
    var action: (Selectable.ID) -> ()

    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: optionToString(tag))
                    .onTapGesture {
                        action(tag.id)
                    }
                    .padding(.vertical, 4)
                    .padding(.trailing, 8)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        HStack(spacing: 8) {
            BasicText(text: text, color: Colors.meeBrand, size: 18, weight: Font.Weight.medium)
            Image("closeIcon")
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .padding(.vertical, 6)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Colors.meeBrand.opacity(0.5), lineWidth: 1.0)
        )
        
        .background(Colors.meeBrand.opacity(0.1))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
