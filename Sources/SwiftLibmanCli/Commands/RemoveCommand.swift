//
//  RemoveCommand.swift
//  SwiftLibmanCli
//
//  Created by Tibor Bodecs on 2020. 04. 19..
//

import Foundation
import ConsoleKit
import PathKit

struct RemoveCommand: Command {
    
    static let name = "remove"

    let help = "Removes an installed library"
        
    struct Signature: CommandSignature {

        @Argument(name: "name", help: "The name of the library")
        var name: String
    }

    func run(using context: CommandContext, signature: Signature) throws {
        
        let libPath = Path("/usr/local/lib/swift-libman")
        let path = libPath.child(signature.name)
        
        guard path.isDirectory else {
            return
        }
        let yes = context.console.ask("Remove `\(path.location)`? (y/n)".consoleText(.info))
        guard yes == "y" else {
            context.console.warning("Skipping removal.")
            return
        }
        do {
            try path.delete()
            context.console.success("Library removed.")
        }
        catch {
            context.console.error("Error: \(error.localizedDescription)")
        }
    }

}
