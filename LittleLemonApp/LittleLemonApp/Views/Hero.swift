/*
*  File: Hero.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

struct Hero: View {
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Little Lemon")
                        .foregroundColor(Color.primaryColor2)
                        .font(.displayFont())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Chicago")
                        .foregroundColor(.white)
                        .font(.subTitleFont())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer(minLength: 5)
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist."
                     )
                    .foregroundColor(.white)
                    .font(.leadText())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Image("hero_image")
                    .resizable()
                    .aspectRatio( contentMode: .fill)
                    .frame(maxWidth: 120, maxHeight: 140)
                    .clipShape(Rectangle())
                    .cornerRadius(16)
            }
        }
        .padding()
        .background(Color.primaryColor1)
        .frame(maxWidth: .infinity, maxHeight: 240)
    }
    
}

struct Hero_Previews: PreviewProvider {
    static var previews: some View {
        Hero()
    }
}
