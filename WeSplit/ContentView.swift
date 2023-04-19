import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
        //SwiftUI has to use strings to store text field values
    @State private var numberOfPeople = 2
    @State private var tipPercentageIndex = 2
    let tipPercentages = [10, 15, 20, 25, 0]
    var orderAmount: Double {
        return Double(checkAmount) ?? 0
            //Converts string to double, unless it fails, then it turns to 0
    }
    var tipAmount: Double {
        let tipSelection = Double((tipPercentages[tipPercentageIndex]))
        return orderAmount * (tipSelection / 100)
    }
    var totalAfterTip: Double {
        return orderAmount + tipAmount
    }
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let amountPerPerson = totalAfterTip / peopleCount
        return amountPerPerson
    }
    var body: some View {
        NavigationView {
            Form {
                //Amount
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }
                //Tip
                Section(header: Text("How much tip do you want to leave?")) {
                    Picker("Tip percentage", selection: $tipPercentageIndex) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    //Segmented Control, looks really nice!
                }
                //Subtotal (Before diving into people)
                Section (header: Text("Subtotal")) {
                    Text("\(totalAfterTip)")
                }
                //Total
                Section(header: Text("Amount per person")) {
                    Text("\(totalPerPerson, specifier: "%.2f")")
                        //specifier is floating point, prints .00 not .0000000
                }
            }.navigationBarTitle("WeSplit")
            //Actually attached to Form, not Nav
        }


    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
 "In this project you learn about the basic structure of SwiftUI apps, how to build forms and sections, creating navigation views and navigation bar titles, how to store program state with the @State property wrapper, how to create user interface controls like TextField and Picker, and how to create views in a loop using ForEach. Even better, you have a real project to show off for your efforts."
 
 - @State automatically watches for changes, which makes it reinvoke body property
    - @State lets us modify values, even though structs have immutable values!
    - @State is not needed for constants like arrays
 - ForEach allows us to create several views in a loop
 - Binding: Two variables that are binded change together (PBR)
    - To avoid error "Can't convert value... to Binding" use the $ sign to PBR
 - Form: Basically a scrolling List
    - You can use "Sections" to split up items
 - Pickers: Need 2-way binding to track their value
 - Navigation View: Can have titles, buttons, and display new views when action is done
 - Modifiers: Methods that always return new instance of what they're used on
 
 - Section(Header) looks sick af
 */
