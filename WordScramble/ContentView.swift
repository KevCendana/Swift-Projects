import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var score = 0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                //Enter newWord
                TextField("Enter your word", text: $newWord, onCommit: addNewWord).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    //OnCommit runs when user presses enter
                
                //Display dynamic list of words
                List(usedWords, id: \.self) {
                    //Picture of a circle that shows length of word
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }
                //Score
                Text("Score: \(score)").padding(.bottom,10)
            }.navigationBarTitle(Text(rootWord)).onAppear(perform: startGame)
            .navigationBarItems(trailing:
                Button(action: startGame) {
                    Text("Refresh")
                }
            )
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    //Runs when user enters word in Text Field
    func addNewWord() {
        //Lowercase and Trim word
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Exit if string is empty
        guard answer.count > 0 else {
            return
        }
        //Exit if user enters the same word
        guard answer != rootWord else {
            wordError(title: "Word is the same", message: "The same word doesn't count!")
            return
        }
        //Functions to check for valid words
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Needs to be original!")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        
        //Add points
        score += calculateScore(word: answer)
        
        //Add new word to array
        usedWords.insert(answer, at: 0)
        newWord = ""    //Reset word
    }
    
    func calculateScore(word: String) -> Int {
        return word.count*10
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        //loop through every letter in given word
        for letter in word {
            //position is the first index found of letter we're searching for
            if let position = tempWord.firstIndex(of: letter) {
                //found it? then remove char from rootWord at position
                tempWord.remove(at: position)
            } else {
                //position doens't exist? word not possible
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        //Note: uses UITextChecker from UIKit
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func startGame() {
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")

                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                //Reset score
                score = 0
                
                // If we are here everything has worked, so we can exit
                return
            }
        }

        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
