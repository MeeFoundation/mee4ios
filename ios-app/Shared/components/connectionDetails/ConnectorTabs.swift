//
//  ConnectorTabs.swift
//  mee-ios-client (iOS)
//
//  Created by Anthony Ivanov on 9.1.24..
//

import SwiftUI

struct ConnectorTabs: View {
    var connectors: [[MeeConnectorWrapper]]
    @Binding var currentConnector: String?
    
    init(connectors: [MeeConnectorWrapper], currentConnector: Binding<String?>) {
        self.connectors = connectors.chunked(into: 3)
        self._currentConnector = currentConnector
    }
    
    func getConnectorItem(_ c: MeeConnectorWrapper) -> some View {
        return switch(c.connectorProtocol) {
        case .Gapi( _): ConnectorTabItem("Account", c.id == currentConnector) {
            currentConnector = c.id
        }
        case .MeeBrowserExtension: ConnectorTabItem("Extension", c.id == currentConnector) {
            currentConnector = c.id
        }
        case .MeeTalk: ConnectorTabItem("Mee Talk", c.id == currentConnector) {
            currentConnector = c.id
        }
            
        case .Siop( _): ConnectorTabItem("Profile", c.id == currentConnector) {
            currentConnector = c.id
        }
        case .openId4Vc( _): ConnectorTabItem("OpenId 4 VC", c.id == currentConnector) {
            currentConnector = c.id
        }
        }
    }
    
    var body: some View {
        return (
            ZStack {
                VStack {
                    ForEach(connectors, id: \.self) { chunked in
                        HStack {
                            ForEach(chunked) { c in
                                getConnectorItem(c)
                            }
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
                .background(Colors.grayTab.opacity(0.12))
                .cornerRadius(9)
                .onAppear() {
                    if (currentConnector == nil && connectors.count > 0) {
                        currentConnector = connectors.first?.first?.id
                    }
                }
        )
    }
}

struct ConnectorTabItem: View {
    var text: String
    var isSelected: Bool
    var onClick: () -> Void
    init(_ text: String,_ isSelected: Bool, onClick: @escaping () -> Void) {
        self.text = text
        self.isSelected = isSelected
        self.onClick = onClick
    }
    var body: some View {
        return (
            Button(action: onClick) {
                HStack {
                    Text(text).foregroundColor(Color.black)
                        .lineLimit(1)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(isSelected ? Color.white : Color.clear)
                .cornerRadius(7)
                .if(isSelected) { view in
                    view
                        .shadow(color: .black.opacity(0.04), radius: 0.5, x: 0, y: 3)
                        .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6.93)
                                .inset(by: -0.25)
                                .stroke(.black.opacity(0.04), lineWidth: 0.5)
                            
                        )
                }
                
            }
                .buttonStyle(.plain)
                .padding(.vertical, 2)
                
        )
    }
}

