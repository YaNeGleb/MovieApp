//
//  ReviewRow.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import SwiftUI

struct ReviewRow: View {
    let review: ReviewResult
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack {
                Circle()
                    .fill(Color.black)
                    .frame(width: 40, height: 40)
                
                Text(String(review.author.prefix(1).capitalized))
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .bold))
            }
            .padding(.trailing, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(review.content)
                    .font(.system(size: 16))
                    .fontWeight(.regular)
                    .lineLimit(1)
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    Text(review.author)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(String(review.createdAt.prefix(10)).formattedDate())
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

