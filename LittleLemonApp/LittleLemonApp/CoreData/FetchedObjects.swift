/*
*  File: FetchedObjects.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import CoreData
import SwiftUI

struct FetchedObjects<T, Content>: View
where T: NSManagedObject, Content: View {
    
    @FetchRequest private var results: FetchedResults<T>
    private let content: (FetchedResults<T>) -> Content
    
    init(
        predicate: NSPredicate = NSPredicate(value: true),
        sortDescriptors: [NSSortDescriptor] = [],
        @ViewBuilder content: @escaping (FetchedResults<T>) -> Content
    ) {
        
        _results = FetchRequest(
            entity: T.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate
        )
        self.content = content
    }
    
    var body: some View {
        content(results)
    }
}
