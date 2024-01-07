import SnapKit
import UIKit

final class ImageGalleryController: UIPageViewController {
    private var imageURLs: [URL] = []
    private var pageControllers: [UIViewController] = []

    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = .cherryMainAccent
        pageControl.pageIndicatorTintColor = .cherryGrayBlue

        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupUI()
    }

    // передать сюда адреса картинок для галереи
    func setURLs(urls: [String]) {
        imageURLs = []
        urls.forEach {
            if let url = URL(string: $0) {
                imageURLs.append(url)
            }
        }
        setupPages()
    }

    // первоначальная настройка
    private func setupUI() {
        view.layer.cornerRadius = CornerRadius.regular.cgFloat()
        view.backgroundColor = .cherryLightBlue
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.centerX.equalToSuperview()
        }
    }

    private func setupPages() {
        for index in 0..<imageURLs.count {
            if let pageVC = contentViewController(at: index) {
                pageControllers.append(pageVC)
            }
        }
        if !pageControllers.isEmpty {
            pageControl.numberOfPages = pageControllers.count
            pageControl.isHidden = pageControllers.count < 2
            view.isUserInteractionEnabled = pageControllers.count > 1
            setupIndicatorsForPage(0)
            setViewControllers([pageControllers[0]], direction: .forward, animated: true, completion: nil)
        }
    }

    private func contentViewController(at index: Int) -> GalleryPageViewController? {
        guard index >= 0 && index < imageURLs.count else { return nil }

        let contentViewController = GalleryPageViewController()
        contentViewController.imageURL = imageURLs[index]
        contentViewController.pageIndex = index
        return contentViewController
    }
}

// MARK: - UIPageViewControllerDataSource

extension ImageGalleryController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let contentViewController = viewController as? GalleryPageViewController,
           let index = contentViewController.pageIndex,
           index > 0 {
            return pageControllers[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let contentViewController = viewController as? GalleryPageViewController,
           let index = contentViewController.pageIndex,
           index < pageControllers.count - 1 {
            return pageControllers[index + 1]
        }
        return nil
    }
}

// MARK: - настройка PageControl

extension ImageGalleryController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first as? GalleryPageViewController,
           let currentIndex = pageControllers.firstIndex(of: currentViewController) {
            setupIndicatorsForPage(currentIndex)
            pageControl.currentPage = currentIndex
        }
    }

    private func setupIndicatorsForPage(_ index: Int) {
        if let allPages = pageControllers as? [GalleryPageViewController] {
            for page in allPages {
                if let pageIndex = page.pageIndex {
                    if pageIndex == index {
                        pageControl.setIndicatorImage(UIImage.currentPageIndicator, forPage: pageIndex)
                    } else {
                        pageControl.setIndicatorImage(UIImage.otherPageIndicator, forPage: pageIndex)
                    }
                }
            }
        }
    }
}
