//
//  HandwritingRecognizer.swift
//  KraepelinApp
//
//  手書き数字認識機能
//

import Foundation
import UIKit
import Vision

class HandwritingRecognizer {

    /// 手書き数字を認識する
    /// - Parameters:
    ///   - image: 認識対象の画像
    ///   - completion: 認識結果のコールバック（0-9の数字、または認識失敗時はnil）
    func recognizeDigit(from image: UIImage, completion: @escaping (Int?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        // 画像を前処理
        guard let processedImage = preprocessImage(image) else {
            completion(nil)
            return
        }

        // Visionフレームワークを使用してテキスト認識
        let request = VNRecognizeTextRequest { (request, error) in
            guard error == nil else {
                print("テキスト認識エラー: \(error!.localizedDescription)")
                completion(nil)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }

            // すべての候補をチェック
            for observation in observations {
                // 複数の候補を確認
                for candidate in observation.topCandidates(5) {
                    let text = candidate.string
                    if let digit = self.extractDigit(from: text) {
                        completion(digit)
                        return
                    }
                }
            }

            completion(nil)
        }

        // 手書き文字認識に最適な設定
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false
        request.customWords = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

        // iOS 16以降で利用可能な設定
        if #available(iOS 16.0, *) {
            request.automaticallyDetectsLanguage = false
        }

        let handler = VNImageRequestHandler(cgImage: processedImage, options: [:])

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print("画像処理エラー: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    /// 画像を前処理する（コントラスト調整、リサイズなど）
    private func preprocessImage(_ image: UIImage) -> CGImage? {
        guard let cgImage = image.cgImage else { return nil }

        let ciImage = CIImage(cgImage: cgImage)

        // 1. グレースケール化
        guard let grayscaleFilter = CIFilter(name: "CIPhotoEffectMono") else {
            return cgImage
        }
        grayscaleFilter.setValue(ciImage, forKey: kCIInputImageKey)
        guard let grayscaleOutput = grayscaleFilter.outputImage else {
            return cgImage
        }

        // 2. コントラストと明るさを調整
        guard let colorControlsFilter = CIFilter(name: "CIColorControls") else {
            return cgImage
        }
        colorControlsFilter.setValue(grayscaleOutput, forKey: kCIInputImageKey)
        colorControlsFilter.setValue(2.0, forKey: kCIInputContrastKey) // コントラストを大幅に上げる
        colorControlsFilter.setValue(0.3, forKey: kCIInputBrightnessKey) // 明るさを調整
        colorControlsFilter.setValue(0.0, forKey: kCIInputSaturationKey) // 彩度を0に

        guard let outputImage = colorControlsFilter.outputImage else {
            return cgImage
        }

        // 3. エッジを強調
        guard let sharpenFilter = CIFilter(name: "CISharpenLuminance") else {
            let context = CIContext()
            return context.createCGImage(outputImage, from: outputImage.extent) ?? cgImage
        }
        sharpenFilter.setValue(outputImage, forKey: kCIInputImageKey)
        sharpenFilter.setValue(1.5, forKey: kCIInputSharpnessKey)

        guard let finalOutput = sharpenFilter.outputImage else {
            return cgImage
        }

        let context = CIContext()
        guard let processedCGImage = context.createCGImage(finalOutput, from: finalOutput.extent) else {
            return cgImage
        }

        return processedCGImage
    }

    /// テキストから数字（0-9）を抽出する
    private func extractDigit(from text: String) -> Int? {
        // 数字のみを抽出
        let digits = text.filter { $0.isNumber }

        // 最初の数字を返す
        if let firstDigit = digits.first,
           let number = Int(String(firstDigit)),
           number >= 0 && number <= 9 {
            return number
        }

        // 特殊なケース: 'O' や 'o' は '0' として認識
        let normalizedText = text.lowercased()
        if normalizedText.contains("o") || normalizedText.contains("О") { // キリル文字のОも含む
            return 0
        }

        // 特殊なケース: 'l' や 'I' は '1' として認識
        if normalizedText.contains("l") || normalizedText.contains("i") {
            return 1
        }

        return nil
    }
}
