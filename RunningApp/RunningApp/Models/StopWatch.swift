
import Foundation

enum watchMode {
    case start, stop
}

class StopWatch : ObservableObject {
    
    @Published var timeString = "00:00"
    @Published var mode : watchMode = .stop
    @Published var secs = 0.0
    var secondsPassed = 0.0
    var timer = Timer()
    
    func start() {
        self.mode = .start
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in self.secondsPassed += 1
            self.formatTimer()
        }
        
    }
    
    func stop() {
        timer.invalidate()
        secs = self.secondsPassed
        self.secondsPassed = 0.0
        self.mode = .stop
    }
    
    
    func formatTimer() {
        
        let minutes : Int = Int(self.secondsPassed/60)
        let minStr = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        
        let seconds : Int = Int(self.secondsPassed) - (minutes * 60)
        let secStr = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        
        //let milli : Int = Int(self.secondsPassed.truncatingRemainder(dividingBy: 1) * 100)
        //let milliStr = (milli < 10) ? "0\(milli)" : "\(milli)"
        
        self.timeString = minStr + ":" + secStr
    }
}
