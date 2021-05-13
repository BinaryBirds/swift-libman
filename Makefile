install:
	swift build -c release
	install .build/release/swift-libman-cli /usr/local/bin/swift-libman

uninstall:
	rm -r /usr/local/lib/swift-libman/
	rm /usr/local/bin/swift-libman

