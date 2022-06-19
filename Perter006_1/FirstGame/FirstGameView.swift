//
//  FirstGameView.swift
//  Perter006_1
//
//  Created by DONG SHENG on 2022/6/19.
//

// 第一個遊戲: 猜數字

import SwiftUI

class FirstGameViewModel: ObservableObject{
    
    @Published var randomNumber: Int = 1  // 隨機的答案
    @Published var number: String = ""  // 使用者猜的數字
    
    @Published var check: String = ""  // 反饋文字(顯示範圍)
    
    @Published var max: Int = 100
    @Published var min: Int = 1
    
    func gameInit(){
        self.randomNumber = Int.random(in: 1...99)
        self.max = 100
        self.min = 0
        self.check = "猜猜蠟筆小新有多少 巧克力餅乾😎"
    }
    
    // 第一版 使用 guard else (如果擔心使用 !不安全 可以 do-catch 來 throw error)
    func getBoundary() {
        // 第ㄧ層 檢查是否為"範圍內" 的 "數字" -> 檢查是否為數字 讓後面的! 比較安全
        // Int(number) 有可能被輸入文字 無法轉成數字 所以用 ?? 0 (防止系統崩潰)
        guard Int(number) ?? 0 > min && Int(number) ?? 100 < max else {
            self.check = "😡請輸入範圍內的數字 \(min) ~ \(max)😡"
            return
        }
        guard Int(number) != randomNumber else {
            self.check = "答對了！"
            // 答對後一秒 重設新的數字(遊戲重新開始)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.gameInit()
            }
            return
        }
        // 猜得如果大於隨機
        guard Int(number)! > randomNumber && Int(number)! < max else {
            self.min = Int(number)!
            self.check = "猜的太少囉！ 範圍: \(number) ~ \(max)"
            return
        }
        self.max = Int(number)!
        self.check = "太多了吧 再少一些！ 範圍: \(min) ~ \(number)"
        return
    }
}

struct FirstGameView: View {
    
    @StateObject var viewModel = FirstGameViewModel()
    
    var body: some View {
        ZStack{
            
            Image("Background1")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Text("終極密碼")
                    .font(.system(size: 50, weight: .bold, design: .serif))
                    .padding(.top ,10)
                
                Text(viewModel.check)
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(.pink)
                    .frame(height: 16)
                    .padding(.top ,6)
                
                TextField("00", text: $viewModel.number)
                    .font(.largeTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle()) // TextField樣式
                    .keyboardType(.numberPad)   // 數字鍵盤
                    .padding()
                    .background(Color.brown.opacity(0.65).cornerRadius(8))
                    .frame(width: 120, height: 120,alignment: .trailing)
                    .padding(.bottom ,6)
                    
                Spacer()
                
                Button {
                    viewModel.getBoundary()
                    viewModel.number = ""
                    UIApplication.shared.endEditing() // 關閉鍵盤
                } label: {
                    Text("GO!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(8)
                        .padding(.bottom ,30)
                        .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                }
            }
        }
        .onAppear {
            viewModel.gameInit()
        }
    }
}

struct FirstGameView_Previews: PreviewProvider {
    static var previews: some View {
        FirstGameView()
    }
}

// 關閉鍵盤 func
extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
