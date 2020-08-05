//
//  PostEditorView.swift
//  BarreirasLinguisticas
//
//  Created by Victor S. Duarte on 04/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import SwiftUI
import UIKit

struct PostEditorView: View {
    
    @State var text: String = ""
    @State var textHeight: CGFloat = 150
    @State var title: String = ""
    @State var link: String = ""
    @State var tag: String = ""
    
    var body: some View {
        
        
        VStack {
            NavigationView {
                
                VStack {
                    
                    HStack {
                        Text("Select a category")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(Color.gray)
                        
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                    
                    TextField("What is the subject?", text: $title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .padding(.bottom)
                    
                    
                    
                    
                    ScrollView {
                        TextView(placeholder: "", text: self.$text, minHeight: self.textHeight, calculatedHeight: self.$textHeight)
                            .frame(minHeight: self.textHeight, maxHeight: self.textHeight)
                        
                    }
                    
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.blue)
                            .font(.headline)
                        
                        TextField("You can paste a related link here", text: $link)
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                    }
                    .padding(.bottom)
                    
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.blue)
                            .font(.headline)
                        
                        TextField("Add tags! Eg.: ''SwiftUI, UX, English'' etc. ", text: $tag)
                            .font(.headline)
                            .foregroundColor(.blue)
                        
                    }
                    .padding(.bottom)
                    
                    Spacer()
                } .padding()
                    
                    .navigationBarTitle(Text("Create a post!"))
                    .font(.system(.largeTitle, design: .rounded))
                    .navigationBarItems(trailing: Text("Go!")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.blue))
                
            }
        }
    }
}

struct PostEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PostEditorView()
    }
}
