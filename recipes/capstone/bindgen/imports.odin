when ODIN_OS == .Windows {
	when #config(CAPSTONE_STATIC, false) {
		foreign import lib "libs/windows/amd64/capstone_static.lib"
	} else {
		foreign import lib "libs/windows/amd64/capstone.lib"
	}
} else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .arm64 {
		when #config(CAPSTONE_STATIC, false) {
			foreign import lib "libs/darwin/arm64/libcapstone_static.a"
		} else {
			foreign import lib "libs/darwin/arm64/libcapstone.dylib"
		}
	} else when ODIN_ARCH == .amd64 {
		when #config(CAPSTONE_STATIC, false) {
			foreign import lib "libs/darwin/amd64/libcapstone_static.a"
		} else {
			foreign import lib "libs/darwin/amd64/libcapstone.dylib"
		}
	}
} else {
	foreign import lib "system:capstone"
}

_ :: lib
