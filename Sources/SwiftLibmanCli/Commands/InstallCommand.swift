//
//  InstallCommand.swift
//  SwiftLibmanCli
//
//  Created by Tibor Bodecs on 2020. 04. 19..
//

import Foundation
import ConsoleKit
import PathKit
import ShellKit


struct InstallCommand: Command {
    
    static let name = "install"

    let help = "Install a new library using a source directory."
        
    struct Signature: CommandSignature {

        @Option(name: "path", help: "The path of the source directory")
        var path: String?
        
        @Option(name: "name", short: "n", help: "Name")
        var name: String?

        @Option(name: "link", short: "l", help: "Link with the following libraries")
        var link: String?
    }

    func run(using context: CommandContext, signature: Signature) throws {
        let loadingBar = context.console.customActivity(frames: ["⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏"].map { $0 + " Installing template..."})
        
        let currentPath = Path.current
        let inputPath = signature.path ?? "./Sources/"
        let workPath = Path(libPath)
        let linkList = (signature.link?.split(separator: ",") ?? []).compactMap { item in
            if workPath.child(libFile(String(item))).isFile {
                return "-L \(libPath) -I \(libPath) -l\(item)"
            }
            return nil
        }.joined(separator: " ")
        
        let name = signature.name ?? currentPath.name

        do {
            loadingBar.start()
            let sh = Shell()
            try sh.run("cd \(currentPath.url.path); find \(inputPath) -name '*.swift' | xargs swiftc \(linkList) -emit-module -emit-library -module-name \(name);")
            
            for file in libFiles(name) {
                let path = currentPath.child(file)
                try path.copy(to: workPath.child(file), force: true)
            }
            loadingBar.succeed()

            context.console.info("Library installed to: \(workPath.location)")
        }
        catch {
            loadingBar.fail()
            context.console.error("Error: \(error.localizedDescription)")
        }
    }
}
