import Swift

extension SequenceType {
	func findMatch(matcher: Self.Generator.Element -> Bool) -> Self.Generator.Element? {
		for element in self where matcher(element) {
			return element
		}
		
		return nil
	}
}

protocol KeyValueCoding {
	func valueForKeyPath(keyPath : String) -> Any?
}

extension KeyValueCoding {
	func valueForKeyPath(keyPath : String) -> Any? {
		
		let _keyPath : [String] = keyPath.characters.split(".").map { String.init($0) }

		var mirror = Mirror(reflecting: self)
		var value : Any? = nil
		for kp in _keyPath {
			if let (label, val) = mirror.children.findMatch({ $0.label == kp }) {
				print(label)
				mirror = Mirror(reflecting: val)
				value = val
			} else {
				return nil
			}
		}
		
		return value
	}
}

struct A : KeyValueCoding {
	struct B {
		let asdf : String
	}
	
	let aaa : B
}

let a = A(aaa: A.B(asdf: "HI"))
a.valueForKeyPath("aaa.asdf")
