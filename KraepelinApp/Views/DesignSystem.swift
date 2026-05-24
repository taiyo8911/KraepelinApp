//
//  DesignSystem.swift
//  KraepelinApp
//
//  アプリ全体で使うデザイントークン（色・間隔・角丸）とボタンスタイルを集約
//

import SwiftUI

// MARK: - Colors

/// アプリ全体で使うセマンティックなカラーパレット
enum AppColor {
    /// ブランドカラー（プライマリ）
    static let primary = Color.green

    /// ブランドカラーの薄い背景（カード・サブボタン用）
    static let primaryMuted = Color.green.opacity(0.1)

    /// 成功状態（正答率 ≧ 80%）
    static let success = Color.green

    /// 注意状態（正答率 60〜80%）
    static let warning = Color.yellow

    /// 危険・破壊的操作
    static let danger = Color.red

    /// 注意喚起アイコン
    static let alert = Color.orange

    /// 画面標準背景（自動でダークモード対応）
    static let background = Color(.systemBackground)

    /// セカンダリ背景（カード・薄いブロック）
    static let surfaceMuted = Color(.secondarySystemBackground)

    /// 区切り線・ボーダー
    static let border = Color(.systemGray4)
}

// MARK: - Spacing

/// 全体で統一する間隔値
enum Spacing {
    /// 4
    static let xs: CGFloat = 4
    /// 8
    static let s: CGFloat = 8
    /// 12
    static let m: CGFloat = 12
    /// 16
    static let l: CGFloat = 16
    /// 24
    static let xl: CGFloat = 24
    /// 32
    static let xxl: CGFloat = 32
}

// MARK: - Corner Radius

enum CornerRadius {
    static let s: CGFloat = 8
    static let m: CGFloat = 10
    static let l: CGFloat = 16
}

// MARK: - Button Styles

/// プライマリボタン: 緑背景・白文字。横幅いっぱい
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(AppColor.primary)
            .cornerRadius(CornerRadius.m)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

/// セカンダリボタン: 緑薄背景・緑文字。横幅いっぱい
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(AppColor.primary)
            .background(AppColor.primaryMuted)
            .cornerRadius(CornerRadius.m)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

/// コンパクトなプライマリ: 横幅を内容に合わせる
struct CompactPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.m)
            .foregroundColor(.white)
            .background(AppColor.primary)
            .cornerRadius(CornerRadius.m)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

/// 破壊的操作用ボタン: 赤背景
struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .padding(.horizontal, Spacing.xl)
            .padding(.vertical, Spacing.m)
            .foregroundColor(.white)
            .background(AppColor.danger.opacity(0.8))
            .cornerRadius(CornerRadius.m)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// MARK: - ButtonStyle convenience

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}

extension ButtonStyle where Self == CompactPrimaryButtonStyle {
    static var compactPrimary: CompactPrimaryButtonStyle { CompactPrimaryButtonStyle() }
}

extension ButtonStyle where Self == DestructiveButtonStyle {
    static var destructive: DestructiveButtonStyle { DestructiveButtonStyle() }
}
