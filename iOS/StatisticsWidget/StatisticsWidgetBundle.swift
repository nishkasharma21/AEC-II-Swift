//
//  StatisticsWidgetBundle.swift
//  StatisticsWidget
//
//  Created by Nishka Sharma on 7/23/24.
//

import WidgetKit
import SwiftUI

@main
struct StatisticsWidgetBundle: WidgetBundle {
    var body: some Widget {
        StatisticsWidget()
//        StatisticsWidgetControl()
        StatisticsWidgetLiveActivity()
    }
}
