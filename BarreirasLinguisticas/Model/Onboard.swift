//
//  OnboardElements.swift
//  BarreirasLinguisticas
//
//  Created by Matheus S. Moreira on 18/08/20.
//  Copyright © 2020 Matheus S. Moreira. All rights reserved.
//

import Foundation

struct Onboard: Identifiable {
    let id: UUID
    let image: String
    let heading: String
    let subheading: String
    
    static var getAll: [Onboard] {
        [
            Onboard(id: UUID(), image: "languageSkills", heading: "Language Skills", subheading: "In LinGO! your Language Skills are identified by colors, that way you know better how to interact with others, and the others with you!"),
            Onboard(id: UUID(), image: "rooms", heading: "Rooms", subheading: "Rooms are private spaces you can interact with others! They work as servers, where you can find people you somehow relate to!"),
            Onboard(id: UUID(), image: "discoverCards", heading: "Discover and Categories", subheading: "Inside Rooms, you'll find personalized categories where you can put content and in the Discover tab, there'll be recomendations based on your subscriptions!"),
            Onboard(id: UUID(), image: "savePosts", heading: "Save Posts", subheading: "You can save posts to read them later! They'll be at the You tab!"),
            Onboard(id: UUID(), image: "questions", heading: "Questions", subheading: "Ask questions! People will know your Language Skill level, so don't worry! Get your doubts cleared up!")
        ]
    }
}
