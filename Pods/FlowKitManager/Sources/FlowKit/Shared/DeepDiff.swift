//
//	Flow
//	A declarative approach to UICollectionView & UITableView management
//	--------------------------------------------------------------------
//	Created by:	Daniele Margutti
//				hello@danielemargutti.com
//				http://www.danielemargutti.com
//
//	DeepDiff is a project by Khoa - https://github.com/onmyway133/DeepDiff
//
//	Twitter:	@danielemargutti
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

import Foundation

// https://gist.github.com/ndarville/3166060

/// Perform diff between old and new collections
///
/// - Parameters:
///   - old: Old collection
///   - new: New collection
/// - Returns: A set of changes
internal func diff(
	old: [ModelProtocol],
	new: [ModelProtocol],
	algorithm: DiffAware = Heckel()) -> [Change<ModelProtocol>] {
	
	if let changes = algorithm.preprocess(old: old, new: new) {
		return changes
	}
	
	return algorithm.diff(old: old, new: new)
}

internal struct Insert<T> {
	let item: T
	let index: Int
}

internal struct Delete<T> {
	let item: T
	let index: Int
}

internal struct Replace<T> {
	let oldItem: T
	let newItem: T
	let index: Int
}

internal struct Move<T> {
	let item: T
	let fromIndex: Int
	let toIndex: Int
}

/// The computed changes from diff
///
/// - insert: Insert an item at index
/// - delete: Delete an item from index
/// - replace: Replace an item at index with another item
/// - move: Move the same item from this index to another index
internal enum Change<T> {
	case insert(Insert<T>)
	case delete(Delete<T>)
	case replace(Replace<T>)
	case move(Move<T>)
	
	var insert: Insert<T>? {
		if case .insert(let insert) = self {
			return insert
		}
		
		return nil
	}
	
	var delete: Delete<T>? {
		if case .delete(let delete) = self {
			return delete
		}
		
		return nil
	}
	
	var replace: Replace<T>? {
		if case .replace(let replace) = self {
			return replace
		}
		
		return nil
	}
	
	var move: Move<T>? {
		if case .move(let move) = self {
			return move
		}
		
		return nil
	}
}

internal protocol DiffAware {
	func diff(old: [ModelProtocol], new: [ModelProtocol]) -> [Change<ModelProtocol>]
}

extension DiffAware {
	func preprocess(old: [ModelProtocol], new: [ModelProtocol]) -> [Change<ModelProtocol>]? {
		switch (old.isEmpty, new.isEmpty) {
		case (true, true):
			// empty
			return []
		case (true, false):
			// all .insert
			return new.enumerated().map { index, item in
				return .insert(Insert(item: item, index: index))
			}
		case (false, true):
			// all .delete
			return old.enumerated().map { index, item in
				return .delete(Delete(item: item, index: index))
			}
		default:
			return nil
		}
	}
}

internal final class Heckel: DiffAware {
	
	// OC and NC can assume three values: 1, 2, and many.
	enum Counter {
		case zero, one, many
		
		func increment() -> Counter {
			switch self {
			case .zero:
				return .one
			case .one:
				return .many
			case .many:
				return self
			}
		}
	}
	
	// The symbol table stores three entries for each line
	class TableEntry: Equatable {
		// The value entry for each line in table has two counters.
		// They specify the line's number of occurrences in O and N: OC and NC.
		var oldCounter: Counter = .zero
		var newCounter: Counter = .zero
		
		// Aside from the two counters, the line's entry
		// also includes a reference to the line's line number in O: OLNO.
		// OLNO is only interesting, if OC == 1.
		// Alternatively, OLNO would have to assume multiple values or none at all.
		var indexesInOld: [Int] = []
		
		static func ==(lhs: TableEntry, rhs: TableEntry) -> Bool {
			return lhs.oldCounter == rhs.oldCounter && lhs.newCounter == rhs.newCounter && lhs.indexesInOld == rhs.indexesInOld
		}
	}
	
	// The arrays OA and NA have one entry for each line in their respective files, O and N.
	// The arrays contain either:
	enum ArrayEntry: Equatable {
		// a pointer to the line's symbol table entry, table[line]
		case tableEntry(TableEntry)
		
		// the line's number in the other file (N for OA, O for NA)
		case indexInOther(Int)
		
		static func == (lhs: ArrayEntry, rhs: ArrayEntry) -> Bool {
			switch (lhs, rhs) {
			case (.tableEntry(let l), .tableEntry(let r)):
				return l == r
			case (.indexInOther(let l), .indexInOther(let r)):
				return l == r
			default:
				return false
			}
		}
	}
	
	init() {}
	
	func diff(old: [ModelProtocol], new: [ModelProtocol]) -> [Change<ModelProtocol>] {
		// The Symbol Table
		// Each line works as the key in the table look-up, i.e. as table[line].
		var table: [Int: TableEntry] = [:]
		
		// The arrays OA and NA have one entry for each line in their respective files, O and N
		var oldArray = [ArrayEntry]()
		var newArray = [ArrayEntry]()
		
		perform1stPass(new: new, table: &table, newArray: &newArray)
		perform2ndPass(old: old, table: &table, oldArray: &oldArray)
		perform345Pass(newArray: &newArray, oldArray: &oldArray)
		let changes = perform6thPass(new: new, old: old, newArray: newArray, oldArray: oldArray)
		return changes
	}
	
	private func perform1stPass(
		new: [ModelProtocol],
		table: inout [Int: TableEntry],
		newArray: inout [ArrayEntry]) {
		
		// 1st pass
		// a. Each line i of file N is read in sequence
		new.forEach { item in
			// b. An entry for each line i is created in the table, if it doesn't already exist
			let entry = table[item.modelID] ?? TableEntry()
			
			// c. NC for the line's table entry is incremented
			entry.newCounter = entry.newCounter.increment()
			
			// d. NA[i] is set to point to the table entry of line i
			newArray.append(.tableEntry(entry))
			
			//
			table[item.modelID] = entry
		}
	}
	
	private func perform2ndPass(
		old: [ModelProtocol],
		table: inout [Int: TableEntry],
		oldArray: inout [ArrayEntry]) {
		
		// 2nd pass
		// Similar to first pass, except it acts on files
		
		old.enumerated().forEach { tuple in
			// old
			let entry = table[tuple.element.modelID] ?? TableEntry()
			
			// oldCounter
			entry.oldCounter = entry.oldCounter.increment()
			
			// lineNumberInOld which is set to the line's number
			entry.indexesInOld.append(tuple.offset)
			
			// oldArray
			oldArray.append(.tableEntry(entry))
			
			//
			table[tuple.element.modelID] = entry
		}
	}
	
	private func perform345Pass(newArray: inout [ArrayEntry], oldArray: inout [ArrayEntry]) {
		// 3rd pass
		// a. We use Observation 1:
		// If a line occurs only once in each file, then it must be the same line,
		// although it may have been moved.
		// We use this observation to locate unaltered lines that we
		// subsequently exclude from further treatment.
		// b. Using this, we only process the lines where OC == NC == 1
		// c. As the lines between O and N "must be the same line,
		// although it may have been moved", we alter the table pointers
		// in OA and NA to the number of the line in the other file.
		// d. We also locate unique virtual lines
		// immediately before the first and
		// immediately after the last lines of the files ???
		//
		// 4th pass
		// a. We use Observation 2:
		// If a line has been found to be unaltered,
		// and the lines immediately adjacent to it in both files are identical,
		// then these lines must be the same line.
		// This information can be used to find blocks of unchanged lines.
		// b. Using this, we process each entry in ascending order.
		// c. If
		// NA[i] points to OA[j], and
		// NA[i+1] and OA[j+1] contain identical table entry pointers
		// then
		// OA[j+1] is set to line i+1, and
		// NA[i+1] is set to line j+1
		//
		// 5th pass
		// Similar to fourth pass, except:
		// It processes each entry in descending order
		// It uses j-1 and i-1 instead of j+1 and i+1
		
		newArray.enumerated().forEach { (indexOfNew, item) in
			switch item {
			case .tableEntry(let entry):
				guard !entry.indexesInOld.isEmpty else {
					return
				}
				let indexOfOld = entry.indexesInOld.removeFirst()
				let isObservation1 = entry.newCounter == .one && entry.oldCounter == .one
				let isObservation2 = entry.newCounter != .zero && entry.oldCounter != .zero && newArray[indexOfNew] == oldArray[indexOfOld]
				guard isObservation1 || isObservation2 else {
					return
				}
				newArray[indexOfNew] = .indexInOther(indexOfOld)
				oldArray[indexOfOld] = .indexInOther(indexOfNew)
			case .indexInOther(_):
				break
			}
		}
	}
	
	private func perform6thPass(
		new: [ModelProtocol],
		old: [ModelProtocol],
		newArray: [ArrayEntry],
		oldArray: [ArrayEntry]) -> [Change<ModelProtocol>] {
		
		// 6th pass
		// At this point following our five passes,
		// we have the necessary information contained in NA to tell the differences between O and N.
		// This pass uses NA and OA to tell when a line has changed between O and N,
		// and how far the change extends.
		
		// a. Determining a New Line
		// Recall our initial description of NA in which we said that the array has either:
		// one entry for each line of file N containing either
		// a pointer to table[line]
		// the line's number in file O
		
		// Using these two cases, we know that if NA[i] refers
		// to an entry in table (case 1), then line i must be new
		// We know this, because otherwise, NA[i] would have contained
		// the line's number in O (case 2), if it existed in O and N
		
		// b. Determining the Boundaries of the New Line
		// We now know that we are dealing with a new line, but we have yet to figure where the change ends.
		// Recall Observation 2:
		
		// If NA[i] points to OA[j], but NA[i+1] does not
		// point to OA[j+1], then line i is the boundary for the alteration.
		
		// You can look at it this way:
		// i  : The quick brown fox      | j  : The quick brown fox
		// i+1: jumps over the lazy dog  | j+1: jumps over the loafing cat
		
		// Here, NA[i] == OA[j], but NA[i+1] != OA[j+1].
		// This means our boundary is between the two lines.
		
		var changes = [Change<ModelProtocol>]()
		var deleteOffsets = Array(repeating: 0, count: old.count)
		
		// deletions
		do {
			var runningOffset = 0
			
			oldArray.enumerated().forEach { oldTuple in
				deleteOffsets[oldTuple.offset] = runningOffset
				
				guard case .tableEntry = oldTuple.element else {
					return
				}
				
				changes.append(.delete(Delete(
					item: old[oldTuple.offset],
					index: oldTuple.offset
				)))
				
				runningOffset += 1
			}
		}
		
		// insertions, replaces, moves
		do {
			var runningOffset = 0
			
			newArray.enumerated().forEach { newTuple in
				switch newTuple.element {
				case .tableEntry:
					runningOffset += 1
					changes.append(.insert(Insert(
						item: new[newTuple.offset],
						index: newTuple.offset
					)))
				case .indexInOther(let oldIndex):
					if old[oldIndex].modelID != new[newTuple.offset].modelID {
						changes.append(.replace(Replace(
							oldItem: old[oldIndex],
							newItem: new[newTuple.offset],
							index: newTuple.offset
						)))
					}
					
					let deleteOffset = deleteOffsets[oldIndex]
					// The object is not at the expected position, so move it.
					if (oldIndex - deleteOffset + runningOffset) != newTuple.offset {
						changes.append(.move(Move(
							item: new[newTuple.offset],
							fromIndex: oldIndex,
							toIndex: newTuple.offset
						)))
					}
				}
			}
		}
		
		return changes
	}
}
