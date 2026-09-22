-- Izahook example / compatibility bootstrap
--
-- The library currently references library.cache from library:tab(), but
-- library.cache is never created by library:window().  This bootstrap creates
-- that missing container before creating a tab, so the UI can load.

local LIBRARY_URL = "https://raw.githubusercontent.com/SlomDEV/Test/refs/heads/main/izahook"

local ok, result = pcall(function()
    return loadstring(game:HttpGet(LIBRARY_URL))()
end)

if not ok then
    error("Izahook failed to load: " .. tostring(result))
end

local library = getgenv().library
assert(library, "Izahook did not initialize getgenv().library")

local window = library:window({
    name = "Test",
    suffix = " UI",
    gameInfo = "Example",
    size = UDim2.fromOffset(700, 565),
})

-- FIX: library:tab() expects this field to exist.  Keep it inside the window
-- content area and expose it using the name expected by the library.
if not library.cache then
    library.cache = library:create("Frame", {
        Parent = window.items.main,
        Name = "ContentCache",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 196, 0, 56),
        Size = UDim2.new(1, -196, 1, -81),
    })
end

local tab = library:tab({
    name = "Home",
    icon = "rbxassetid://6034767608",
    tabs = {"Overview"},
})

-- A small dependency-free example content panel.  It deliberately uses the
-- library's create helper, so it works even if optional widget APIs are absent.
local page = tab.items.tab_holder
page.Visible = true

local padding = library:create("UIPadding", {
    Parent = page,
    PaddingTop = UDim.new(0, 18),
    PaddingLeft = UDim.new(0, 18),
    PaddingRight = UDim.new(0, 18),
})

local layout = library:create("UIListLayout", {
    Parent = page,
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

local heading = library:create("TextLabel", {
    Parent = page,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 32),
    Text = "Izahook is loaded",
    TextColor3 = Color3.fromRGB(155, 150, 219),
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 1,
})

local status = library:create("TextLabel", {
    Parent = page,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 24),
    Text = "The missing library.cache container was initialized successfully.",
    TextColor3 = Color3.fromRGB(190, 190, 195),
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 2,
})

local button = library:create("TextButton", {
    Parent = page,
    BackgroundColor3 = Color3.fromRGB(35, 35, 42),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 38),
    Text = "Click me",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    AutoButtonColor = true,
    LayoutOrder = 3,
})
library:create("UICorner", {
    Parent = button,
    CornerRadius = UDim.new(0, 6),
})

button.MouseButton1Click:Connect(function()
    status.Text = "Button clicked at " .. os.date("%X")
end)

return window
