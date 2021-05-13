//
//  main.swift
//  SwiftLibmanCli
//
//  Created by Tibor Bodecs on 2020. 04. 19..
//

import Foundation
import ConsoleKit

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)
commands.use(ListCommand(), as: ListCommand.name, isDefault: true)
commands.use(InstallCommand(), as: InstallCommand.name, isDefault: false)
commands.use(RemoveCommand(), as: RemoveCommand.name, isDefault: false)

do {
    let group = commands.group(help: "Swift Library Manager")
    try console.run(group, input: input)
}
catch {
    console.error(error.localizedDescription)
    exit(1)
}
