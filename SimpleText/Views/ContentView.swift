//
//  ContentView.swift
//  SimpleText
//
//  Created by Max094_Reikeb on 19/09/2022.
//

import SwiftUI
import PencilKit

struct ContentView: View {

    @State var textSize: Double
    var newText: TextView
    @State var loadData: Bool
    @State var openPopover = false
    @State var popoverSize = CGSize(width: 300, height: 110)
    @State private var canvasToggle = false
    @State private var pkCanvasView = PKCanvasView()
    @FocusState private var focusedText: Field?
    @EnvironmentObject var datasManager: DataManager

    // @Environment(\.scenePhase) private var scenePhase

    let localizedTextSize: LocalizedStringKey = "slider.text_size"

    private enum Field: Int {
        case textEdit
    }

    var textView: some View {
        return VStack {
            newText.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity).focused($focusedText, equals: .textEdit)
        }.onTapGesture {
            if focusedText != nil {
                focusedText = nil
            }
        }
    }

    var canvasView: CanvasView {
        return CanvasView(canvasView: $pkCanvasView)
    }

    var body: some View {
        NavigationView {
            ZStack {
                if canvasToggle {
                    canvasView
                } else {
                    textView
                        //.onChange(of: scenePhase) { phase in
                        //if phase == .background {
                        //    saveText()
                        //}
                    //}
                }
            }
            .padding()
            .navigationTitle("Simple Text")
            .toolbar {
                if UIDevice.isIPad {
                    ToolbarItem {
                        Toggle("\(Image(systemName: "pencil"))", isOn: $canvasToggle).onChange(of: canvasToggle) { value in
                            if !canvasToggle {
                                canvasView.hideToolPicker()
                            }
                        }
                    }
                }
                ToolbarItem {
                    Popover(showPopover: $openPopover,
                    popoverSize: popoverSize,
                    arrowDirections: [.up],
                    content: {
                        Button(action: {
                            self.openPopover.toggle()
                        }) {
                            Image(systemName: "textformat.size")
                                .foregroundColor(.white)
                        }
                    },
                    popoverContent: {
                        VStack {
                            Slider(value: $textSize, in: 10...100, step: 1)
                                .padding()
                                .accentColor(.blue)
                                .border(.white, width: 2)
                            HStack {
                                Text(localizedTextSize)
                                Text("\(Int(textSize))")
                            }
                        }
                    })
                }
                /*
                ToolbarItem {
                    Button(action: {
                        share(items: [newText.text])
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.white)
                    }
                }
                 */
                ToolbarItem {
                    Button(action: {
                        if canvasToggle {
                            deleteDrawing()
                        } else {
                            newText.reset()
                        }
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .navigationViewStyle(.stack)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            saveText()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if !loadData {
                DataManager.load { result in
                    switch result {
                    case .success(let success):
                        datasManager.data = success
                        newText.text = datasManager.data.first?.savedText ?? ""
                    case .failure(let failure):
                        fatalError(failure.localizedDescription)
                    }
                }
                loadData = true
            }
        }
    }

    /*
    @discardableResult
    func share(items: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil) -> Bool {
        guard let source = UIApplication.shared.currentUIWindow()?.rootViewController else { return false }
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.excludedActivityTypes = excludedActivityTypes
        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
        return true
    }
     */

    func saveText() {
        let newDatas = Data(savedText: newText.text)
        var data = datasManager.data
        if !data.isEmpty { data.removeFirst() }
        data.append(newDatas)
        DataManager.save(datas: data) { result in
            if case .failure(let failure) = result {
                fatalError(failure.localizedDescription)
            }
        }
    }

    func deleteDrawing() {
        pkCanvasView.drawing = PKDrawing()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(textSize: 20.0, newText: TextView(text: .constant(""), textSize: .constant(20.0)), loadData: true)
    }
}
