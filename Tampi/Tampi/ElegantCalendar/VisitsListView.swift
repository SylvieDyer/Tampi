// Kevin Li - 4:00 PM - 6/13/20

import SwiftUI

struct VisitsListView: View {

    private let timer = Timer.publish(every: VisitPreviewConstants.previewTime,
                                      on: .main, in: .common).autoconnect()
    @State var visitIndex = 0
    
    let cycleEvents: [Event]
    let numberOfCellsInBlock: Int

    init(cycleEvents: [Event], height: CGFloat) {
        self.cycleEvents = cycleEvents
        numberOfCellsInBlock = Int(height / (VisitPreviewConstants.cellHeight + VisitPreviewConstants.cellPadding*2))
    }

    private var range: Range<Int> {
        let exclusiveEndIndex = visitIndex + numberOfCellsInBlock
        guard cycleEvents.count > numberOfCellsInBlock &&
            exclusiveEndIndex <= cycleEvents.count else {
            return visitIndex..<cycleEvents.count
        }
        return visitIndex..<exclusiveEndIndex
    }

    var body: some View {
        visitsPreviewList
            .animation(.easeInOut)
            .onAppear(perform: setUpVisitsSlideShow)
            .onReceive(timer) { _ in
                self.shiftActivePreviewVisitIndex()
            }
    }

    private func setUpVisitsSlideShow() {
        if cycleEvents.count <= numberOfCellsInBlock {
            // To reduce memory usage, we don't want the timer to fire when
            // visits count is less than or equal to the number
            // of visits allowed in a single slide
            timer.upstream.connect().cancel()
        }
    }

    private func shiftActivePreviewVisitIndex() {
        let startingVisitIndexOfNextSlide = visitIndex + numberOfCellsInBlock
        let startingVisitIndexOfNextSlideIsValid = startingVisitIndexOfNextSlide < cycleEvents.count
        visitIndex = startingVisitIndexOfNextSlideIsValid ? startingVisitIndexOfNextSlide : 0
    }

    private var visitsPreviewList: some View {
        VStack(spacing: 0) {
            ForEach(cycleEvents[range]) { event in

                CycleEvent(event: event)
            }
        }
    }

}

//struct VisitsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DarkThemePreview {
//            VisitsListView(cycleEvents: Event.mocks(start: Date(), end: .daysFromToday(2)), height: 300)
//        }
//    }
//}
