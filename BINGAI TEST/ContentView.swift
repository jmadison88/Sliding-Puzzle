//
//  ContentView.swift
//  BINGAI TEST
//
//  Created by Josh Madison on 1/11/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var tiles = Array(1...8) + [0]
    var body: some View {
        VStack {
            ForEach(0..<3) { row in
                HStack {
                    ForEach(0..<3) { col in
                        Button(action: {
                            self.moveTile(at: self.index(forRow: row, col: col))
                        }) {
                            if self.tiles[self.index(forRow: row, col: col)] != 0 {
                                Text("\(self.tiles[self.index(forRow: row, col: col)])")
                                    .frame(width: 80, height: 80)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                                    .cornerRadius(10)
                            } else {
                                Text("")
                                    .frame(width: 80, height: 80)
                            }
                        }
                    }
                }
            }
            Button("Shuffle") {
                shuffleAndCheckPuzzle()
            }
        }
        .onAppear() {
            shuffleAndCheckPuzzle()
        }
    }
    
    func index(forRow row: Int, col: Int) -> Int {
        return row * 3 + col
    }
    
    func moveTile(at index: Int) {
        let offsets = [-1, 1, -3, 3]
        let invalidLeftIndices = [0, 3, 6] //ensures the puzzle does not wrap and moves tile incorrectly
        let invalidRightIndices = [2, 5, 8]
        for offset in offsets {
            let neighborIndex = index + offset
            if neighborIndex >= 0 && neighborIndex < 9 && tiles[neighborIndex] == 0 {
                if offset == -1 && invalidLeftIndices.contains(index) {
                    continue
                }
                if offset == 1 && invalidRightIndices.contains(index) {
                    continue
                }
                tiles.swapAt(index, neighborIndex)
                return
            }
        }
    }
    
    private func shuffleAndCheckPuzzle() { //repeats tiles.shuffle until isSolvable is true
        repeat {
            tiles.shuffle()
        } while !isSolvable(tiles: tiles)
    }

    private func isSolvable(tiles: [Int]) -> Bool {
        let inversions = countInversions(tiles: tiles)
        
        // find row position of blank tile
        let blankIndex = tiles.firstIndex(of: 0)!
        let rowNumber = (tiles.count - blankIndex) / 3
        
        // determines if blank tile is on an odd row from bottom (ensures the puzzle is solvable)
        let blankOnOddRowFromBottom = rowNumber % 2 == 1
        
        return (inversions % 2 == 0) != blankOnOddRowFromBottom
    }


    private func countInversions(tiles: [Int]) -> Int { //counts the number of inversions by iterating through an array
        var inversions = 0
        for i in 0..<tiles.count {
            if tiles[i] == 0 {
                continue // Skip the blank tile
            }
            for j in (i + 1)..<tiles.count {
                if tiles[j] == 0 {
                    continue // Skip the blank tile
                }
                if tiles[i] > tiles[j] {
                    inversions += 1
                }
            }
        }
        return inversions
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
