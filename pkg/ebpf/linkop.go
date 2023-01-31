package ebpf

import (
	"fmt"
	"github.com/cilium/ebpf/link"
)

// PinLinks func is used to pin links to filesystem.
func (c *CiliumEBPFRuntime) PinLinks() error {
	for k, v := range c.Links {
		err := v.Pin(FS + "/" + k)
		if err != nil {
			return fmt.Errorf("Pin %v error: %w", k, err)
		}
	}
	return nil
}

// InfoLinks func is used to print links info metadata
func (c *CiliumEBPFRuntime) InfoLinks() map[string]link.Info {
	var Infos map[string]link.Info
	for k, v := range c.Links {
		Info, err := v.Info()
		if err != nil {
			// Infos[k] = link.Info{}
			// return nil
			continue
		}
		// log.Debugf("Got link %v info: %v", k, Info)
		Infos[k] = *Info
	}
	return Infos
}

// UnpinLinks func is used to unpin links from filesystem.
func (c *CiliumEBPFRuntime) UnpinLinks() error {
	for k, v := range c.Links {
		err := v.Unpin()
		if err != nil {
			return fmt.Errorf("Unpin %v error: %w", k, err)
		}
	}
	return nil
}

// CreatePinnedLink func will try load PinnedLinks or create new links without attach process.
func (c *CiliumEBPFRuntime) CreatePinnedLink() error {
	var err error
	// c.Links[BPF_PROG_SYSCALL_ENTER_OPENAT], err = link.LoadPinnedLink(BPF_PROG_FS_SYSCALL_ENTER_OPENAT, &ebpf.LoadPinOptions{})
	// c.Links[BPF_MAPS_PAYLOAD_BUFFER], err = link.LoadPinnedLink(BPF_MAPS_FS_PAYLOAD_BUFFER, &ebpf.LoadPinOptions{})
	if err != nil {
		return fmt.Errorf("load pinned link error: %w", err)
	}
	return nil
}

// CreateLink creates a link between a BPF program. // Current There are attach process in link.Tracepoint
func (c *CiliumEBPFRuntime) CreateLink() error {
	var err error

	// c.Links[BPF_PROG_SYSCALL_ENTER_OPENAT], err = link.Tracepoint(
	// 	"syscalls", "sys_enter_openat", c.Objects.HandleOpenatEnter, nil)

	/*
		c.Links["Prog"], err = link.AttachRawLink(link.RawLinkOptions{

		})
	*/

	if err != nil { // any error occurred trigger this.
		return fmt.Errorf("link error: %w", err)
	}
	return nil
}
