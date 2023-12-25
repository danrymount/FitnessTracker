

import Foundation
import SwiftUI


enum ActivityListType
{
    case myActivities
    case userActivities
}

struct ActivitiesListView: View
{
    @ObservedObject private var activitiesViewModel: ActivitiesListViewModel = ActivitiesListViewModel()

    private var activityListType: ActivityListType
    
    
    init(type: ActivityListType) {
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }
        
        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
        
        activityListType = type
    }
    
    var body: some View {
        VStack
        {
            List {
                Group
                {
                    ForEach(activitiesViewModel.activities.keys.sorted(by: {$0 > $1}), id: \.self) { key in
                        Text(key.toString())
                        ForEach(activitiesViewModel.activities[key]!) { activity in
                            ActivityCardView(data: activity)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .hideListSeparator()
                    ExtraBottomSafeAreaInset()
                        .listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
                        .listRowBackground(Color.clear)
                    
                }
            }
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .onAppear {
                activitiesViewModel.reload()
            }
        }
    }
}


extension View {
    func readHeight(onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Spacer()
                    .preference(
                        key: HeightPreferenceKey.self,
                        value: geometryProxy.size.height
                    )
            }
        )
        .onPreferenceChange(HeightPreferenceKey.self, perform: onChange)
    }
}

private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

extension View {
    func bottomSafeAreaInset<OverlayContent: View>(_ overlayContent: OverlayContent) -> some View {
        modifier(BottomInsetViewModifier(overlayContent: overlayContent))
    }
}

struct BottomSafeAreaInsetKey: EnvironmentKey {
    static var defaultValue: CGFloat = 0
}

extension EnvironmentValues {
    var bottomSafeAreaInset: CGFloat {
        get { self[BottomSafeAreaInsetKey.self] }
        set { self[BottomSafeAreaInsetKey.self] = newValue }
    }
}

struct ExtraBottomSafeAreaInset: View {
    @Environment(\.bottomSafeAreaInset) var bottomSafeAreaInset: CGFloat
    
    var body: some View {
        Spacer(minLength: bottomSafeAreaInset)
        
    }
}

struct BottomInsetViewModifier<OverlayContent: View>: ViewModifier {
    @Environment(\.bottomSafeAreaInset) var ancestorBottomSafeAreaInset: CGFloat
    var overlayContent: OverlayContent
    @State var overlayContentHeight: CGFloat = 0
    
    func body(content: Self.Content) -> some View {
        content
            .environment(\.bottomSafeAreaInset, overlayContentHeight + ancestorBottomSafeAreaInset)
            .overlay(
                overlayContent
                    .readHeight {
                        overlayContentHeight = $0
                    }
                    .padding(.bottom, ancestorBottomSafeAreaInset)
                ,
                alignment: .bottom
            )
    }
}


fileprivate extension View
{
    func hideListSeparator() -> some View {
        if #available(iOS 15, *) {
            return self.listRowSeparator(.hidden)
        }
        // TODO iOS 14
        else {
            return self.onAppear {
                UITableView.appearance().separatorStyle = .none
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
            }
        }
    }
}
