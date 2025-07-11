```lua
local IsDevelopmentBranch, NotificationTime = false, 30
local Branch = IsDevelopmentBranch and "development" or "main"
local Source = "https://raw.githubusercontent.com/ErickdeSouza/lol/refs/heads/" .. Branch .. "/"
loadstring(game:HttpGet(Source .. "Loader.lua"), "Loader")(Branch, NotificationTime)

```
