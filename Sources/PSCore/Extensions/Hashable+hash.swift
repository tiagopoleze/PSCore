public extension Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
