//
//  ListCommand.swift
//  SwiftLibmanCli
//
//  Created by Tibor Bodecs on 2020. 04. 19..
//

import Foundation
import ConsoleKit
import PathKit

struct ListCommand: Command {
    
    static let name = "list"

    let help = "List installed libraries"
        
    struct Signature: CommandSignature {}

    func run(using context: CommandContext, signature: Signature) throws {
        let workPath = Path("/usr/local/lib/swift-libman/")

        context.console.output("Swift libraries:", style: .info)
        
        for path in workPath.children().filter(\.isDirectory).filter(\.isVisible) {
            context.console.output(" · " + path.name, style: .info)
        }
    }
}
