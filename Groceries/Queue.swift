// The MIT License (MIT)
//
// Copyright (c) 2014 Thomas Visser
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Dispatch

/// Queue is a tiny wrapper around a Grand Central Dispatch queue.
/// Queue provides a nice syntax for scheduling (async) execution of closures.
///
/// q.async {
///     // executes asynchronously
/// }
///
///
/// It also simplifies executing a closure synchronously and getting the
/// return value from the closure:
///
/// let n = q.sync {
///     return 42
/// }
///
public struct Queue {
  
  /// The queue that is bound to the main thread (`dispatch_get_main_queue()`)
  public static let main = Queue(queue: dispatch_get_main_queue());
  
  /// The global queue with default priority
  public static let global = Queue(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
  
  /// The underlying `dispatch_queue_t`
  private(set) public var underlyingQueue: dispatch_queue_t
  
  public init() {
    self.init(queueLabel: "queue")
  }
  
  public init(queueLabel: String, attributes: dispatch_queue_attr_t! = DISPATCH_QUEUE_SERIAL) {
    self.init(queue: dispatch_queue_create(queueLabel, attributes))
  }
  
  /// Instantiates a new `Queue` with the given queue.
  /// If `queue` is omitted, a serial queue with identifier "queue" is used.
  public init(queue: dispatch_queue_t) {
    self.underlyingQueue = queue
  }
  
  /// Synchronously executes the given closure on this queue.
  /// Analogous to dispatch_sync(self.underlyingQueue, block)
  public func sync(block: () -> Void) {
    dispatch_sync(underlyingQueue, block)
  }
  
  /// Synchronously executes the given closure on this queue
  /// If the closure throws an error, the error is rethrown to the caller.
  /// Note: we cannot use the rethrows key here because we are not
  /// directly executing the closure. (It is passed to `dispatch_sync`)
  public func sync(block: () throws -> Void) throws {
    var error: ErrorType?
    
    sync {
      do {
        try block()
      } catch let e {
        error = e
      }
    }
    
    if let error = error {
      throw error
    }
  }
  
  /// Synchronously executes the given closure on this queue and returns
  /// the return value of the given closure.
  public func sync<T>(block: () -> T) -> T {
    var res: T? = nil
    
    sync {
      res = block()
    }
    
    return res!;
  }
  
  /// Asynchronously executes the given closure on this queue.
  /// Analogous to dispatch_async(self.underlyingQueue, block)
  public func async(block: () -> Void) {
    dispatch_async(underlyingQueue, block)
  }
  
}