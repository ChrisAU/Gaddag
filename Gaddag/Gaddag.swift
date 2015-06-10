//
//  Gaddag.swift
//  Locution
//
//  Created by Chris Nevin on 9/06/2015.
//  Copyright (c) 2015 CJNevin. All rights reserved.
//
//  Adapted from https://nullwords.wordpress.com/2013/02/27/gaddag-data-structure/

import Foundation

class Gaddag {
	let rootNode: Node
	init() {
		rootNode = Node(Node.Root)
	}
	func add(word: String) {
		var prevNode = [Node]()
		var chars = Array(word.utf8)
		for var i = 0; i < chars.count; i++ {
			autoreleasepool {
				var wordChars = [UInt8]()
				for var z = i; z >= 0; z-- {
					wordChars.append(chars[z])
				}
				wordChars.append(Node.Break)
				for var z = i + 1; z < chars.count; z++ {
					wordChars.append(chars[z])
				}
				wordChars.append(Node.Eow)
				var currentNode = rootNode
				var breakFound = false
				var j = 0
				for c in wordChars {
					if breakFound && prevNode.count > j {
						currentNode.addChild(c, node: prevNode[j])
						break
					}
					currentNode = currentNode.addChild(c)
					if prevNode.count == j {
						prevNode.append(currentNode)
					}
					if c == Node.Break {
						breakFound = true
					}
					j++
				}
			}
		}
	}
	
	private static func getWord(charArray: [UInt8]) -> String {
		var word = ""
		if let nodeBreakIndex = find(charArray, Node.Break) {
			var newBytes = [UInt8]()
			for var i = nodeBreakIndex - 1; i >= 0; i-- {
				newBytes.append(charArray[i])
			}
			for var i: Int = nodeBreakIndex + 1; i < charArray.count; i++ {
				newBytes.append(charArray[i])
			}
			if let w = String(bytes: newBytes, encoding: NSUTF8StringEncoding) {
				word = w
			}
		}
		return word
	}
	
	func wordDefined(word: String) -> Bool {
		return contains(findWords("", rack: word), word.lowercaseString)
	}
	
	func findWords(hook: String, rack: String) -> [String] {
		var h = reverse(Array(hook.lowercaseString.utf8))
		var r = Array(rack.lowercaseString.utf8)
		var letters = [UInt8]()
		var set = Set<String>()
		Gaddag.findWordsRecursive(rootNode, rtn: &set, letters: letters, rack: r, hook: h)
		return Array(set)
	}
	
	private static func findWordsRecursive(node: Node, inout rtn: Set<String>, letters: [UInt8], rack: [UInt8], hook: [UInt8]) {
		if node.value == Node.Eow {
			var w = getWord(letters)
			if !rtn.contains(w) {
				rtn.insert(w)
			}
			return
		}
		if !hook.isEmpty {
			var newLetters = letters
			if node.value != Node.Root {
				newLetters.append(node.value)
			}
			var h = hook
			if node.containsKey(h[0]) {
				h.removeAtIndex(0)
				if !h.isEmpty {
					if let n = node[h[0]] {
						findWordsRecursive(n, rtn: &rtn, letters: newLetters, rack: rack, hook: h)
					}
				}
			}
		} else {
			var newLetters = letters
			if node.value != Node.Root {
				newLetters.append(node.value)
			}
			for key in node.children.keys.array.filter({ contains(rack, $0) || $0 == Node.Eow || $0 == Node.Break }) {
				var r = rack
				if key != Node.Eow && key != Node.Break {
					if let i = find(r, key) {
						r.removeAtIndex(i)
					}
				}
				if let n = node[key] {
					findWordsRecursive(n, rtn: &rtn, letters: newLetters, rack: r, hook: hook)
				}
			}
		}
	}
	
	class Node {
		typealias NodeDictionary = [UInt8: Node]
		static let Break: UInt8 = 62 //">"
		static let Eow: UInt8 = 36 //"$"
		static let Root: UInt8 = 32 //" "
		let value: UInt8
		lazy private var children = NodeDictionary()
		
		init(_ value: UInt8) {
			self.value = value
		}
		
		subscript(value: UInt8) -> Node? {
			return children[value]
		}
		
		func containsKey(value: UInt8) -> Bool {
			return children[value] != nil
		}
		
		func addChild(value: UInt8) -> Node {
			var node = children[value]
			if node == nil {
				node = Node(value)
				children.updateValue(node!, forKey: value)
			}
			return node!
		}
		
		func addChild(value: UInt8, node: Node) -> Node {
			if !containsKey(value) {
				children.updateValue(node, forKey: value)
				return node
			}
			return children[value]!
		}
	}
}