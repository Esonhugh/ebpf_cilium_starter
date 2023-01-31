# cilium/ebpf starter template
cilium ebpf common template for go.

## requirements:

- **go**: the basic go environment.
- **make**: helpful predefined make commands for development.
- **clang**: cilium ebpf library needs the clang to compile the ebpf program.
- **llvm**: cilium ebpf library needs the llvm to process the compiled ebpf program. Such as llvm-strip when generate go code.
- **bpftools**: dump kernel define, (un)load ebpf program, test ebpf program validation, etc.
- **bpftrace**: helpful when debugging the ebpf programs, easily get POC with bt script. (but this is optional)

## Usage:

```bash
make help
|=======================================================================================================
|Current Setting Variable:
|       CLANG:                          clang
|       CFLAGS:                         -O2 -g -Wall -Werror -I /usr/include/aarch64-linux-gnu -I ./pkg/ebpf-c/common
|       GOPROXY:                        'https://goproxy.io,direct'
|       GENERATED_TYPE:                 my_event
|       PATH_TO_VMLINUX:                ./pkg/ebpf-c/common
|       VMLINUX:                        vmlinux.h
|=======================================================================================================
|make command usage:
|       build:                                  build full program, default make command
|       generate:                               Generate the ebpf prog in kernel with clang.
|                                               if you need you can set the CFLAGS to append
|       tool_gen_vmlinux:                       generate vmlinux.h as ./pkg/ebpf-c/common/vmlinux.h
|       test_ebpf:                              if you editing the ebpf-c c files and header files
|                                               to test the ebpf can be compiled and pass ebpf verifier when load
|       tool_unload:                            bpftool unload progs.
|       tool_load:                              bpftool load progs.
|       tool_trace_printk:                      read tracing pipe debug bpf_printk
|       help:                                   show this help
|       usage:                                  show this help
|
```
