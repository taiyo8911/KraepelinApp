//
//  HandwritingCanvasView.swift
//  KraepelinApp
//
//  手書き入力用キャンバスビュー
//

import SwiftUI
import PencilKit

struct HandwritingCanvasView: View {
    let onNumberRecognized: (Int) -> Void

    @StateObject private var canvasController = CanvasController()
    @State private var showClearButton = false

    var body: some View {
        VStack(spacing: 16) {
            // 認識結果表示
            if let recognizedNumber = canvasController.recognizedNumber {
                Text("認識: \(recognizedNumber)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.top, 8)
            } else {
                Text("数字を書いてください (0-9)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }

            // キャンバス
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)

                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)

                CanvasView(canvasController: canvasController)
                    .frame(height: 200)
                    .cornerRadius(12)
            }
            .frame(height: 200)
            .padding(.horizontal, 20)

            // ボタン群
            HStack(spacing: 16) {
                // クリアボタン
                Button(action: {
                    canvasController.clearCanvas()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("クリア")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                }

                // 認識ボタン
                Button(action: {
                    canvasController.recognizeDrawing { number in
                        if let number = number {
                            onNumberRecognized(number)
                            // 認識成功後、少し待ってからキャンバスをクリア
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                canvasController.clearCanvas()
                            }
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: "checkmark.circle")
                        Text("入力")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.green)
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical)
    }
}

// キャンバスコントローラー
class CanvasController: ObservableObject {
    @Published var canvasView = PKCanvasView()
    @Published var recognizedNumber: Int? = nil

    private let recognizer = HandwritingRecognizer()

    init() {
        setupCanvas()
    }

    private func setupCanvas() {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.backgroundColor = .clear
    }

    func clearCanvas() {
        canvasView.drawing = PKDrawing()
        recognizedNumber = nil
    }

    func recognizeDrawing(completion: @escaping (Int?) -> Void) {
        let drawing = canvasView.drawing

        // 何も描かれていない場合
        guard !drawing.bounds.isEmpty else {
            completion(nil)
            return
        }

        // 描画を画像に変換
        let image = drawing.image(from: drawing.bounds, scale: 1.0)

        // 手書き認識を実行
        recognizer.recognizeDigit(from: image) { [weak self] result in
            DispatchQueue.main.async {
                self?.recognizedNumber = result
                completion(result)
            }
        }
    }
}

// PencilKitキャンバスをSwiftUIで使用するためのラッパー
struct CanvasView: UIViewRepresentable {
    @ObservedObject var canvasController: CanvasController

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = canvasController.canvasView
        canvasView.delegate = context.coordinator
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // 必要に応じて更新処理
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: CanvasView

        init(_ parent: CanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            // 描画が変更されたときの処理（必要に応じて）
        }
    }
}

struct HandwritingCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        HandwritingCanvasView(onNumberRecognized: { _ in })
    }
}
