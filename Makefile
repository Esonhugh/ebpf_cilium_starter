# PATH to load VMLINUX.h file
PATH_TO_VMLINUX := ./pkg/ebpf-c/common/
VMLINUX			:= vmlinux.h
CLANG 			?= clang
DEBUG_OPTION 	?= -DDEBUG
#CFLAGS			:= $(DEBUG_OPTION)
CFLAGS 			:= -O2 -g -Wall -Werror -I /usr/include/aarch64-linux-gnu -I $(PATH_TO_VMLINUX) $(CFLAGS)
GOPROXY 		:= 'https://goproxy.io,direct'
GENERATED_TYPE 	:= my_event

build:
	$(info The build function need fullfill)

help: usage
usage:
	$(info |=======================================================================================================)
	$(info |Current Setting Variable:)
	$(info |	CLANG: 				$(CLANG))
	$(info |	CFLAGS: 			$(CFLAGS))
	$(info |	GOPROXY: 			$(GOPROXY))
	$(info |	GENERATED_TYPE: 		$(GENERATED_TYPE))
	$(info |	PATH_TO_VMLINUX: 		$(PATH_TO_VMLINUX))
	$(info |	VMLINUX: 			$(VMLINUX))
	$(info |=======================================================================================================)
	$(info |make command usage:)
	$(info |	build:  				build full program, default make command)
	$(info |	generate: 				Generate the ebpf prog in kernel with clang.)
	$(info |			  			if you need you can set the CFLAGS to append)
	$(info |	tool_gen_vmlinux:			generate vmlinux.h as $(PATH_TO_VMLINUX)$(VMLINUX))
	$(info |	test_ebpf: 				if you editing the ebpf-c c files and header files)
	$(info |						to test the ebpf can be compiled and pass ebpf verifier when load)
	$(info |	tool_unload: 				bpftool unload progs.)
	$(info |	tool_load:				bpftool load progs.)
	$(info |	tool_trace_printk: 			read tracing pipe debug bpf_printk)
	$(info |	help:					show this help)
	$(info |	usage: 					show this help)
	$(info |)

generate: mod_tidy
generate: export BPF_CLANG := $(CLANG)
generate: export BPF_CFLAGS := $(CFLAGS)
generate: export GENERATED_TYPE := $(GENERATED_TYPE)
generate:
	go generate ./pkg/generate...

# go mod tidy with proxy
mod_tidy: export GOPROXY := $(GOPROXY)
mod_tidy: 
	go mod tidy

# read tracing pipe debug bpf_printk
tool_trace_printk:
	cat  /sys/kernel/debug/tracing/trace_pipe

# bpftool load progs.
tool_load:
	bpftool prog loadall ./pkg/generate/bpf_bpfel.o /sys/fs/bpf
	$(info  load Complete But need attach)

# bpftool unload progs.
tool_unload:
	rm /sys/fs/bpf/*
	$(info unload Complete)

# generate vmlinux.h file to $(PATH_TO_VMLINUX)$(VMLINUX)
tool_gen_vmlinux:
	bpftool btf dump file /sys/kernel/btf/vmlinux format c > $(PATH_TO_VMLINUX)$(VMLINUX)

# test ebpf prog in passing verifier.
test_ebpf: generate
test_ebpf: tool_load
test_ebpf: tool_unload
