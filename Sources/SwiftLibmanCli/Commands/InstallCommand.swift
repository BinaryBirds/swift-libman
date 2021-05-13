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
        
//        @Flag(name: "global", short: "g", help: "Template name to use")
//        var global: Bool
    }

    func run(using context: CommandContext, signature: Signature) throws {
        let loadingBar = context.console.customActivity(frames: ["⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏"].map { $0 + " Installing template..."})
        
        let currentPath = Path.current
        let inputPath = signature.path ?? "./Sources/"
        let libPath = Path("/usr/local/lib/")
        let linkList = (signature.link?.split(separator: ",") ?? []).compactMap { item in
            if libPath.child(String(item)).isDirectory {
                return "-L /usr/local/lib/\(item)/ -I /usr/local/lib/\(item)/ -l\(item)"
            }
            return nil
        }.joined(separator: " ")
        
        let name = signature.name ?? currentPath.name

        do {
            loadingBar.start()
            if !libPath.isDirectory {
                try libPath.create()
            }
            let sh = Shell()
            try sh.run("cd \(currentPath.url.path); find \(inputPath) -name '*.swift' | xargs swiftc \(linkList) -emit-module -emit-library -module-name \(name);")

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

            
            for f in res {
                let p = currentPath.child(f)
                try p.copy(to: libPath.child(f), force: true)
            }
            loadingBar.succeed()

            context.console.info("Library installed to: \(libPath.location)")
        }
        catch {
            loadingBar.fail()
            context.console.error("Error: \(error.localizedDescription)")
        }
    }
}
