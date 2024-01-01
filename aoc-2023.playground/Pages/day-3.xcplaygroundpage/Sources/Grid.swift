/// Represents a point on a grid.
///
/// - Note: Instances of this type are not bound to any particular Grid and may be invalid depending on the size of the grid.
///
public struct GridCoordinate: Equatable, Hashable, CustomStringConvertible {
        
    /// The column (East/West) position of this coordinate.
    public let x: Int
    
    /// The row (North/South) position of this coordinate.
    public let y: Int
    
    /// Create a new instance of GridCoordinate.
    ///
    /// - Parameters:
    ///     - x: The horizontal component of the coordinate.
    ///     - y: The vertical component of the coordinate.
    ///
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
        
    /// Scales the x and y components of the coordinate by the scale value.
    ///
    /// - Parameter scale: The multiplier applied to the x and y components.
    /// - Returns: A new `GridCoordinage` with the scaled components.
    ///
    public func scaledBy(_ scale: Int) -> GridCoordinate {
        GridCoordinate(x: x * scale, y: y * scale)
    }
    
    /// Tests if two GridCoordinates are adjacent.
    ///
    /// - Parameters:
    ///     - other: The other GridCoordinate to test against.
    ///     - allowDiagonalAdjacency: When `true`, coordinates sharing a corner will be considered adjacent.
    ///                               When `false`, only coordinates sharing an edge will be considered adjacent.
    ///
    /// - Returns: `true` if the coordinates are adjacent, otherwise returns `false`.
    ///
    public func isAdjacentTo(_ other: GridCoordinate, allowDiagonalAdjacency: Bool = false) -> Bool {
        
        // A coordinate cannot be adjacent to itself.
        guard self != other else { return false }
        
        let dx = abs(x - other.x)
        let dy = abs(y - other.y)
        
        if allowDiagonalAdjacency {
            return dx <= 1 && dy <= 1
        } else {
            return dx <= 1 && dy == 0 || dx == 0 && dy <= 1
        }
    }
    
    /// Test if two coordinates are adjacent within the same grid row.
    ///
    /// - Parameter other: The other coordinate to test against.
    ///
    /// - Returns: `true` if the coordinates are adjacent, otherwise returns `false`.
    ///
    public func isHorizontallyAdjacentTo(_ other: GridCoordinate) -> Bool {
        // If they're not in the same row, return false.
        guard self.y == other.y else { return false }
        // If the x distance is 0, they're the same point. If it's greater than 1, they don't touch.
        return abs(self.x - other.x) == 1
    }
    
    /// Test if two coordinates are adjacent within the same grid column.
    ///
    /// - Parameter other: The other coordinate to test against.
    ///
    /// - Returns: `true` if the coordinates are adjacent, otherwise returns `false`.
    ///
    public func isVerticallyAdjacentTo(_ other: GridCoordinate) -> Bool {
        // If they're not in the same column, return false.
        guard self.x == other.x else { return false }
        // If the y distance is 0, they're the same point. If it's greater than 1, they don't touch.
        return abs(self.y - other.y) == 1
    }

    public var description: String { "(\(x), \(y))" }
    
    // MARK: - Operators
    
    public static func + (lhs: GridCoordinate, rhs: GridCoordinate) -> GridCoordinate {
        GridCoordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: GridCoordinate, rhs: GridCoordinate) -> GridCoordinate {
        GridCoordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

/// Designates a heading on the Grid using a compass analogy.
///
/// In this type, the `.n` (North) direction corresponds to up on the screen, or decreasing row indices. The `.e` direction
/// points to the right or increasing column indices. The `.s` direction points down, or increasing row indices. The `.w`
/// direction points to the left, or decreasing column indices. The rest of the cases are 45 degree diagonals between two
/// of the cardinal directions.
///
public enum GridDirection: String, CaseIterable {
    
    /// A set of only cardinal (no diagonal) directions.
    ///
    public static let cardinals: [GridDirection] = [.n, .e, .s, .w]
    
    case n, ne, e, se, s, sw, w, nw
    
    /// Get the coordinate offset that will translate into the specified direction.
    public var offset: GridCoordinate {
        switch self {
        case .n:  GridCoordinate(x:  0, y: -1)
        case .ne: GridCoordinate(x:  1, y: -1)
        case .e:  GridCoordinate(x:  1, y:  0)
        case .se: GridCoordinate(x:  1, y:  1)
        case .s:  GridCoordinate(x:  0, y:  1)
        case .sw: GridCoordinate(x: -1, y:  1)
        case .w:  GridCoordinate(x: -1, y:  0)
        case .nw: GridCoordinate(x: -1, y: -1)
        }
    }
}

/// Represents a continuous line of Coordinates.
///
/// Currently, this is restricted to lines that are horizontal, vertical, or at a 45 degree
/// diagonal; corresponding to the GridDirections enum. Lines are not tied to any particular
/// Grid and may contain points that are invalid for that grid.
///
public struct GridLine: CustomStringConvertible {
    
    /// The starting coordinate of the GridLine.
    let start: GridCoordinate
    
    /// The ending coordinate of the GridLine.
    let end: GridCoordinate
    
    /// Create a new instance of GridLine.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate of the GridLine.
    ///     - end: The ending coordinate of the GridLine.
    ///
    public init(start: GridCoordinate, end: GridCoordinate) {
        let diff = end - start
        guard (diff.x == 0 || diff.y == 0 || abs(diff.x) == abs(diff.y)) else {
            fatalError("Only horizontal, vertical or 45 degree diagonal lines are allowed.")
        }
        self.start = start
        self.end = end
    }
    
    /// Create a new instance of GridLine.
    ///
    /// This initializer calculates its end value using the given direction and length.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate for the line.
    ///     - direction: The direction the line travels away from the start.
    ///     - length: The length of the line.
    ///
    public init(start: GridCoordinate, direction: GridDirection, length: Int) {
        self.start = start
        self.end = start + direction.offset.scaledBy(length - 1)
    }
    
    /// Get all coordinates within the line, ordered from `start` to `end`.
    ///
    public var allCoordinates: [GridCoordinate] {
        if start.x == end.x {
            // Vertical orientation
            return (start.y...end.y).map { y in GridCoordinate(x: start.x, y: y) }
        } else if start.y == end.y {
            // Horizontal orientation
            return (start.x...end.x).map { x in GridCoordinate(x: x, y: start.y) }
        } else {
            return zip((start.x...end.x), (start.y...end.y)).map { x, y in GridCoordinate(x: x, y: y)}
        }
    }
    
    /// Check if this line intersects another line.
    ///
    /// This check is based on sharing at least one coordinate, it is possible for two diagonal lines not to intersect if
    /// one line starts on an even x and the other starts on odd.
    ///
    /// - Parameter line: The other line to test interaction with.
    /// - Returns: Returns `true` if the lines share at least 1 coordinate, otherwise returns `false`.
    /// 
    public func intersects(line: GridLine) -> Bool {
        let locs = Set(allCoordinates)
        let otherLocs = Set(line.allCoordinates)
        return !locs.isDisjoint(with: otherLocs)
    }
    
    public var description: String {
        "GridLine(\(start) -> \(end))"
    }
}

/// A the result of a neighbor search.
///
/// Its generic type will always be the same as the Grid which created it.
///
public struct GridNeighbor<T>: CustomStringConvertible {
    
    /// The value of the neighbor.
    public let value: T
    
    /// The coordinate of the neighbor within the Grid.
    public let coordinate: GridCoordinate
    
    /// The direction from the starting coordinate in which this neighbor lies.
    public let direction: GridDirection
    
    /// Create a new instance of `GridNeighbor`.
    ///
    /// - Parameters:
    ///     - value: The value of the neighbor coordinate.
    ///     - coordinate: The grid coordinate of the neighbor.
    ///     - direction: The direction this match lies from the starting coordinate.
    ///
    public init(value: T, coordinate: GridCoordinate, direction: GridDirection) {
        self.value = value
        self.coordinate = coordinate
        self.direction = direction
    }
    
    public var description: String { "Neighbor{value: \(value), pos: \(coordinate), dir: \(direction.rawValue)}" }
}

/// An object which simplifies interactions with 2D homogenous data arrays.
///
/// This type is designed for both convenience and safety: it provides numerous methods for searching the grid while preventing
/// Array out-of-bounds exceptions.
///
public struct Grid<T: Comparable> {
    
    /// An axis to search along.
    public enum SearchType {
        
        /// Will search in a horizontal line (both directions) from the starting point.
        case horizontal
        
        /// Will search in a vertical line (both directions) from the starting point.
        case vertical
    }
    
    /// The underlying Grid data.
    public let data: [[T]]
    
    /// Get the width of the Grid.
    public var width: Int
    
    /// Get the height of the Grid.
    public var height: Int
    
    /// Create a new instance of Grid.
    ///
    /// - Parameter data: The data to base the grid on.
    ///
    /// - Warning: The data object must not be empty and all rows must be the same width.
    ///
    public init(data: [[T]]) {
        guard !data.isEmpty, !data[0].isEmpty else { fatalError("Cannot init with empty data.") }
        self.data = data
        width = data[0].count
        height = data.count
    }
    
    /// Returns the value at the specified coordinate if the coordinate is valid.
    ///
    /// This provides a crash-proof means of accessing values within the grid. It is not possible
    /// to get an out-of-bounds access execption because the validity of the coordinate is
    /// determined prior to array access.
    ///
    /// - Parameter coordinate: The position in the Grid to retrieve the value for.
    /// - Returns: The value at the specified position, or `nil` if the position is invalid.
    ///
    public func value(at coordinate: GridCoordinate) -> T? {
        return isValid(coordinate: coordinate) ? data[coordinate.y][coordinate.x] : nil
    }
    
    /// Find all matches of a specific element within the Grid.
    ///
    /// - Parameter match: The element to match within the grid.
    /// - Returns: An array of zero or more coordinates of elements that matched the provided element.
    ///
    public func findAll(_ match: T) -> [GridCoordinate] {
        findAll(matching: { $0 == match })
    }
    
    /// Find all elements in the grid matching a predicate closure.
    ///
    /// - Parameter matching: The comparison closure to test whether the element should be included in results.
    /// - Returns: An array of zero or more coordinates of elements that matched the predicate.
    ///
    public func findAll(matching: (T) -> Bool) -> [GridCoordinate] {
        data.enumerated().reduce(into: []) { partialResult, row in
            let y = row.offset
            let elements: [GridCoordinate] = row.element.enumerated().reduce(into: []) { partialResult, rowItem in
                let x = rowItem.offset
                if matching(rowItem.element) {
                    partialResult.append(GridCoordinate(x: x, y: y))
                }
            }
            partialResult.append(contentsOf: elements)
        }
    }
    
    /// Return neighbors of the specified coordinate.
    ///
    /// This function will only return results from valid Grid coordinates. If the specified coordinate
    /// lies along an edge of the Grid, then neighors will not be returned for directions with coordinates
    /// that fall outside of the Grid.
    ///
    /// - Parameters:
    ///     - coordinate: The coordinate to return neighbors of.
    ///     - allowDiagonals: Whether or not to consider diagonally-adjacent coordinates as neighbors. Defaults to `true`.
    ///
    /// - Returns: An array of `GridNeighbor` objects.
    ///
    public func neighbors(of coordinate: GridCoordinate, allowDiagonals: Bool = true) -> [GridNeighbor<T>] {
        let dirs: [GridDirection] = allowDiagonals ? GridDirection.allCases : GridDirection.cardinals
        return dirs.compactMap { dir in
            let pos = coordinate + dir.offset
            guard let value = value(at: pos) else { return nil }
            return GridNeighbor(value: value, coordinate: pos, direction: dir)
        }
    }
    
    /// Indicates whether or not the coordinate lies within the boundaries of the Grid.
    ///
    /// - Parameter coordinate: The coordinate to test for validity.
    /// - Returns: A `Bool` value indicating the validity of the coordinate.
    ///
    public func isValid(coordinate: GridCoordinate) -> Bool {
        (0..<width).contains(coordinate.x) &&
        (0..<height).contains(coordinate.y)
    }
    
    /// Returns all values along the line ordered from the start point to the end point.
    ///
    /// - Parameter line: The line to return values for.
    /// - Returns: An array containing zero or more values found along the line.
    ///
    /// - Note: Lines may contain points that fall outside the grid. Those invalid points will not return values.
    ///
    public func values(on line: GridLine) -> [T] {
        line.allCoordinates.compactMap { value(at: $0) }
    }
    
    /// Search along an axis from the starting coordinate, finding all contiguous elements that match the predicate.
    ///
    /// This will iteratively search in both directions along the indicated axis until either the predicate returns
    /// false or the edge of the Grid is reached. If the starting point is invalid (outside the Grid) or does not match
    /// the validation closure, then this method will return `nil`.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate of the search.
    ///     - searchType: The axis to search along.
    ///     - matching: The predicate closure that indicates whether elements are considered matches.
    ///
    /// - Returns: A GridLine encompasing the coordinates that matched elements or `nil` if the starting coordinate was invalid.
    ///
    public func linearSearch(start: GridCoordinate, searchType: SearchType, matching: @escaping (T) -> Bool) -> GridLine?  {
        let searchDirections: [GridDirection] = (searchType == .horizontal) ? [.w, .e] : [.n, .s]
        guard
            let min = raySearch(from: start, direction: searchDirections[0], matching: matching),
            let max = raySearch(from: start, direction: searchDirections[1], matching: matching)
        else { return nil }
        return GridLine(start: min, end: max)
    }
    
    /// Searches in the specified direction from the starting point, finding all contiguous elements that match the predicate.
    ///
    /// This will iteratively search in the indicated direction until either the predicate returns false or the edge of the Grid is reached.
    /// If the starting position is invalid (outside the Grid) or does not match the validation closure, then this method will return `nil`.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate of the search.
    ///     - direction: The direction to search in.
    ///     - matching: The predicate closure that indicates whether elements are considered matches.
    ///
    /// - Returns: A GridCoordinate indicating the furthest contiguous element matching the predicate or nil if the starting
    ///            coordinate is invalid.
    ///
    public func raySearch(from start: GridCoordinate, direction: GridDirection, matching: (T) -> Bool) -> GridCoordinate? {
        guard let startVal = value(at: start), matching(startVal) else { return nil }
        var count = 0
        while let val = value(at: start + direction.offset.scaledBy(count)), matching(val) {
            count += 1
        }
        return start + direction.offset.scaledBy(count - 1)
    }
}
