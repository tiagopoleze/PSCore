import Foundation

extension URLRequest {

    var streamedBody: Data? {
        guard let bodyStream = httpBodyStream else { return nil }
        bodyStream.open()

        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var requestData = Data()

        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            requestData.append(buffer, count: readData)
        }

        buffer.deallocate()
        bodyStream.close()

        return requestData
    }
}
