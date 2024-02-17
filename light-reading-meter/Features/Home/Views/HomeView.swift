//
//  HomeView.swift
//  light-reading-meter
//
//  Created by Oscar Rivera Moreira on 6/2/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        VStack {
            HStack {
                NavigationLink(destination: ManageMeterView(meter: nil)) {
                    Text("register_meter")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .foregroundColor(Color.textColorPrimary)
                }
                .background(
                    RadialGradient(gradient: Gradient(colors: [Color.buttonMain, Color.buttonSecondary]), center: .center, startRadius: 1, endRadius: 100)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            VStack {
                HStack {
                    Text("my_meters")
                        .font(.title)
                        .foregroundColor(.primary)
                        .padding()
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if viewModel.myMeters.isEmpty {
                    List {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .padding()
                                .foregroundColor(.gray)
                            
                            Text("no_meters_found")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                else {
                    List(viewModel.myMeters) { meter in
                        NavigationLink(destination: MeterView()) {
                            VStack(alignment: .leading) {
                                Text(meter.name)
                                    .font(.headline)
                                    .padding(.bottom, 10)
                                HStack {
                                    Label(meter.kilowattHours, systemImage: "bolt")
                                        .labelStyle(.titleAndIcon)
                                        .foregroundColor(colorForKWh(kWh: meter.kWh, threshold: meter.desiredMonthlyKWH))
                                    Spacer()
                                    Label(meter.tag, systemImage: "tag")
                                        .labelStyle(.titleAndIcon)
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 15)
                                }
                                .font(.caption)
                            }
                        }
        
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(.primaryBackground)
        }
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(
               title: Text("error"),
               message: viewModel.errorMessage.map { Text($0) },
               dismissButton: .default(Text("ok")) {
                  viewModel.showErrorAlert = false
               }
            )
        }
        .overlay {
            if viewModel.isLoading {
                LoaderView()
            }
        }
        .background(.primaryBackground)
    }
    
    private func colorForKWh(kWh: Int, threshold: Int) -> Color {
        let percentage = Double(kWh) / Double(threshold)
        
        if percentage <= Constants.RED_THRESHOLD_METER {
            return .green
        } else if percentage <= Constants.YELLOW_THRESHOLD_METER {
            return .yellow
        } else {
            return .red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
