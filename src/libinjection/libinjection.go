package libinjection

/*
#cgo CFLAGS: -I./libinjection
#cgo LDFLAGS: -L. -linjection 
#include "libinjection.h"
#include "libinjection_sqli.h"
*/
import "C"
import (
	// "bytes"
	"log"
	"unsafe"
)

func IsSqli(input string) int {
	var fingerprint [8]C.char
	pointer := (*C.char)(unsafe.Pointer(&fingerprint[0]))
	c_input := C.CString(input)
	c_input_size := C.size_t(len(input))
	isSqli := C.libinjection_sqli(c_input, c_input_size, pointer)
	if isSqli == 1 {
		output := C.GoBytes(unsafe.Pointer(pointer), 8)
		log.Printf("sqli input: '%s'\n", input)
		log.Printf("sqli with fingerprint of '%s'\n", string(output))
	}
	return int(isSqli)
}
