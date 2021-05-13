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
        
        let libPath = Path("/usr/local/lib/")
        let name = signature.name
        
        #if os(macOS)
            let ext = "dylib"
        #elseif os(Windows)
            let ext = "dll"
        #else
            let ext = "so"
        #endif

        let res = [
            "\(name).swiftdoc",
            "\(name).swiftmodule",
            "\(name).swiftsourceinfo",
            "lib\(name).\(ext)",
        ]
        

        let yes = context.console.ask("Remove `\(name)`? (y/n)".consoleText(.info))
        guard yes == "y" else {
            context.console.warning("Skipping removal.")
            return
        }
        do {
            for f in res {
                try libPath.child(f).delete()
            }
            context.console.success("Library removed.")
        }
        catch {
            context.console.error("Error: \(error.localizedDescription)")
        }
    }

}
