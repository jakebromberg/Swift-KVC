extension Sequence {
	func findMatch(_ matcher: (Iterator.Element) -> Bool) -> Iterator.Element? {
		for element in self where matcher(element) {
			return element
		}
		
		return nil
	}
}

protocol KeyValueCoding {
	func valueFor<T>(keyPath: String) -> T?
}

extension KeyValueCoding {
	func valueFor<T>(keyPath: String) -> T? {
		let keys : [String] = keyPath.characters.split(separator: ".").map(String.init)

		var value : Any = self

        for key in keys {
            let mirror = Mirror(reflecting: value)
            
			if let child = mirror.children.findMatch({ $0.label == key }) {
				value = child.1
			} else {
				return nil
			}
		}
		
		return value as? T
	}
}

struct A : KeyValueCoding {
	struct B {
		let asdf : String
	}
	
	let aaa : B
}

let a = A(aaa: A.B(asdf: "HI"))
if let b : String = a.valueFor(keyPath: "aaa.asdf") {
    print(b)
}
