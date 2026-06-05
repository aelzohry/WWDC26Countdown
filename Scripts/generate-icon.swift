import AppKit

let outputPath = CommandLine.arguments.dropFirst().first ?? "AppIcon-1024.png"
let size: CGFloat = 1024
let rect = NSRect(x: 0, y: 0, width: size, height: size)
let image = NSImage(size: rect.size)

func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> NSColor {
    NSColor(calibratedRed: red, green: green, blue: blue, alpha: alpha)
}

image.lockFocus()

let backgroundPath = NSBezierPath(roundedRect: rect.insetBy(dx: 58, dy: 58), xRadius: 210, yRadius: 210)
NSGradient(colors: [
    color(0.02, 0.025, 0.07),
    color(0.05, 0.04, 0.15),
    color(0.0, 0.14, 0.18)
])?.draw(in: backgroundPath, angle: -38)

for index in 0..<7 {
    let inset = CGFloat(index) * 54 + 92
    let orbit = NSBezierPath(ovalIn: rect.insetBy(dx: inset, dy: inset + CGFloat(index % 2) * 16))
    orbit.lineWidth = index == 0 ? 16 : 7
    color(
        0.22 + CGFloat(index) * 0.06,
        0.85 - CGFloat(index) * 0.05,
        1.0,
        0.55 - CGFloat(index) * 0.045
    ).setStroke()
    orbit.stroke()
}

let glow = NSBezierPath(ovalIn: rect.insetBy(dx: 220, dy: 220))
NSGradient(colors: [
    color(1, 1, 1, 0.98),
    color(0.22, 0.9, 1, 0.85),
    color(0.95, 0.3, 0.76, 0.45),
    color(0.56, 0.44, 1, 0.08)
])?.draw(in: glow, relativeCenterPosition: NSPoint(x: -0.1, y: 0.15))

let paragraph = NSMutableParagraphStyle()
paragraph.alignment = .center

let textShadow = NSShadow()
textShadow.shadowColor = color(0.22, 0.9, 1, 0.58)
textShadow.shadowBlurRadius = 34
textShadow.shadowOffset = .zero

let titleAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 188, weight: .black),
    .paragraphStyle: paragraph,
    .foregroundColor: NSColor.white,
    .shadow: textShadow
]
NSAttributedString(string: "WW", attributes: titleAttributes)
    .draw(in: NSRect(x: 112, y: 488, width: 800, height: 220))
NSAttributedString(string: "DC26", attributes: titleAttributes)
    .draw(in: NSRect(x: 112, y: 318, width: 800, height: 230))

let badgeAttributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.monospacedSystemFont(ofSize: 42, weight: .bold),
    .paragraphStyle: paragraph,
    .foregroundColor: color(1, 1, 1, 0.82),
    .kern: 7
]
NSAttributedString(string: "JUN 8", attributes: badgeAttributes)
    .draw(in: NSRect(x: 220, y: 230, width: 584, height: 74))

image.unlockFocus()

guard
    let tiffData = image.tiffRepresentation,
    let representation = NSBitmapImageRep(data: tiffData),
    let pngData = representation.representation(using: .png, properties: [:])
else {
    fatalError("Unable to generate icon")
}

try pngData.write(to: URL(fileURLWithPath: outputPath))
