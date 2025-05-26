/*
*  File: Styles.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    let fill: Color
    let pressedFill: Color
    let textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundColor(textColor)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .padding(10)
            .background(configuration.isPressed ? pressedFill : fill)
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

struct OutlinedButtonStyle: ButtonStyle {
    let strokeColor: Color
    let fill: Color
    let pressedFill: Color
    let textColor: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(textColor)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .padding(10)
            .background(configuration.isPressed ? pressedFill : fill)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(strokeColor, lineWidth: 1)
            )
            .padding(.horizontal)
    }
}

extension ButtonStyle {
    static var yellowWide: some ButtonStyle {
        FilledButtonStyle(
            fill: .primaryColor2,
            pressedFill: .primaryColor1,
            textColor: .black
        )
    }

    static var primary: some ButtonStyle {
        OutlinedButtonStyle(
            strokeColor: .primaryColor1,
            fill: .white,
            pressedFill: .primaryColor1,
            textColor: .primaryColor1
        )
    }

    static var primaryReversed: some ButtonStyle {
        OutlinedButtonStyle(
            strokeColor: .primaryColor1,
            fill: .primaryColor1,
            pressedFill: .white,
            textColor: .white
        )
    }
}

extension Text {
    func onboardingTextStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.primaryColor1)
            .font(.custom("Karla-Bold", size: 13))
    }
}

extension Font {
    static func displayFont() -> Font {
        Font.custom("Karla-Medium", size: 32)
    }
    static func subTitleFont() -> Font {
        Font.custom("Karla-Regular", size: 32)
    }
    static func leadText() -> Font {
        Font.custom("Karla-Regular", size: 16)
    }
    static func regularText() -> Font {
        Font.custom("Karla-Regular", size: 18)
    }
    static func sectionTitle() -> Font {
        Font.custom("Karla-ExtraBold", size: 18)
    }
    static func sectionCategories() -> Font {
        Font.custom("Karla-Bold", size: 16)
    }
    static func paragraphText() -> Font {
        Font.custom("Karla-Regular", size: 14)
    }
    static func highlightText() -> Font {
        Font.custom("Karla-Regular", size: 14)
    }
}


extension Color {
    static let primaryColor1    = Color(red: 0.2863, green: 0.3686, blue: 0.3412)
    static let primaryColor2    = Color(red: 0.9569, green: 0.8078, blue: 0.0784)

    static let secondaryColor1  = Color(red: 0.9892, green: 0.5802, blue: 0.4141)
    static let secondaryColor2  = Color(red: 1.0,    green: 0.8489, blue: 0.7164)

    static let highlightColor1  = Color(red: 0.9276, green: 0.9376, blue: 0.9331)
    static let highlightColor2  = Color(red: 0.2,    green: 0.2,    blue: 0.2)
}
