//
//  AppDelegate.swift
//  Quick Look
//
//  Created by Theodore Dubois on 9/15/24.
//

import UIKit
import QuickLook

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.window = UIWindow()
        self.window?.rootViewController = DocumentBrowserViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Ensure the URL is a file URL
        guard inputURL.isFileURL else { return false }
                
        guard let documentBrowserViewController = window?.rootViewController as? DocumentBrowserViewController else { return false }
        documentBrowserViewController.presentDocument(at: inputURL)

        return true
    }
}


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self

        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
    }


    // MARK: UIDocumentBrowserViewControllerDelegate

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }

        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }

    func presentDocument(at documentURL: URL) {
        let qlController = PreviewController(url: documentURL)
        qlController.modalPresentationStyle = .fullScreen
        present(qlController, animated: true, completion: nil)
    }
}

class PreviewController: QLPreviewController, QLPreviewControllerDataSource {
    var url: URL
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
        URLPreviewItem(previewItemURL: url)
    }

    class URLPreviewItem: NSObject, QLPreviewItem {
        var previewItemURL: URL?
        init(previewItemURL: URL) {
            self.previewItemURL = previewItemURL
        }
    }
}

