local cfg = require("do-the-needful.config")

DoTheNeedful = {}

function DoTheNeedful.setup(config)
	config = config or {}
	cfg.init(config)
	DoTheNeedful.Log = require("do-the-needful.logger").init()
	DoTheNeedful.Edit = require("do-the-needful.edit")
end

function DoTheNeedful.edit_config(config)
	config = ("project" or "global") and config or "project"
	DoTheNeedful.Edit.edit_config(config)
end

function DoTheNeedful.please()
	require("do-the-needful.telescope").tasks()
end

return DoTheNeedful
