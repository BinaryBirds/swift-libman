//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 13..
//

import Foundation

#if os(macOS)
    let libExt = "dylib"
#elseif os(Windows)
    let libExt = "dll"
#else
    let libExt = "so"
#endif

let libPath = "/usr/local/lib/"

func libFile(_ name: String) -> String {
    "lib\(name).\(libExt)"
}

func libFiles(_ name: String) -> [String] {
    [
        "\(name).swiftdoc",
        "\(name).swiftmodule",
        "\(name).swiftsourceinfo",
        libFile(name),
    ]
}
