// Kevin Li - 4:30 PM - 6/13/20

import SwiftUI

struct CycleEvent: View {
    
    let event: Event

    var body: some View {
        HStack {
            tagView

            VStack(alignment: .leading) {
                locationName
                visitDuration
            }

            Spacer()
        }
        .frame(height: VisitPreviewConstants.cellHeight)
        .padding(.vertical, VisitPreviewConstants.cellPadding)
    }

}

private extension CycleEvent {

    var tagView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(event.tagColor)
            .frame(width: 5, height: 30)
    }

    var locationName: some View {
        Text(event.eventName)
            .font(.system(size: 16))
            .lineLimit(1)
    }

    var visitDuration: some View {
        Text(event.notes)
            .font(.system(size: 10))
            .lineLimit(1)
    }

}

struct VisitCell_Previews: PreviewProvider {
    static var previews: some View {
        DarkThemePreview {
            CycleEvent(event: .mock(withDate: Date()))
        }
    }
}
