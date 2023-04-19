import SwiftUI

//Extension that removes trailing zeroes from Double
//(Not mine!)
extension Double {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

struct ContentView: View {
    let timeUnits = ["Seconds", "Minutes", "Hours", "Days"]
    @State private var userUnitInputIndex: Int = 0
    @State private var userUnitOutputIndex: Int = 0
    @State private var userTime: String = ""
    
    func convertToSeconds(_ time: Double, _ unit: String) -> Double {
        switch unit {
        case "Seconds":
            return time
        case "Minutes":
            return time * 60.0
        case "Hours":
            return time * 3600
        case "Days":
            return time * 86400
        default:
            return 0.0
        }
    }
    func convertSecondsToUnit(_ time: Double, _ unit: String) -> Double {
        switch unit {
        case "Seconds":
            return time
        case "Minutes":
            return time / 60.0
        case "Hours":
            return time / 3600
        case "Days":
            return time / 86400
        default:
            return 0.0
        }
    }
    var convertedTime: Double {
        var time = Double(userTime) ?? 0
        let baseUnit = timeUnits[userUnitInputIndex]
        let convertedUnit = timeUnits[userUnitOutputIndex]
        
        //Convert Input to Seconds
        time = convertToSeconds(time,baseUnit)
        //Convert Input to User-Selected Measurement
        time = convertSecondsToUnit(time,convertedUnit)
        
        return time
    }
    
    var body: some View {
        NavigationView {
            Form {
                //User Input Time
                Section {
                    TextField("Input Time Here", text: $userTime).keyboardType(.decimalPad)
                }
                //Output Time
                Section {
                    //Print Output Time
                    Text("\(userTime) \(timeUnits[userUnitInputIndex]) = \(convertedTime.clean) \(timeUnits[userUnitOutputIndex])")
                    //User Select Output Unit
                }
                //User Select Input Unit
                Section (header: Text("From:")){
                    Picker("Input Time:", selection: $userUnitInputIndex) {
                        ForEach(0..<timeUnits.count) {
                            Text("\(self.timeUnits[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                //User Select Output Unit
                Section (header: Text("To:")) {
                    Picker("Output Time:", selection: $userUnitOutputIndex) {
                        ForEach(0..<timeUnits.count) {
                            Text("\(self.timeUnits[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }.navigationTitle("Time Converter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
