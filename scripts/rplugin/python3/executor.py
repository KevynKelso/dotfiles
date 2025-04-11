#!/usr/bin/env python3
"""Execute commands automatically from nvim"""
# -*- coding: utf-8 -*-

import textwrap
import threading
from subprocess import PIPE, STDOUT, Popen

import pynvim

from script_data2 import ScriptData2


@pynvim.plugin
class ExecutorPlugin:
    """NVIM plugin for executing commands and logging their output."""

    def __init__(self, nvim):
        self.nvim = nvim
        self.running = False
        self.log_file = "executor.log"

        sd = ScriptData2(ExecutorPlugin.__name__)
        if not sd.db.get("enable"):
            sd.db["enable"] = True

    # @pynvim.autocmd("BufWritePost", pattern="*.c", eval='expand("<afile>")', sync=True)
    # def on_bufwritepost(self, filename):
    #     """Execute some functions after writing a C file."""
    #     if self._can_run():
    #         threading.Thread(target=self._execute).start()

    @pynvim.command("ExecutorRun", nargs="*", range="")
    def executor_run(self, args, range):
        if self._can_run():
            threading.Thread(target=self._execute).start()

    @pynvim.command("ExecutorSetEnable", nargs="*", range="")
    def executor_set_enable(self, args, range):
        """Set enable for executing command."""
        sd = ScriptData2(ExecutorPlugin.__name__)
        if len(args) and args[0] == "1":
            sd.db["enable"] = True
            self.nvim.out_write("enabled\n")
        else:
            sd.db["enable"] = False
            self.nvim.out_write("disabled\n")

    @pynvim.command("ExecutorAux1", nargs="*", range="")
    def executor_aux1(self, args, range):
        """Execute aux command 1 nvim command."""
        if self._can_run():
            threading.Thread(target=self._execute_aux1).start()

    def _execute_aux1(self):
        """Execute aux command 1."""
        self.running = True
        self._nvim_print("upload start")
        cmd = "bu --no-build".split()
        output = b""
        with Popen(cmd, stdout=PIPE, stderr=STDOUT) as proc:
            for line in iter(proc.stdout.readline, b""):
                output += line

        with open(self.log_file, "a", encoding="utf-8") as fp:
            fp.write(output.decode("utf-8"))

        msg = "upload successful"
        if proc.returncode != 0:
            msg = f"upload failed status {proc.returncode}"
        self._nvim_print(msg)
        self.running = False


    def _can_run(self) -> bool:
        """Test if we can execute."""
        sd = ScriptData2(ExecutorPlugin.__name__)
        return sd.db.get("enable") and not self.running

    def _nvim_print(self, output: str) -> None:
        """Print output to nvim using the notify API"""
        output = output.replace('"', "'")
        wrapped_output = textwrap.wrap(output, 80)
        if len(wrapped_output) > 5:
            wrapped_output = wrapped_output[0:4]
            wrapped_output.append("...")
        for out in wrapped_output:
            self.nvim.async_call(self.nvim.command, f'lua vim.notify("{out}")')

    def _execute(self):
        self.running = True
        self._nvim_print("build start")
        cmd = "bu".split()
        output = b""
        with Popen(cmd, stdout=PIPE, stderr=STDOUT) as proc:
            for line in iter(proc.stdout.readline, b""):
                output += line
                self._nvim_print(line.decode("utf-8").strip())

        with open(self.log_file, "w", encoding="utf-8") as fp:
            fp.write(output.decode("utf-8"))

        msg = "build successful"
        if proc.returncode != 0:
            msg = f"build failed status {proc.returncode}"
        self._nvim_print(msg)
        self.running = False
