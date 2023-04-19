import SwiftUI

struct ContentView: View {
    @State var alertIsVisible = false
    @State var sliderValue: Double = 50.0
    @State var target: Int = Int.random(in: 1...100)
    @State var score: Int = 0
    @State var round: Int = 1
    let midnightBlue = Color(red: 0.0/255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
    
    func roundedSliderValue() -> Int {
        return Int(self.sliderValue.rounded())
    }
    func calculateEarnedPoints() -> Int {
        let maximumPoints = 100
        var bonus = 0
        let earnedPoints = (maximumPoints - abs((roundedSliderValue()) - self.target))
        if (earnedPoints == 100) {
            bonus = 100
        }
        else if (earnedPoints == 99) {
            bonus = 50
        }
        return earnedPoints + bonus
    }
    func alertTitle() -> String {
        switch self.calculateEarnedPoints() {
        case 200:
            return "Bullseye!"
        case 149:
            return "You Almost Had It!"
        case 95...98:
            return "Close One!"
        case 90...94:
            return "Not Bad!"
        default:
            return "Not Even Close!"
        }
    }
    func startNewGame() {
        sliderValue = 50.0
        target = Int.random(in: 1...100)
        score = 0
        round = 1
    }
    //ViewModifier is a protocol that changes a view the way you want it
    struct LabelStyle : ViewModifier {
        func body(content: Content) -> some View {
            //Needed for ViewModifier
            return content
                .foregroundColor(Color.white)
                .shadow(color: .black, radius: 5, x: 2, y: 2)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
        }
    }
    struct ValueStyle : ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT", size: 24))
        }
    }
    struct Shadow : ViewModifier {
        func body(content: Content) -> some View {
            return content
                .shadow(color: .black, radius: 5, x: 2, y: 2)
        }
    }
    struct ButtonLargeTextStyle : ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT", size: 18))
        }
    }
    struct ButtonSmallTextStyle : ViewModifier {
        func body(content: Content) -> some View {
            return content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT", size: 12))
        }
    }
    
    //Body
    var body: some View {
        VStack {
            //Target Row
            Spacer()
            HStack {
                Text("Put the bullseye as close as you can to: \(self.target)").modifier(LabelStyle())
            }
            Spacer()
            
            //Slider Row
            HStack {
                Text("1").modifier(ValueStyle())
                //Pass by reference ensures that, whenever the sliderValue changes, the slider changes
                Slider(value: self.$sliderValue, in: 1...100).accentColor(Color.green)
                Text("100").modifier(ValueStyle())
            }
            Spacer()
            
            //Button Row
            HStack {
                Button(action:{
                    print("Button Pressed!")    //For debugging
                    self.alertIsVisible = true  //Change State variable
                }) {
                    Text("Hit Me!")
                }
                    //State variables need a $
                    .alert(isPresented: $alertIsVisible) { () -> Alert in
                        return Alert(title:Text("\(alertTitle())"),
                            message: Text("The slider's value is \(roundedSliderValue()). \n You scored \(calculateEarnedPoints()) points this round."),
                            dismissButton: .default(Text("Awesome!")){
                                    //After alert is dismissed, update score & round, change target
                                    self.score += calculateEarnedPoints()
                                    self.round += 1
                                    self.target = Int.random(in: 1...100)
                            } )
                }
            }.background(Image("Button")).modifier(ButtonLargeTextStyle())
            Spacer()
            
            //Score Row
            HStack {
                //Start Over Button
                Button (action: {
                    self.startNewGame()
                }) {
                    HStack {
                        Image("StartOverIcon")
                        Text("Start Over")
                    }
                }.background(Image("Button")).modifier(ButtonSmallTextStyle())
                Spacer()
                Text("Score: ").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                Text("Round: ").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                //Get Info Button (Leads to About Page)
                NavigationLink(destination:AboutView()) {
                    HStack {
                        Image("InfoIcon")
                        Text("Get Info")
                    }
                }.background(Image("Button")).modifier(ButtonSmallTextStyle())
            }.padding(.bottom, 20)
        }.background(Image("Background"), alignment: .center)
        .accentColor(midnightBlue)  //Default color for our giant VStack
        .navigationBarTitle("Bullseye") //Navigation Bar
    }
}

//Changes how you see the preview screen (The screen that shows real time changes when you code)
//We changed it to landscape in this case
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewLayout(.fixed(width: 896, height: 414))
        }
    }
}

// Some views used in SwiftUI: Text, Button, Vertical Stack
// Add views by clicking + button in top left
    //Add HStack by putting directly into element
    //Spacers add enough space for entire row
// Command + Click to easily edit views
// Option + Click to quickly change variables and see developer documentation

//Use States when you need to keep track of variables
//State of the app will change when alert happens
//When the State of app changes (alertIsVisible becomes true), the body will be refreshed

//Add images by dragging to Assets folder
    //1x,2x,3x sections are for resolutions (low, med, high res)
    //paintcodeapp.com shows ios resolutions

//Change Navigation Bar
//Making New Page
    // File -> New File -> iOS -> SwiftUI View -> Next -> Create
//Go to SceneDelegate.swift and change ContentView

//Adding Icons:
    //Assets -> AppIcon -> Drag In Icon
