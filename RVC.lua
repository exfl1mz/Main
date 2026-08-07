--[[
     ███▄    █  ▒█████   ▄████▄  ▄▄▄█████▓ █    ██  ██▀███   ▄▄▄       ██▓    
     ██ ▀█   █ ▒██▒  ██▒▒██▀ ▀█  ▓  ██▒ ▓▒ ██  ▓██▒▓██ ▒ ██▒▒████▄    ▓██▒    
    ▓██  ▀█ ██▒▒██░  ██▒▒▓█    ▄ ▒ ▓██░ ▒░▓██  ▒██░▓██ ░▄█ ▒▒██  ▀█▄  ▒██░    
    ▓██▒  ▐▌██▒▒██   ██░▒▓▓▄ ▄██▒░ ▓██▓ ░ ▓▓█  ░██░▒██▀▀█▄  ░██▄▄▄▄██ ▒██░    
    ▒██░   ▓██░░ ████▓▒░▒ ▓███▀ ░  ▒██▒ ░ ▒▒█████▓ ░██▓ ▒██▒ ▓█   ▓██▒░██████▒
    ░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ░ ░▒ ▒  ░  ▒ ░░   ░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ▒░▓  ░
    ░ ░░   ░ ▒░  ░ ▒ ▒░   ░  ▒       ░    ░░▒░ ░ ░   ░▒ ░ ▒░  ▒   ▒▒ ░░ ░ ▒  ░
      ░   ░ ░ ░ ░ ░ ▒  ░          ░       ░░░ ░ ░   ░░   ░   ░   ▒     ░ ░   
            ░     ░ ░  ░ ░                  ░        ░           ░  ░    ░  ░
                       ░                                                     
]]

local _, s = pcall(function(...)
    string.byte("a", function(...) return end, 9999, 38)
end)
if s:find("httplog") or s:find("sandbox") then while true do error("anti env log by exfl1mz") end end

if not game:IsLoaded() then game.Loaded:Wait() end

local NotificationHolder = loadstring(game:HttpGet("https://raw.githubusercontent.com/exfl1mz/Main/main/Module.lua"))()
local Notification = loadstring(game:HttpGet("https://raw.githubusercontent.com/exfl1mz/Main/main/Client.lua"))()

if getgenv().RVCLoader then
    Notification:Notify(
        {Title = "RVC", Description = "Script already started."},
        {OutlineColor = Color3.fromRGB(0, 0, 255), Time = 3, Type = "image"},
        {Image = "http://www.roblox.com/asset/?id=17860774372", ImageColor = Color3.fromRGB(255, 255, 255)}
    ); return
end

getgenv().RVCLoader = true

type SettingsTable = {
    Main: {
        RagdollTime: boolean,
        Invisible: boolean,
        AntiPush: boolean,
        AntiExplode: boolean,
        AntiFall: boolean
    },
    Misc: {
        Fly: boolean,
        FlySpeed: number,
        FlyKey: Enum.KeyCode,
        Speed: boolean,
        SpeedBasic: number,
        CustomSpeed: number
    },
    Power: {
        EnablePush: boolean,
        EnableExplode: boolean,
        CustomPower: number,
        CustomHeight: number
    },
    Items: {
        Carpet: boolean,
        CarpetSpeed: number
    }
}

type NetListener = {
    _command: string
}

type CaseEntry = {
    Title: string,
    Desc: string,
    Icon: string?,
    Rarity: string
}

type StyleEntry = {
    Name: string,
    Rarity: string,
    Image: string?,
    Equip: string
}

local Settings: SettingsTable = {
    Main = {
        RagdollTime = false,
        Invisible = false,
        AntiPush = false,
        AntiExplode = false,
        AntiFall = false
    },
    Misc = {
        Fly = false,
        FlySpeed = 50,
        FlyKey = Enum.KeyCode.E,
        Speed = false,
        SpeedBasic = 16,
        CustomSpeed = 16
    },
    Power = {
        EnablePush = false,
        EnableExplode = false,
        CustomPower = 1,
        CustomHeight = 1
    },
    Items = {
        Carpet = false,
        CarpetSpeed = 50
    }
}

local File: string = "RVC.json"
local HttpService: HttpService = game:GetService("HttpService")

local function packData(t: {[any]: any}): {[any]: any}
    local c: {[any]: any} = {}
    for k, v in pairs(t) do
        if typeof(v) == "EnumItem" then
            c[k] = tostring(v)
        elseif type(v) == "table" then
            c[k] = packData(v)
        else
            c[k] = v
        end
    end
    return c
end

local function SaveSettings(t: SettingsTable): ()
    pcall(function()
        writefile(File, HttpService:JSONEncode(packData(t)))
    end)
end

local function unPackData(j: {[any]: any}): {[any]: any}
    for k, v in pairs(j) do
        if type(v) == "string" then
            local e, n = v:match("Enum%.(%w+)%.(%w+)")
            if e and n and Enum[e] and Enum[e][n] then
                j[k] = Enum[e][n]
            end
        elseif type(v) == "table" then
            unPackData(v)
        end
    end
    return j
end

local function LoadSettings(): {[any]: any}?
    if not isfile(File) then return end
    local ok, d = pcall(function()
        local j = HttpService:JSONDecode(readfile(File))
        if type(j) ~= "table" then return end
        return unPackData(j)
    end)
    if ok then return d end
end

local function Merge(defaults: {[any]: any}, loaded: {[any]: any}): ()
    for k, v in pairs(loaded) do
        if type(v) == "table" and type(defaults[k]) == "table" then
            Merge(defaults[k], v)
        else
            defaults[k] = v
        end
    end
end

local L = LoadSettings()
if L then Merge(Settings, L) end

local Players: Players = game:GetService("Players")
local LocalPlayer: Player = Players.LocalPlayer
local Workspace: Workspace = game:GetService("Workspace")
local Character: Model? = LocalPlayer.Character

local RunService: RunService = cloneref(game:GetService("RunService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local ReplicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local VirtualUser: VirtualUser = cloneref(game:GetService("VirtualUser"))

local Physics = require(ReplicatedStorage.PublicShared.Net.Physics)
local configuration = require(ReplicatedStorage.PublicShared.GameIndex.configuration)
local Network = require(ReplicatedStorage.Quadro.Packages.Network)
local FlyingCarpet = require(ReplicatedStorage.PublicShared.Main.Controllable.FlyingCarpet)

local OriginalExplode = Physics.Explode
local OriginalPushForce = Physics.PushForce
local OriginalCarpetUpdate = FlyingCarpet.update

local function ChangeLabel(Name: string): TextLabel?
    for _, v in ipairs(game.CoreGui:GetChildren()) do
        if v.Name == "Khaw" then
            for _, z in ipairs(v:GetDescendants()) do
                if z:IsA("TextLabel") and string.find(z.Text, Name) then
                    return z
                end
            end
        end
    end
    return nil
end

local function forceVisible(player: Player): ()
    local Character: Model? = LocalPlayer.Character
    if Character and Character:GetAttribute("IsInvisible") then
        Character:SetAttribute("IsInvisible", false)
    end

    player:SetAttribute("show_country", true)
    player:SetAttribute("ShowIconContainers", true)
    player:SetAttribute("ShowNicknames", true)

    if Character then
        Character:GetAttributeChangedSignal("IsInvisible"):Connect(function()
            if Character:GetAttribute("IsInvisible") then
                Character:SetAttribute("IsInvisible", false)
            end
        end)
    end
end

type NetBlockClass = {
    Blocked: {[string]: NetListener},
    Block: (self: NetBlockClass, command: string) -> boolean,
    Unblock: (self: NetBlockClass, command: string) -> ()
}

local NetBlock: NetBlockClass = {Blocked = {}}

function NetBlock:Block(command: string): boolean
    if self.Blocked[command] then return end
    for i = #Network.Listeners, 1, -1 do
        if Network.Listeners[i]._command == command then
            self.Blocked[command] = Network.Listeners[i]
            table.remove(Network.Listeners, i)
            return true
        end
    end
    return false
end

function NetBlock:Unblock(command: string): ()
    if not self.Blocked[command] then return end
    table.insert(Network.Listeners, self.Blocked[command])
    self.Blocked[command] = nil
end

type ShowInvisibleClass = {
    Active: boolean,
    Connection: RBXScriptConnection?,
    Start: (self: ShowInvisibleClass) -> (),
    Stop: (self: ShowInvisibleClass) -> ()
}

local ShowInvisible: ShowInvisibleClass = {Active = false, Connection = nil}

function ShowInvisible:Start(): ()
    if self.Active then return end
    self.Active = true
    self.Connection = RunService.Heartbeat:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, v in ipairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "PushFX" and v.Transparency > 0 then
                        v.Transparency = 0
                    end
                end
            end
        end
    end)
end

function ShowInvisible:Stop(): ()
    if not self.Active then return end
    self.Active = false
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

type FlyClass = {
    Active: boolean,
    UIEnabled: boolean,
    Speed: number,
    Connections: {[string]: any},
    Constraints: {Instance},
    Enabled: (self: FlyClass) -> (),
    Stop: (self: FlyClass) -> (),
    Toggle: (self: FlyClass) -> ()
}

local Fly: FlyClass = {
    Active = false,
    UIEnabled = false,
    Speed = Settings.Misc.FlySpeed,
    Connections = {},
    Constraints = {}
}

function Fly:Enabled(): ()
    if self.Active then return end
    local Character: Model? = LocalPlayer.Character
    if not Character then return end
    local HumanoidRootPart: BasePart? = Character:FindFirstChild("HumanoidRootPart") :: BasePart?
    local Humanoid: Humanoid? = Character:FindFirstChildOfClass("Humanoid") :: Humanoid?
    if not HumanoidRootPart or not Humanoid then return end

    self.Active = true

    local BodyGyro: BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.Parent = HumanoidRootPart
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = HumanoidRootPart.CFrame

    local BodyVelocity: BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Parent = HumanoidRootPart
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    self.Constraints = {BodyGyro, BodyVelocity}
    Humanoid.PlatformStand = true
    Humanoid.AutoRotate = false

    local CONTROL = {
        F = UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0,
        B = UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0,
        L = UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0,
        R = UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0,
        Q = UserInputService:IsKeyDown(Enum.KeyCode.E) and 1 or 0,
        E = UserInputService:IsKeyDown(Enum.KeyCode.Q) and 1 or 0
    }

    self.Connections.InputBegan = UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 1
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 1
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 1
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 1
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 1
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 1 end
    end)

    self.Connections.InputEnded = UserInputService.InputEnded:Connect(function(input: InputObject, processed: boolean)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
    end)

    self.Connections.Loop = task.spawn(function()
        repeat
            task.wait()
            if not self.Active then break end
            local camera: Camera = workspace.CurrentCamera
            local char: Model? = LocalPlayer.Character
            local hum: Humanoid? = char and char:FindFirstChildOfClass("Humanoid") :: Humanoid?
            if hum then hum.PlatformStand = true end

            local moveX: number = CONTROL.R - CONTROL.L
            local moveZ: number = CONTROL.F - CONTROL.B
            local moveY: number = CONTROL.Q - CONTROL.E

            if moveX ~= 0 or moveZ ~= 0 or moveY ~= 0 then
                local direction: Vector3 = (camera.CFrame.LookVector * moveZ) + (camera.CFrame.RightVector * moveX) + (Vector3.yAxis * moveY)
                BodyVelocity.Velocity = direction.Unit * self.Speed
            else
                BodyVelocity.Velocity = Vector3.zero
            end
            BodyGyro.CFrame = camera.CFrame
        until not self.Active
    end)

    self.Connections.Died = Humanoid.Died:Connect(function()
        self:Stop()
    end)
end

function Fly:Stop(): ()
    if not self.Active then return end
    self.Active = false
    for _, Connection in pairs(self.Connections) do
        if typeof(Connection) == "RBXScriptConnection" then
            Connection:Disconnect()
        elseif typeof(Connection) == "thread" then
            task.cancel(Connection)
        end
    end

    table.clear(self.Connections)

    for _, Constraint in pairs(self.Constraints) do
        if Constraint then Constraint:Destroy() end
    end

    table.clear(self.Constraints)

    local Character: Model? = LocalPlayer.Character
    if Character then
        local Humanoid: Humanoid? = Character:FindFirstChildOfClass("Humanoid") :: Humanoid?
        if Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.AutoRotate = true
        end
    end

    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

function Fly:Toggle(): ()
    if self.Active then self:Stop() else self:Enabled() end
    Settings.Misc.Fly = self.Active
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(.5)
    if Fly.UIEnabled then Fly:Enabled() end
end)

UserInputService.InputBegan:Connect(function(Input: InputObject, GameProcessed: boolean)
    if GameProcessed then return end
    if Input.KeyCode == Settings.Misc.FlyKey and Fly.UIEnabled then
        Fly:Toggle()
    end
end)

local function CustomCarpetUpdate(self, dt: number): ()
    if self.active and self.bodyVelocity and self.PlayerModule then
        local moveVec: Vector3 = self.PlayerModule.controls.activeController.moveVector
        if moveVec.Magnitude > 0 then
            local cam: Camera = workspace.CurrentCamera
            local dir: Vector3 = Vector3.zero
            if moveVec.Z ~= 0 then
                dir = dir + cam.CFrame.LookVector * -moveVec.Z
            end
            if moveVec.X ~= 0 then
                dir = dir + cam.CFrame.RightVector * moveVec.X
            end

            local maxSpeed: number = Settings.Items.CarpetSpeed
            self.currentVelocity = dir.Unit * maxSpeed
            self.bodyVelocity.Velocity = self.currentVelocity
        else
            self.currentVelocity = self.currentVelocity:Lerp(Vector3.zero, 3 * dt)
            self.bodyVelocity.Velocity = self.currentVelocity
        end

        if self.bodyGyro then
            local cam: Camera = workspace.CurrentCamera
            self.bodyGyro.CFrame = self.bodyGyro.CFrame:Lerp(CFrame.new(self.bodyGyro.Parent.Position, self.bodyGyro.Parent.Position + cam.CFrame.LookVector), 15 * dt)
        end
    end
end

local function ApplyCarpetHook(): ()
    FlyingCarpet.update = CustomCarpetUpdate
end

local function RemoveCarpetHook(): ()
    FlyingCarpet.update = OriginalCarpetUpdate
end

if Settings.Items.Carpet then
    ApplyCarpetHook()
end

local function ApplyPushHook(): ()
    Physics.PushForce = function(force: Vector3, ragdoll: boolean)
        return OriginalPushForce(force * Settings.Power.CustomPower, ragdoll)
    end
end

local function ApplyExplodeHook(): ()
    Physics.Explode = function(pos: Vector3, radius: number, power: number, extraY: number, ragdoll: boolean)
        return OriginalExplode(pos, radius, power * Settings.Power.CustomPower, extraY * Settings.Power.CustomHeight, ragdoll)
    end
end

local function RemovePushHook(): ()
    Physics.PushForce = OriginalPushForce
end

local function RemoveExplodeHook(): ()
    Physics.Explode = OriginalExplode
end

if Settings.Power.EnablePush then
    ApplyPushHook()
end
if Settings.Power.EnableExplode then
    ApplyExplodeHook()
end

local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/exfl1mz/Main/main/Kawaii-UI.lua", true))()

local UISettings = {
    ['Game'] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    ['General'] = 101849161408766,
    ['Auto'] = 110162136250435,
    ['Setting'] = 72210587662292,
    ['Misc'] = 84034775913393,
    ['Items'] = 98574803492996,
    ['Shop'] = 74630923244478,
    ['Teleport'] = 137847566773112,
    ['Visual'] = 123257335719276,
    ['Combat'] = 112935442242481,
    ['Update'] = 86844430363710,
}

local Window = ui:Window({
    Title = "RVC | exfl1mz",
    Desc = UISettings.Game
})

local General = Window:Add({
    Title = "General",
    Desc = UISettings.Game,
    Banner = UISettings.General
})

local GeneralL = General:Section({Title = "Protection", Side = "l"})
local GeneralR = General:Section({Title = "Movement", Side = "r"})

GeneralL:Toggle({Title = "Anti Push", Desc = "Block server push ragdoll", Value = Settings.Main.AntiPush, Callback = function(state: boolean)
    Settings.Main.AntiPush = state; SaveSettings(Settings)
    if state then NetBlock:Block("PushForce") else NetBlock:Unblock("PushForce") end
end})

GeneralL:Toggle({Title = "Anti Explode", Desc = "Block server explosion ragdoll", Value = Settings.Main.AntiExplode, Callback = function(state: boolean)
    Settings.Main.AntiExplode = state; SaveSettings(Settings)
    if state then NetBlock:Block("Explode") else NetBlock:Unblock("Explode") end
end})

GeneralL:Toggle({Title = "Anti Fall", Desc = "Block server fall ragdoll", Value = Settings.Main.AntiFall, Callback = function(state: boolean)
	Settings.Main.AntiFall = state; SaveSettings(Settings)
    configuration.realistic_ragdoll_min_fall_height = state and 9999999 or 6
    configuration.realistic_ragdoll_freefall_time = state and 9999999 or 1.5
end})

GeneralL:Toggle({Title = "Remove Ragdoll Cooldown", Desc = "Removing server ragdoll cooldown (basic 2sec)", Value = Settings.Main.RagdollTime, Callback = function(state: boolean)
	Settings.Main.RagdollTime = state; SaveSettings(Settings)
    configuration.realistic_ragdoll_getup_lock_time = state and 0 or 2
    configuration.default_ragdoll_time = state and 0 or 2
end})

GeneralL:Toggle({Title = "Show Invisible Players", Desc = "Shows players through Invisible Tool", Value = Settings.Main.Invisible, Callback = function(state: boolean)
	Settings.Main.Invisible = state; SaveSettings(Settings)
	if state then ShowInvisible:Start() else ShowInvisible:Stop() end
end})

GeneralR:Toggle({Title = "Fly", Desc = "Enable flight mode", Value = Settings.Misc.Fly, Callback = function(state: boolean)
    Fly.UIEnabled = state; Settings.Misc.Fly = state; SaveSettings(Settings)
    if state then Fly:Enabled() else Fly:Stop() end
end})

GeneralR:Slider({Title = "Fly Speed", Min = 1, Max = 500, Value = Settings.Misc.FlySpeed, Rounding = 3, CallBack = function(state: number)
    Fly.Speed = state; Settings.Misc.FlySpeed = state; SaveSettings(Settings)
end})

GeneralR:Keybind({Title = "Fly Keybind", Key = Settings.Misc.FlyKey, Value = Settings.Misc.FlyKey, Callback = function(Key: Enum.KeyCode)
    if typeof(Key) == "EnumItem" then
        Settings.Misc.FlyKey = Key; SaveSettings(Settings)
    end
end})

GeneralR:Paragarp({Title = "Info", Desc = "Coins"})

local Misc = Window:Add({
    Title = "Misc",
    Desc = UISettings.Game,
    Banner = UISettings.Misc
})

local MiscL = Misc:Section({Title = "Speed & Carpet", Side = "l"})
local MiscR = Misc:Section({Title = "Power", Side = "r"})

MiscL:Toggle({Title = "Enable Player Speed", Desc = "", Value = Settings.Misc.Speed, Callback = function(state)
    task.spawn(function()
        Settings.Misc.Speed = state; SaveSettings(Settings)
        local Humanoid: Humanoid? = Character:FindFirstChildOfClass("Humanoid") :: Humanoid?
        while true do
            if not Settings.Misc.Speed then Humanoid.WalkSpeed = Settings.Misc.SpeedBasic return end
            Humanoid.WalkSpeed = Settings.Misc.CustomSpeed
            task.wait(.1)
        end
    end)
end})

MiscL:Slider({Title = "Player Speed", Min = 0, Max = 1000, Value = Settings.Misc.CustomSpeed, Rounding = 0, CallBack = function(v: number)
    Settings.Misc.CustomSpeed = v; SaveSettings(Settings)
end})

MiscL:Toggle({Title = "Custom Carpet Speed", Desc = "Override flying carpet speed", Value = Settings.Items.Carpet, Callback = function(state: boolean)
    Settings.Items.Carpet = state; SaveSettings(Settings)
    if state then ApplyCarpetHook() else RemoveCarpetHook() end
end})

MiscL:Slider({Title = "Carpet Speed", Min = 1, Max = 1000, Value = Settings.Items.CarpetSpeed, Rounding = 0, CallBack = function(v: number)
    Settings.Items.CarpetSpeed = v; SaveSettings(Settings)
end})

MiscL:Button({Title = "Teleport Tool", Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/spn8O2kz/raw", true))()
end})

MiscR:Toggle({Title = "Custom Push Power", Desc = "Multiply incoming push force", Value = Settings.Power.EnablePush, Callback = function(state: boolean)
    Settings.Power.EnablePush = state; SaveSettings(Settings)
    if state then ApplyPushHook() else RemovePushHook() end
end})

MiscR:Toggle({Title = "Custom Explode Power", Desc = "Multiply explosion force and height", Value = Settings.Power.EnableExplode, Callback = function(state: boolean)
    Settings.Power.EnableExplode = state; SaveSettings(Settings)
    if state then ApplyExplodeHook() else RemoveExplodeHook() end
end})

MiscR:Slider({Title = "Power Multiplier", Min = 1, Max = 100, Value = Settings.Power.CustomPower, Rounding = 0, CallBack = function(v: number)
    Settings.Power.CustomPower = v; SaveSettings(Settings)
end})

MiscR:Slider({Title = "Height Multiplier", Min = 1, Max = 100, Value = Settings.Power.CustomHeight, Rounding = 0, CallBack = function(v: number)
    Settings.Power.CustomHeight = v; SaveSettings(Settings)
end})

local Items = Window:Add({
    Title = "Items",
    Desc = UISettings.Game,
    Banner = UISettings.Items
})

local ItemsL = Items:Section({Title = "Misc", Side = 'l'})
local ItemsR = Items:Section({Title = "Misc", Side = 'r'})

local RarityOrder: {[string]: number} = {
    ["exrare"] = 1,
	["ancient"] = 2,
    ["legendary"] = 3,
	["mythic"] = 4,
	["rare"] = 5,
	["uncommon"] = 6,
	["common"] = 7
}

local RarityNames: {[string]: string} = {
    ["exrare"] = "Exrare",
	["ancient"] = "Ancient",
    ["legendary"] = "Legendary",
	["mythic"] = "Mythic",
	["rare"] = "Rare",
	["uncommon"] = "Uncommon",
	["common"] = "Common"
}

local function GetWeight(l: string): number
	return RarityOrder[string.lower(tostring(l))] or 999
end

local casesList: {CaseEntry} = {}

for _, v in pairs(ReplicatedStorage.PublicShared.GameIndex.items.cases:GetChildren()) do
	if v:IsA("ModuleScript") then
		local req = require(v)
		table.insert(casesList, {Title = req.name, Desc = string.format("%s | %s", req.isLimitedText or "Case", RarityNames[req.rarity]), Icon = req.image, Rarity = req.rarity})
	end
end

table.sort(casesList, function(a: CaseEntry, b: CaseEntry): boolean return GetWeight(a.Rarity) < GetWeight(b.Rarity) end)

for _, v in ipairs(casesList) do
	ItemsL:Button({Title = v.Title, Desc = v.Desc, Icon = v.Icon, Callback = function() end})
end

local stylesList: {StyleEntry} = {}

for _, v in pairs(ReplicatedStorage.PublicShared.Main.NicknameStyles.Modules.StylesList:GetChildren()) do
	for _, z in pairs(v:GetChildren()) do
		if z:IsA("ModuleScript") and z:FindFirstChildWhichIsA("ImageLabel") then
			local username_style = ReplicatedStorage.PublicShared.GameIndex.items.username_style:FindFirstChild(z.Name)
			if username_style then
				local req = require(username_style)
				table.insert(stylesList, {Name = req.name, Rarity = RarityNames[req.rarity], Image = z:FindFirstChildWhichIsA("ImageLabel").Image, Equip = username_style.Name})
			end
		end
	end
end

table.sort(stylesList, function(a: StyleEntry, b: StyleEntry): boolean return GetWeight(a.Rarity) < GetWeight(b.Rarity) end)

for _, v in ipairs(stylesList) do
	ItemsR:Button({Title = v.Name, Desc = v.Rarity, Icon = v.Image, Callback = function()
		LocalPlayer:SetAttribute("EquippedStyle", v.Equip)
	end})
end

for _, v in ipairs(Players:GetPlayers()) do
	forceVisible(v)
	v.CharacterAdded:Connect(forceVisible)
end

Players.PlayerAdded:Connect(function(v: Player)
	forceVisible(v)
	v.CharacterAdded:Connect(forceVisible)
end)

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait()
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

task.spawn(function()
    local SteppedRender: RBXScriptConnection
    SteppedRender = RunService.RenderStepped:Connect(function()
        local Connect: TextLabel? = ChangeLabel("Coins")
        if Connect then
            Connect.Text = string.format("Coins: %s; Server Country: %s\n%s / %i ms / %i FPS", LocalPlayer.leaderstats.Coins.Value, Workspace:GetAttribute("server_country"), DateTime.now():FormatLocalTime("LTS", "de-DE"), math.round(LocalPlayer:GetNetworkPing() * 1000), tostring(Workspace:GetRealPhysicsFPS()))
        end
    end)
end)

--[[
-- tf shit idea but removing cooldown on every items (not all working)

local classes = game.ReplicatedStorage.PublicShared.Main.Tools.classes
local typeClone = type(clonefunction) == "function"

for _, v in ipairs(classes:GetChildren()) do
    if v:IsA("ModuleScript") and v.Name ~= "init" then
        local ok, class = pcall(require, v)
        if ok and type(class) == "table" then
            local activated = rawget(class, "activated")
            if type(activated) == "function" then
                local original = typeClone and clonefunction(activated) or nil

                hookfunction(activated, newcclosure(function(self)
                    if type(self) == "table" then
                        if rawget(self, "debounce") ~= nil then
                            self.debounce = false
                        end
                        if rawget(self, "equipped_tick") ~= nil then
                            self.equipped_tick = 0
                        end
                    end
                    if original then
                        return original(self)
                    elseif type(calloriginal) == "function" then
                        return calloriginal(self)
                    end
                end))
            end
        end
    end
end
]]
