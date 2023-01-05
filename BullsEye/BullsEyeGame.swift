/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import Alamofire

class BullsEyeGame {
  var round = 0
  let startValue = 50
  var targetValue = 50
  var scoreRound = 0
  var scoreTotal = 0

  init() {
    startNewGame()
  }

  func startNewGame() {
    round = 1
    scoreTotal = 0
  }

  func startNewRound(completion: @escaping () -> Void) {
    round += 1
    scoreRound = 0
    getRandomNumber { newTarget in
      self.targetValue = newTarget
      DispatchQueue.main.async {
        completion()
      }
    }
  }

  @discardableResult
  func check(guess: Int) -> Int {
    let difference = abs(targetValue - guess)
    scoreRound = 100 - difference
    scoreTotal += scoreRound
    return difference
  }

  func getRandomNumber(completion: @escaping (Int) -> Void) {
    guard let url = URL(string: "http://www.randomnumberapi.com/api/v1.0/random?min=0&max=100&count=1") else {
      return
    }
    
    AF.request(url.absoluteString).responseDecodable(of: [Int].self) { response in
      switch response.result {
      case .success(let dTypes):
        let newTarget = dTypes.first ?? 50
        completion(newTarget)
      case .failure(let error):
        print("Decoding of random numbers failed. Error msg: \(error)")
      }
    }
  }
}
