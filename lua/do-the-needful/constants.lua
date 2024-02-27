local t = require("do-the-needful.utils").indent_str

Constants = {}

Constants.val = {
	plugin_name = "do-the-needful",
	field_order = {
		"name",
		"cmd",
		"cwd",
		"window",
		"tags",
	},
	wrap_fields_at = 3,
	task_defaults = {
		cwd = vim.fn.getcwd(),
		tags = {},
		window = {
			close = true,
			keep_current = false,
		},
	},
	default_task_lines = {
		"{",
		t(1, '"tasks": ['),
		t(2, "{"),
		t(3, '"name": "",'),
		t(3, '"cmd": "",'),
		t(3, '"tags": [""],'),
		t(3, '"window": {'),
		t(4, '"name": "",'),
		t(4, '"close": false,'),
		t(4, '"keep_current": false,'),
		t(4, '"open_relative": true,'),
		t(4, '"relative": "after"'),
		t(3, "}"),
		t(2, "}"),
		t(1, "]"),
		"}",
	},
	default_log_level = "warn",
	log_levels = { "trace", "debug", "info", "warn", "error", "fatal" },
}

return Constants
