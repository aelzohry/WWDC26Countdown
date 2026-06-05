import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSPopoverDelegate {
    private var mainWindow: NSWindow?
    private var statusItem: NSStatusItem?
    private var statusPopover: NSPopover?
    private var statusTimer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        NSApp.applicationIconImage = NSImage(named: "AppIcon")

        configureStatusItem()
        showMainWindow()
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showMainWindow()
        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        statusTimer?.invalidate()
    }

    func showMainWindow() {
        if mainWindow == nil {
            let hostingController = NSHostingController(rootView: ContentView())
            let window = NSWindow(contentViewController: hostingController)
            window.title = "WWDC26 Countdown"
            window.setContentSize(NSSize(width: 980, height: 680))
            window.minSize = NSSize(width: 900, height: 620)
            window.center()
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.insert(.fullSizeContentView)
            window.isReleasedWhenClosed = false
            window.delegate = self
            mainWindow = window
        }

        mainWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(nil)
        return false
    }

    private func configureStatusItem() {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem = statusItem

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "sparkles", accessibilityDescription: "WWDC26 Countdown")
            button.imagePosition = .imageLeading
            button.action = #selector(toggleStatusPopover(_:))
            button.target = self
        }

        let popover = NSPopover()
        popover.behavior = .transient
        popover.delegate = self
        popover.contentSize = NSSize(width: 330, height: 232)
        popover.contentViewController = NSHostingController(
            rootView: MenuBarCountdownView(
                openMainWindow: { [weak self] in
                    self?.showMainWindow()
                    self?.statusPopover?.performClose(nil)
                },
                dismissMenu: { [weak self] in
                    self?.statusPopover?.performClose(nil)
                }
            )
        )
        statusPopover = popover

        updateStatusTitle()
        statusTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateStatusTitle()
            }
        }
    }

    @objc private func toggleStatusPopover(_ sender: NSStatusBarButton) {
        guard let statusPopover else { return }

        if statusPopover.isShown {
            statusPopover.performClose(sender)
        } else {
            statusPopover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .minY)
            statusPopover.contentViewController?.view.window?.makeKey()
        }
    }

    private func updateStatusTitle() {
        let snapshot = CountdownSnapshot(now: Date(), target: EventDates.wwdc26Keynote)
        statusItem?.button?.title = " " + snapshot.menuBarTitle
    }
}
