local Job = require("plenary.job")
local tmux = require("do-the-needful.tmux")
local Log = require("do-the-needful").Log
local extend = vim.list_extend
local sf = require("do-the-needful.utils").string_format

---@class Window
---@func open(selection: TaskConfig)
---@return Window
Window = {}

local compose_job = function(cmd, cwd)
	Log.trace(sf("window._compose_job(): cmd %s, cwd %s", cmd, cwd))
	local command = table.remove(cmd, 1)
	local job_tbl = {
		command = command,
		args = cmd,
		cwd = cwd,
	}
	Log.trace(sf("window._compose_job(): return job_tbl %s", job_tbl))
	return job_tbl
end

local function build_job_command(selection)
	local cmd = tmux.build_command(selection)
	Log.debug(sf("window.build_command(): cmd %s", cmd))
	if not cmd then
		Log.error(sf("window.build_command(): no return value from tmux.build_command(). selection: %s", selection))
		return
	end
	return compose_job(cmd, selection.cwd)
end

local send_cmd_to_pane = function(selection, pane)
	local cmd = { "tmux", "send", "-R", "-t", pane }
	extend(cmd, { selection.cmd })
	extend(cmd, { "Enter" })
	Log.trace(sf("window._send_cmd_to_pane(): sending cmd %s to pane %s", cmd, pane))
	Job:new(compose_job(cmd, selection.cwd)):sync()
end

local function tmux_running()
	if not vim.env.TMUX then
		Log.error("checking $TMUX env...tmux is not running")
		return nil
	end
	return true
end

function Window.open(selection)
	if not tmux_running() then
		return nil
	end
	local cmd = build_job_command(selection)
	Log.trace(sf("window.run_task(): cmd %s", cmd))
	if not cmd then
		Log.error("window.run_tasks(): no return value from build_command(). selection %s", selection)
		return nil
	end
	if selection.window.close then
		Job:new(cmd):sync()
	else
		local pane = Job:new(cmd):sync()
		if not pane then
			Log.warn(sf("window.run_task(): pane not found when running job for selected task %s", selection))
			return nil
		end
		pane = pane[1]
			Log.trace(sf("window.run_task(): sending selected task %s to pane %s", selection, pane))
			send_cmd_to_pane(selection, pane)
	end
end

return Window
