-- See https://wiki.hypr.land/configuring/core/rules/workspace-rules/

-- default_name - начальное имя; persistent не даёт удалить стол, когда он пуст
local names = { "web", "doc", "devel", "cmdr", "media", "custom", "bg" }
for id, name in ipairs(names) do
    hl.workspace_rule({ workspace = tostring(id), default_name = name, persistent = true })
end
