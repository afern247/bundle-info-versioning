import Foundation

public class BundleInfoObserver {

    internal let bundle: Bundle
    internal let storage: Storage

    public init(bundle: Bundle, storage: Storage = FileStorage()) {
        self.bundle = bundle
        self.storage = storage
    }

    public func observerChange<T: Comparable>(forKeyPath keyPath: String, callback: (_ storedValue: T?, _ currentValue: T?) -> Void) {

        let currentValue: T? = getBundleInfoValue(for: keyPath)
        let storedValue: T? = storage.getValue(for: keyPath)
        
        guard currentValue != storedValue else { return }
        
        callback(storedValue, currentValue)
        storage.set(value: currentValue, for: keyPath)
    }
    
    private func getBundleInfoValue<T>(for keyPath: String) -> T? {
       
        guard let infoDic = bundle.infoDictionary else { preconditionFailure("Bundle is missing the info dictionary.") }
    
        return (infoDic as NSDictionary).value(forKeyPath: keyPath) as? T
    }
}
