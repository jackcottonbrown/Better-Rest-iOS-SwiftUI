//
//  ContentView.swift
//  BetterRest
//
//  Created by Jack Cotton-Brown on 30/11/21.
//
/*
 To do:
 -Create a picker for the date
 -Create a toolbar item to calculate something
 -Create a stepper to increment the number of cups of coffee. Change "cup" to "cups" for plural.
 -Create a navigation title
 -Create an empty function to calculate.
 -Create a text view that always shows the result of the calculate bedtime function. This needs to update when the UI refreshes.
 */


import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = standardWakeUpTime
    @State private var hoursOfSleep = 8.0
    @State private var cupsOfCoffee = 1
    @State private var recommendedBedTime = ""
    
    static var standardWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 6
        components.minute = 30
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                Form {
                        VStack(alignment: .leading, spacing: 5){
                            Text("When do you want to wake up?")
                                .font(.headline)
                            DatePicker("myTitle", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                                .onChange(of: wakeUp) { newValue in
                                    calculateBedtime()
                                }
                        }
                        VStack(alignment: .leading, spacing: 5){
                            Text("Desired amount of sleep")
                                .font(.headline)
                            Stepper("\(hoursOfSleep.formatted()) hours", value: $hoursOfSleep, in: 4...12, step: 0.25 )
                                .onChange(of: hoursOfSleep) { newValue in
                                    calculateBedtime()
                                }
                            Text("Daily coffee intake")
                                .font(.headline)
                            Stepper(cupsOfCoffee == 1 ? "1 cup" : "\(cupsOfCoffee) cups", value: $cupsOfCoffee, in: 1...20, step: 1)
                                .onChange(of: cupsOfCoffee) { newValue in
                                    calculateBedtime()
                                }
                        }
                }
                .navigationTitle("Better Rest")
                .onAppear {
                    calculateBedtime()
                }
                
                VStack{

                    Text("Optimised Bedtime").font(.headline).underline()
                    Text(recommendedBedTime)
                        .padding(30)
                        .foregroundColor(.blue)
                        .background(Color(.init(red: 0.9, green: 0.9, blue: 1, alpha: 50)))
                        .font(.system(size: 50, weight: .bold))
                        .cornerRadius(30)
                    Text("😴💤😴💤😴💤😴💤😴💤😴")
                    
                    Spacer()
                }
            }
        }
    }
    func calculateBedtime() {
        do {
            let modelConfig = MLModelConfiguration()
            let model = try BetterRestModel(configuration: modelConfig)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hoursInSeconds = (components.hour ?? 0) * 60 * 60
            let minutesInSeconds = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hoursInSeconds + minutesInSeconds), estimatedSleep: hoursOfSleep, coffee: Double(cupsOfCoffee))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let finalOutput = sleepTime.formatted(date: .omitted, time: .shortened)
            recommendedBedTime = finalOutput
        }
        catch {
            print("There was a problem loading the ML model")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
