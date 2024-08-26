//
//  String + Extensions.swift
//  MovieApp
//
//  Created by Zabroda Gleb on 26.08.2024.
//

import Foundation

extension String {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        } else {
            return "01.01.0001"
        }
    }
}
