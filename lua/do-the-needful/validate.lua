local warn = require("do-the-needful.logger").warn
local ins = vim.inspect

---@class Validate
---@field tasks fun(tasks: TaskConfig[]): TaskConfig[]
Validate = {}

local function validate_cmd(task, index)
	if not task.cmd or #task.cmd == 0 then
		warn("Task %s is missing a cmd. Excluding task from aggregation: %s", index, ins(task))
		return false
	end
	return true
end

local function validate_name(task)
	if not task.name or #task.name == 0 then
		local name = "Unknown task"
		warn("Task is missing a name. Setting value to '%s'.  task: %s", name, task)
		task.name = name
	end
end

local function validate_tags(task)
	if task.tags then
		if #task.tags == 0 or task.tags[1] == "" then
			task.tags = nil
		elseif type(task.tags) ~= "table" then
			warn("Task has an invalid tags property. Expecting a table. task: %s", ins(task))
			task.tags = nil
		else
			for i, tag in ipairs(task.tags) do
				if type(tag) ~= "string" then
					warn("Task has an invalid tag. Converting to string. task: %s", ins(task))
					task.tags[i] = tostring(tag)
				end
			end
		end
	end
end

local function validate_window(task, relative)
	local window = task.window
	if not window then
		return
	end
	if window.name and #window.name == 0 then
		window.name = nil
	end
	local properties = { "close", "keep_current", "open_relative" }
	for _, prop in ipairs(properties) do
		if window[prop] and type(window[prop]) ~= "boolean" then
			window[prop] = nil
		end
	end
	if window.relative and not vim.tbl_contains(relative, window.relative) then
		warn("Task has an invalid window property: relative. Expecting one of %s. task: %s", relative, ins(task))
		window.relative = nil
	end
end

Validate.tasks = function(tasks)
	---@type relative
	local relative = { "after", "before" }
	local remove = {}

	for index, task in pairs(tasks) do
		if not validate_cmd(task, index) then
			remove[#remove + 1] = index
		else
			validate_name(task)
			validate_tags(task)
			validate_window(task, relative)
		end
	end

	for _, index in ipairs(remove) do
		tasks[index] = nil
	end

	return tasks
end

return Validate
