import Foundation
import VectorIOCodeGen

do {
	try CLI().run()
} catch {
	print("failed to convert files: \(error)")
	exit(-1)
}
