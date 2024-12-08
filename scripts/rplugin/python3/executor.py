#!/usr/bin/env python3
"""Execute commands automatically from nvim"""
# -*- coding: utf-8 -*-

import threading
from subprocess import Popen

import pynvim

from script_data2 import ScriptData2


@pynvim.plugin
class ExecutorPlugin:
    """NVIM plugin for executing commands and logging their output."""
    def __init__(self, nvim):
        self.nvim = nvim
        self.running = False
        self.sd = ScriptData2(ExecutorPlugin.__name__)
        if not self.sd.db.get("enable"):
            self.sd.db["enable"] = True

    @pynvim.autocmd("BufWritePost", pattern="*.c", eval='expand("<afile>")', sync=True)
    def on_bufwritepost(self, filename):
        """Execute some functions after writing a C file."""
        if self.sd.db.get("enable") and not self.running:
            threading.Thread(target=self._execute).start()

    @pynvim.command("ExecutorSetEnable", nargs="*", range="")
    def executor_set_enable(self, args, range):
        """Set enable for executing command."""
        if len(args) and args[0] == "1":
            self.sd.db["enable"] = True
            self.nvim.out_write("enabled\n")
        else:
            self.sd.db["enable"] = False
            self.nvim.out_write("disabled\n")

    def _execute(self):
        self.running = True
        self.nvim.async_call(self.nvim.out_write, "build start\n")
        cmd = "bu --no-erase --no-upload".split()
        with Popen(
            cmd,
            stdout=open("executor.stdout.log", "w", encoding="utf-8"),
            stderr=open("executor.stderr.log", "w", encoding="utf-8"),
        ) as proc:
            proc.communicate()
        msg = "build successful"
        if proc.returncode != 0:
            msg = f"build failed status {proc.returncode}"
        self.nvim.async_call(self.nvim.out_write, f"{msg}\n")
        self.running = False
