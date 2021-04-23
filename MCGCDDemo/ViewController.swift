//
//  ViewController.swift
//  MCGCDDemo
//
//  Created by xthk_lmc on 2021/4/16.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        syncConcurrent()
//        asyncConcurrent()
//        syncSerial()
//        asyncSerial()
//        syncMain()
//        syncMainOtherThread()
//        asyncConcurrentBarrier()
//        dispatchApply()
        diapatchGroup()
    }
    
    /// 同步执行任务+并发队列
    private func syncConcurrent() {
        print("开始====\(Thread.current)")
        let queue = DispatchQueue.global(qos: .default)
        queue.sync {
            Thread.sleep(forTimeInterval: 2)
            print("1====\(Thread.current)")
        }
        queue.sync {
            Thread.sleep(forTimeInterval: 2)
            print("2====\(Thread.current)")
        }
        queue.sync {
            Thread.sleep(forTimeInterval: 2)
            print("3====\(Thread.current)")
        }
        print("结束====\(Thread.current)")
    }
    
    /// 异步任务执行+并发队列
    private func asyncConcurrent() {
        
        print("开始====\(Thread.current)")
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("1====\(Thread.current)")
        }
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("2====\(Thread.current)")
        }
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("3====\(Thread.current)")
        }
        print("结束====\(Thread.current)")
        
    }
    
    /// 同步任务执行+串行队列
    private func syncSerial() {
        print("开始====\(Thread.current)")
        // attributes: .concurrent为并发队列， 不写attributes这个参数就代表是串行队列（默认是串行队列）
        let queue = DispatchQueue(label: "", qos: .default)
        
        queue.sync {
            Thread.sleep(forTimeInterval: 2)
            print("1====\(Thread.current)")
        }
        queue.sync {
            Thread.sleep(forTimeInterval: 2)
            print("2====\(Thread.current)")
        }
        queue.sync {
            Thread.sleep(forTimeInterval: 2)
            print("3====\(Thread.current)")
        }
        print("结束====\(Thread.current)")
    }
    
    /// 异步执行任务+串行队列
    private func asyncSerial() {
        print("开始====\(Thread.current)")
        // attributes: .concurrent为并发队列， 不写attributes这个参数就代表是串行队列（默认是串行队列）
        let queue = DispatchQueue(label: "", qos: .default)
        
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("1====\(Thread.current)")
        }
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("2====\(Thread.current)")
        }
        queue.async {
            Thread.sleep(forTimeInterval: 2)
            print("3====\(Thread.current)")
        }
        print("结束====\(Thread.current)")
    }
    
    /// 主线程中 同步任务执行+主队列，相互等待崩溃
    private func syncMain() {
        print("开始====\(Thread.current)")
        let queue = DispatchQueue.main
        queue.sync {
            Thread.sleep(forTimeInterval: 1)
            print("1====\(Thread.current)")
        }
        print("结束====\(Thread.current)")
    }
    
    /// 子线程中 同步任务执行+主队列
    private func syncMainOtherThread() {
        
        let globalQueue = DispatchQueue.global(qos: .default)
        globalQueue.async {
            print("开始====\(Thread.current)")
            let queue = DispatchQueue.main
            queue.sync {
                Thread.sleep(forTimeInterval: 1)
                print("1====\(Thread.current)")
            }
            queue.sync {
                Thread.sleep(forTimeInterval: 1)
                print("2====\(Thread.current)")
            }
            queue.sync {
                Thread.sleep(forTimeInterval: 1)
                print("3====\(Thread.current)")
            }
            print("结束====\(Thread.current)")
        }
        
//        Thread.detachNewThread {
//            print("开始====\(Thread.current)")
//            let queue = DispatchQueue.main
//            queue.sync {
//                Thread.sleep(forTimeInterval: 1)
//                print("1====\(Thread.current)")
//            }
//            queue.sync {
//                Thread.sleep(forTimeInterval: 1)
//                print("2====\(Thread.current)")
//            }
//            queue.sync {
//                Thread.sleep(forTimeInterval: 1)
//                print("3====\(Thread.current)")
//            }
//            print("结束====\(Thread.current)")
//        }
        
    }
    
    /// 栅栏函数：如果要让任务3一定在任务1和任务2之后执行，那就可以用栅栏函数，栅栏函数在普通的队列有效，但在全局队列globlequeue里面不生效，因为全局队列是不受拦截，全局就一个，给拦截的那程序整个都会被卡主，所以系统不让栅栏函数拦截全局队列里面的任务
    /// 异步任务+同步队列
    private func asyncConcurrentBarrier() {
        let queue = DispatchQueue(label: "普通同步队列栅栏函数", qos: .default, attributes: .concurrent)
//        let queue = DispatchQueue.global(qos: .default)
        print("开始====\(Thread.current)")
        queue.async {
            Thread.sleep(forTimeInterval: 1)
            print("1====\(Thread.current)")
        }
        queue.async {
            Thread.sleep(forTimeInterval: 1)
            print("2====\(Thread.current)")
        }
        
        queue.async(flags: .barrier) {
            Thread.sleep(forTimeInterval: 1)
            print("barrier====\(Thread.current)")
        }
        
        queue.async {
            Thread.sleep(forTimeInterval: 1)
            print("3====\(Thread.current)")
        }
        
    }
    
    /// OC中的dispatch_apply
    /// 这是因为 dispatch_apply 方法会等待全部任务执行完毕。
    private func dispatchApply() {
        print("开始====\(Thread.current)")
        DispatchQueue.concurrentPerform(iterations: 5) { (index) in
            Thread.sleep(forTimeInterval: 1)
            print("concurrentPerform====\(Thread.current)")
        }
        print("结束====\(Thread.current)")
    }
    
    /// 队列组
    private func diapatchGroup() {
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: .default)
        
        queue.async(group: group) {
            Thread.sleep(forTimeInterval: 1)
            print("1====\(Thread.current)")
        }
        
        queue.async(group: group) {
            Thread.sleep(forTimeInterval: 2)
            print("2====\(Thread.current)")
        }
        
        queue.async(group: group) {
            Thread.sleep(forTimeInterval: 3)
            print("3====\(Thread.current)")
        }
        
        group.notify(queue: DispatchQueue.main) {
            print("end====\(Thread.current)")
        }
        
    }

}

