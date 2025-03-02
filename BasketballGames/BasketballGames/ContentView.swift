//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Score: Codable{
    var opponent: Int
    var unc: Int
}

struct Game: Codable {
    var id: Int
    var date: String
    var isHomeGame: Bool
    var score: Score
    var opponent: String
    var team: String
}


struct ContentView: View {
    @State private var games = [Game]()
    
    var body: some View {
        List(games, id: \.id) { game in
            HStack{
                VStack(alignment: .leading) {
                    Text("\(game.team) vs. \(game.opponent)")
                        .font(.headline)
                    
                    Text("\(game.date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(game.score.unc) - \(game.score.opponent)")
                    Text(game.isHomeGame ? "Home" : "Away")
                        .font(.caption)
                        .foregroundColor(game.isHomeGame ? .green : .red)
                }
                
            }
           .padding()
       }
       .task {
           await loadData()
       }
   }
    func loadData() async {
            guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
                print("Invalid URL")
                return
            }
    
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedResponse = try JSONDecoder().decode([Game].self, from: data)
            games = decodedResponse
        } catch {
            print("Invalid data: \(error)")
        }
    }
}
                    

#Preview {
    ContentView()
}
