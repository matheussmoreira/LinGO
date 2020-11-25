////
////  OnboardViewController.swift
////  BarreirasLinguisticas
////
////  Created by Matheus S. Moreira on 18/08/20.
////  Copyright © 2020 Matheus S. Moreira. All rights reserved.
////
//
//import SwiftUI
//
//struct OnboardViewController: UIViewControllerRepresentable {
//    
//    var controllers: [UIViewController]
//    
//    @Binding var currentPage: Int
//
//    
//    func makeUIViewController(context: Context) -> UIPageViewController {
//        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//        pageViewController.dataSource = context.coordinator
//        pageViewController.delegate = context.coordinator
//        controllers.forEach({$0.view.backgroundColor = UIColor(named: "bgColor") })
//        pageViewController.view.backgroundColor = UIColor(named: "bgColor")
//        return pageViewController
//    }
//    
//    func updateUIViewController(_ pageViewController: UIPageViewController, context: UIViewControllerRepresentableContext<OnboardViewController>) {
//        pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true)
//    }
//    
//    
//    func makeCoordinator() -> OnboardViewController.Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//        
//        var parent: OnboardViewController
//        
//        init(_ controller: OnboardViewController) {
//            self.parent = controller
//        }
//        
//        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//            guard let index  = parent.controllers.firstIndex(of: viewController) else {
//                return nil
//            }
//            
//            if index == 0 {
//                return nil
//            }
//            return parent.controllers[index - 1]
//        }
//        
//        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//            guard let index  = parent.controllers.firstIndex(of: viewController) else {
//                return nil
//            }
//            
//            if index == parent.controllers.count - 1{
//                return nil
//            }
//                      
//            return parent.controllers[index + 1]
//        }
//        
//        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//            if completed,
//                let visibleViewController = pageViewController.viewControllers?.first,
//                let index = parent.controllers.firstIndex(of: visibleViewController) {
//                parent.currentPage = index
//            }
//        }
//    }
//}
//
//struct OnboardViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
//    }
//}
