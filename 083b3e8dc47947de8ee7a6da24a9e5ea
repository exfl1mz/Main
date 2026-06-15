local ExistingGUI = game:GetService("CoreGui"):FindFirstChild("ProxiConfirm")
if ExistingGUI then
	ExistingGUI:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "ProxiConfirm"
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = game:GetService("CoreGui")

local function Create(instance, properties, children)
	local obj = Instance.new(instance)
	for prop, val in pairs(properties or {}) do
		obj[prop] = val
	end
	for _, child in pairs(children or {}) do
		child.Parent = obj
	end
	return obj
end

local MainFrame = Create("Frame", {
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Size = UDim2.new(0.4, 0, 0.6, 0),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Parent = GUI
}, {
	Create("UICorner", { CornerRadius = UDim.new(0, 16) }),
	Create("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder
	}),
	Create("UIAspectRatioConstraint", {
		AspectRatio = 1,
		AspectType = Enum.AspectType.ScaleWithParentSize,
		DominantAxis = Enum.DominantAxis.Height
	}),
	Create("UISizeConstraint", {
		MaxSize = Vector2.new(500, 500),
		MinSize = Vector2.new(250, 250)
	})
})

local TopFrame = Create("Frame", {
	ZIndex = 2,
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	Size = UDim2.new(1, 0, 0.125, 0),
	LayoutOrder = 1,
	Parent = MainFrame
}, {
	Create("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingRight = UDim.new(0, 30),
		PaddingLeft = UDim.new(0, 30),
		PaddingBottom = UDim.new(0, 12)
	}),
	Create("UIStroke", { Color = Color3.fromRGB(231, 231, 231) })
})

local Buttons = Create("Frame", {
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	AnchorPoint = Vector2.new(1, 0.5),
	Size = UDim2.new(0.5, 0, 1, 0),
	Position = UDim2.new(1, 0.0375, 0.5, 0),
	BackgroundTransparency = 1,
	Parent = TopFrame
}, {
	Create("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal
	}),
	Create("ImageButton", {
		ScaleType = Enum.ScaleType.Fit,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(164, 162, 166),
		ImageColor3 = Color3.fromRGB(16, 34, 60),
		ZIndex = 2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "rbxassetid://14829181141",
		Size = UDim2.new(1, 0, 1, 0),
		BorderColor3 = Color3.fromRGB(27, 43, 53),
		Name = "Close",
		Position = UDim2.new(1, 0, 0.5, 0)
	}, {
		Create("UIAspectRatioConstraint", {})
	})
})

Create("TextLabel", {
	TextWrapped = true,
	BorderSizePixel = 0,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal),
	TextColor3 = Color3.fromRGB(16, 34, 60),
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0, 0.5),
	Size = UDim2.new(0, 0, 1, 0),
	AutomaticSize = Enum.AutomaticSize.X,
	Name = "Title",
	Position = UDim2.new(0, 0, 0.5, 0),
	Text = "CONFIRMATION",
	Parent = TopFrame
})

local ContentFrame = Create("Frame", {
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	ClipsDescendants = true,
	Size = UDim2.new(1, 0, 0.875, 0),
	LayoutOrder = 2,
	BackgroundTransparency = 1,
	Parent = MainFrame
}, {
	Create("UIPadding", {
		PaddingTop = UDim.new(0.05, 0),
		PaddingRight = UDim.new(0.05, 0),
		PaddingLeft = UDim.new(0.05, 0),
		PaddingBottom = UDim.new(0.05, 0)
	})
})

local ImageLabel = Create("ImageLabel", {
	BorderSizePixel = 0,
	ScaleType = Enum.ScaleType.Fit,
	BackgroundColor3 = Color3.fromRGB(0, 0, 255),
	Image = "rbxassetid://1234567890",
	Size = UDim2.new(1, 0, 0.7, 0),
	Parent = ContentFrame
}, {
	Create("UICorner", {})
})

local MessageLabel = Create("TextLabel", {
	TextWrapped = true,
	BorderSizePixel = 0,
	TextSize = 20,
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
	TextColor3 = Color3.fromRGB(16, 34, 60),
	RichText = true,
	Size = UDim2.new(1, 0, 0.125, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	Name = "Message",
	Position = UDim2.new(0, 0, 0.7, 0),
	Text = 'Current UGC Correct <font color="rgb(0, 0, 255)">...</font>?',
	Parent = ContentFrame
})

local Options = Create("Frame", {
	Active = true,
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(64, 183, 255),
	Selectable = true,
	AnchorPoint = Vector2.new(0, 1),
	Size = UDim2.new(1, 0, 0.1, 0),
	Position = UDim2.new(0, 0, 1, 0),
	Name = "Options",
	LayoutOrder = 1,
	BackgroundTransparency = 1,
	Parent = ContentFrame
}, {
	Create("UIListLayout", {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0.025, 0),
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal
	}),
	Create("TextButton", {
		BorderSizePixel = 0,
		TextSize = 20,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = Color3.fromRGB(171, 171, 171),
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal),
		Size = UDim2.new(0.48, 0, 1, 0),
		LayoutOrder = 1,
		Text = "NO",
		Name = "No"
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 10) })
	}),
	Create("TextButton", {
		BorderSizePixel = 0,
		TextSize = 20,
		TextScaled = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = Color3.fromRGB(0, 0, 255),
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal),
		Size = UDim2.new(0.48, 0, 1, 0),
		LayoutOrder = 1,
		Text = "YES",
		Name = "Yes"
	}, {
		Create("UICorner", { CornerRadius = UDim.new(0, 10) })
	})
})

Buttons.Close.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

Options.No.MouseButton1Click:Connect(function()
	GUI:Destroy()
end)

local function ShowConfirmation(assetId, callback)
	local success, info = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfo(assetId)
	end)

	if success and info then
		ImageLabel.Image = "rbxthumb://type=Asset&id=" .. tostring(assetId) .. "&w=420&h=420"
		MessageLabel.Text = 'Current UGC Correct <font color="rgb(0, 0, 255)">' .. info.Name .. '</font>?'

		local yesConnection
		yesConnection = Options.Yes.MouseButton1Click:Connect(function()
			yesConnection:Disconnect()
			GUI:Destroy()
			if callback then
				callback(true, assetId)
			end
		end)

		GUI.Enabled = true
	else
		if callback then
			callback(false, assetId)
		end
	end
end

GUI.Enabled = false

return ShowConfirmation
