//
//  SpecificRoundedCorners.swift
//  MonsterChat
//
//  Created by Obaro Paul on 24/06/2024.
//

import SwiftUI

struct SpecificRoundedCorners: Shape {
    let radius: CGFloat
    let corners: UIRectCorner

    init(radius: CGFloat = .infinity, corners: UIRectCorner = .allCorners) {
        self.radius = radius
        self.corners = corners
    }

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func customConerRadius(_ radius:CGFloat, corners:UIRectCorner)-> some View{
        clipShape(SpecificRoundedCorners(radius: radius, corners: corners))
    }
}
