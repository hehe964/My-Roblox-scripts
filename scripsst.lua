-- [[ 통합 관리자 스크립트: Aimbot, ESP, Fly, Speed ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- 설정값 (수정 가능)
_G.AimbotEnabled = false
_G.ESPEnabled = true
_G.FlySpeed = 50
_G.WalkSpeed = 100

local flying = false
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Parent = LocalPlayer.Character:WaitForChild("HumanoidRootPart")

-- [기능 1] ESP: 적 위치 표시
local function DrawESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if not p.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", p.Character)
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

-- [기능 2] 에임봇: 가장 가까운 적 조준
local function GetClosest()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToScreenPoint(p.Character.Head.Position)
            if vis then
                local m_dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                if m_dist < dist then
                    target = p
                    dist = m_dist
                end
            end
        end
    end
    return target
end

-- [기능 3] 키 입력 처리 (Q: 에임봇 토글, E: 비행 토글)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Q then
        _G.AimbotEnabled = not _G.AimbotEnabled
        print("에임봇:", _G.AimbotEnabled)
    elseif input.KeyCode == Enum.KeyCode.E then
        flying = not flying
        bv.MaxForce = flying and Vector3.new(4e5, 4e5, 4e5) or Vector3.new(0, 0, 0)
    end
end)

-- [기능 4] 무한 루프 실행
RunService.RenderStepped:Connect(function()
    if _G.ESPEnabled then DrawESP() end
    if _G.AimbotEnabled then
        local t = GetClosest()
        if t then Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position) end
    end
    if flying then
        bv.Velocity = Camera.CFrame.LookVector * _G.FlySpeed
    end
    LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
end)

print("시헌의 통합 스크립트 로드 완료! [Q]에임봇 [E]비행")
