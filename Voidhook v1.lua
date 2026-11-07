local LOADER = {
	TITLE         = "VoidHook",
	SIZE          = 74,
	DOTS_PER_PX   = 0.42,
	DOT_SIZE      = 3,
	SCATTER       = 0.60,
	GATHER_MIN    = 0.90,
	GATHER_MAX    = 1.50,
	GATHER_SPREAD = 1.70,	
	DECODE_STEP   = 0.045,
	BATCH         = 6,
	LOCK_AT       = 2.50,
	LOAD_TIME     = 2.80,
	HOLD          = 0.90,
	FADE_OUT      = 0.80,
	BACKDROP      = true,
	SHOW_BAR      = true,
	SEGMENTS      = 48,
	FLOOR_LINES   = 18,
	ORBIT_COUNT   = 16,
	ARC_DASHES    = 56,
	STATIC_LINES  = 24,
	VIGNETTE      = true,
	STATIC        = true,
	PARALLAX      = true,
	RIPPLE        = true,
	CHECKLIST     = true,
	KEEP_AFTER    = false,
	TOTAL         = 7.20,
	CYAN          = Color3.fromRGB(0, 229, 255),
	CYAN_DEEP     = Color3.fromRGB(8, 62, 84),
	MAGENTA       = Color3.fromRGB(255, 0, 110),
	MAGENTA_DEEP  = Color3.fromRGB(84, 4, 42),
	WHITE         = Color3.fromRGB(240, 250, 255),
	VERSION       = "v3.0  VOIDHOOK",
	STATUS        = {
		"mounting client",
		"resolving endpoints",
		"mapping memory pages",
		"attaching handlers",
		"verifying checksum",
		"hook online",
	},
	LOG           = {
		"> mounting payload ................ ok",
		"> resolving endpoints ............. ok",
		"> shim base ....................... ok",
		"> vtable patch 0x18 ............... ok",
		"> integrity ....................... ok",
		"> handshake complete .............. ok",
	},
	GLYPHS        = "0123456789",
	SCANRATE      = 3.20,
}

local LoaderDone = false
local LoaderGate = Instance.new("BindableEvent")
task.delay(LOADER.TOTAL, function()
	if not LoaderDone then
		LoaderDone = true
		LoaderGate:Fire()
	end
end)

local LoadGui = nil

local ok, err = pcall(function()
	local Players      = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local RunService   = game:GetService("RunService")
	local RNG          = Random.new()

	local UIS = nil
	do
		local got, svc = pcall(function() return game:GetService("UserInputService") end)
		if got then UIS = svc end
	end

	local lp = Players.LocalPlayer
	local host = nil
	if lp then
		host = lp:FindFirstChildOfClass("PlayerGui")
		if not host then
			local got, g = pcall(function() return lp:WaitForChild("PlayerGui", 5) end)
			if got then host = g end
		end
	end
	if not host then
		local got, g = pcall(function() return game:GetService("CoreGui") end)
		if got then host = g end
	end
	if not host then return end

	local old = host:FindFirstChild("SpectrixHookLoader")
	if old then old:Destroy() end

	LoadGui = Instance.new("ScreenGui")
	LoadGui.Name = "SpectrixHookLoader"
	LoadGui.ResetOnSpawn = false
	LoadGui.IgnoreGuiInset = true
	LoadGui.DisplayOrder = 500
	LoadGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	LoadGui.Parent = host

	_G.SpectrixLoader = {
		Gui = LoadGui,
		Close = function()
			pcall(function()
				if LoadGui and LoadGui.Parent then LoadGui:Destroy() end
			end)
			if not LoaderDone then
				LoaderDone = true
				LoaderGate:Fire()
			end
		end,
	}

	local function New(class, props, parent)
		local o = Instance.new(class)
		if props then
			for k, v in pairs(props) do o[k] = v end
		end
		if parent then o.Parent = parent end
		return o
	end

	local function Tw(o, props, time, style, dir)
		local t = TweenService:Create(o, TweenInfo.new(
			time or 0.4,
			style or Enum.EasingStyle.Quint,
			dir or Enum.EasingDirection.Out
		), props)
		t:Play()
		return t
	end

local function Round(o, r)
	-- Square corners everywhere (per VoidHook design).
	return o
end

	local function Label(props, parent)
		return New("TextLabel", props, parent)
	end

	local function Alive()
		return LoadGui ~= nil and LoadGui.Parent ~= nil
	end

	local FONT, MONO
	do
		local ok1, f1 = pcall(function() return Enum.Font.GothamBold end)
		if ok1 then FONT = f1 else FONT = Enum.Font.Legacy end
		local ok2, f2 = pcall(function() return Enum.Font.Code end)
		if ok2 then MONO = f2 else MONO = FONT end
	end

	local cam = workspace.CurrentCamera
	local W, H = 1920, 1080
	local function ReadVP()
		local got, v = pcall(function() return cam.ViewportSize end)
		if got and v and v.X > 0 then W, H = v.X, v.Y end
	end
	ReadVP()
	local vpConn = nil
	if cam then
		vpConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(ReadVP)
	end

	local CX, CY = W * 0.5, H * 0.44

	local TITLE = LOADER.TITLE
	local SIZE  = LOADER.SIZE
	local GAP   = SIZE * 0.10
	local ROW_H = SIZE * 1.30
	local ADV = {
		N = 0.80, H = 0.80, M = 0.92, W = 0.94, O = 0.80, Q = 0.80,
		A = 0.72, B = 0.70, C = 0.70, D = 0.74, E = 0.66, F = 0.62,
		G = 0.74, I = 0.30, J = 0.50, K = 0.72, L = 0.62, P = 0.66,
		R = 0.70, S = 0.66, T = 0.66, U = 0.76, V = 0.72, X = 0.72,
		Y = 0.72, Z = 0.66,
		a = 0.58, b = 0.60, c = 0.54, d = 0.60, e = 0.58, f = 0.40,
		g = 0.60, h = 0.60, i = 0.26, j = 0.26, k = 0.58, l = 0.26,
		m = 0.86, n = 0.60, o = 0.60, p = 0.60, q = 0.60, r = 0.42,
		s = 0.52, t = 0.38, u = 0.60, v = 0.56, w = 0.80, x = 0.56,
		y = 0.56, z = 0.52,
		["."] = 0.28, [","] = 0.28, ["-"] = 0.40, ["_"] = 0.60,
		[" "] = 0.36, [":"] = 0.30, ["/"] = 0.44,
	}

	local cells = {}
	local totalW = 0
	for i = 1, #TITLE do
		local ch = TITLE:sub(i, i)
		local w = SIZE * (ADV[ch] or 0.62)
		totalW += w
		cells[i] = { ch = ch, w = w, mid = 0 }
	end
	totalW += GAP * (#TITLE - 1)
	local pen = -totalW / 2
	for i = 1, #cells do
		cells[i].mid = pen + cells[i].w / 2
		pen += cells[i].w + GAP
	end

	local BW  = math.ceil(totalW)
	local NC  = #cells

	local function RandomGlyph()
		return LOADER.GLYPHS:sub(RNG:NextInteger(1, #LOADER.GLYPHS))
	end

	if LOADER.BACKDROP then
		New("Frame", {
			Name = "Backdrop",
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.fromRGB(4, 4, 9),
			BorderSizePixel = 0,
			ZIndex = 1,
		}, LoadGui)
	end

	local floorLines = {}
	do
		local horizon = CY + ROW_H * 0.5 + 40
		for i = 1, LOADER.FLOOR_LINES do
			local f = New("Frame", {
				Size = UDim2.fromOffset(W * 0.4, 1),
				Position = UDim2.fromOffset(CX - W * 0.2, horizon),
				BackgroundColor3 = LOADER.CYAN_DEEP,
				BackgroundTransparency = 0.75,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, LoadGui)
			floorLines[i] = f
		end
		for i = -6, 6 do
			local f = New("Frame", {
				Size = UDim2.fromOffset(1, H - horizon),
				Position = UDim2.fromOffset(CX + i * 26, horizon),
				BackgroundColor3 = LOADER.MAGENTA_DEEP,
				BackgroundTransparency = 0.8,
				BorderSizePixel = 0,
				ZIndex = 2,
			}, LoadGui)
			floorLines[LOADER.FLOOR_LINES + 1 + i + 6] = f
		end
	end

	local bloom = {}
	local bloomBase = {}
	for i = 7, 1, -1 do
		local d = 240 + i * 130
		local col = (i % 2 == 0) and LOADER.CYAN_DEEP or LOADER.MAGENTA_DEEP
		local t = 0.91 - i * 0.006
		local g = New("Frame", {
			Size = UDim2.fromOffset(d, d * 0.56),
			Position = UDim2.fromOffset(CX - d / 2, CY - d * 0.28),
			BackgroundColor3 = col,
			BackgroundTransparency = t,
			BorderSizePixel = 0,
			ZIndex = 3,
		}, LoadGui)
		Round(g, 999)
		bloom[#bloom + 1] = g
		bloomBase[#bloomBase + 1] = t
	end

	local vignette = {}
	if LOADER.VIGNETTE then
		local function Edge(pos, size, rot)
			local f = New("Frame", {
				Size = size,
				Position = pos,
				BackgroundColor3 = Color3.new(0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 30,
			}, LoadGui)
			New("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Rotation = rot,
			}, f)
			vignette[#vignette + 1] = f
		end
		Edge(UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 250), 0)
		Edge(UDim2.new(0, 0, 1, -250), UDim2.new(1, 0, 0, 250), 180)
		Edge(UDim2.fromOffset(0, 0), UDim2.new(0, 250, 1, 0), 270)
		Edge(UDim2.new(1, -250, 0, 0), UDim2.new(0, 250, 1, 0), 90)
	end

	local static = {}
	if LOADER.STATIC then
		for i = 1, LOADER.STATIC_LINES do
			static[i] = New("Frame", {
				Size = UDim2.fromOffset(W, 2),
				Position = UDim2.fromOffset(0, RNG:NextNumber(0, H)),
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 40,
			}, LoadGui)
		end
	end

	local arc = {}
	do
		local rx = BW * 0.82
		local ry = ROW_H * 1.48
		local N = LOADER.ARC_DASHES
		for i = 1, N do
			local d = New("Frame", {
				Size = UDim2.fromOffset(12, 2),
				BackgroundColor3 = LOADER.CYAN_DEEP,
				BackgroundTransparency = 0.72,
				BorderSizePixel = 0,
				ZIndex = 6,
			}, LoadGui)
			Round(d, 1)
			arc[i] = {
				frame = d,
				rx = rx,
				ry = ry,
				a = (i - 1) / N * math.pi * 2,
				on = false,
			}
		end
	end

	local function BuildRow(dx, sizeAdd, color, trans, z)
		local holder = New("Frame", {
			Size = UDim2.fromOffset(BW + 140, ROW_H + 80),
			Position = UDim2.fromOffset(CX - BW / 2 + dx, CY - ROW_H / 2),
			BackgroundTransparency = 1,
			ZIndex = z,
		}, LoadGui)
		holder:SetAttribute("BaseX", CX - BW / 2 + dx)
		holder:SetAttribute("BaseY", CY - ROW_H / 2)
		local labels = {}
		local x = 0
		for i = 1, NC do
			local c = cells[i]
			local l = New("TextLabel", {
				Size = UDim2.fromOffset(c.w, ROW_H + 80),
				Position = UDim2.fromOffset(x, 40),
				BackgroundTransparency = 1,
				Text = RandomGlyph(),
				TextSize = SIZE + sizeAdd,
				Font = FONT,
				TextColor3 = color,
				TextTransparency = trans,
				TextStrokeTransparency = 1,
				ZIndex = z,
			}, holder)
			New("UIScale", { Scale = 1 }, l)
			labels[i] = l
			x += c.w + GAP
		end
		return holder, labels
	end

	local rowCyan,    labCyan    = BuildRow(-4, 0, LOADER.CYAN, 1, 8)
	local rowMagenta, labMagenta = BuildRow(4, 0, LOADER.MAGENTA, 1, 8)
	local rowGlow,    labGlow    = BuildRow(0, 18, LOADER.CYAN_DEEP, 1, 9)
	local rowCore,    labCore    = BuildRow(0, 0, LOADER.CYAN, 1, 10)

	for i = 1, NC do
		New("UIStroke", {
			Color = LOADER.CYAN,
			Thickness = 2,
			Transparency = 0.6,
		}, labCore[i])
	end

	local function FadeRow(row, target, time)
		for _, d in ipairs(row:GetDescendants()) do
			if d:IsA("TextLabel") then
				Tw(d, { TextTransparency = target }, time or 0.35)
			end
		end
	end

	local px, py = 0, 0
	local gdx, rjx, rjy = 0, 0, 0

	local function ApplyRows()
		rowCore.Position    = UDim2.fromOffset(CX - BW / 2 + px + rjx, CY - ROW_H / 2 + py + rjy)
		rowGlow.Position    = UDim2.fromOffset(CX - BW / 2 + px + rjx, CY - ROW_H / 2 + py + rjy)
		rowCyan.Position    = UDim2.fromOffset(CX - BW / 2 - 4 - gdx + px * 1.5, CY - ROW_H / 2 + py * 1.5)
		rowMagenta.Position = UDim2.fromOffset(CX - BW / 2 + 4 + gdx + px * 1.5, CY - ROW_H / 2 + py * 1.5)
	end

	local function SetGlitch(amount, time)
		gdx = amount > 0 and amount or 0
		FadeRow(rowCyan, amount > 0 and 0.55 or 1, time)
		FadeRow(rowMagenta, amount > 0 and 0.55 or 1, time)
	end

	local function PopLabels(labels, amount)
		for i, l in ipairs(labels) do
			local s = l:FindFirstChildOfClass("UIScale")
			if s then
				s.Scale = amount
				Tw(s, { Scale = 1 }, 0.28, Enum.EasingStyle.Back)
			end
		end
	end

	local function SetGlyph(i, g)
		labCore[i].Text = g
		labGlow[i].Text = g
		labCyan[i].Text = g
		labMagenta[i].Text = g
	end

	local brackets = {}
	do
		local blw, bll = 46, 3
		local pad = 28
		local X0, X1 = CX - BW / 2 - pad, CX + BW / 2 + pad
		local Y0, Y1 = CY - ROW_H * 0.5 - pad, CY + ROW_H * 0.5 + pad
		local defs = {
			{ X0, Y0, 1, 1 }, { X1, Y0, -1, 1 },
			{ X0, Y1, 1, -1 }, { X1, Y1, -1, -1 },
		}
		for i = 1, 4 do
			local d = defs[i]
			local group = New("Frame", {
				Size = UDim2.fromOffset(blw, bll),
				Position = UDim2.fromOffset(
					d[1] - (d[3] < 0 and blw or 0),
					d[2] - (d[4] < 0 and bll or 0)
				),
				BackgroundTransparency = 1,
				ZIndex = 11,
			}, LoadGui)
			local a = New("Frame", {
				Size = UDim2.fromOffset(blw, bll),
				BackgroundColor3 = LOADER.CYAN,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 11,
			}, group)
			local b = New("Frame", {
				Size = UDim2.fromOffset(bll, 38),
				Position = UDim2.fromOffset(
					d[3] < 0 and blw - bll or 0,
					d[4] < 0 and 38 - bll or 0
				),
				BackgroundColor3 = LOADER.CYAN,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 11,
			}, group)
			brackets[i] = { a, b }
		end
	end

	local rings = {}
	for i = 1, 4 do
		local r = New("Frame", {
			Size = UDim2.fromOffset(70, 40),
			Position = UDim2.fromOffset(CX - 35, CY - 20),
			BackgroundColor3 = (i % 2 == 0) and LOADER.MAGENTA or LOADER.CYAN,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 7,
		}, LoadGui)
		Round(r, 999)
		rings[i] = r
	end

	local function Shockwave(maxW, maxH, dur)
		for i = 1, #rings do
			local r = rings[i]
			local w = maxW + i * 150
			local h = maxH + i * 90
			r.BackgroundTransparency = 0.42 - i * 0.07
			Tw(r, {
				Size = UDim2.fromOffset(w, h),
				Position = UDim2.fromOffset(CX - w / 2, CY - h / 2),
				BackgroundTransparency = 1,
			}, dur or 0.9, Enum.EasingStyle.Quart)
		end
	end

	local bands = {}
	for i = 1, 5 do
		bands[i] = New("Frame", {
			Size = UDim2.fromOffset(W, 10),
			Position = UDim2.fromOffset(0, CY),
			BackgroundColor3 = LOADER.CYAN,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 20,
		}, LoadGui)
	end

	local function TearBurst(count, power)
		for _ = 1, (count or 4) do
			if not Alive() then return end
			local b = bands[RNG:NextInteger(1, #bands)]
			b.Size = UDim2.fromOffset(W, RNG:NextNumber(4, 30))
			b.Position = UDim2.fromOffset(
				RNG:NextNumber(-(power or 70), 0),
				CY + RNG:NextNumber(-ROW_H, ROW_H)
			)
			b.BackgroundColor3 = RNG:NextNumber() < 0.5 and LOADER.CYAN or LOADER.MAGENTA
			b.BackgroundTransparency = RNG:NextNumber(0.45, 0.7)
			task.wait(RNG:NextNumber(0.035, 0.07))
			b.BackgroundTransparency = 1
		end
	end

	local orbit = {}
	do
		local holder = New("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ZIndex = 6,
		}, LoadGui)
		for i = 1, LOADER.ORBIT_COUNT do
			local s = RNG:NextInteger(2, 5)
			local d = New("Frame", {
				Size = UDim2.fromOffset(s, s),
				BackgroundColor3 = (i % 3 == 0) and LOADER.MAGENTA or LOADER.CYAN,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 6,
			}, holder)
			Round(d, 1)
			orbit[i] = {
				frame = d,
				r = BW * 0.72 + RNG:NextNumber(-20, 46),
				a = RNG:NextNumber(0, math.pi * 2),
				sp = RNG:NextNumber(0.5, 1.6) * (RNG:NextNumber() < 0.5 and -1 or 1),
				el = BW * 0.30,
				vert = RNG:NextNumber(0.10, 0.34),
			}
		end
	end

	local sub = Label({
		Size = UDim2.fromOffset(620, 20),
		Position = UDim2.fromOffset(CX - 310, CY + ROW_H * 0.5 + 24),
		BackgroundTransparency = 1,
		Text = LOADER.VERSION,
		TextSize = 13,
		Font = FONT,
		TextColor3 = LOADER.CYAN,
		TextTransparency = 1,
		ZIndex = 11,
	}, LoadGui)

	local tags = {}
	local tagText = { "VOIDHOOK", "CLIENT LOADER", "LUAC", "LOCAL ONLY" }
	local tagPos = {
		UDim2.fromOffset(26, 24),
		UDim2.new(1, -26, 0, 24),
		UDim2.fromOffset(26, 1, -24),
		UDim2.new(1, -26, 1, -24),
	}
	for i = 1, 4 do
		local left = (i == 1 or i == 3)
		tags[i] = Label({
			Size = UDim2.fromOffset(300, 18),
			Position = tagPos[i],
			BackgroundTransparency = 1,
			Text = tagText[i],
			TextSize = 12,
			Font = FONT,
			TextColor3 = (i % 2 == 0) and LOADER.MAGENTA or LOADER.CYAN,
			TextTransparency = 1,
			TextXAlignment = left and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right,
			TextYAlignment = (i <= 2) and Enum.TextYAlignment.Top or Enum.TextYAlignment.Bottom,
			ZIndex = 11,
		}, LoadGui)
	end

	local stageText = Label({
		Size = UDim2.fromOffset(220, 20),
		Position = UDim2.fromOffset(CX - 220, CY + ROW_H * 0.5 + 24),
		BackgroundTransparency = 1,
		Text = "",
		TextSize = 12,
		Font = MONO,
		TextColor3 = LOADER.MAGENTA,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 11,
	}, LoadGui)

	local logText = Label({
		Size = UDim2.fromOffset(430, 132),
		Position = UDim2.fromOffset(26, H - 160),
		BackgroundTransparency = 1,
		Text = "",
		TextSize = 12,
		Font = MONO,
		TextColor3 = LOADER.CYAN,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		ZIndex = 11,
	}, LoadGui)

	local hexText = Label({
		Size = UDim2.fromOffset(760, 18),
		Position = UDim2.fromOffset(CX - 380, H - 74),
		BackgroundTransparency = 1,
		Text = "",
		TextSize = 12,
		Font = MONO,
		TextColor3 = LOADER.MAGENTA,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 11,
	}, LoadGui)

	local etaText = Label({
		Size = UDim2.fromOffset(300, 18),
		Position = UDim2.new(1, -326, 1, -74),
		BackgroundTransparency = 1,
		Text = "T+ 00.0s",
		TextSize = 12,
		Font = MONO,
		TextColor3 = LOADER.CYAN,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 11,
	}, LoadGui)

	local checkRows = {}
	if LOADER.CHECKLIST then
		for i = 1, #LOADER.STATUS do
			local holder = New("Frame", {
				Size = UDim2.fromOffset(280, 22),
				Position = UDim2.fromOffset(W - 306, CY - ROW_H * 0.5 - 20 + (i - 1) * 26),
				BackgroundTransparency = 1,
				ZIndex = 12,
			}, LoadGui)
			local dot = New("Frame", {
				Size = UDim2.fromOffset(6, 6),
				Position = UDim2.fromOffset(2, 8),
				BackgroundColor3 = LOADER.CYAN,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 13,
			}, holder)
			Round(dot, 3)
			local name = Label({
				Size = UDim2.fromOffset(268, 20),
				Position = UDim2.fromOffset(18, 0),
				BackgroundTransparency = 1,
				Text = LOADER.STATUS[i],
				TextSize = 12,
				Font = MONO,
				TextColor3 = LOADER.CYAN,
				TextTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 13,
			}, holder)
			checkRows[i] = { dot = dot, name = name }
		end
	end

	local scanLine = New("Frame", {
		Size = UDim2.fromOffset(W, 2),
		Position = UDim2.fromOffset(0, -4),
		BackgroundColor3 = LOADER.CYAN,
		BackgroundTransparency = 0.75,
		BorderSizePixel = 0,
		ZIndex = 5,
	}, LoadGui)
	local scanBand = New("Frame", {
		Size = UDim2.fromOffset(W, 150),
		Position = UDim2.fromOffset(0, -160),
		BackgroundColor3 = LOADER.CYAN_DEEP,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		ZIndex = 4,
	}, LoadGui)

	local BARW = 520
	local BAR_Y = H * 0.78
	local progress = 0
	local fill, head, track, pctText, statusText, shimmer, segs

	local function FadeAll(target, time)
		Tw(sub, { TextTransparency = target }, time)
		Tw(stageText, { TextTransparency = target == 0 and 0.4 or target }, time)
		Tw(logText, { TextTransparency = target }, time)
		Tw(hexText, { TextTransparency = target }, time)
		Tw(etaText, { TextTransparency = target == 0 and 0.3 or target }, time)
		for i = 1, #vignette do
			Tw(vignette[i], { BackgroundTransparency = target == 0 and 0.5 or target }, time)
		end
		for i = 1, #static do
			Tw(static[i], { BackgroundTransparency = target }, time)
		end
		for i = 1, #arc do
			Tw(arc[i].frame, { BackgroundTransparency = target }, time)
		end
		for i = 1, #checkRows do
			Tw(checkRows[i].dot, { BackgroundTransparency = target }, time)
			Tw(checkRows[i].name, { TextTransparency = target }, time)
		end
		for i = 1, 4 do
			Tw(tags[i], { TextTransparency = target == 0 and 0.45 or target }, time)
			for _, d in ipairs(brackets[i]) do
				Tw(d, { BackgroundTransparency = target == 0 and 0.15 or target }, time)
			end
		end
		if pctText then Tw(pctText, { TextTransparency = target }, time) end
		if statusText then Tw(statusText, { TextTransparency = target }, time) end
		if track then Tw(track, { BackgroundTransparency = target }, time) end
		if head then Tw(head, { BackgroundTransparency = target }, time) end
		Tw(scanLine, { BackgroundTransparency = target }, time)
		Tw(scanBand, { BackgroundTransparency = target }, time)
		for i = 1, #bloom do
			Tw(bloom[i], { BackgroundTransparency = target }, time)
		end
	end

	if LOADER.SHOW_BAR then
		pctText = Label({
			Size = UDim2.fromOffset(220, 34),
			Position = UDim2.fromOffset(CX - BARW / 2, BAR_Y - 58),
			BackgroundTransparency = 1,
			Text = "0%",
			TextSize = 26,
			Font = FONT,
			TextColor3 = LOADER.WHITE,
			TextTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 12,
		}, LoadGui)

		stageText.Position = UDim2.fromOffset(CX + BARW / 2 - 220, BAR_Y - 50)

		track = New("Frame", {
			Size = UDim2.fromOffset(BARW, 10),
			Position = UDim2.fromOffset(CX - BARW / 2, BAR_Y),
			BackgroundColor3 = Color3.fromRGB(12, 16, 28),
			BackgroundTransparency = 0.1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			ZIndex = 11,
		}, LoadGui)
		Round(track, 5)
		New("UIStroke", { Color = LOADER.CYAN_DEEP, Thickness = 1, Transparency = 0.3 }, track)

		segs = {}
		local N = LOADER.SEGMENTS
		local gap = 3
		local sw = (BARW - gap * (N - 1)) / N
		for i = 1, N do
			local s = New("Frame", {
				Size = UDim2.fromOffset(sw, 10),
				Position = UDim2.fromOffset((i - 1) * (sw + gap), 0),
				BackgroundColor3 = (i % 5 == 0) and LOADER.MAGENTA or LOADER.CYAN,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 12,
			}, track)
			Round(s, 2)
			New("UIScale", { Scale = 1 }, s)
			segs[i] = s
		end

		fill = New("Frame", {
			Size = UDim2.fromScale(0, 1),
			BackgroundColor3 = LOADER.CYAN,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 13,
		}, track)
		Round(fill, 5)
		New("UIGradient", {
			Color = ColorSequence.new(LOADER.CYAN, LOADER.WHITE, LOADER.MAGENTA),
		}, fill)

		head = New("Frame", {
			Size = UDim2.fromOffset(4, 10),
			Position = UDim2.fromOffset(0, 0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 14,
		}, track)
		Round(head, 2)

		shimmer = New("Frame", {
			Size = UDim2.fromOffset(70, 10),
			Position = UDim2.fromOffset(-70, 0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.8,
			BorderSizePixel = 0,
			Rotation = 15,
			ZIndex = 14,
		}, track)

		statusText = Label({
			Size = UDim2.fromOffset(BARW / 2, 20),
			Position = UDim2.fromOffset(CX - BARW / 2, BAR_Y + 18),
			BackgroundTransparency = 1,
			Text = LOADER.STATUS[1],
			TextSize = 13,
			Font = FONT,
			TextColor3 = LOADER.CYAN,
			TextTransparency = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 12,
		}, LoadGui)
	end

	local lit = {}
	local shownPct = -1
	local shownIdx = 1
	local shownSeg = 0
	local arcOn = 0

	local function RevealCheck(idx)
		for i = 1, idx do
			if checkRows[i] and not checkRows[i].done then
				checkRows[i].done = true
				task.delay((i - idx) * 0.07, function()
					if not Alive() then return end
					Tw(checkRows[i].dot, { BackgroundTransparency = 0 }, 0.2)
					Tw(checkRows[i].name, { TextTransparency = 0.3 }, 0.3)
				end)
			end
		end
	end

	local function Ignite(i)
		if lit[i] then return end
		lit[i] = true
		labCore[i].TextColor3 = LOADER.WHITE
		local s = labCore[i]:FindFirstChildOfClass("UIScale")
		if s then
			s.Scale = 1.18
			Tw(s, { Scale = 1 }, 0.3, Enum.EasingStyle.Back)
		end
	end

	local function SetProgress(v)
		local k = math.clamp(v / 100, 0, 1)
		if fill then fill.Size = UDim2.fromScale(k, 1) end
		if head then
			head.Position = UDim2.new(k, -4, 0, 0)
			if head.BackgroundTransparency > 0 then
				Tw(head, { BackgroundTransparency = 0.05 }, 0.2)
			end
		end
		if segs then
			local want = math.floor(k * #segs + 0.5)
			for i = shownSeg + 1, want do
				local s = segs[i]
				s.BackgroundTransparency = 1
				Tw(s, { BackgroundTransparency = 0.1 }, 0.18)
				local sc = s:FindFirstChildOfClass("UIScale")
				if sc then
					sc.Scale = 1.5
					Tw(sc, { Scale = 1 }, 0.22, Enum.EasingStyle.Back)
				end
			end
			shownSeg = want
		end
		local wantArc = math.floor(k * #arc + 0.5)
		if wantArc ~= arcOn then
			for i = 1, wantArc do
				if not arc[i].on then
					arc[i].on = true
					arc[i].frame.BackgroundColor3 = LOADER.WHITE
					Tw(arc[i].frame, { BackgroundTransparency = 0.05 }, 0.22)
				end
			end
			arcOn = wantArc
		end
		for i = 1, #bloom do
			bloom[i].BackgroundTransparency = bloomBase[i] - k * 0.17
		end
		local p = math.floor(v + 0.5)
		if pctText and p ~= shownPct then
			shownPct = p
			pctText.Text = tostring(p) .. "%"
		end
		for i = 1, NC do
			if k >= i / NC then Ignite(i) end
		end
		if statusText then
			local idx = math.floor(k * (#LOADER.STATUS - 1)) + 1
			if idx > #LOADER.STATUS then idx = #LOADER.STATUS end
			if idx ~= shownIdx then
				shownIdx = idx
				statusText.Text = LOADER.STATUS[idx]
				if stageText then
					stageText.Text = string.format("STAGE %d/%d", idx, #LOADER.STATUS)
				end
				if LOADER.CHECKLIST then RevealCheck(idx) end
				if checkRows[idx] then checkRows[idx].name.TextColor3 = LOADER.WHITE end
			end
		end
	end

	local field = New("Frame", {
		Name = "Field",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 6,
	}, LoadGui)

	local specks = {}
	local embers = {}
	local targets = {}
	local slot = 0

	for i = 1, NC do
		local c = cells[i]
		local n = math.floor(c.w * LOADER.DOTS_PER_PX)
		if n < 3 then n = 3 end
		for _ = 1, n do
			slot += 1
			local depth = RNG:NextNumber(0.4, 1)
			local s = math.floor((LOADER.DOT_SIZE + RNG:NextInteger(0, 2)) * depth)
			if s < 1 then s = 1 end
			local r = RNG:NextNumber()
			local col = LOADER.CYAN
			if r < 0.13 then
				col = LOADER.MAGENTA
			elseif r < 0.28 then
				col = LOADER.WHITE
			end
			local sp = New("Frame", {
				Size = UDim2.fromOffset(s, s),
				Position = UDim2.fromOffset(
					RNG:NextNumber(16, math.max(36, W - 16)),
					RNG:NextNumber(16, math.max(36, H - 16))
				),
				BackgroundColor3 = col,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Rotation = RNG:NextNumber(0, 180),
				ZIndex = 6,
			}, field)
			Round(sp, 1)
			sp:SetAttribute("Depth", depth)
			specks[#specks + 1] = sp
			if i % 3 == 0 then embers[#embers + 1] = sp end
			targets[slot] = UDim2.fromOffset(
				CX + c.mid + (RNG:NextNumber() - 0.5) * c.w * 0.84,
				CY + (RNG:NextNumber() - 0.5) * ROW_H * 0.60
			)
		end
	end

	local flash = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 100,
	}, LoadGui)

	task.spawn(function()
		for _, sp in ipairs(specks) do
			task.wait(RNG:NextNumber(0, 8) / 100)
			local d = sp:GetAttribute("Depth") or 1
			Tw(sp, { BackgroundTransparency = RNG:NextNumber(0.05, 0.35) }, RNG:NextNumber(0.2, 0.5))
			sp.Position = UDim2.fromOffset(
				sp.Position.X.Offset + RNG:NextNumber(-30, 30) * d,
				sp.Position.Y.Offset + RNG:NextNumber(-30, 30) * d
			)
		end
	end)

	task.spawn(function()
		task.wait(LOADER.SCATTER)
		local perBatch = LOADER.GATHER_SPREAD / math.max(1, math.ceil(#specks / LOADER.BATCH))
		for i = 1, #specks do
			local sp = specks[i]
			Tw(sp, {
				Position = targets[i],
				BackgroundTransparency = 0.1,
				Rotation = 0,
			}, RNG:NextNumber(LOADER.GATHER_MIN, LOADER.GATHER_MAX),
				Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			if i % LOADER.BATCH == 0 then
				task.wait(perBatch)
			end
		end
	end)

	task.spawn(function()
		for _, l in ipairs(labCore) do
			Tw(l, { TextTransparency = 0.42 }, 0.5)
		end

		local done = {}
		for i = 1, NC do done[i] = false end
		local t0 = os.clock()
		local span = LOADER.GATHER_SPREAD * 0.92

		while os.clock() - t0 < span and Alive() do
			local el = os.clock() - t0
			for i = 1, NC do
				if not done[i] then
					local th = ((i - 1) / math.max(1, NC - 1)) * span
					if el >= th then
						done[i] = true
						SetGlyph(i, cells[i].ch)
						local s = labCore[i]:FindFirstChildOfClass("UIScale")
						if s then
							s.Scale = 1.22
							Tw(s, { Scale = 1 }, 0.26, Enum.EasingStyle.Back)
						end
					else
						SetGlyph(i, RandomGlyph())
					end
				end
			end
			task.wait(LOADER.DECODE_STEP)
		end

		for i = 1, NC do
			if not done[i] then SetGlyph(i, cells[i].ch) end
		end
	end)

	task.spawn(function()
		task.wait(LOADER.LOCK_AT)
		Shockwave(BW * 1.3, ROW_H * 2.0, 0.95)
		TearBurst(6, 90)
		SetGlitch(16, 0.04)
		FadeRow(rowGlow, 0.6, 0.45)
		for _, l in ipairs(labCore) do
			Tw(l, { TextTransparency = 0 }, 0.25)
			l.TextColor3 = LOADER.CYAN
		end
		SetGlitch(0, 0.25)
		PopLabels(labCore, 1.14)
		Tw(sub, { TextTransparency = 0.15 }, 0.5)
		for i = 1, 4 do
			Tw(tags[i], { TextTransparency = 0.45 }, 0.6)
			for _, d in ipairs(brackets[i]) do
				Tw(d, { BackgroundTransparency = 0.15 }, 0.6)
			end
		end
		Tw(logText, { TextTransparency = 0.25 }, 0.6)
		Tw(hexText, { TextTransparency = 0.5 }, 0.6)
		for i = 1, #embers do
			Tw(embers[i], { BackgroundTransparency = 0.88 }, 0.45)
		end
		if pctText then Tw(pctText, { TextTransparency = 0 }, 0.5) end
		if statusText then Tw(statusText, { TextTransparency = 0.1 }, 0.5) end
		if track then Tw(track, { BackgroundTransparency = 0 }, 0.4) end
		if fill then Tw(fill, { BackgroundTransparency = 0.86 }, 0.4) end
		if stageText then Tw(stageText, { TextTransparency = 0.4 }, 0.5) end
		if etaText then Tw(etaText, { TextTransparency = 0.3 }, 0.5) end
		for i = 1, #vignette do
			Tw(vignette[i], { BackgroundTransparency = 0.5 }, 1.1)
		end
		if LOADER.CHECKLIST then RevealCheck(1) end

		for _ = 1, 5 do
			task.wait(RNG:NextNumber(0.10, 0.30))
			SetGlitch(RNG:NextNumber(5, 16), 0.02)
			rjx = RNG:NextNumber(-4, 4)
			rjy = RNG:NextNumber(-2, 2)
			task.wait(0.07)
			SetGlitch(0, 0.05)
			rjx, rjy = 0, 0
		end

		if LOADER.RIPPLE then
			for i = 1, NC do
				local l = labCore[i]
				local bx, by = l.Position.X.Offset, l.Position.Y.Offset
				task.delay(i * 0.028, function()
					if not Alive() then return end
					Tw(l, { Position = UDim2.fromOffset(bx, by - 22) },
						0.16, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
					task.wait(0.16)
					Tw(l, { Position = UDim2.fromOffset(bx, by) }, 0.28, Enum.EasingStyle.Bounce)
				end)
			end
		end
	end)

	task.spawn(function()
		local acc = 0
		local i = 1
		while Alive() do
			acc += RunService.Heartbeat:Wait()
			if acc >= 0.06 then
				acc = 0
				for _ = 1, 5 do
					if i > #embers then i = 1 end
					local sp = embers[i]
					i += 1
					if sp and sp.Parent then
						sp.BackgroundTransparency = RNG:NextNumber(0.7, 0.95)
					end
				end
				local s = ""
				for _ = 1, 22 do
					s ..= string.format("%02X", RNG:NextInteger(0, 255)) .. " "
				end
				hexText.Text = s
			end
		end
	end)

	task.spawn(function()
		local sacc = 0
		while Alive() do
			local dt = RunService.Heartbeat:Wait()

			if LOADER.PARALLAX and UIS then
				local okm, m = pcall(function() return UIS:GetMouseLocation() end)
				if okm and m then
					local vx, vy = W * 0.5, H * 0.5
					if cam then
						local got, v = pcall(function() return cam.ViewportSize end)
						if got and v and v.X > 0 then vx, vy = v.X * 0.5, v.Y * 0.5 end
					end
					px = math.clamp((m.X - vx) * 0.020, -24, 24)
					py = math.clamp((m.Y - vy) * 0.013, -15, 15)
				end
			end
			ApplyRows()

			for _, d in ipairs(arc) do
				d.a = d.a + dt * 0.16
				d.frame.Position = UDim2.fromOffset(
					CX + math.cos(d.a) * d.rx + px * 1.8 - 6,
					CY + math.sin(d.a) * d.ry + py * 1.8 - 1
				)
				d.frame.Rotation = math.deg(d.a) - 90
			end

			if LOADER.STATIC then
				sacc += dt
				if sacc >= 0.05 then
					sacc = 0
					for _, s in ipairs(static) do
						s.Position = UDim2.fromOffset(0, RNG:NextNumber(0, H))
						s.Size = UDim2.fromOffset(W, RNG:NextNumber(1, 3))
						s.BackgroundColor3 = RNG:NextNumber() < 0.25 and LOADER.CYAN or Color3.new(1, 1, 1)
						s.BackgroundTransparency = RNG:NextNumber(0.9, 1)
					end
				end
			end
		end
	end)

	task.spawn(function()
		local ph = 0
		local horizon = CY + ROW_H * 0.5 + 40
		local N = LOADER.FLOOR_LINES
		while Alive() do
			local dt = RunService.Heartbeat:Wait()
			ph = (ph + dt * 0.22) % 1
			local floorH = H - horizon
			for i = 1, N do
				local f = floorLines[i]
				if f and f.Parent then
					local p = ((i - 1) / N + ph) % 1
					local e = p * p
					local w = W * (0.30 + 0.70 * p)
					f.Size = UDim2.fromOffset(w, 1 + p * 2)
					f.Position = UDim2.fromOffset(CX - w / 2, horizon + floorH * e)
					f.BackgroundTransparency = 0.88 - p * 0.45
				end
			end
			for i = 1, 13 do
				local f = floorLines[N + i]
				if f and f.Parent then
					local t = (i - 7) / 6
					f.Position = UDim2.fromOffset(CX + t * (26 + (ph * 900)), horizon)
					f.BackgroundTransparency = 0.88 - (ph * 0.5)
				end
			end
		end
	end)

	task.spawn(function()
		while Alive() do
			scanBand.Position = UDim2.fromOffset(0, -160)
			scanLine.Position = UDim2.fromOffset(0, -4)
			Tw(scanBand, { Position = UDim2.fromOffset(0, H) }, LOADER.SCANRATE, Enum.EasingStyle.Sine)
			Tw(scanLine, { Position = UDim2.fromOffset(0, H) }, LOADER.SCANRATE, Enum.EasingStyle.Sine)
			task.wait(LOADER.SCANRATE + 1.1)
		end
	end)

	task.spawn(function()
		while Alive() do
			local dt = RunService.Heartbeat:Wait()
			for _, o in ipairs(orbit) do
				if o.frame.Parent then
					o.a += o.sp * dt
					o.el = o.el + dt * 0.5
					if o.el > o.vert then o.el = -o.vert end
					o.frame.Position = UDim2.fromOffset(
						CX + math.cos(o.a) * o.r,
						CY + math.sin(o.a) * o.r * 0.34 + math.sin(o.el * 6) * 8
					)
					o.frame.BackgroundTransparency = 0.55 + math.sin(o.el * 5) * 0.25
				end
			end
		end
	end)

	task.spawn(function()
		task.wait(0.5)
		local buffer = {}
		for n = 1, #LOADER.LOG do
			local line = LOADER.LOG[n]
			for c = 1, #line do
				if not Alive() then return end
				table.insert(buffer, line:sub(c, c))
				local keep = math.max(1, #buffer - 6)
				local out = {}
				for i = keep, #buffer do table.insert(out, buffer[i]) end
				logText.Text = table.concat(out, "")
				task.wait(0.008)
			end
			table.insert(buffer, "\n")
			task.wait(0.10)
		end
	end)

	if LOADER.SHOW_BAR then
		task.spawn(function()
			task.wait(LOADER.LOCK_AT + 0.2)

			task.spawn(function()
				while shimmer and shimmer.Parent do
					Tw(shimmer, { Position = UDim2.fromOffset(BARW + 40, 0) }, 1.3, Enum.EasingStyle.Sine)
					task.wait(1.42)
					shimmer.Position = UDim2.fromOffset(-70, 0)
				end
			end)

			progress = 0
			SetProgress(0)
			local elapsed = 0
			while progress < 100 do
				if not Alive() then break end
				elapsed += RunService.Heartbeat:Wait()
				local k = math.clamp(elapsed / LOADER.LOAD_TIME, 0, 1)
				progress = (1 - (1 - k) * (1 - k)) * 100
				SetProgress(progress)
				if statusText then
					statusText.Text = LOADER.STATUS[shownIdx]
						.. string.rep(".", (math.floor(elapsed * 4) % 3) + 1)
				end
				if etaText then
					etaText.Text = string.format("T+ %04.1fs", elapsed)
				end
			end
			progress = 100
			SetProgress(100)
			if statusText then
				statusText.Text = LOADER.STATUS[#LOADER.STATUS]
				statusText.TextColor3 = LOADER.WHITE
			end
			if stageText then stageText.Text = "STAGE 6/6  READY" end

			SetGlitch(20, 0.05)
			TearBurst(5, 110)
			for i = 1, NC do Ignite(i) end
			PopLabels(labCore, 1.1)
			task.wait(0.18)
			SetGlitch(0, 0.12)
		end)
	end

	task.spawn(function()
		task.wait(LOADER.LOCK_AT + LOADER.LOAD_TIME + LOADER.HOLD)
		Tw(flash, { BackgroundTransparency = 0.55 }, 0.09)
		Shockwave(BW * 1.8, ROW_H * 3.0, 1.1)
		TearBurst(8, 130)
		task.wait(0.14)
		Tw(flash, { BackgroundTransparency = 1 }, 0.4)

		for i = 1, #specks do
			local sp = specks[i]
			if sp.Parent then
				local p = sp.Position
				local ang = math.atan2(p.Y.Offset - CY, p.X.Offset - CX)
				Tw(sp, {
					Position = UDim2.fromOffset(
						p.X.Offset + math.cos(ang) * 320,
						p.Y.Offset + math.sin(ang) * 320
					),
					BackgroundTransparency = 1,
				}, LOADER.FADE_OUT, Enum.EasingStyle.Cubic)
			end
		end
		for _, o in ipairs(orbit) do
			Tw(o.frame, { BackgroundTransparency = 1 }, LOADER.FADE_OUT)
		end
		for i = 1, #floorLines do
			local f = floorLines[i]
			if f then Tw(f, { BackgroundTransparency = 1 }, LOADER.FADE_OUT) end
		end
		FadeRow(rowGlow, 1, LOADER.FADE_OUT)
		FadeRow(rowCore, 1, LOADER.FADE_OUT)
		SetGlitch(0, 0.01)
		FadeAll(1, LOADER.FADE_OUT)
		if fill then Tw(fill, { BackgroundTransparency = 1 }, LOADER.FADE_OUT) end
		if shimmer then Tw(shimmer, { BackgroundTransparency = 1 }, LOADER.FADE_OUT) end
		if segs then
			for i = 1, #segs do
				Tw(segs[i], { BackgroundTransparency = 1 }, LOADER.FADE_OUT)
			end
		end

		task.wait(LOADER.FADE_OUT + 0.1)
		if vpConn then pcall(function() vpConn:Disconnect() end) end
		if not LOADER.KEEP_AFTER then
			pcall(function()
				if LoadGui and LoadGui.Parent then LoadGui:Destroy() end
			end)
		end
		if not LoaderDone then
			LoaderDone = true
			LoaderGate:Fire()
		end
	end)
end)

if not ok then
	warn("[SpectrixHook] loader failed: " .. tostring(err))
	pcall(function()
		if LoadGui and LoadGui.Parent then LoadGui:Destroy() end
	end)
	if not LoaderDone then
		LoaderDone = true
		LoaderGate:Fire()
	end
end

-- ===================== LOADER GATE =====================
-- Wait on the state flag instead of relying only on BindableEvent:Wait().
-- BindableEvent signals are not queued, so an early loader completion could
-- otherwise be missed and leave the script waiting forever.
if not LoaderDone then
	while not LoaderDone do
		task.wait()
	end
end

print("[VoidHook] loader complete; starting cheat")


local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local Workspace        = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting         = game:GetService("Lighting")
local Terrain          = Workspace.Terrain

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local OriginalFieldOfView
local FOVWasApplied = false
local player = LocalPlayer
local Status

print("[Spectrix.Hook] Drawing available:", Drawing ~= nil)

-- Main feature config: this table stores the cheat's toggle states, colors,
-- values, and runtime flags used by the menu and the active hooks.

-- Theme
local BG      = Color3.fromRGB(9, 12, 18)
local SIDE    = Color3.fromRGB(17, 20, 29)
local PANEL   = Color3.fromRGB(22, 26, 36)
local FG      = Color3.fromRGB(240, 244, 255)
local MUTED   = Color3.fromRGB(152, 166, 185)
local DIM     = Color3.fromRGB(96, 110, 132)
local ACCENT  = Color3.fromRGB(123, 97, 255)
local ACCENT_2= Color3.fromRGB(67, 225, 204)
local HOVER   = Color3.fromRGB(28, 34, 45)
local LINE    = Color3.fromRGB(47, 57, 72)

-- FEATURE FLAGS: core cheat config for rage, visuals, movement, world, and misc
-- toggles. These values control the active behavior behind the menu and hooks.
local Flags = {
    SilentAim = false, Aimbot = false, AimFOV = 180, AimSmooth = 0.18, AimHitPart = "Head", SA_WallCheck = true, SA_Prediction = true, SA_TeamCheck = true,
    SA_TargetAI = true, SA_FOV = 180, SA_HitPart = "Head", SA_MaxDistance = 300,
    SA_Snapline = true,
    SA_CircleColor = Color3.fromRGB(0, 255, 100),
    SA_SnapColor   = Color3.fromRGB(0, 200, 255),
    SA_CircleThickness = 1.5,
    SA_SnapThickness   = 3.5,
    SA_SnapTransparency = 1,
    Crosshair = false, CrosshairFollow = true, CrosshairPulse = true, CrosshairPulseAmount = 4, CrosshairRainbow = false, CrosshairShape = "Dot",
    CrosshairColor = Color3.fromRGB(255,255,255),
    CrosshairLength = 12, CrosshairThickness = 2, CrosshairGap = 4, CrosshairOpacity = 1, CrosshairSpin = 0,
    CrosshairOutline = true, CrosshairDot = false, CrosshairPos = "Mouse",
    InstantReload = false, AutoPackMags = false, ForceAuto = false,

    ESP = false, ESP_Box = true, ESP_Name = true, ESP_Distance = true,
    ESP_Tracer = false, ESP_Health = true, ESP_Skeleton = false,
    Chams = false, ChamsTransparency = 0.25,
    -- Backtrack-style ESP options
    ESP_BoxStyle = "Dynamic", ESP_BoxThickness = 1,
    ESP_Glow = false, ESP_GlowTransparency = 0.7,
    ESP_Fill = false, ESP_FillTransparency = 0.7,
    ESP_HealthBar = false, ESP_Weapon = false, ESP_Flags = false,
    ESP_RenderDist = 1300, ESP_TextSize = 13, ESP_TextCase = "Normal",
    ESP_DistFormat = "m", ESP_TeamCheck = false, ESP_SnaplineFrom = "Bottom",
    ThemeColor = ACCENT,
    ESPColors = {
        Box = Color3.fromRGB(255, 255, 255),
        Name = Color3.fromRGB(255, 255, 255),
        Distance = Color3.fromRGB(255, 255, 255),
        Health = Color3.fromRGB(255, 255, 255),
        Tracer = Color3.fromRGB(255, 255, 255),
        Skeleton = Color3.fromRGB(255, 255, 255),
        Chams = Color3.fromRGB(255, 255, 255),
        Item = Color3.fromRGB(255, 255, 255),
        Corpse = Color3.fromRGB(255, 255, 255),
        Extract = Color3.fromRGB(255, 255, 255),
        AI = Color3.fromRGB(255, 80, 80),
    },
    ItemESP = false, CorpseESP = false, ExtractESP = false,
    AI_ESP = false, AI_ESP_Box = true, AI_ESP_Name = true, AI_ESP_Distance = true,
    AI_ESP_Health = true, AI_ESP_Tracer = false, AI_ESP_Skeleton = false, AI_ESP_MaxDist = 1000,

    Speed = false, SpeedValue = 26,
    ThirdPerson = false, ThirdPersonDist = 12,
    BHop = false, WalkOnWater = false, NoFall = false, Noclip = false,
    NoclipFloors = true, NoclipWalls = true, NoclipLayers = 1, NoclipSpeed = 2,

    AntiAim = false, AA_YawValue = 180,
    NoRecoil = false,
    RapidKnife = false, RapidKnifeRate = 1,

    -- Insta Hit / combat extras (ported from femhax)
    InstantHit = false, ForceHitbox = false, ForceHitboxPart = "Head", ForceHitboxChance = 100,
    SA_NoPrediction = false,
    FirerateOverride = false, FirerateValue = 0.05, NoBolt = false, InstantADS = false,

    -- Force Render (ESP): stream unrendered players around us
    ForceRender = false, ForceRenderMode = "Render All",

    ReportNotifications = false,
    ReportNotifySound = false,
    ReportNotifyFlashing = true,
    ReportNotifyDuration = 3,
    ReportNotifyVolume = 1,
    ReportAttribute = "1",

    CustomFOV = false, FOVValue = 70, Zoom = false, ZoomValue = 30,

    DebugCamera = false, DebugCamSpeed = 2,

    FullBright = false, NoGrass = false, NoTrees = false, VisualDesync = false,
    NoFog = false, EnvAmbientOut = false, EnvAmbientOutColor = Color3.fromRGB(70, 70, 70),
    EnvAmbientIn = false, EnvAmbientInColor = Color3.fromRGB(20, 20, 20),
    EnvBrightness = false, EnvBrightnessVal = 2,
    EnvAtmo = false, EnvAtmoDensity = 0.3, EnvAtmoOffset = 0, EnvAtmoGlare = 0, EnvAtmoHaze = 0,
    EnvAtmoColor = Color3.fromRGB(199, 170, 107), EnvTime = false, EnvTimeVal = 12,
    AC_Detection = false, AC_Alert = true,

    InvChecker = false, InvFull = false, InvValue = false, InvCorpse = false, InvDrag = true,
    InvFinderOn = false, InvFinderItem = {},
    InvFinderGlow = 5, InvFinderX = nil, InvFinderY = 50,
    InvX = 200, InvY = 200, InvScale = 100, InvDelay = 10,
}

local Connections = {}
local ESPObjects, MiscESP, ChamObjects = {}, {}, {}
local function RemoveDrawingObject(obj)
    if type(obj) == "table" then
        for _, child in pairs(obj) do
            RemoveDrawingObject(child)
        end
    elseif obj and obj.Remove then
        pcall(function() obj:Remove() end)
    end
end

local DesyncClone, DesyncHighlight
local OriginalCameraMode, OriginalMaxZoom, OriginalMinZoom
local WaterPart = nil
local InstantReloadDebounce = false
local DebugCamActive, DebugCamOrigin = false, nil
local SAFOV, SASnap
local NoclipClip, NoclipBackup = nil, {}
local AmmoBackup = {}
local FirerateBackup = setmetatable({}, { __mode = "k" })
local BoltBackup = setmetatable({}, { __mode = "k" })
local AdsBackup = setmetatable({}, { __mode = "k" })

local Colors = {
    {"Green",  Color3.fromRGB(0, 255, 100)},
    {"Cyan",   Color3.fromRGB(0, 200, 255)},
    {"Red",    Color3.fromRGB(255, 60, 60)},
    {"Yellow", Color3.fromRGB(255, 220, 0)},
    {"White",  Color3.fromRGB(255, 255, 255)},
    {"Purple", Color3.fromRGB(180, 80, 255)},
    {"Orange", Color3.fromRGB(255, 140, 0)},
}
local CircleColorIdx, SnapColorIdx = 1, 2

local function DisconnectAll()
    for _, c in pairs(Connections) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(Connections)
end

-- ===================== 02 | UI AND CONTROLS =====================
local UIS = UserInputService
local HttpService = game:GetService("HttpService")
local CAS = game:GetService("ContextActionService")

local TITLE = "VoidHook"
local TOGGLE_KEY = Enum.KeyCode.RightShift

;(function()
local SCALE = 1.2

local FOLDER = "spectrix.hook"
local CONFIG_DIR = FOLDER .. "/configs"

local BG_IMAGE = "rbxassetid://0"
local LOGO_IMAGE = "rbxassetid://0"
local LOGO_ASPECT = 1263 / 740

local HAS_BG = BG_IMAGE ~= "" and BG_IMAGE ~= "rbxassetid://0"
local HAS_LOGO = LOGO_IMAGE ~= "" and LOGO_IMAGE ~= "rbxassetid://0"

local FONT, SIZE = Enum.Font.Code, 13
local C = {
    BG = Color3.fromRGB(10, 10, 12),
    Panel = Color3.fromRGB(14, 14, 17),
    Field = Color3.fromRGB(22, 22, 26),
    Button = Color3.fromRGB(34, 34, 39),
    ButtonHover = Color3.fromRGB(46, 46, 53),
    ButtonDown = Color3.fromRGB(24, 24, 28),
    Border = Color3.fromRGB(74, 20, 24),
    Outline = Color3.fromRGB(52, 52, 58),
    Accent = Color3.fromRGB(220, 22, 22),
    Text = Color3.fromRGB(200, 200, 200),
    Dim = Color3.fromRGB(122, 122, 128),
}
local FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local PANEL_ALPHA = 0.5
local CORNER = 3

local accented, controls, accentHooks = {}, {}, {}

local function dark(m)
    return function(c) return Color3.new(c.R * m, c.G * m, c.B * m) end
end
local borderFn = dark(0.34)

local function accent(inst, prop, fn)
    table.insert(accented, { inst, prop, fn })
    inst[prop] = fn and fn(C.Accent) or C.Accent
end
local function setAccent(col)
    C.Accent = col
    for _, a in ipairs(accented) do
        if a[1].Parent then a[1][a[2]] = a[3] and a[3](col) or col end
    end
    for _, h in ipairs(accentHooks) do h(col) end
end
local function tween(inst, props) TweenService:Create(inst, FAST, props):Play() end

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function stroke(p, col)
    local s = new("UIStroke", { Color = col or C.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, p)
    if col == nil or col == C.Border then accent(s, "Color", borderFn) end
    return s
end
local function round(p, r) return p end
local function pad(p, t, b, l, r)
    new("UIPadding", { PaddingTop = UDim.new(0, t), PaddingBottom = UDim.new(0, b), PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r) }, p)
end
local function vlist(p, gap)
    new("UIListLayout", { Padding = UDim.new(0, gap), SortOrder = Enum.SortOrder.LayoutOrder }, p)
end
local function hlist(p, gap)
    new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, gap), SortOrder = Enum.SortOrder.LayoutOrder }, p)
end
local function text(p, str, col, align, h)
    return new("TextLabel", {
        BackgroundTransparency = 1, Text = str, Font = FONT, TextSize = SIZE, TextColor3 = col or C.Text,
        TextXAlignment = align or Enum.TextXAlignment.Left, Size = UDim2.new(1, 0, 0, h or 17),
    }, p)
end
local function fmt(v) return string.format("%g", math.floor(v * 10 + 0.5) / 10) end
local function isPointer(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

-- GUI shell: builds the draggable settings menu, tabs, buttons, notifications,
-- and bind configuration used to control the active features.
local gui = new("ScreenGui", { Name = "SettingsMenu", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }, player:WaitForChild("PlayerGui"))

local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)

local toast = new("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -18), Size = UDim2.new(), AutomaticSize = Enum.AutomaticSize.XY,
    BackgroundColor3 = C.BG, BackgroundTransparency = 1, TextTransparency = 1, Text = "", Font = FONT, TextSize = 14,
    TextColor3 = C.Text, ZIndex = 50,
}, gui)
round(toast, CORNER)
pad(toast, 5, 5, 10, 10)
local toastId = 0
local notifySound
local function playNotifySound(volume)
    local ok, svc = pcall(function() return game:GetService("SoundService") end)
    if not ok or not svc then return end
    if not notifySound or not notifySound.Parent then
        notifySound = new("Sound", { SoundId = "rbxassetid://4585382046" }, svc)
    end
    notifySound.Volume = tonumber(volume) or 1
    pcall(function() notifySound:Play() end)
end
-- notify(msg[, opts]) - opts: { duration, flashing, sound, volume }
local function notify(msg, opts)
    opts = opts or {}
    toastId += 1
    local id = toastId
    local dur = tonumber(opts.duration) or 2.5
    toast.Text = msg
    toast.TextColor3 = C.Text
    TweenService:Create(toast, FAST, { BackgroundTransparency = 0.1, TextTransparency = 0 }):Play()
    if opts.sound then playNotifySound(opts.volume) end
    if opts.flashing then
        task.spawn(function()
            local t = 0
            while toastId == id and t < dur do
                tween(toast, { TextColor3 = C.Accent })
                task.wait(0.22)
                if toastId ~= id then break end
                tween(toast, { TextColor3 = C.Text })
                task.wait(0.22)
                t += 0.44
            end
            if toastId == id then toast.TextColor3 = C.Text end
        end)
    end
    task.delay(dur, function()
        if id == toastId and toast.Parent then
            TweenService:Create(toast, TweenInfo.new(0.3), { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
        end
    end)
end

local reportWatchConn, reportNodeConn, reportRetry = nil, nil, 0
local function player_node()
    local rp = ReplicatedStorage:FindFirstChild("Players")
    if not rp or not player then return nil end
    return rp:FindFirstChild(player.Name)
end

local function reports_node()
    local node = player_node()
    if not node then return nil end
    local status = node:FindFirstChild("Status")
    local uac = status and status:FindFirstChild("UAC")
    if not uac then
        local journey = node:FindFirstChild("Journey")
        local jstatus = journey and journey:FindFirstChild("Status")
        uac = jstatus and jstatus:FindFirstChild("UAC")
    end
    if not uac then uac = node:FindFirstChild("UAC", true) end
    return uac and uac:FindFirstChild("Reports")
end

local function getReportCount()
    local reports = reports_node()
    if not reports then return 0 end
    for _, key in ipairs({ Flags.ReportAttribute, "1", "ReportCount" }) do
        local value = reports:GetAttribute(key)
        if value ~= nil then return tonumber(value) or 0 end
    end
    return 0
end

local function reportNotify(text)
    notify(text, {
        duration = Flags.ReportNotifyDuration,
        flashing = Flags.ReportNotifyFlashing,
        sound = Flags.ReportNotifySound,
        volume = Flags.ReportNotifyVolume,
    })
end

local function showReportNotification()
    if not Flags.ReportNotifications then return end
    local count = getReportCount()
    local text
    if count > 0 then
        text = "You have been reported " .. count .. " time" .. (count == 1 and "" or "s") .. "!"
    else
        text = "You have not been reported"
    end
    reportNotify(text)
end

local function bindReportsWatcher()
    local reports = reports_node()
    if not reports then return false end
    if reportWatchConn then reportWatchConn:Disconnect() end
    reportWatchConn = reports:GetAttributeChangedSignal(Flags.ReportAttribute):Connect(function()
        if Flags.ReportNotifications then showReportNotification() end
    end)
    return true
end

local function watchReports()
    if reportWatchConn then reportWatchConn:Disconnect(); reportWatchConn = nil end
    if reportNodeConn then reportNodeConn:Disconnect(); reportNodeConn = nil end
    if bindReportsWatcher() then return end
    reportRetry = 0
    reportNodeConn = RunService.Heartbeat:Connect(function(dt)
        reportRetry += dt
        if reportRetry < 0.5 then return end
        reportRetry = 0
        if bindReportsWatcher() then
            reportNodeConn:Disconnect()
            reportNodeConn = nil
        end
    end)
end

local drag, resize
local applySize
local tabs = {}
local TOP_H, TAB_H = 30, 28
local function headerH() return TOP_H + (#tabs > 0 and TAB_H or 0) end
local MIN_W, MIN_H = 480, 320
local maxW, maxH = math.max(viewport.X, MIN_W), math.max(viewport.Y, MIN_H)

local function makeDraggable(handle, target, canDrag)
    handle.InputBegan:Connect(function(i)
        if isPointer(i) and canDrag() then
            drag = { target = target, pos = target.Position, mouse = i.Position }
        end
    end)
end

UIS.InputChanged:Connect(function(i)
    if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
    if drag then
        local d = i.Position - drag.mouse
        local p = drag.pos
        drag.target.Position = UDim2.new(p.X.Scale, p.X.Offset + d.X, p.Y.Scale, p.Y.Offset + d.Y)
    elseif resize then
        local d = i.Position - resize.mouse
        applySize(math.clamp(resize.size.X + d.X, MIN_W, maxW), math.clamp(resize.size.Y + d.Y, MIN_H, maxH))
    end
end)
UIS.InputEnded:Connect(function(i)
    if isPointer(i) then drag, resize = nil, nil end
end)

local function section(parent, title, order)
    local f = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.Panel,
        BackgroundTransparency = PANEL_ALPHA, LayoutOrder = order or 0,
    }, parent)
    round(f, 8)
    stroke(f, C.Border)
    pad(f, 7, 10, 9, 9)
    vlist(f, 6)
    text(f, title)
    return f
end

local function button(parent, str, cb, width)
    local b = new("TextButton", {
        Size = width or UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.Button, AutoButtonColor = false,
        Text = str, Font = FONT, TextSize = SIZE, TextColor3 = C.Text,
    }, parent)
    round(b, CORNER)
    local st = stroke(b, C.Outline)
    new("UIGradient", { Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(172, 172, 180)), Rotation = 90 }, b)
    local function look(bg, line) tween(b, { BackgroundColor3 = bg }); tween(st, { Color = line }) end
    b.MouseEnter:Connect(function() look(C.ButtonHover, C.Accent) end)
    b.MouseLeave:Connect(function() look(C.Button, C.Outline) end)
    b.MouseButton1Down:Connect(function() look(C.ButtonDown, C.Accent) end)
    b.MouseButton1Up:Connect(function() look(C.ButtonHover, C.Accent) end)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end

local function buttonRow(parent, a, b)
    local row = new("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1 }, parent)
    hlist(row, 6)
    button(row, a[1], a[2], UDim2.new(0.5, -3, 1, 0))
    button(row, b[1], b[2], UDim2.new(0.5, -3, 1, 0))
end

local toggle, FeatureBinds, FeatureBindButtons, FeatureBindModes, bindLabel = (function()
-- Isolated bind controller. Bind, then choose Hold / Always / Toggle.
local FeatureBinds, FeatureBindButtons, FeatureBindModes = {}, {}, {}
local ListeningFeatureBind, BindCaptureReady = nil, false
local HoldActive = {}

local function bindLabel(b)
    if not b then return "Bind" end
    return b.kind == "Keyboard" and tostring(b.key) or tostring(b.key):gsub("MouseButton", "M")
end
local function inputToBinding(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
        return {kind="Keyboard", key=input.KeyCode.Name}
    end
    local n=input.UserInputType.Name
    if n:match("^MouseButton[1-5]$") then return {kind="Mouse", key=n} end
end
local function bindingMatches(b,input)
    local x=inputToBinding(input)
    return x and b and x.kind==b.kind and x.key==b.key
end
local function clearFeatureBind(id)
    FeatureBinds[id]=nil; HoldActive[id]=nil
    if FeatureBindButtons[id] then FeatureBindButtons[id].Text="Bind" end
end

local function setBound(id, value)
    if controls[id] then controls[id].Set(value) end
end

UIS.InputBegan:Connect(function(input, processed)
    if ListeningFeatureBind then
        if input.UserInputType==Enum.UserInputType.MouseButton1 and not BindCaptureReady then return end
        local id=ListeningFeatureBind
        ListeningFeatureBind=nil; BindCaptureReady=false
        local btn=FeatureBindButtons[id]
        if btn then btn.TextColor3=C.Dim end
        if input.KeyCode==Enum.KeyCode.Escape then clearFeatureBind(id); return end
        local b=inputToBinding(input)
        if b then FeatureBinds[id]=b; if btn then btn.Text=bindLabel(b) end end
        return
    end
    if processed then return end
    for id,b in pairs(FeatureBinds) do
        if bindingMatches(b,input) and controls[id] then
            local mode=FeatureBindModes[id] or "Hold"
            if mode=="Hold" then
                HoldActive[id]=true; setBound(id,true)
            elseif mode=="Toggle" then
                setBound(id,not controls[id].Get())
            end
        end
    end
end)
UIS.InputEnded:Connect(function(input)
    if ListeningFeatureBind and input.UserInputType==Enum.UserInputType.MouseButton1 then
        BindCaptureReady=true
        return
    end
    for id,b in pairs(FeatureBinds) do
        if bindingMatches(b,input) and (FeatureBindModes[id] or "Always")=="Hold" and HoldActive[id] then
            HoldActive[id]=nil; setBound(id,false)
        end
    end
end)
RunService.Heartbeat:Connect(function()
    for id in pairs(FeatureBinds) do
        if FeatureBindModes[id]=="Always" and controls[id] and not controls[id].Get() then
            controls[id].Set(true)
        end
    end
end)

local function makeBindMenu(id, modeBtn, parent)
    local menu=new("Frame",{Size=UDim2.fromOffset(92,86),Position=UDim2.new(1,-94,0,24),BackgroundColor3=C.BG,BorderSizePixel=0,Visible=false,ZIndex=300},parent)
    round(menu,5); stroke(menu,C.Outline)
    local function option(y,label,mode)
        local b=new("TextButton",{Size=UDim2.new(1,-8,0,22),Position=UDim2.fromOffset(4,y),BackgroundColor3=C.Field,AutoButtonColor=false,Text=label,Font=FONT,TextSize=SIZE-1,TextColor3=C.Text,ZIndex=301},menu)
        round(b,3)
        b.MouseButton1Click:Connect(function()
            FeatureBindModes[id]=mode
            modeBtn.Text=mode
            HoldActive[id]=nil
            if mode=="Always" then
                setBound(id,true)
            elseif mode=="Hold" then
                setBound(id,false)
            end
            menu.Visible=false
        end)
    end
    option(4,"Hold","Hold"); option(31,"Always","Always"); option(58,"Toggle","Toggle")
    return menu
end

local function toggle(parent,name,default,cb,key,bindable)
    local state=default; local id=key or name
    local onCol = Color3.fromRGB(0, 140, 255)
    local row=new("TextButton",{Size=UDim2.new(1,0,0,24),BackgroundTransparency=1,Text="",AutoButtonColor=false},parent)
    local t=text(row,name); t.Position=UDim2.fromOffset(2,0); t.Size=UDim2.new(1,-130,1,0)
    local box=new("Frame",{Size=UDim2.fromOffset(16,16),Position=UDim2.new(1,-18,0.5,-8),BackgroundColor3=state and onCol or C.Field,BorderSizePixel=0},row)
    local st=stroke(box,C.Outline)
    local bindBtn=new("TextButton",{Size=UDim2.fromOffset(50,20),Position=UDim2.new(1,-124,0.5,-10),Visible=bindable==true,BackgroundColor3=C.Field,AutoButtonColor=false,Text="Bind",Font=FONT,TextSize=math.max(SIZE-1,10),TextColor3=C.Dim},row)
    stroke(bindBtn,C.Outline)
    local modeBtn=new("TextButton",{Size=UDim2.fromOffset(50,20),Position=UDim2.new(1,-70,0.5,-10),Visible=bindable==true,BackgroundColor3=C.Field,AutoButtonColor=false,Text="Hold",Font=FONT,TextSize=math.max(SIZE-2,9),TextColor3=C.Dim},row)
    stroke(modeBtn,C.Outline)
    if bindable==true then
        FeatureBindButtons[id]=bindBtn; FeatureBindModes[id]="Hold"
        local menu=makeBindMenu(id,modeBtn,row)
        bindBtn.MouseButton1Click:Connect(function()
            if ListeningFeatureBind then return end
            ListeningFeatureBind=id; BindCaptureReady=false; bindBtn.Text="Press"; bindBtn.TextColor3=C.Accent; menu.Visible=false
        end)
        modeBtn.MouseButton1Click:Connect(function() if not ListeningFeatureBind then menu.Visible=not menu.Visible end end)
    end
    row.MouseEnter:Connect(function() tween(st,{Color=onCol}); tween(t,{TextColor3=Color3.new(1,1,1)}) end)
    row.MouseLeave:Connect(function() tween(st,{Color=C.Outline}); tween(t,{TextColor3=C.Text}) end)
    local api={}
    function api.Set(v) state=v and true or false; tween(box,{BackgroundColor3=state and onCol or C.Field}); if cb then task.spawn(cb,state) end end
    function api.Get() return state end
    row.MouseButton1Click:Connect(function() api.Set(not state) end)
    controls[id]=api
    return api
end
return toggle, FeatureBinds, FeatureBindButtons, FeatureBindModes, bindLabel
end)()

local function slider(parent, name, min, max, default, step, suffix, cb)
    suffix = suffix or ""
    step = step or 1
    local value = default
    local holder = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1 }, parent)
    local t = text(holder, "", nil, nil, 17)
    local bar = new("Frame", { Size = UDim2.new(1, 0, 0, 11), Position = UDim2.fromOffset(0, 21), BackgroundColor3 = C.Field, BorderSizePixel = 0 }, holder)
    round(bar, 4)
    accent(stroke(bar, Color3.fromRGB(40, 20, 22)), "Color", dark(0.18))
    local fill = new("Frame", { BorderSizePixel = 0, Size = UDim2.fromScale(0, 1) }, bar)
    round(fill, 4)
    accent(fill, "BackgroundColor3")
    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 17), Position = UDim2.fromOffset(0, 17), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
    }, holder)

    local api = {}
    local function render()
        fill.Size = UDim2.fromScale(math.max((value - min) / (max - min), 0.02), 1)
        t.Text = name .. ": " .. fmt(value) .. suffix
    end
    function api.Set(v)
        v = min + math.floor((v - min) / step + 0.5) * step
        value = math.clamp(v, min, max)
        render()
        if cb then task.spawn(cb, value) end
    end
    function api.Get() return value end

    local dragging = false
    local function fromX(x)
        local w = bar.AbsoluteSize.X
        if w <= 0 then return end
        api.Set(min + (max - min) * math.clamp((x - bar.AbsolutePosition.X) / w, 0, 1))
    end
    hit.InputBegan:Connect(function(i)
        if isPointer(i) then
            dragging = true
            fromX(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromX(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if isPointer(i) then dragging = false end
    end)
    render()
    controls[name] = api
    return api
end

local function dropdown(parent, name, options, default, cb)
    local current = default
    text(parent, name)
    local holder = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, parent)
    vlist(holder, 3)
    local head = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.Field, AutoButtonColor = false, Text = "  " .. current,
        Font = FONT, TextSize = SIZE, TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Left,
    }, holder)
    round(head, CORNER)
    local st = stroke(head, C.Outline)
    local arrow = text(head, "â–¾", C.Dim, Enum.TextXAlignment.Right, 26)
    arrow.Size = UDim2.new(1, -9, 1, 0)
    head.MouseEnter:Connect(function() tween(st, { Color = C.Accent }) end)
    head.MouseLeave:Connect(function() tween(st, { Color = C.Outline }) end)

    local drop = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.Field, Visible = false }, holder)
    round(drop, CORNER)
    stroke(drop, C.Outline)
    pad(drop, 3, 3, 0, 0)
    vlist(drop, 0)

    local api = {}
    local function setOpen(o) drop.Visible = o; arrow.Text = o and "â–´" or "â–¾" end
    function api.Set(v) current = v; head.Text = "  " .. v; setOpen(false); if cb then task.spawn(cb, v) end end
    function api.Get() return current end
    function api.SetOptions(opts)
        for _, c in ipairs(drop:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, o in ipairs(opts) do
            local b = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Text = "  " .. o, Font = FONT, TextSize = SIZE,
                TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
            }, drop)
            b.MouseEnter:Connect(function() tween(b, { TextColor3 = C.Accent }) end)
            b.MouseLeave:Connect(function() tween(b, { TextColor3 = C.Text }) end)
            b.MouseButton1Click:Connect(function() api.Set(o) end)
        end
    end
    head.MouseButton1Click:Connect(function() setOpen(not drop.Visible) end)
    api.SetOptions(options)
    controls[name] = api
    return api
end

local function colorPicker(parent, label, flagKey)
    local function getColor()
        if flagKey == "__SA_Circle" then
            return Flags.SA_CircleColor or Color3.fromRGB(0,255,100)
        elseif flagKey == "__SA_Snap" then
            return Flags.SA_SnapColor or Color3.fromRGB(0,200,255)
        elseif flagKey == "__Crosshair" then
            return Flags.CrosshairColor or Color3.fromRGB(255,255,255)
        elseif flagKey == "__EnvAmbientOut" then
            return Flags.EnvAmbientOutColor or Color3.fromRGB(70,70,70)
        elseif flagKey == "__EnvAmbientIn" then
            return Flags.EnvAmbientInColor or Color3.fromRGB(20,20,20)
        elseif flagKey == "__EnvAtmoColor" then
            return Flags.EnvAtmoColor or Color3.fromRGB(199,170,107)
        end
        return (Flags.ESPColors and Flags.ESPColors[flagKey]) or Color3.fromRGB(255,255,255)
    end

    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        ZIndex = 20,
    }, parent)

    local lab = text(row, label)
    lab.Size = UDim2.new(1, -42, 1, 0)
    lab.Position = UDim2.fromOffset(0, 0)
    lab.TextXAlignment = Enum.TextXAlignment.Left
    lab.ZIndex = 20

    local swatch = new("TextButton", {
        Size = UDim2.fromOffset(30, 22),
        Position = UDim2.new(1, -30, 0.5, -11),
        BackgroundColor3 = getColor(),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 21,
    }, row)
    round(swatch, 4)
    stroke(swatch, C.Outline)

    local picker = new("Frame", {
        Size = UDim2.fromOffset(218, 285),
        Position = UDim2.new(1, -218, 1, 4),
        BackgroundColor3 = C.BG,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 100,
    }, row)
    round(picker, 5)
    stroke(picker, C.Outline)
    picker.ClipsDescendants = false

    local title = text(picker, label, C.Text)
    title.Size = UDim2.new(1, -34, 0, 22)
    title.Position = UDim2.fromOffset(6, 3)
    title.ZIndex = 101

    local closePicker = new("TextButton", {
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.new(1, -27, 0, 3),
        BackgroundTransparency = 1,
        Text = "Ã—",
        Font = FONT,
        TextSize = 18,
        TextColor3 = C.Dim,
        AutoButtonColor = false,
        ZIndex = 110,
    }, picker)
    closePicker.MouseButton1Click:Connect(function()
        picker.Visible = false
    end)

    local current = getColor()
    local h, sat, val = Color3.toHSV(current)
    local alpha = 1
    local rainbow = false

    -- Saturation / brightness square:
    -- base = pure hue, white gradient = saturation, black gradient = value.
    local sv = new("Frame", {
        Size = UDim2.fromOffset(178, 140),
        Position = UDim2.fromOffset(6, 29),
        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 101,
    }, picker)

    local whiteLayer = new("Frame", {
        Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 102,
    }, sv)
    new("UIGradient", {
        Color = ColorSequence.new(Color3.new(1,1,1), Color3.new(1,1,1)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 0,
    }, whiteLayer)

    local blackLayer = new("Frame", {
        Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.new(0,0,0),
        BorderSizePixel = 0,
        ZIndex = 103,
    }, sv)
    new("UIGradient", {
        Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
    }, blackLayer)

    local svMarker = new("Frame", {
        Size = UDim2.fromOffset(12,12),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 106,
    }, sv)
    round(svMarker, 6)
    stroke(svMarker, Color3.new(0,0,0))

    -- Rainbow hue strip.
    local hue = new("Frame", {
        Size = UDim2.fromOffset(20, 140),
        Position = UDim2.fromOffset(190, 29),
        BorderSizePixel = 0,
        ZIndex = 101,
    }, picker)
    new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,0,0)),
        }),
        Rotation = 90,
    }, hue)
    local hueMarker = new("Frame", {
        Size = UDim2.fromOffset(24, 5),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 106,
    }, hue)
    round(hueMarker, 2)

    -- Checkerboard alpha bar with the selected color fading to transparent.
    local alphaHolder = new("Frame", {
        Size = UDim2.fromOffset(204, 18),
        Position = UDim2.fromOffset(6, 176),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 101,
    }, picker)
    for yy=0,1 do
        for xx=0,11 do
            local sq = new("Frame", {
                Size = UDim2.fromOffset(17,9),
                Position = UDim2.fromOffset(xx*17, yy*9),
                BackgroundColor3 = ((xx+yy)%2==0) and Color3.fromRGB(238,238,238) or Color3.fromRGB(180,180,180),
                BorderSizePixel = 0,
                ZIndex = 101,
            }, alphaHolder)
        end
    end
    local alphaTint = new("Frame", {
        Size = UDim2.fromScale(1,1),
        BackgroundColor3 = current,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, alphaHolder)
    new("UIGradient", {
        Color = ColorSequence.new(current, current),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Rotation = 0,
    }, alphaTint)
    local alphaMarker = new("Frame", {
        Size = UDim2.fromOffset(4, 22),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = UDim2.new(alpha,0,0.5,0),
        BackgroundColor3 = Color3.new(1,1,1),
        BorderSizePixel = 0,
        ZIndex = 106,
    }, alphaHolder)

    local rainbowButton = new("TextButton", {
        Size = UDim2.fromOffset(204, 24),
        Position = UDim2.fromOffset(6, 201),
        BackgroundColor3 = C.Field,
        BorderSizePixel = 0,
        Text = "RAINBOW",
        Font = FONT,
        TextSize = SIZE - 1,
        TextColor3 = C.Dim,
        AutoButtonColor = false,
        ZIndex = 101,
    }, picker)
    round(rainbowButton, 3)
    stroke(rainbowButton, C.Outline)

    local function writeColor(c)
        current = c
        swatch.BackgroundColor3 = c
        alphaTint.BackgroundColor3 = c
        if flagKey == "__SA_Circle" then
            Flags.SA_CircleColor = c
        elseif flagKey == "__SA_Snap" then
            Flags.SA_SnapColor = c
        elseif flagKey == "__Crosshair" then
            Flags.CrosshairColor = c
        elseif flagKey == "__EnvAmbientOut" then
            Flags.EnvAmbientOutColor = c
        elseif flagKey == "__EnvAmbientIn" then
            Flags.EnvAmbientInColor = c
        elseif flagKey == "__EnvAtmoColor" then
            Flags.EnvAtmoColor = c
        else
            Flags.ESPColors[flagKey] = c
        end
    end

    local function render()
        local c = Color3.fromHSV(h, sat, val)
        writeColor(c)
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svMarker.Position = UDim2.new(sat, 0, 1-val, 0)
        hueMarker.Position = UDim2.new(0.5, 0, 1-h, 0)
        alphaMarker.Position = UDim2.new(alpha, 0, 0.5, 0)
        rainbowButton.TextColor3 = rainbow and C.Accent or C.Dim
        -- Keep the alpha tint gradient synchronized with the chosen color.
        local g = alphaTint:FindFirstChildOfClass("UIGradient")
        if g then g.Color = ColorSequence.new(c, c) end
    end

    local function refreshFromFlag()
        current = getColor()
        h, sat, val = Color3.toHSV(current)
        render()
    end

    local function setSV(x, y)
        sat = math.clamp((x - sv.AbsolutePosition.X) / math.max(sv.AbsoluteSize.X, 1), 0, 1)
        val = 1 - math.clamp((y - sv.AbsolutePosition.Y) / math.max(sv.AbsoluteSize.Y, 1), 0, 1)
        render()
    end
    local function setHue(y)
        h = 1 - math.clamp((y - hue.AbsolutePosition.Y) / math.max(hue.AbsoluteSize.Y, 1), 0, 1)
        render()
    end
    local function setAlpha(x)
        alpha = math.clamp((x - alphaHolder.AbsolutePosition.X) / math.max(alphaHolder.AbsoluteSize.X, 1), 0, 1)
        alphaMarker.Position = UDim2.new(alpha, 0, 0.5, 0)
    end

    local dragSV, dragHue, dragAlpha = false, false, false
    sv.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragSV = true
            setSV(i.Position.X, i.Position.Y)
        end
    end)
    hue.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragHue = true
            setHue(i.Position.Y)
        end
    end)
    alphaHolder.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragAlpha = true
            setAlpha(i.Position.X)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then
            if dragSV then setSV(i.Position.X, i.Position.Y) end
            if dragHue then setHue(i.Position.Y) end
            if dragAlpha then setAlpha(i.Position.X) end
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragSV, dragHue, dragAlpha = false, false, false
        end
    end)

    swatch.MouseButton1Click:Connect(function()
        picker.Visible = not picker.Visible
        if picker.Visible then
            refreshFromFlag()
        end
    end)

    closePicker.MouseButton1Click:Connect(function()
        picker.Visible = false
    end)

    rainbowButton.MouseButton1Click:Connect(function()
        rainbow = not rainbow
        if rainbow then
            task.spawn(function()
                while rainbow and picker.Parent do
                    h = (os.clock() * 0.12) % 1
                    render()
                    task.wait()
                end
            end)
        end
        render()
    end)

    -- Initial state comes directly from Flags, so the swatch and picker always agree.
    refreshFromFlag()
end

-- ===================== WINDOWS + TOP BAR =====================
-- Remade layout: a top icon bar opens separate draggable windows.
-- Combat (Rage / Legit / Visuals / World / Misc), Players, Configs, Settings.
-- Every window shares the same neon outline and can be moved by its title bar.
local settingsPage, configPage, themesPage
local ApplyFullBright

local uiVisible = true
local windowStates = {}
local dockRefreshers = {}
local dock

local function refreshDock()
    for i = 1, #dockRefreshers do dockRefreshers[i]() end
end

local function applyWindowVis()
    for sh, desired in pairs(windowStates) do
        sh.Visible = desired and uiVisible
    end
    if dock then dock.Visible = uiVisible end
end

local function setWindowVisible(ctx, v)
    windowStates[ctx.shell] = v and true or false
    applyWindowVis()
    refreshDock()
end

local function toggleWindow(ctx)
    setWindowVisible(ctx, not windowStates[ctx.shell])
end

local function setUIVisible(v)
    uiVisible = v and true or false
    applyWindowVis()
    refreshDock()
end

local function toggleUI()
    setUIVisible(not uiVisible)
end

-- Builds one draggable window: neon ring outline, gradient body, title bar,
-- optional sub-tab bar, and a scrolling page area with Left/Right columns.
local function newWindow(cfg)
    local w, h = cfg.w or 520, cfg.h or 420
    local shell = new("Frame", {
        Size = UDim2.fromOffset(w, h),
        Position = cfg.pos or UDim2.fromOffset(80, 90),
        BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
    }, gui)

    local ring = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 1,
    }, shell)
    round(ring, 12)
    local rs = stroke(ring, C.Accent)
    rs.Thickness = 3
    rs.Transparency = 0.55
    accent(rs, "Color")

    local win = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.BG, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2,
    }, shell)
    round(win, 10)
    local ws = stroke(win, C.Accent)
    ws.Thickness = 1.4
    accent(ws, "Color")

    local grad = new("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2,
        ClipsDescendants = true,
    }, win)
    round(grad, 10)
    local gg = new("UIGradient", { Rotation = 65 }, grad)
    local gbase = Color3.fromRGB(6, 6, 8)
    table.insert(accentHooks, function(c)
        gg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, gbase:Lerp(c, 0.20)),
            ColorSequenceKeypoint.new(0.6, gbase:Lerp(c, 0.38)),
            ColorSequenceKeypoint.new(1, gbase:Lerp(c, 0.58)),
        })
    end)
    accentHooks[#accentHooks](C.Accent)

    local content = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3 }, win)
    vlist(content, 0)

    local header = new("Frame", { Size = UDim2.new(1, 0, 0, TOP_H), BackgroundTransparency = 1, LayoutOrder = 1 }, content)
    local ttl = text(header, cfg.title, C.Text, nil, TOP_H)
    ttl.Position = UDim2.fromOffset(12, 0)
    local hline = new("Frame", { Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0 }, header)
    accent(hline, "BackgroundColor3")

    local closeBtn = new("TextButton", {
        Size = UDim2.fromOffset(22, 22), Position = UDim2.new(1, -27, 0, 4), BackgroundTransparency = 1,
        Text = "x", Font = FONT, TextSize = 15, TextColor3 = C.Dim, AutoButtonColor = false, ZIndex = 8,
    }, header)
    closeBtn.MouseEnter:Connect(function() tween(closeBtn, { TextColor3 = C.Accent }) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, { TextColor3 = C.Dim }) end)

    makeDraggable(header, shell, function() return uiVisible and shell.Visible end)

    local body
    local tabBar
    local ctx = { shell = shell, win = win, header = header, tabs = {} }

    if cfg.tabs then
        local tabHolder = new("Frame", {
            Size = UDim2.new(1, 0, 0, TAB_H), BackgroundColor3 = C.Panel, BackgroundTransparency = PANEL_ALPHA,
            BorderSizePixel = 0, LayoutOrder = 2,
        }, content)
        new("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = C.Outline, BorderSizePixel = 0 }, tabHolder)
        tabBar = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, tabHolder)
        pad(tabBar, 0, 0, 6, 6)
        hlist(tabBar, 2)
        body = new("Frame", {
            Size = UDim2.new(1, 0, 0, h - TOP_H - TAB_H), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 3,
        }, content)
        ctx.tabBar = tabBar
    else
        body = new("Frame", {
            Size = UDim2.new(1, 0, 0, h - TOP_H), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = 2,
        }, content)
    end
    ctx.body = body

    local function makePage(visible)
        local page = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = visible }, body)
        local function col(order, px)
            local s = new("ScrollingFrame", {
                Size = UDim2.new(0.5, -4, 1, 0), Position = UDim2.new(px, 0, 0, 0),
                BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = order,
                CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 6,
                ElasticBehavior = Enum.ElasticBehavior.Never, VerticalScrollBarInset = Enum.ScrollBarInset.Always,
            }, page)
            pad(s, 8, 10, 8, 14)
            vlist(s, 8)
            accent(s, "ScrollBarImageColor3")
            return s
        end
        return { Frame = page, Left = col(1, 0), Right = col(2, 0.5) }
    end
    ctx.makePage = makePage

    local function showPage(target)
        for _, t in ipairs(ctx.tabs) do
            local on = (t.page.Frame == target)
            t.page.Frame.Visible = on
            t.line.Visible = on
            tween(t.btn, { TextColor3 = on and C.Text or C.Dim })
        end
    end
    ctx.showPage = showPage

    local function addTab(name)
        local btn = new("TextButton", {
            Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, AutoButtonColor = false,
            Text = name, Font = FONT, TextSize = SIZE, TextColor3 = C.Dim, LayoutOrder = #ctx.tabs + 1,
        }, tabBar)
        pad(btn, 0, 0, 12, 12)
        local line = new("Frame", { Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0, Visible = false }, btn)
        accent(line, "BackgroundColor3")
        local page = makePage(false)
        table.insert(ctx.tabs, { btn = btn, page = page, line = line })
        btn.MouseEnter:Connect(function() if not page.Frame.Visible then tween(btn, { TextColor3 = C.Text }) end end)
        btn.MouseLeave:Connect(function() if not page.Frame.Visible then tween(btn, { TextColor3 = C.Dim }) end end)
        btn.MouseButton1Click:Connect(function() showPage(page.Frame) end)
        return page
    end
    ctx.addTab = addTab

    closeBtn.MouseButton1Click:Connect(function() setWindowVisible(ctx, false) end)

    windowStates[shell] = false
    return ctx
end

-- Create the four windows.
local combat   = newWindow({ title = "Combat",   w = 680, h = 540, tabs = true, pos = UDim2.fromOffset(30, 58) })
local players  = newWindow({ title = "Player",   w = 380, h = 470, tabs = true, pos = UDim2.fromOffset(830, 58) })
local themes   = newWindow({ title = "Theme",    w = 430, h = 300, pos = UDim2.fromOffset(830, 548) })
local settings = newWindow({ title = "Settings", w = 520, h = 440, pos = UDim2.fromOffset(1230, 58) })
local configs  = newWindow({ title = "Configs",  w = 430, h = 330, pos = UDim2.fromOffset(1230, 520) })

-- Combat holds all combat-related pages as sub-tabs.
local ragePage    = combat.addTab("Rage")
local legitPage   = combat.addTab("Legit")
local visualsPage = combat.addTab("Visuals")
local worldPage   = combat.addTab("World")
local miscPage    = combat.addTab("Misc")
settingsPage = settings.makePage(true)
configPage   = configs.makePage(true)
themesPage   = themes.makePage(true)
combat.showPage(ragePage.Frame)
local playerPreviewPage = players.addTab("ESP Preview")
local playerListPage    = players.addTab("Players")
players.showPage(playerListPage.Frame)



-- Players window: live server list with health and distance.
do
    local pList = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 6,
        ElasticBehavior = Enum.ElasticBehavior.Never, VerticalScrollBarInset = Enum.ScrollBarInset.Always,
    }, playerListPage.Frame)
    pad(pList, 10, 12, 10, 18)
    vlist(pList, 8)
    accent(pList, "ScrollBarImageColor3")

    local searchSec = section(pList, "Filter", 1)
    local filterBox = new("TextBox", {
        Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.Field, Text = "", PlaceholderText = "search players...",
        PlaceholderColor3 = C.Dim, Font = FONT, TextSize = SIZE, TextColor3 = C.Text, ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, searchSec)
    round(filterBox, CORNER)
    stroke(filterBox, C.Outline)
    pad(filterBox, 0, 0, 9, 9)

    local listSec = section(pList, "Server Players", 2)
    local list = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1 }, listSec)
    vlist(list, 4)

    local function distOf(plr)
        local a = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local b = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if a and b then return math.floor((a.Position - b.Position).Magnitude) end
        return -1
    end
    local function healthOf(plr)
        local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then return math.floor(hum.Health) end
        return 0
    end

    local function rebuild()
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
        local q = filterBox.Text:lower()
        local count = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            local nm = plr.Name
            if q == "" or nm:lower():find(q, 1, true) then
                count += 1
                local d = distOf(plr)
                local row = new("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1 }, list)
                local lab = text(row, nm, plr == LocalPlayer and C.Accent or C.Text, nil, 22)
                lab.Size = UDim2.new(1, -150, 1, 0)
                local stat = text(row, healthOf(plr) .. " hp  |  " .. (d >= 0 and (d .. " studs") or "---"), C.Dim, Enum.TextXAlignment.Right, 22)
                stat.Size = UDim2.new(0, 150, 1, 0)
                stat.Position = UDim2.new(1, -150, 0, 0)
            end
        end
        if count == 0 then
            text(list, "no players found", C.Dim)
        end
    end
    filterBox:GetPropertyChangedSignal("Text"):Connect(rebuild)
    rebuild()
    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        acc += dt
        if acc >= 1 then acc = 0; rebuild() end
    end)
end

-- Player window: live 3D ESP preview of your own character (ViewportFrame).
-- Ported in spirit from femhax's esp_preview: clone LocalPlayer.Character into a
-- ViewportFrame with a Track camera, drag to orbit, and overlay a 2D ESP box.
do
    local holder = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, playerPreviewPage.Frame)
    local vf = new("ViewportFrame", {
        Size = UDim2.new(1, -24, 0, 250), Position = UDim2.fromOffset(12, 12),
        BackgroundColor3 = Color3.fromRGB(18, 18, 22), BackgroundTransparency = 0.15,
        BorderSizePixel = 0, ClipsDescendants = true, Active = true,
    }, holder)
    round(vf, 8); stroke(vf, C.Outline)

    local cam = Instance.new("Camera")
    cam.FieldOfView = 70
    cam.CameraType = Enum.CameraType.Track
    cam.CFrame = CFrame.new(0, 0, -6)
    vf.CurrentCamera = cam

    local boxHolder = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true }, vf)
    local box = new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false }, boxHolder)
    local boxSt = Instance.new("UIStroke"); boxSt.Color = Flags.ESPColors.Box; boxSt.Thickness = 2; boxSt.Parent = box
    local nameLbl = text(boxHolder, "", Flags.ESPColors.Name)
    nameLbl.TextSize = 13; nameLbl.TextStrokeTransparency = 0.4; nameLbl.Visible = false

    local hint = text(holder, "drag to rotate", C.Dim, Enum.TextXAlignment.Center, 18)
    hint.Size = UDim2.new(1, -24, 0, 18); hint.Position = UDim2.new(0, 12, 0, 266)

    local rotation, pitch = 180, 0
    local targetRotation, targetPitch = 180, 0
    local dragging, sx, sy, sRot, sPitch = false, 0, 0, 0, 0
    local clone = nil

    local function buildClone()
        if clone then clone:Destroy(); clone = nil end
        local char = LocalPlayer.Character
        if not char then return end
        local ok, c = pcall(function()
            char.Archivable = true
            return char:Clone()
        end)
        if ok and c then
            local anim = c:FindFirstChild("Animate"); if anim then anim:Destroy() end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
            c.Parent = vf
            clone = c
            cam.CameraSubject = c
        end
    end

    vf.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; sx = i.Position.X; sy = i.Position.Y; sRot = rotation; sPitch = pitch
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            rotation = sRot + (i.Position.X - sx) * 0.6
            targetRotation = rotation
            pitch = math.clamp(sPitch + (i.Position.Y - sy) * 0.6, -85, 85)
            targetPitch = pitch
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            dragging = false; targetRotation = 180; targetPitch = 0
        end
    end)

    buildClone()
    table.insert(Connections, LocalPlayer.CharacterAdded:Connect(function() task.wait(0.2); buildClone() end))

    RunService.RenderStepped:Connect(function()
        if not vf.Visible or not clone then return end
        local cf, sz = clone:GetBoundingBox()
        if sz.Magnitude <= 0 then return end
        local dist = math.max(sz.X, sz.Y, sz.Z) * 2.2 + 2
        local rot = CFrame.Angles(0, math.rad(rotation), 0) * CFrame.Angles(math.rad(pitch), 0, 0)
        cam.CFrame = CFrame.new(cf.Position) * rot * CFrame.new(0, 0, dist)
        boxSt.Color = Flags.ESPColors.Box

        local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
        for xi = -1, 1, 2 do for yi = -1, 1, 2 do for zi = -1, 1, 2 do
            local wp = (cf * CFrame.new(sz.X * 0.5 * xi, sz.Y * 0.5 * yi, sz.Z * 0.5 * zi)).Position
            local sp, onScreen = cam:WorldToViewportPoint(wp)
            if onScreen and sp.Z > 0 then
                minX = math.min(minX, sp.X); maxX = math.max(maxX, sp.X)
                minY = math.min(minY, sp.Y); maxY = math.max(maxY, sp.Y)
            end
        end end end
        if minX < math.huge and Flags.ESP and Flags.ESP_Box then
            box.Visible = true
            box.Position = UDim2.fromOffset(minX, minY)
            box.Size = UDim2.fromOffset(math.max(1, maxX - minX), math.max(1, maxY - minY))
            if Flags.ESP_Name then
                nameLbl.Visible = true
                nameLbl.Text = LocalPlayer.Name
                nameLbl.Position = UDim2.fromOffset(minX, minY - 18)
                nameLbl.Size = UDim2.fromOffset(math.max(1, maxX - minX), 16)
            else
                nameLbl.Visible = false
            end
        else
            box.Visible = false; nameLbl.Visible = false
        end
    end)
end

-- Top bar: small icons that open / close each window.
dock = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 10),
    Size = UDim2.new(0, 0, 0, 34), AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = C.BG, BorderSizePixel = 0, ZIndex = 90,
}, gui)
round(dock, 10)
local dockStroke = stroke(dock, C.Accent)
dockStroke.Thickness = 1.6
accent(dockStroke, "Color")
pad(dock, 0, 0, 8, 8)
hlist(dock, 4)

local dockTitle = text(dock, "VOIDHOOK", C.Accent, Enum.TextXAlignment.Center, 34)
dockTitle.Size = UDim2.fromOffset(120, 34)

local function dockIcon(label, ctx)
    local b = new("TextButton", {
        Size = UDim2.fromOffset(76, 24), BackgroundColor3 = C.Button, AutoButtonColor = false,
        Text = label, Font = FONT, TextSize = SIZE - 1, TextColor3 = C.Text,
    }, dock)
    round(b, 6)
    local st = stroke(b, C.Outline)
    local function refresh()
        local on = windowStates[ctx.shell]
        tween(b, { BackgroundColor3 = on and C.ButtonHover or C.Button })
        st.Color = on and C.Accent or C.Outline
        b.TextColor3 = on and C.Accent or C.Text
    end
    b.MouseEnter:Connect(function() st.Color = C.Accent end)
    b.MouseLeave:Connect(refresh)
    b.MouseButton1Click:Connect(function() toggleWindow(ctx) end)
    table.insert(dockRefreshers, refresh)
    refresh()
    return b
end

dockIcon("COMBAT", combat)
dockIcon("PLAYER", players)
dockIcon("THEME", themes)
dockIcon("SETTINGS", settings)
dockIcon("CONFIGS", configs)

setWindowVisible(combat, true)
applyWindowVis()


-- ===================== TAB CONTENT =====================
-- Main menu groups: Rage = combat/aim assist, Legit = cleaner aimbot settings,
-- Visuals = ESP/chams/crosshair, World = lighting and detection, Misc = movement/camera.
-- This section just connects the feature flags to the menu UI.
do
    -- RAGE / COMBAT: silent aim, auto-aim helpers, hitbox selection, recoil control,
    -- anti-aim, and weapon-related safety settings.
    do
        local s = section(ragePage.Left, "Silent Aim", 1)
        toggle(s, "Silent Aim", Flags.SilentAim, function(v) Flags.SilentAim = v end, "Silent Aim", true)
        toggle(s, "Wall Check", Flags.SA_WallCheck, function(v) Flags.SA_WallCheck = v end, "SA Wall Check")
        toggle(s, "Prediction", Flags.SA_Prediction, function(v) Flags.SA_Prediction = v end, "SA Prediction")
        toggle(s, "Team Check", Flags.SA_TeamCheck, function(v) Flags.SA_TeamCheck = v end, "SA Team Check")
        toggle(s, "Target AI", Flags.SA_TargetAI, function(v) Flags.SA_TargetAI = v end, "SA Target AI")
        toggle(s, "Snapline", Flags.SA_Snapline, function(v) Flags.SA_Snapline = v end, "SA Snapline")
        dropdown(s, "Hit Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, Flags.SA_HitPart, function(v) Flags.SA_HitPart = v end)
        slider(s, "Aim FOV", 1, 360, Flags.SA_FOV, 1, "Â°", function(v) Flags.SA_FOV = v end)
        slider(s, "Max Distance", 25, 2000, Flags.SA_MaxDistance, 25, "", function(v) Flags.SA_MaxDistance = v end)
        slider(s, "Circle Thickness", 0.5, 6, Flags.SA_CircleThickness, 0.5, "", function(v) Flags.SA_CircleThickness = v end)
        slider(s, "Snap Thickness", 0.5, 8, Flags.SA_SnapThickness, 0.5, "", function(v) Flags.SA_SnapThickness = v end)
        slider(s, "Snap Transparency", 0, 1, Flags.SA_SnapTransparency, 0.05, "", function(v) Flags.SA_SnapTransparency = v end)
        colorPicker(s, "FOV Color", "__SA_Circle")
        colorPicker(s, "Snapline Color", "__SA_Snap")
    end
    do
        local s = section(ragePage.Left, "Insta Hit", 2)
        toggle(s, "Instant Hit", Flags.InstantHit, function(v) Flags.InstantHit = v end, "Instant Hit", true)
        toggle(s, "No Prediction", Flags.SA_NoPrediction, function(v) Flags.SA_NoPrediction = v end, "SA No Prediction")
        toggle(s, "Force Hitbox", Flags.ForceHitbox, function(v) Flags.ForceHitbox = v end, "Force Hitbox")
        dropdown(s, "Hitbox Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "FaceHitBox", "HeadTopHitBox"}, Flags.ForceHitboxPart, function(v) Flags.ForceHitboxPart = v end)
        slider(s, "Hitbox Chance", 0, 100, Flags.ForceHitboxChance, 1, "%", function(v) Flags.ForceHitboxChance = v end)
    end
    do
        local s = section(ragePage.Right, "Weapon", 2)
        toggle(s, "No Recoil", Flags.NoRecoil, function(v) Flags.NoRecoil = v end, "No Recoil")
        toggle(s, "Instant Reload", Flags.InstantReload, function(v) Flags.InstantReload = v end, "Instant Reload")
        toggle(s, "Auto Pack Mags", Flags.AutoPackMags, function(v) Flags.AutoPackMags = v end, "Auto Pack Mags")
        toggle(s, "Firerate Override", Flags.FirerateOverride, function(v) Flags.FirerateOverride = v end, "Firerate Override")
        slider(s, "Fire Rate", 0.01, 0.5, Flags.FirerateValue, 0.01, "s", function(v) Flags.FirerateValue = v end)
        toggle(s, "No Bolt", Flags.NoBolt, function(v) Flags.NoBolt = v end, "No Bolt")
        toggle(s, "Instant ADS", Flags.InstantADS, function(v) Flags.InstantADS = v end, "Instant ADS")
        toggle(s, "Force Auto", Flags.ForceAuto, function(v) Flags.ForceAuto = v end, "Force Auto")
    end
    do
        local s = section(ragePage.Right, "Anti Aim", 3)
        toggle(s, "Anti Aim", Flags.AntiAim, function(v) Flags.AntiAim = v end, "Anti Aim", true)
        slider(s, "Yaw", -180, 180, Flags.AA_YawValue, 1, "Â°", function(v) Flags.AA_YawValue = v end)
    end

    -- LEGIT / AIMBOT
    do
        local s = section(legitPage.Left, "Aimbot", 1)
        toggle(s, "Aimbot", Flags.Aimbot, function(v) Flags.Aimbot = v end, "Aimbot", true)
        slider(s, "Aim FOV", 1, 360, Flags.AimFOV, 1, "Â°", function(v) Flags.AimFOV = v end)
        slider(s, "Aim Smooth", 0.02, 1, Flags.AimSmooth, 0.02, "", function(v) Flags.AimSmooth = v end)
        dropdown(s, "Lock Hit Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, Flags.AimHitPart, function(v) Flags.AimHitPart = v end)
    end

    -- MISC / MOVEMENT / CAMERA: speed, bhop, third-person, zoom, and camera tweaks.
    do
        local s = section(miscPage.Left, "Movement", 1)
        toggle(s, "Speed", Flags.Speed, function(v) Flags.Speed = v end, "Speed", true)
        slider(s, "Speed Value", 8, 100, Flags.SpeedValue, 1, "", function(v) Flags.SpeedValue = v end)
        toggle(s, "BHop", Flags.BHop, function(v) Flags.BHop = v end, "BHop")
        toggle(s, "Walk On Water", Flags.WalkOnWater, function(v) Flags.WalkOnWater = v end, "Walk On Water")
        toggle(s, "No Fall", Flags.NoFall, function(v) Flags.NoFall = v end, "No Fall")
        toggle(s, "Noclip", Flags.Noclip, function(v) Flags.Noclip = v end, "Noclip", true)
        toggle(s, "Clip Floors", Flags.NoclipFloors, function(v) Flags.NoclipFloors = v end, "Noclip Floors")
        toggle(s, "Clip Walls", Flags.NoclipWalls, function(v) Flags.NoclipWalls = v end, "Noclip Walls")
        slider(s, "Max Layers", 1, 4, Flags.NoclipLayers, 1, "", function(v) Flags.NoclipLayers = v end)
        slider(s, "Clip Speed", 0.5, 8, Flags.NoclipSpeed, 0.5, "", function(v) Flags.NoclipSpeed = v end)
    end
    do
        local s = section(miscPage.Right, "Camera", 2)
        toggle(s, "Third Person", Flags.ThirdPerson, function(v) Flags.ThirdPerson = v end, "Third Person", true)
        slider(s, "Third Person Distance", 2, 50, Flags.ThirdPersonDist, 1, "", function(v) Flags.ThirdPersonDist = v end)
        toggle(s, "Zoom", Flags.Zoom, function(v) Flags.Zoom = v end, "Zoom", true)
        slider(s, "Zoom FOV", 5, 80, Flags.ZoomValue, 1, "Â°", function(v) Flags.ZoomValue = v end)
        toggle(s, "Custom FOV", Flags.CustomFOV, function(v) Flags.CustomFOV = v end, "Custom FOV")
        slider(s, "FOV", 40, 140, Flags.FOVValue, 1, "Â°", function(v) Flags.FOVValue = v end)
        toggle(s, "Debug Camera", Flags.DebugCamera, function(v) Flags.DebugCamera = v end, "Debug Camera")
        slider(s, "Debug Camera Speed", 0.5, 10, Flags.DebugCamSpeed, 0.5, "", function(v) Flags.DebugCamSpeed = v end)
    end
    do
        local s = section(miscPage.Right, "Reports", 3)
        toggle(s, "Report Notifications", Flags.ReportNotifications, function(v)
            Flags.ReportNotifications = v
            if v then
                watchReports()
                showReportNotification()
            end
        end, "Report Notifications")
        toggle(s, "Sound", Flags.ReportNotifySound, function(v) Flags.ReportNotifySound = v end, "Report Sound")
        toggle(s, "Flashing", Flags.ReportNotifyFlashing, function(v) Flags.ReportNotifyFlashing = v end, "Report Flashing")
        slider(s, "Duration", 1, 10, Flags.ReportNotifyDuration, 0.5, "s", function(v) Flags.ReportNotifyDuration = v end)
        slider(s, "Volume", 0.5, 2, Flags.ReportNotifyVolume, 0.1, "", function(v) Flags.ReportNotifyVolume = v end)
        button(s, "Show Current Reports", function()
            local count = getReportCount()
            local text = count > 0 and ("You have been reported " .. count .. " time" .. (count == 1 and "" or "s") .. "!") or "You have not been reported"
            reportNotify(text)
        end)
    end

    if Flags.ReportNotifications then
        watchReports()
    end

    -- VISUALS / ESP: player ESP, world ESP, item tracking, chams, inventory overlays,
    -- crosshair settings, and visual color tuning.
    do
        local s = section(visualsPage.Left, "ESP", 1)
        toggle(s, "ESP", Flags.ESP, function(v) Flags.ESP = v end, "ESP")
        toggle(s, "Box", Flags.ESP_Box, function(v) Flags.ESP_Box = v end, "ESP Box")
        toggle(s, "Name", Flags.ESP_Name, function(v) Flags.ESP_Name = v end, "ESP Name")
        toggle(s, "Distance", Flags.ESP_Distance, function(v) Flags.ESP_Distance = v end, "ESP Distance")
        toggle(s, "Tracer", Flags.ESP_Tracer, function(v) Flags.ESP_Tracer = v end, "ESP Tracer")
        toggle(s, "Health", Flags.ESP_Health, function(v) Flags.ESP_Health = v end, "ESP Health")
        toggle(s, "Health Bar", Flags.ESP_HealthBar, function(v) Flags.ESP_HealthBar = v end, "ESP Health Bar")
        toggle(s, "Weapon", Flags.ESP_Weapon, function(v) Flags.ESP_Weapon = v end, "ESP Weapon")
        toggle(s, "Skeleton", Flags.ESP_Skeleton, function(v) Flags.ESP_Skeleton = v end, "ESP Skeleton")
        toggle(s, "Flags", Flags.ESP_Flags, function(v) Flags.ESP_Flags = v end, "ESP Flags")
        toggle(s, "Chams", Flags.Chams, function(v) Flags.Chams = v end, "Chams")
        slider(s, "Chams Transparency", 0, 1, Flags.ChamsTransparency, 0.05, "", function(v) Flags.ChamsTransparency = v end)
        dropdown(s, "Box Style", {"Dynamic", "Static"}, Flags.ESP_BoxStyle, function(v) Flags.ESP_BoxStyle = v end)
        slider(s, "Box Thickness", 1, 5, Flags.ESP_BoxThickness, 1, "", function(v) Flags.ESP_BoxThickness = v end)
        toggle(s, "Glow", Flags.ESP_Glow, function(v) Flags.ESP_Glow = v end, "ESP Glow")
        slider(s, "Glow Transparency", 0, 1, Flags.ESP_GlowTransparency, 0.05, "", function(v) Flags.ESP_GlowTransparency = v end)
        toggle(s, "Fill", Flags.ESP_Fill, function(v) Flags.ESP_Fill = v end, "ESP Fill")
        slider(s, "Fill Transparency", 0, 1, Flags.ESP_FillTransparency, 0.05, "", function(v) Flags.ESP_FillTransparency = v end)
        dropdown(s, "Text Case", {"Normal", "Lowercase", "Uppercase", "Titlecase"}, Flags.ESP_TextCase, function(v) Flags.ESP_TextCase = v end)
        dropdown(s, "Distance Format", {"m", " studs", ""}, Flags.ESP_DistFormat, function(v) Flags.ESP_DistFormat = v end)
        slider(s, "Text Size", 8, 24, Flags.ESP_TextSize, 1, "", function(v) Flags.ESP_TextSize = v end)
        dropdown(s, "Snapline From", {"Bottom", "Center"}, Flags.ESP_SnaplineFrom, function(v) Flags.ESP_SnaplineFrom = v end)
        slider(s, "Render Distance", 50, 5000, Flags.ESP_RenderDist, 50, "", function(v) Flags.ESP_RenderDist = v end)
        toggle(s, "Team Check", Flags.ESP_TeamCheck, function(v) Flags.ESP_TeamCheck = v end, "ESP Team Check")
        toggle(s, "AI ESP", Flags.AI_ESP, function(v) Flags.AI_ESP = v end, "AI ESP", true)
        toggle(s, "AI Box", Flags.AI_ESP_Box, function(v) Flags.AI_ESP_Box = v end, "AI ESP Box")
        toggle(s, "AI Name", Flags.AI_ESP_Name, function(v) Flags.AI_ESP_Name = v end, "AI ESP Name")
        toggle(s, "AI Distance", Flags.AI_ESP_Distance, function(v) Flags.AI_ESP_Distance = v end, "AI ESP Distance")
        toggle(s, "AI Health", Flags.AI_ESP_Health, function(v) Flags.AI_ESP_Health = v end, "AI ESP Health")
        toggle(s, "AI Tracer", Flags.AI_ESP_Tracer, function(v) Flags.AI_ESP_Tracer = v end, "AI ESP Tracer")
        toggle(s, "AI Skeleton", Flags.AI_ESP_Skeleton, function(v) Flags.AI_ESP_Skeleton = v end, "AI ESP Skeleton")
        slider(s, "AI Max Distance", 50, 2000, Flags.AI_ESP_MaxDist, 25, "", function(v) Flags.AI_ESP_MaxDist = v end)
        toggle(s, "Item ESP", Flags.ItemESP, function(v) Flags.ItemESP = v end, "Item ESP")
        toggle(s, "Corpse ESP", Flags.CorpseESP, function(v) Flags.CorpseESP = v end, "Corpse ESP")
        toggle(s, "Extract ESP", Flags.ExtractESP, function(v) Flags.ExtractESP = v end, "Extract ESP")
    end
    do
        local s = section(visualsPage.Right, "ESP Colors", 2)
        colorPicker(s, "Box Color", "Box")
        colorPicker(s, "Name Color", "Name")
        colorPicker(s, "Distance Color", "Distance")
        colorPicker(s, "Health Color", "Health")
        colorPicker(s, "Tracer Color", "Tracer")
        colorPicker(s, "Skeleton Color", "Skeleton")
        colorPicker(s, "Chams Color", "Chams")
        colorPicker(s, "Item Color", "Item")
        colorPicker(s, "Corpse Color", "Corpse")
        colorPicker(s, "Extract Color", "Extract")
        colorPicker(s, "AI Color", "AI")
    end
    do
        local s = section(visualsPage.Right, "Force Render", 3)
        toggle(s, "Force Render", Flags.ForceRender, function(v) Flags.ForceRender = v end, "Force Render", true)
        dropdown(s, "Mode", {"Render All", "Render Priority", "Render Target"}, Flags.ForceRenderMode, function(v) Flags.ForceRenderMode = v end)
    end
        local x = section(visualsPage.Right, "Crosshair", 4)
        toggle(x, "Crosshair", Flags.Crosshair, function(v) Flags.Crosshair = v end, "Crosshair")
        colorPicker(x, "Crosshair Color", "__Crosshair")
        slider(x, "Length", 1, 40, Flags.CrosshairLength, 1, "", function(v) Flags.CrosshairLength = v end)
        slider(x, "Thickness", 1, 10, Flags.CrosshairThickness, 1, "", function(v) Flags.CrosshairThickness = v end)
        slider(x, "Gap", 0, 30, Flags.CrosshairGap, 1, "", function(v) Flags.CrosshairGap = v end)
        slider(x, "Opacity", 0, 1, Flags.CrosshairOpacity, 0.05, "", function(v) Flags.CrosshairOpacity = v end)
        slider(x, "Spin Speed", 0, 10, Flags.CrosshairSpin, 0.5, "", function(v) Flags.CrosshairSpin = v end)
        toggle(x, "Outline", Flags.CrosshairOutline, function(v) Flags.CrosshairOutline = v end, "Crosshair Outline")
        toggle(x, "Dot", Flags.CrosshairDot, function(v) Flags.CrosshairDot = v end, "Crosshair Dot")
        dropdown(x, "Position", {"Mouse", "Center", "Top", "Bottom", "Left", "Right"}, Flags.CrosshairPos, function(v) Flags.CrosshairPos = v end)

    do
        local s = section(visualsPage.Right, "Inventory Checker", 5)
        toggle(s, "Inventory Checker", Flags.InvChecker, function(v) Flags.InvChecker = v end, "Inventory Checker", true)
        toggle(s, "Full Inventory", Flags.InvFull, function(v) Flags.InvFull = v end, "Inventory Full")
        toggle(s, "Show Value", Flags.InvValue, function(v) Flags.InvValue = v end, "Inventory Value")
        toggle(s, "Show Corpse", Flags.InvCorpse, function(v) Flags.InvCorpse = v end, "Inventory Corpse")
        toggle(s, "Drag Inventory", Flags.InvDrag, function(v) Flags.InvDrag = v end, "Inventory Drag")
        slider(s, "Inventory X", 0, 1500, Flags.InvX, 10, "", function(v) Flags.InvX = v end)
        slider(s, "Inventory Y", 0, 1000, Flags.InvY, 10, "", function(v) Flags.InvY = v end)
        slider(s, "Inventory Scale", 50, 150, Flags.InvScale, 5, "%", function(v) Flags.InvScale = v end)
        slider(s, "Inventory Delay", 1, 60, Flags.InvDelay, 1, "s", function(v) Flags.InvDelay = v end)
    end

    -- WORLD / LIGHTING / DETECTION: fullbright, no-grass, anti-cheat detection, and world visual cleanup.
    do
        local s = section(worldPage.Left, "Lighting", 1)
        toggle(s, "Full Bright", Flags.FullBright, function(v) Flags.FullBright = v; ApplyFullBright() end, "Full Bright")
        toggle(s, "No Grass", Flags.NoGrass, function(v) Flags.NoGrass = v end, "No Grass")
        toggle(s, "No Trees", Flags.NoTrees, function(v) Flags.NoTrees = v end, "No Trees")
        toggle(s, "No Fog", Flags.NoFog, function(v) Flags.NoFog = v end, "No Fog")
        toggle(s, "Visual Desync", Flags.VisualDesync, function(v) Flags.VisualDesync = v end, "Visual Desync")
    end
    do
        local s = section(worldPage.Left, "Ambient & Brightness", 2)
        toggle(s, "Outdoor Ambient", Flags.EnvAmbientOut, function(v) Flags.EnvAmbientOut = v end, "Env Outdoor Ambient")
        colorPicker(s, "Outdoor Color", "__EnvAmbientOut")
        toggle(s, "Indoor Ambient", Flags.EnvAmbientIn, function(v) Flags.EnvAmbientIn = v end, "Env Indoor Ambient")
        colorPicker(s, "Indoor Color", "__EnvAmbientIn")
        toggle(s, "Brightness", Flags.EnvBrightness, function(v) Flags.EnvBrightness = v end, "Env Brightness")
        slider(s, "Brightness Value", 0, 10, Flags.EnvBrightnessVal, 0.1, "", function(v) Flags.EnvBrightnessVal = v end)
    end
    do
        local s = section(worldPage.Left, "Atmosphere", 3)
        toggle(s, "Atmosphere Editor", Flags.EnvAtmo, function(v) Flags.EnvAtmo = v end, "Env Atmosphere")
        slider(s, "Density", 0, 1, Flags.EnvAtmoDensity, 0.05, "", function(v) Flags.EnvAtmoDensity = v end)
        slider(s, "Offset", -1, 1, Flags.EnvAtmoOffset, 0.05, "", function(v) Flags.EnvAtmoOffset = v end)
        slider(s, "Glare", 0, 10, Flags.EnvAtmoGlare, 0.1, "", function(v) Flags.EnvAtmoGlare = v end)
        slider(s, "Haze", 0, 10, Flags.EnvAtmoHaze, 0.1, "", function(v) Flags.EnvAtmoHaze = v end)
        colorPicker(s, "Atmosphere Color", "__EnvAtmoColor")
    end
    do
        local s = section(worldPage.Left, "Time", 4)
        toggle(s, "Time Changer", Flags.EnvTime, function(v) Flags.EnvTime = v end, "Env Time")
        slider(s, "Time", 0, 24, Flags.EnvTimeVal, 0.25, "h", function(v) Flags.EnvTimeVal = v end)
    end
    do
        local s = section(worldPage.Right, "Detection", 2)
        toggle(s, "AC Detection", Flags.AC_Detection, function(v) Flags.AC_Detection = v end, "AC Detection")
        toggle(s, "AC Alerts", Flags.AC_Alert, function(v) Flags.AC_Alert = v end, "AC Alerts")
    end

    do
        local s = section(miscPage.Left, "Item Finder", 2)
        toggle(s, "Item Finder", Flags.InvFinderOn, function(v) Flags.InvFinderOn = v end, "Item Finder")
        slider(s, "Finder Glow", 1, 20, Flags.InvFinderGlow, 1, "", function(v) Flags.InvFinderGlow = v end)
        slider(s, "Finder X", 0, 1800, Flags.InvFinderX or 200, 10, "", function(v) Flags.InvFinderX = v end)
        slider(s, "Finder Y", 0, 1000, Flags.InvFinderY or 50, 10, "", function(v) Flags.InvFinderY = v end)
    end

    -- MISC / WEAPON: rapid knife speeds up the local viewmodel's knife swing animations.
    do
        local s = section(miscPage.Right, "Weapons", 1)
        toggle(s, "Rapid Knife", Flags.RapidKnife, function(v) Flags.RapidKnife = v end, "Rapid Knife")
        slider(s, "Swing Rate", 1, 100, Flags.RapidKnifeRate, 1, "", function(v) Flags.RapidKnifeRate = v end)

        local rkUseConn
        local function hookViewModel(vm)
            local hum = vm:FindFirstChildOfClass("Humanoid") or vm:FindFirstChild("Humanoid")
            local animator = hum and (hum:FindFirstChildOfClass("Animator") or hum:FindFirstChild("Animator"))
            if not animator then return end
            if rkUseConn then rkUseConn:Disconnect() end
            rkUseConn = animator.AnimationPlayed:Connect(function(track)
                if not Flags.RapidKnife then return end
                local anim = track.Animation
                if not anim then return end
                local n = anim.Name
                if n == "Use" or n == "UseAlt" or n == "Stab" then
                    track:AdjustSpeed(math.max(tonumber(Flags.RapidKnifeRate) or 1, 0.01))
                end
            end)
        end
        local function watchViewModel(child)
            if child:IsA("Model") and child.Name == "ViewModel" then hookViewModel(child) end
        end
        table.insert(Connections, camera.ChildAdded:Connect(watchViewModel))
        local existingVM = camera:FindFirstChild("ViewModel")
        if existingVM then hookViewModel(existingVM) end
    end
end

local indicator = new("Frame", {
    Size = UDim2.fromOffset(140, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.BG,
    Position = UDim2.fromScale(0.085, 0.35), Visible = false,
}, gui)
round(indicator, CORNER)
stroke(indicator, C.Border)
pad(indicator, 5, 5, 8, 8)
vlist(indicator, 2)
text(indicator, "Keybinds")
local indicatorKeyLbl = text(indicator, "", C.Dim)

local wm = new("Frame", {
    Size = UDim2.new(), AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = C.BG, BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8),
}, gui)
round(wm, CORNER)
stroke(wm, C.Border)
pad(wm, 5, 5, 6, 6)
new("UIListLayout", {
    Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, wm)

local LOGO_W = 100
local function logoH(w) return HAS_LOGO and w / LOGO_ASPECT or w * 0.22 end
local logoBox = new("Frame", { Size = UDim2.fromOffset(LOGO_W, logoH(LOGO_W)), BackgroundTransparency = 1, LayoutOrder = 1 }, wm)
new("ImageLabel", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = LOGO_IMAGE, ScaleType = Enum.ScaleType.Fit, Visible = HAS_LOGO,
}, logoBox)
local logoText = new("TextLabel", {
    Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = TITLE, Font = Enum.Font.GothamBlack, TextScaled = true,
    TextColor3 = Color3.new(1, 1, 1), Visible = not HAS_LOGO,
}, logoBox)
local logoGrad = new("UIGradient", { Rotation = 90 }, logoText)
local logoStroke = new("UIStroke", { Thickness = 1.5 }, logoText)
accent(logoStroke, "Color", dark(0.8))
table.insert(accentHooks, function(c)
    logoGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1):Lerp(c, 0.6))
end)
accentHooks[#accentHooks](C.Accent)

local wmText = new("TextLabel", {
    Size = UDim2.new(), AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1, Text = TITLE .. " | -- fps", Font = FONT,
    TextSize = 14, TextColor3 = C.Text, LayoutOrder = 2,
}, wm)
Status = { Text = "â—  ready", TextColor3 = C.Text }
local fpsTime, fpsFrames = 0, 0
RunService.RenderStepped:Connect(function(dt)
    fpsTime += dt
    fpsFrames += 1
    if fpsTime >= 0.5 then
        wmText.Text = TITLE .. " | " .. math.floor(fpsFrames / fpsTime + 0.5) .. " fps"
        fpsTime, fpsFrames = 0, 0
    end
end)

local wmDrag, keyDrag
local function refreshDrag()
    local open = uiVisible
    wm.Active = open and wmDrag ~= nil and wmDrag.Get()
    indicator.Active = open and keyDrag ~= nil and keyDrag.Get()
end
makeDraggable(wm, wm, function() return uiVisible and wmDrag ~= nil and wmDrag.Get() end)
makeDraggable(indicator, indicator, function() return uiVisible and keyDrag ~= nil and keyDrag.Get() end)

local ACTION_NAME = "SettingsMenuToggle"
local listening = false
local keyBtn

local function updateKeyText()
    local nm = TOGGLE_KEY.Name
    if keyBtn then keyBtn.Text = "[" .. nm:upper() .. "]" end
    indicatorKeyLbl.Text = "Menu [" .. nm .. "]"
end

local function onToggleAction(_, state, _)
    if state == Enum.UserInputState.Begin and not listening then
        toggleUI()
        refreshDrag()
    end
    return Enum.ContextActionResult.Sink
end

local function bindToggleKey()
    CAS:UnbindAction(ACTION_NAME)
    CAS:BindActionAtPriority(ACTION_NAME, onToggleAction, false, Enum.ContextActionPriority.High.Value + 1, TOGGLE_KEY)
end

local function setKey(keyCode)
    TOGGLE_KEY = keyCode
    bindToggleKey()
    updateKeyText()
end

setKey(TOGGLE_KEY)

local theme = section(themesPage.Left, "Theme", 1)
local presets = {
    Default = Color3.fromRGB(220, 22, 22), Blue = Color3.fromRGB(40, 110, 230),
    Green = Color3.fromRGB(40, 190, 90), Purple = Color3.fromRGB(150, 70, 230),
    Pink = Color3.fromRGB(230, 60, 160), Orange = Color3.fromRGB(255, 140, 0),
    Cyan = Color3.fromRGB(40, 210, 230), Gold = Color3.fromRGB(230, 190, 40),
}
dropdown(theme, "Accent Color", { "Default", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Gold" }, "Default", function(v)
    if presets[v] then setAccent(presets[v]) end
end)
text(theme, "Pick an accent color for the whole menu.")
local themeRGB = { r = 220, g = 22, b = 22 }
slider(theme, "Red", 0, 255, 220, 1, "", function(v) themeRGB.r = v; setAccent(Color3.fromRGB(themeRGB.r, themeRGB.g, themeRGB.b)) end)
slider(theme, "Green", 0, 255, 22, 1, "", function(v) themeRGB.g = v; setAccent(Color3.fromRGB(themeRGB.r, themeRGB.g, themeRGB.b)) end)
slider(theme, "Blue", 0, 255, 22, 1, "", function(v) themeRGB.b = v; setAccent(Color3.fromRGB(themeRGB.r, themeRGB.g, themeRGB.b)) end)

local cfgListSec = section(configPage.Left, "Configurations", 1)
local cfgManage = section(configPage.Right, "Manage", 1)
text(cfgManage, "Config Name")
local nameBox = new("TextBox", {
    Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = C.Field, Text = "", PlaceholderText = "type a name...", PlaceholderColor3 = C.Dim,
    Font = FONT, TextSize = SIZE, TextColor3 = C.Text, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
}, cfgManage)
round(nameBox, CORNER)
local nameStroke = stroke(nameBox, C.Outline)
pad(nameBox, 0, 0, 9, 9)
nameBox.Focused:Connect(function() tween(nameStroke, { Color = C.Accent }) end)
nameBox.FocusLost:Connect(function() tween(nameStroke, { Color = C.Outline }) end)

local canFS = type(writefile) == "function" and type(readfile) == "function" and type(makefolder) == "function"
    and type(isfolder) == "function" and type(listfiles) == "function" and type(delfile) == "function"
if canFS then
    pcall(function()
        if not isfolder(FOLDER) then makefolder(FOLDER) end
        if not isfolder(CONFIG_DIR) then makefolder(CONFIG_DIR) end
    end)
end
local memory = {}
local where = canFS and "" or " (session only)"

local function cleanName(s)
    local n = tostring(s):gsub("[^%w _%-]", "")
    return (n:match("^%s*(.-)%s*$"))
end
local function pathOf(name) return CONFIG_DIR .. "/" .. name .. ".json" end

local function listConfigs()
    local names = {}
    if canFS then
        local ok, files = pcall(listfiles, CONFIG_DIR)
        if ok and type(files) == "table" then
            for _, f in ipairs(files) do
                local n = tostring(f):match("([^/\\]+)%.json$")
                if n then table.insert(names, n) end
            end
        end
    else
        for k in pairs(memory) do table.insert(names, k) end
    end
    table.sort(names)
    return names
end
local function store(name, data)
    if canFS then
        return (pcall(writefile, pathOf(name), HttpService:JSONEncode(data)))
    end
    memory[name] = data
    return true
end
local function fetch(name)
    if canFS then
        local ok, raw = pcall(readfile, pathOf(name))
        if not ok then return nil end
        local ok2, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok2 and type(data) == "table" then return data end
        return nil
    end
    return memory[name]
end
local function remove(name)
    if canFS then pcall(delfile, pathOf(name)) else memory[name] = nil end
end

do
    -- Config helpers live in an isolated function scope. The main UI has a very
    -- large number of locals, and nested functions inside that scope can hit
    -- Luau's 200-register limit simply by capturing outer locals.
    local function setupConfig(state)
        local new = state.new
        local round = state.round
        local stroke = state.stroke
        local pad = state.pad
        local vlist = state.vlist
        local tween = state.tween
        local text = state.text
        local button = state.button
        local buttonRow = state.buttonRow
        local C = state.C
        local FONT = state.FONT
        local SIZE = state.SIZE
        local CORNER = state.CORNER
        local controls = state.controls
        local FeatureBinds = state.FeatureBinds
        local FeatureBindButtons = state.FeatureBindButtons
        local wm = state.wm
        local indicator = state.indicator
        local cleanName = state.cleanName
        local store = state.store
        local listConfigs = state.listConfigs
        local fetch = state.fetch
        local remove = state.remove
        local notify = state.notify
        local bindLabel = state.bindLabel
        local where = state.where
        local nameBox = state.nameBox
        local setUIVisible = state.setUIVisible
        local cfgListSec = state.cfgListSec
        local cfgManage = state.cfgManage

        -- Selectable list of saved configurations.
        local list = (function(parent)
            local frame = new("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, LayoutOrder = 1,
            }, parent)
            vlist(frame, 2)
            local rows, selected = {}, nil
            local api = {}
            local function highlight()
                for n, row in pairs(rows) do
                    local sel = (n == selected)
                    row.BackgroundTransparency = sel and 0.25 or 1
                    row.TextColor3 = sel and C.Accent or C.Text
                end
            end
            function api.Get() return selected end
            function api.Set(v) selected = v; highlight() end
            function api.SetItems(names)
                for _, row in pairs(rows) do row:Destroy() end
                rows = {}
                selected = nil
                local placeholder = frame:FindFirstChild("EmptyRow")
                if placeholder then placeholder:Destroy() end
                if #names == 0 then
                    local e = text(frame, "  no configurations found", C.Dim)
                    e.Name = "EmptyRow"
                end
                for i, n in ipairs(names) do
                    local row = new("TextButton", {
                        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, AutoButtonColor = false,
                        Text = "  " .. n, Font = FONT, TextSize = SIZE, TextColor3 = C.Text,
                        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = i,
                    }, frame)
                    round(row, 3)
                    row.MouseEnter:Connect(function() if selected ~= n then tween(row, { BackgroundTransparency = 0.7 }) end end)
                    row.MouseLeave:Connect(function() if selected ~= n then tween(row, { BackgroundTransparency = 1 }) end end)
                    row.MouseButton1Click:Connect(function() api.Set(n) end)
                    rows[n] = row
                end
            end
            return api
        end)(cfgListSec)

        local function posOf(f)
            local p = f.Position
            return { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
        end

        local function snapshot()
            local t = {}
            for k, api in pairs(controls) do
                local ok, v = pcall(api.Get)
                if ok then t[k] = v end
            end
            t["@wm"] = posOf(wm)
            t["@indicator"] = posOf(indicator)
            local binds = {}
            for id, b in pairs(FeatureBinds) do
                if type(b) == "table" then
                    binds[id] = { kind = b.kind, key = b.key, active = b.active, mode = b.mode }
                end
            end
            t["@binds"] = binds
            return t
        end

        local function apply(data)
            if type(data) ~= "table" then return end
            for id, binding in pairs(data["@binds"] or {}) do
                if type(binding) == "table" and binding.kind and binding.key then
                    FeatureBinds[id] = binding
                    if FeatureBindButtons[id] then FeatureBindButtons[id].Text = bindLabel(binding) end
                end
            end
            for k, v in pairs(data) do
                if k == "@wm" or k == "@indicator" then
                    if type(v) == "table" and #v == 4 then
                        local f = (k == "@wm") and wm or indicator
                        pcall(function() f.Position = UDim2.new(v[1], v[2], v[3], v[4]) end)
                    end
                elseif k ~= "@binds" and controls[k] then
                    pcall(controls[k].Set, v)
                end
            end
        end

        local baseline = snapshot()

        local function refresh()
            list.SetItems(listConfigs())
        end

        local function typedName()
            return cleanName(nameBox.Text)
        end

        local function create()
            local n = typedName()
            if n == "" then notify("Type a config name first"); return end
            if store(n, snapshot()) then
                refresh()
                list.Set(n)
                notify("Created configuration: " .. n .. where)
            else
                notify("Could not write config file")
            end
        end

        local function load()
            local n = list.Get()
            if not n then notify("Select a configuration first"); return end
            local data = fetch(n)
            if data then
                apply(data)
                notify("Loaded configuration: " .. n)
            else
                notify("Could not read configuration: " .. n)
            end
        end

        local function save()
            local n = list.Get() or typedName()
            if not n or n == "" then notify("Select or type a name first"); return end
            if store(n, snapshot()) then
                refresh()
                list.Set(n)
                notify("Saved configuration: " .. n .. where)
            else
                notify("Could not write config file")
            end
        end

        local function del()
            local n = list.Get()
            if not n then notify("Select a configuration first"); return end
            remove(n)
            refresh()
            notify("Deleted configuration: " .. n)
        end

        buttonRow(cfgManage, { "Load", load }, { "Save", save })
        buttonRow(cfgManage, { "Create", create }, { "Delete", del })
        button(cfgManage, "Refresh Configurations", function()
            refresh()
            notify("Refreshed configurations")
        end)
        button(cfgManage, "Unload Configuration", function()
            apply(baseline)
            notify("Unloaded configuration: reverted to defaults")
        end)
        button(cfgManage, "Unload Menu", function()
            setUIVisible(false)
            notify("Menu unloaded (RightShift to reopen)")
        end)

        refresh()
    end

    setupConfig({
        new = new, round = round, stroke = stroke, pad = pad, vlist = vlist, tween = tween,
        text = text, button = button, buttonRow = buttonRow, C = C, FONT = FONT, SIZE = SIZE, CORNER = CORNER,
        controls = controls, FeatureBinds = FeatureBinds, FeatureBindButtons = FeatureBindButtons,
        wm = wm, indicator = indicator, cleanName = cleanName, store = store, listConfigs = listConfigs,
        fetch = fetch, remove = remove, notify = notify, bindLabel = bindLabel, where = where,
        nameBox = nameBox, setUIVisible = setUIVisible, cfgListSec = cfgListSec, cfgManage = cfgManage,
    })
end

end)()

-- ===================== 03 | INVENTORY VIEWER AND ITEM FINDER =====================
do
    -- Item Finder: Drawing-based floating panel
    local inv_finder_glow_color = Color3.fromRGB(120, 110, 180)
    local inv_finder_panel = {}
    inv_finder_panel.pos    = Vector2.new(
        Flags.InvFinderX or (Camera.ViewportSize.X - 250),
        Flags.InvFinderY or 50
    )
    inv_finder_panel.width    = 200
    inv_finder_panel.dragging = false
    inv_finder_panel.dragoffset = Vector2.new(0, 0)

    local function new_drawing(class, props)
        local d = Drawing.new(class)
        for k, v in pairs(props) do d[k] = v end
        return d
    end

    inv_finder_panel.bg     = new_drawing("Square",  {Visible=false, Filled=true,  Color=Color3.fromRGB(20,20,20), ZIndex=100})
    inv_finder_panel.border = new_drawing("Square",  {Visible=false, Filled=false, Color=Color3.fromRGB(45,45,45), Thickness=1, ZIndex=101})
    inv_finder_panel.title  = new_drawing("Text",    {Visible=false, Text="Item Finder", Size=16, Center=true, Color=Color3.new(1,1,1), Outline=true, ZIndex=102})
    inv_finder_panel.glow   = {}
    for i = 1, 6 do
        inv_finder_panel.glow[i] = new_drawing("Square", {Visible=false, Filled=false, Thickness=1, ZIndex=99})
    end
    inv_finder_panel.labels = {}
    for i = 1, 30 do
        inv_finder_panel.labels[i] = new_drawing("Text", {Visible=false, Text="", Size=14, Center=true, Color=Color3.fromRGB(200,200,200), Outline=true, ZIndex=102})
    end

    local last_inv_finder_scan = 0
    local inv_finder_cache = {}
    local GuiInset = game:GetService("GuiService"):GetGuiInset()

    table.insert(Connections, RunService.Heartbeat:Connect(function()
        local enabled = Flags.InvFinderOn
        if not enabled then
            inv_finder_panel.bg.Visible    = false
            inv_finder_panel.border.Visible = false
            inv_finder_panel.title.Visible  = false
            for i = 1, 6  do inv_finder_panel.glow[i].Visible   = false end
            for i = 1, 30 do inv_finder_panel.labels[i].Visible  = false end
            return
        end

        local found_players
        local now = tick()
        if now - last_inv_finder_scan < 1 then
            found_players = inv_finder_cache
        else
            last_inv_finder_scan = now
            local selected_items = Flags.InvFinderItem or {}
            found_players = {}
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local rp    = ReplicatedStorage:FindFirstChild("Players")
                    local rpp   = rp and rp:FindFirstChild(player.Name)
                    local p_inv = rpp and rpp:FindFirstChild("Inventory")
                    if p_inv then
                        local found_for_player = {}
                        local function check_item(item)
                            if selected_items[item.Name] and not found_for_player[item.Name] then
                                found_for_player[item.Name] = true
                                table.insert(found_players, player.Name .. " (" .. item.Name .. ")")
                            end
                            local sub_inv = item:FindFirstChild("Inventory")
                            if sub_inv then for _, si in ipairs(sub_inv:GetChildren()) do check_item(si) end end
                            local atts = item:FindFirstChild("Attachments")
                            if atts then for _, at in ipairs(atts:GetChildren()) do check_item(at) end end
                        end
                        for _, item in ipairs(p_inv:GetChildren()) do check_item(item) end
                    end
                end
            end
            inv_finder_cache = found_players
        end

        if #found_players > 0 then
            inv_finder_panel.bg.Visible     = true
            inv_finder_panel.border.Visible = true
            inv_finder_panel.title.Visible  = true
            local max_display = math.min(#found_players, 30)
            local h    = 45 + (max_display * 16)
            local p    = inv_finder_panel.pos
            local size = Vector2.new(inv_finder_panel.width, h)
            local mousepos = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y + GuiInset.Y)

            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                local in_bounds = mousepos.X >= p.X and mousepos.X <= p.X + size.X and mousepos.Y >= p.Y and mousepos.Y <= p.Y + size.Y
                if in_bounds or inv_finder_panel.dragging then
                    if not inv_finder_panel.dragging then
                        inv_finder_panel.dragging   = true
                        inv_finder_panel.dragoffset = p - mousepos
                    end
                    inv_finder_panel.pos = mousepos + inv_finder_panel.dragoffset
                    p = inv_finder_panel.pos
                end
            else
                inv_finder_panel.dragging = false
            end

            inv_finder_panel.bg.Position     = p;    inv_finder_panel.bg.Size     = size
            inv_finder_panel.border.Position = p;    inv_finder_panel.border.Size = size
            inv_finder_panel.title.Position  = p + Vector2.new(inv_finder_panel.width / 2, 5)

            local g_color = inv_finder_glow_color
            local g_size  = Flags.InvFinderGlow or 5
            for i = 1, 6 do
                local th = (i / 6) * g_size
                inv_finder_panel.glow[i].Visible     = true
                inv_finder_panel.glow[i].Color       = g_color
                inv_finder_panel.glow[i].Thickness   = math.max(1, th)
                inv_finder_panel.glow[i].Transparency = 0.3 - (i * 0.04)
                inv_finder_panel.glow[i].Size        = size + Vector2.new(th * 2, th * 2)
                inv_finder_panel.glow[i].Position    = p - Vector2.new(th, th)
            end
            for i = 1, 30 do
                if i <= max_display then
                    inv_finder_panel.labels[i].Visible  = true
                    inv_finder_panel.labels[i].Text     = found_players[i]
                    inv_finder_panel.labels[i].Position = p + Vector2.new(inv_finder_panel.width / 2, 25 + (i * 15))
                else
                    inv_finder_panel.labels[i].Visible = false
                end
            end
        else
            inv_finder_panel.bg.Visible     = false
            inv_finder_panel.border.Visible = false
            inv_finder_panel.title.Visible  = false
            for i = 1, 6  do inv_finder_panel.glow[i].Visible  = false end
            for i = 1, 30 do inv_finder_panel.labels[i].Visible = false end
        end
    end))

end

-- Forward declarations used by the inventory/render driver below.
local AimbotCrosshair
local getAimbotTarget

-- Split the inventory viewer into a fresh scope so the Luau local-register limit
-- from the Item Finder block does not carry into MainFrame creation.
do
    -- EliteInventory ScreenGui (grid viewer)
    local InvGui = Instance.new("ScreenGui", CoreGui)
    InvGui.Name           = "Spectrix.Hook_Inventory"
    InvGui.Enabled        = false
    InvGui.DisplayOrder   = 999
    InvGui.ResetOnSpawn   = false

    local MainFrame = Instance.new("Frame", InvGui)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel  = 0
    MainFrame.Size     = UDim2.new(0, 410, 0, 800)
    MainFrame.Position = UDim2.new(0, 200, 0, 200)
    local _mfstroke = Instance.new("UIStroke", MainFrame)
    _mfstroke.Color = Color3.fromRGB(50, 50, 50); _mfstroke.Thickness = 1
    _mfstroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local MainScale = Instance.new("UIScale", MainFrame); MainScale.Name = "MainScale"

    local AccentBar = Instance.new("Frame", MainFrame)
    AccentBar.BackgroundColor3 = ACCENT; AccentBar.BorderSizePixel = 0
    AccentBar.Size = UDim2.new(1, 0, 0, 2); AccentBar.ZIndex = 3

    local InvGlow = Instance.new("ImageLabel", AccentBar)
    InvGlow.ImageColor3        = ACCENT
    InvGlow.ScaleType          = Enum.ScaleType.Slice
    InvGlow.ImageTransparency  = 0.5
    InvGlow.BackgroundTransparency = 1
    InvGlow.Size               = UDim2.new(1, 0, 1, 8)
    InvGlow.AnchorPoint        = Vector2.new(0.5, 0.5)
    InvGlow.Position           = UDim2.new(0.5, 0, 0.5, 0)
    InvGlow.Image              = "rbxassetid://18245826428"
    InvGlow.ZIndex             = 4
    InvGlow.SliceCenter        = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
    local _invg = Instance.new("UIGradient", InvGlow)
    _invg.Rotation    = 90
    _invg.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}

    local HeaderBg = Instance.new("Frame", MainFrame)
    HeaderBg.BackgroundColor3 = Color3.fromRGB(22, 22, 22); HeaderBg.BorderSizePixel = 0
    HeaderBg.Size     = UDim2.new(1, 0, 0, 82); HeaderBg.Position = UDim2.new(0, 0, 0, 2)

    local TopHeader = Instance.new("TextLabel", HeaderBg); TopHeader.BackgroundTransparency = 1
    TopHeader.Position = UDim2.new(0, 12, 0, 10); TopHeader.Size = UDim2.new(1, -24, 0, 18)
    TopHeader.Font = Enum.Font.GothamMedium; TopHeader.TextSize = 14
    TopHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
    TopHeader.TextXAlignment = Enum.TextXAlignment.Left; TopHeader.Text = "Inventory Viewer"

    local TargetNameHeader = Instance.new("TextLabel", HeaderBg); TargetNameHeader.BackgroundTransparency = 1
    TargetNameHeader.Position = UDim2.new(0, 12, 0, 30); TargetNameHeader.Size = UDim2.new(1, -24, 0, 16)
    TargetNameHeader.Font = Enum.Font.Gotham; TargetNameHeader.TextSize = 13
    TargetNameHeader.TextColor3 = Color3.fromRGB(185, 185, 185)
    TargetNameHeader.TextXAlignment = Enum.TextXAlignment.Left; TargetNameHeader.Text = ""

    local HoldingHeader = Instance.new("TextLabel", HeaderBg); HoldingHeader.BackgroundTransparency = 1
    HoldingHeader.Position = UDim2.new(0, 12, 0, 48); HoldingHeader.Size = UDim2.new(1, -24, 0, 16)
    HoldingHeader.Font = Enum.Font.Gotham; HoldingHeader.TextSize = 12
    HoldingHeader.TextColor3 = Color3.fromRGB(155, 155, 155)
    HoldingHeader.TextXAlignment = Enum.TextXAlignment.Left; HoldingHeader.Text = "HOLDING: NONE"

    local Divider = Instance.new("Frame", MainFrame)
    Divider.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Divider.BorderSizePixel = 0
    Divider.Position = UDim2.new(0, 0, 0, 84); Divider.Size = UDim2.new(1, 0, 0, 1)

    local SubHeader = Instance.new("TextLabel", MainFrame); SubHeader.BackgroundTransparency = 1
    SubHeader.Position = UDim2.new(0, 12, 0, 92); SubHeader.Size = UDim2.new(1, -24, 0, 16)
    SubHeader.Font = Enum.Font.GothamMedium; SubHeader.TextSize = 13
    SubHeader.TextColor3 = Color3.fromRGB(185, 185, 185)
    SubHeader.TextXAlignment = Enum.TextXAlignment.Left; SubHeader.Text = "Items"

    local GridContainer = Instance.new("ScrollingFrame", MainFrame)
    GridContainer.BackgroundTransparency = 1
    GridContainer.Position            = UDim2.new(0, 12, 0, 100)
    GridContainer.Size                = UDim2.new(1, -24, 1, -108)
    GridContainer.CanvasSize          = UDim2.new(0, 0, 0, 0)
    GridContainer.ScrollBarThickness  = 3
    GridContainer.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
    GridContainer.BorderSizePixel     = 0
    local GridLayout = Instance.new("UIGridLayout", GridContainer)
    GridLayout.CellSize    = UDim2.new(0, 88, 0, 88)
    GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
    GridLayout.SortOrder   = Enum.SortOrder.LayoutOrder

    -- Dragging
    local inv_Dragging = false; local inv_StartPos, inv_StartMouse
    HeaderBg.InputBegan:Connect(function(input)
        if not Flags.InvDrag then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            inv_Dragging   = true
            inv_StartPos   = MainFrame.Position
            inv_StartMouse = UserInputService:GetMouseLocation()
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then inv_Dragging = false end
            end)
        end
    end)
    table.insert(Connections, UserInputService.InputChanged:Connect(function(input)
        if not inv_Dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta  = UserInputService:GetMouseLocation() - inv_StartMouse
        local parentS = InvGui.AbsoluteSize
        local guiS    = MainFrame.AbsoluteSize
        local newOffX = math.clamp(inv_StartPos.X.Offset + delta.X, -inv_StartPos.X.Scale * parentS.X, parentS.X - guiS.X - inv_StartPos.X.Scale * parentS.X)
        local newOffY = math.clamp(inv_StartPos.Y.Offset + delta.Y, -inv_StartPos.Y.Scale * parentS.Y, parentS.Y - guiS.Y - inv_StartPos.Y.Scale * parentS.Y)
        MainFrame.Position = UDim2.new(inv_StartPos.X.Scale, newOffX, inv_StartPos.Y.Scale, newOffY)
        Flags.InvX = newOffX; Flags.InvY = newOffY
    end))

    -- inventory object
    local inventory = {}
    local LastTargetInventory = nil
    local function formatMoney(amount)
        local formatted = tostring(amount)
        while true do
            local k; formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
            if k == 0 then break end
        end
        return formatted
    end
    local _inv_last_accent = nil
    function inventory:update(__obj)
        if not __obj then InvGui.Enabled = false; return end
        InvGui.Enabled = Flags.InvChecker
        local _cur_accent = ACCENT
        if _cur_accent ~= _inv_last_accent then
            _inv_last_accent         = _cur_accent
            AccentBar.BackgroundColor3 = _cur_accent
            InvGlow.ImageColor3       = _cur_accent
        end
        local ix = Flags.InvX or 200; local iy = Flags.InvY or 200
        if not inv_Dragging then MainFrame.Position = UDim2.new(0, ix, 0, iy) end
        local sc = MainFrame:FindFirstChild("MainScale")
        if sc then sc.Scale = (Flags.InvScale or 100) / 100 end

        local sourceObj = __obj
        local sourcePlayer = __obj:IsA("Player") and __obj or Players:FindFirstChild(__obj.Name)
        if sourceObj:IsA("Player") then sourceObj = sourceObj.Character end
        if not sourceObj then InvGui.Enabled = false; return end

        -- Show the weapon/tool currently equipped by the target.
        local heldTool = sourceObj:FindFirstChildOfClass("Tool")
        local heldName = heldTool and heldTool.Name or nil
        if heldTool then
            local weaponAttr = heldTool:GetAttribute("WeaponName") or heldTool:GetAttribute("ItemName") or heldTool:GetAttribute("DisplayName")
            if type(weaponAttr) == "string" and weaponAttr ~= "" then
                heldName = weaponAttr
            end
        end
        HoldingHeader.Text = "HOLDING: " .. string.upper(heldName or "NONE")

        -- Resolve inventories from the common locations used by the game.
        local inv = sourceObj:FindFirstChild("Inventory", true)
        if not inv and sourcePlayer then
            inv = sourcePlayer:FindFirstChild("Inventory", true)
        end
        if not inv then
            local rp = ReplicatedStorage:FindFirstChild("Players")
            local rpp = rp and sourcePlayer and rp:FindFirstChild(sourcePlayer.Name)
            inv = rpp and rpp:FindFirstChild("Inventory", true)
        end
        if not inv then
            local bp = sourcePlayer and sourcePlayer:FindFirstChildOfClass("Backpack")
            if bp and #bp:GetChildren() > 0 then inv = bp end
        end
        if inv or not (LastTargetInventory == sourceObj) then
            local existing_cards = {}
            for _, child in pairs(GridContainer:GetChildren()) do
                if child:IsA("Frame") then child.Visible = false; table.insert(existing_cards, child) end
            end
            local ItemsList  = ReplicatedStorage:FindFirstChild("ItemsList") or ReplicatedStorage:FindFirstChild("Items", true)
            local itemCount  = 0; local val = 0
            if inv and ItemsList then
                local function process_item(item_folder, hidden)
                    if not item_folder or not item_folder:IsA("Instance") then return end
                    local n = string.lower(item_folder.Name)
                    if n:find("dagr") or n:find("keychain") or n:find("map") or n:find("lighter")
                    or n:find("radio") or n:find("compass") or n:find("pathfinder")
                    or n:find("dv%-2") or n:find("dv2") then return end

                    local item_ref = ItemsList and ItemsList:FindFirstChild(item_folder.Name)
                    local itemProps = item_ref and item_ref:FindFirstChild("ItemProperties")
                    local iconObj = itemProps and itemProps:FindFirstChild("ItemIcon")
                    local itype = itemProps and itemProps:GetAttribute("ItemType")
                    if itype == "Melee" or itype == "MeleeWeapon" then return end

                    local amount = tonumber(item_folder:GetAttribute("Amount")) or 1
                    local price = itemProps and (itemProps:GetAttribute("Price") or 0) or 0
                    if Flags.InvValue and price > 0 then
                        if itype == "Extra" then price = price * 0.4
                        elseif itype == "Ammo" then price = price * amount * 0.7
                        elseif itype == "Clothing" then price = price * 0.35
                        elseif itype == "Medical" then price = price * 0.75
                        elseif itype == "Barter" then price = price * 0.4 end
                        val = val + price
                    end
                    if hidden then return end

                    itemCount = itemCount + 1
                    local card = existing_cards[itemCount]
                    if not card then
                        card = Instance.new("Frame", GridContainer)
                        card.BackgroundColor3 = Color3.fromRGB(28, 28, 28); card.BorderSizePixel = 0
                        local _cs = Instance.new("UIStroke", card); _cs.Color = Color3.fromRGB(50,50,50); _cs.Thickness = 1
                        _cs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                        local icon = Instance.new("ImageLabel", card); icon.BackgroundTransparency = 1
                        icon.Size = UDim2.new(0.8,0,0.65,0); icon.Position = UDim2.new(0.1,0,0.02,0); icon.ScaleType = Enum.ScaleType.Fit
                        local lbl = Instance.new("TextLabel", card); lbl.BackgroundTransparency = 1
                        lbl.Position = UDim2.new(0,4,0.67,0); lbl.Size = UDim2.new(1,-8,0.3,0)
                        lbl.Font = Enum.Font.Gotham; lbl.TextSize = 11; lbl.TextColor3 = Color3.fromRGB(185,185,185)
                        lbl.TextXAlignment = Enum.TextXAlignment.Center; lbl.TextWrapped = true
                    end
                    card.LayoutOrder = itemCount; card.Visible = true
                    local icon = card:FindFirstChildOfClass("ImageLabel")
                    local lbl = card:FindFirstChildOfClass("TextLabel")
                    icon.Image = iconObj and iconObj:IsA("ImageLabel") and iconObj.Image or (iconObj and iconObj:IsA("StringValue") and iconObj.Value or "")
                    icon.Visible = icon.Image ~= ""
                    local itemName = item_folder.Name
                    if amount > 1 then itemName = itemName .. " x" .. tostring(amount) end
                    if #itemName > 20 then itemName = itemName:sub(1,18) .. "..." end
                    lbl.Text = itemName:upper()
                end
                for _, slot in pairs(inv:GetChildren()) do
                    process_item(slot, false)
                    local slot_attr = slot:GetAttribute("Slot")
                    if slot_attr and slot_attr:find("Clothing") and slot:FindFirstChild("Inventory") then
                        if Flags.InvFull then
                            for _, si in pairs(slot.Inventory:GetChildren()) do process_item(si, false) end
                        end
                    elseif slot:FindFirstChild("Attachments") then
                        for _, att in pairs(slot.Attachments:GetChildren()) do process_item(att, true) end
                    end
                end
            end
            val = math.floor(val)
            TopHeader.Text      = "INVENTORY VIEWER â€” " .. itemCount .. " ITEMS" .. (Flags.InvValue and (", $" .. formatMoney(val)) or "")
            TargetNameHeader.Text = sourceObj.Name:upper(); SubHeader.Text = inv and ("ITEMS (" .. itemCount .. ")") or "NO INVENTORY DATA"
            local rows = math.ceil(itemCount / 4)
            GridContainer.CanvasSize = UDim2.new(0, 0, 0, rows * 96)
            MainFrame.Size = UDim2.new(0, 410, 0, math.clamp(130 + rows * 96, 300, 900))
        end
        LastTargetInventory = sourceObj
    end
    function inventory:refresh() end

    -- RenderStepped driver â€” closest-to-crosshair targeting, corpse scan
    local inv_FrameTimer = tick()
    table.insert(Connections, RunService.RenderStepped:Connect(function()
    local aimTarget=(Flags.Aimbot or Flags.CrosshairFollow) and getAimbotTarget() or nil
    if Flags.Aimbot and aimTarget and Camera.CameraType ~= Enum.CameraType.Scriptable then
        local smooth = math.clamp(tonumber(Flags.AimSmooth) or 0.18, 0.02, 1)
        local targetPos = aimTarget.Position
        local desired = CFrame.lookAt(Camera.CFrame.Position, targetPos)
        Camera.CFrame = Camera.CFrame:Lerp(desired, smooth)
    end
    if Flags.Crosshair then
        local pos = aimTarget and Camera:WorldToViewportPoint(aimTarget.Position) or nil
        local x, y
        local mode = Flags.CrosshairPos or "Mouse"
        if mode == "Mouse" then
            local m = UserInputService:GetMouseLocation()
            x, y = m.X, m.Y
        elseif mode == "Top" then x, y = Camera.ViewportSize.X/2, 0
        elseif mode == "Bottom" then x, y = Camera.ViewportSize.X/2, Camera.ViewportSize.Y
        elseif mode == "Left" then x, y = 0, Camera.ViewportSize.Y/2
        elseif mode == "Right" then x, y = Camera.ViewportSize.X, Camera.ViewportSize.Y/2
        else x, y = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2 end
        if pos and Flags.CrosshairFollow then x, y = pos.X, pos.Y end
        local col = Flags.CrosshairRainbow and Color3.fromHSV((os.clock()*0.2)%1,1,1) or (Flags.CrosshairColor or Color3.new(1,1,1))
        AimbotCrosshair.update(RunService.RenderStepped and 0.016 or 0.016, {
            enabled = true, x = x, y = y, color = col,
            length = Flags.CrosshairLength, thickness = Flags.CrosshairThickness,
            gap = Flags.CrosshairGap, opacity = Flags.CrosshairOpacity,
            spin = Flags.CrosshairSpin, outline = Flags.CrosshairOutline, dot = Flags.CrosshairDot,
        })
    else
        AimbotCrosshair.update(0.016, { enabled = false })
    end
        if (tick() - inv_FrameTimer) < math.max(0.05, (Flags.InvDelay or 10) / 100) then return end
        inv_FrameTimer = tick()
        if Flags.InvChecker then
            local target = nil; local dist = math.huge
            local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local char = p.Character
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
                    if hum and hum.Health > 0 and root then
                        local sp, ov = Camera:WorldToViewportPoint(root.Position)
                        if ov and sp.Z > 0 then
                            local mag = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if mag < dist then dist = mag; target = p end
                        end
                    end
                end
            end
            if Flags.InvCorpse then
                local dropped = Workspace:FindFirstChild("DroppedItems")
                if dropped then
                    for _, item in ipairs(dropped:GetChildren()) do
                        if item:FindFirstChild("Humanoid") and item:FindFirstChild("Head") then
                            local sp, ov = Camera:WorldToViewportPoint(item.Head.Position)
                            if ov then
                                local mag = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                                if mag < dist then dist = mag; target = item end
                            end
                        end
                    end
                end
            end
            if target then inventory:update(target) else inventory:refresh(); inventory:update(nil) end
        else
            if InvGui.Enabled then InvGui.Enabled = false end
        end
    end))
end

-- ===================== 04 | COMBAT TARGETING AND PROJECTILE PREDICTION =====================

SAFOV = Drawing.new("Circle")
SAFOV.Thickness = Flags.SA_CircleThickness
SAFOV.NumSides = 64
SAFOV.Filled = false
SAFOV.Color = Flags.SA_CircleColor
SAFOV.Transparency = 1
SAFOV.Visible = false

SASnap = Drawing.new("Line")
SASnap.Thickness = Flags.SA_SnapThickness
SASnap.Color = Flags.SA_SnapColor
SASnap.Transparency = Flags.SA_SnapTransparency
SASnap.Visible = false

print("[Spectrix.Hook] FOV Circle (thin) + Snapline (thick) created")

local function isAlive(char)
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0 and char:FindFirstChild("HumanoidRootPart")
end

local function sameTeam(plr)
    if not Flags.SA_TeamCheck then return false end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    return false
end

local function isVisible(origin, targetPart, extraIgnore)
    local ignore = {Camera, LocalPlayer.Character}
    if extraIgnore then for _, v in ipairs(extraIgnore) do table.insert(ignore, v) end end
    local ray = Ray.new(origin, targetPart.Position - origin)
    local hit = Workspace:FindPartOnRayWithIgnoreList(ray, ignore, false, true)
    return hit and hit:IsDescendantOf(targetPart.Parent)
end

local function getHitPart(char)
    return char:FindFirstChild(Flags.SA_HitPart) or char:FindFirstChild("HumanoidRootPart")
end

local function collectTargets()
    local list = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and isAlive(plr.Character) and not sameTeam(plr) then
            table.insert(list, plr.Character)
        end
    end
    if Flags.SA_TargetAI then
        local AiZones = Workspace:FindFirstChild("AiZones")
        if AiZones then
            for _, zone in ipairs(AiZones:GetChildren()) do
                for _, char in ipairs(zone:GetChildren()) do
                    if isAlive(char) then table.insert(list, char) end
                end
            end
        end
    end
    return list
end

local function getClosest(ignoreList)
    local closest, closestDist = nil, Flags.SA_FOV
    local center = Camera.ViewportSize / 2
    local maxDist = Flags.SA_MaxDistance or 300

    for _, char in ipairs(collectTargets()) do
        local part = getHitPart(char)
        if not part then continue end

        local worldDist = (part.Position - Camera.CFrame.Position).Magnitude
        if worldDist > maxDist then continue end

        if Flags.SA_WallCheck and not isVisible(Camera.CFrame.Position, part, ignoreList) then
            continue
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = part
        end
    end
    return closest
end

local function solveQuadratic(a, b, c)
    local disc = b*b - 4*a*c
    if disc < 0 then return nil end
    local sqrtD = math.sqrt(disc)
    return (-b - sqrtD)/(2*a), (-b + sqrtD)/(2*a)
end

local function trajectoryTime(dir, gravity, speed)
    local a = gravity:Dot(gravity)/4
    local b = gravity:Dot(dir) - speed*speed
    local c = dir:Dot(dir)
    local r1, r2 = solveQuadratic(a, b, c)
    if not r1 then return 0 end
    if r1 > 0 and (not r2 or r1 < r2) then return math.sqrt(r1) end
    if r2 and r2 > 0 then return math.sqrt(r2) end
    return 0
end

local function predict(targetPart, origin, speed, dropAttr)
    local gravity = Vector3.yAxis * (dropAttr * 2)
    local t = trajectoryTime(targetPart.Position - origin, gravity, speed)
    return targetPart.Position + (targetPart.AssemblyLinearVelocity * t)
end

local function projectileDrop(origin, targetPos, speed, dropAttr)
    local gravity = Vector3.yAxis * (dropAttr * 2)
    local t = trajectoryTime(targetPos - origin, gravity, speed)
    return 0.5 * gravity * t * t
end

local ok, BulletModule = pcall(require, ReplicatedStorage.Modules.FPS.Bullet)
if ok and BulletModule and BulletModule.CreateBullet and hookfunction then
    local oldCreate
    oldCreate = hookfunction(BulletModule.CreateBullet, function(a, model, model2, model3, aimPart, e, ammoType, tickVal, recoil)
        local finalRecoil = Flags.NoRecoil and 0 or recoil
        if not (Flags.SilentAim or Flags.InstantHit) then
            return oldCreate(a, model, model2, model3, aimPart, e, ammoType, tickVal, finalRecoil)
        end
        local target = getClosest({model, model2, model3})
        if not target then return oldCreate(a, model, model2, model3, aimPart, e, ammoType, tickVal, finalRecoil) end
        local ammoData = ReplicatedStorage.AmmoTypes:FindFirstChild(ammoType)
        if not ammoData then return oldCreate(a, model, model2, model3, aimPart, e, ammoType, tickVal, finalRecoil) end
        local drop = ammoData:GetAttribute("ProjectileDrop") or 0
        local speed = ammoData:GetAttribute("MuzzleVelocity") or 800
        local origin = aimPart.Position

        local aimPartTarget = target
        if Flags.ForceHitbox and math.random(1, 100) <= (tonumber(Flags.ForceHitboxChance) or 100) then
            local ch = target and target.Parent
            local fp = ch and ch:FindFirstChild(Flags.ForceHitboxPart)
            if fp and fp:IsA("BasePart") then aimPartTarget = fp end
        end

        local instant = Flags.InstantHit or Flags.SA_NoPrediction
        if instant then
            if AmmoBackup[ammoData] == nil then
                AmmoBackup[ammoData] = {
                    drop = ammoData:GetAttribute("ProjectileDrop"),
                    speed = ammoData:GetAttribute("MuzzleVelocity"),
                    drag = ammoData:GetAttribute("Drag"),
                }
            end
            pcall(function()
                ammoData:SetAttribute("ProjectileDrop", 0)
                ammoData:SetAttribute("MuzzleVelocity", 100000)
                ammoData:SetAttribute("Drag", 0)
            end)
            return oldCreate(a, model, model2, model3, {CFrame = CFrame.new(origin, aimPartTarget.Position)}, e, ammoType, tickVal, finalRecoil)
        end

        pcall(function() ammoData:SetAttribute("Drag", 0) end)
        local aimPos = Flags.SA_Prediction and predict(aimPartTarget, origin, speed, drop) or aimPartTarget.Position
        local dropOffset = projectileDrop(origin, aimPos, speed, drop)
        return oldCreate(a, model, model2, model3, {CFrame = CFrame.new(origin, aimPos + dropOffset)}, e, ammoType, tickVal, finalRecoil)
    end)
    warn("[SA] Hooked")
else
    warn("[SA] Hook failed")
end

-- ===================== INSTA HIT / FORCE RENDER (ported from femhax) =====================
local function findUpdateClient()
    local ok, mod = pcall(function()
        local mods = ReplicatedStorage:FindFirstChild("Modules")
        local fps = mods and mods:FindFirstChild("FPS")
        if fps and fps:IsA("ModuleScript") then return require(fps) end
    end)
    if ok and type(mod) == "table" then
        local uc = rawget(mod, "updateClient")
        if type(uc) == "function" then return uc end
    end
    if getgc then
        local found
        pcall(function()
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    local uc = rawget(v, "updateClient")
                    if type(uc) == "function" then found = uc return end
                end
            end
        end)
        if type(found) == "function" then return found end
    end
end

if hookfunction then
    task.spawn(function()
        for _ = 1, 40 do
            local uc = findUpdateClient()
            if type(uc) == "function" then
                local ok = pcall(function()
                    local old
                    local function weaponHook(item, ...)
                        if type(item) == "table" then
                            if Flags.FirerateOverride and type(item.FireRate) == "number" then
                                if FirerateBackup[item] == nil then FirerateBackup[item] = item.FireRate end
                                item.FireRate = tonumber(Flags.FirerateValue) or 0.05
                            elseif FirerateBackup[item] ~= nil then
                                item.FireRate = FirerateBackup[item]
                                FirerateBackup[item] = nil
                            end

                            local cfg = item.settings
                            local cyc = type(cfg) == "table" and cfg.CycleTiming
                            if Flags.NoBolt and type(cyc) == "table" then
                                if BoltBackup[item] == nil then BoltBackup[item] = { cyc[1], cyc[2] } end
                                if cyc[1] ~= 0 then cyc[1] = 0 end
                                if cyc[2] ~= 0 then cyc[2] = 0 end
                            elseif BoltBackup[item] ~= nil then
                                local b = BoltBackup[item]
                                if type(cyc) == "table" then cyc[1] = b[1]; cyc[2] = b[2] end
                                BoltBackup[item] = nil
                            end

                            if Flags.InstantADS and type(item.AimInSpeed) == "number" then
                                if AdsBackup[item] == nil then AdsBackup[item] = { item.AimInSpeed, item.AimOutSpeed } end
                                item.AimInSpeed = 0
                                item.AimOutSpeed = 0
                            elseif AdsBackup[item] ~= nil then
                                item.AimInSpeed = AdsBackup[item][1]
                                item.AimOutSpeed = AdsBackup[item][2]
                                AdsBackup[item] = nil
                            end
                        end
                        return old(item, ...)
                    end
                    old = hookfunction(uc, (newcclosure and newcclosure(weaponHook)) or weaponHook)
                end)
                if ok then break end
            end
            task.wait(0.5)
        end
    end)
end

local function uacPos(name)
    local root = ReplicatedStorage:FindFirstChild("Players")
    local p = root and root:FindFirstChild(name)
    local st = p and p:FindFirstChild("Status")
    local uac = st and st:FindFirstChild("UAC")
    local v = uac and uac:GetAttribute("LastVerifiedPos")
    if typeof(v) == "Vector3" then return v end
end

local function isStreamed(plr)
    local ch = plr.Character
    return ch ~= nil and ch:FindFirstChild("HumanoidRootPart") ~= nil
end

local RunForceRender = (function()
    local accum = 0
    local last = setmetatable({}, { __mode = "k" })
    return function(dt)
        if not Flags.ForceRender then return end
        accum = accum + dt
        if accum < 0.5 then return end
        accum = 0

        local ch = LocalPlayer.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        local origin = root and root.Position
        if not origin then return end

        local cam = Camera.CFrame
        local mode = Flags.ForceRenderMode or "Render All"
        local vp = Camera.ViewportSize
        local center = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
        local queue = {}
        local best, bestScore = nil, math.huge

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and not isStreamed(plr) then
                local pos = uacPos(plr.Name)
                if pos and (pos - origin).Magnitude <= 12000 then
                    local rel = pos - cam.Position
                    if mode == "Render Priority" then
                        if cam.LookVector:Dot(rel.Unit) > 0.3 then
                            queue[#queue + 1] = {plr, pos}
                        end
                    elseif mode == "Render Target" then
                        local sp, on = Camera:WorldToViewportPoint(pos)
                        if on and sp.Z > 0 then
                            local score = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if score < bestScore then bestScore = score; best = {plr, pos} end
                        end
                    else
                        queue[#queue + 1] = {plr, pos}
                    end
                end
            end
        end
        if mode == "Render Target" and best then
            queue[1] = best
        end

        task.spawn(function()
            local now = os.clock()
            for _, ent in ipairs(queue) do
                local plr, pos = ent[1], ent[2]
                if not last[plr] or now - last[plr] > 1.5 then
                    last[plr] = now
                    pcall(function() LocalPlayer:RequestStreamAroundAsync(pos, 0.5) end)
                    task.wait(0.2)
                end
            end
        end)
    end
end)()

local function noclipDetect(char, root, hum)
    local ignore = { char }
    local nc = Workspace:FindFirstChild("NoCollision")
    local di = Workspace:FindFirstChild("DroppedItems")
    if nc then ignore[#ignore+1] = nc end
    if di then ignore[#ignore+1] = di end

    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances = ignore
    ray.IgnoreWater = true
    pcall(function() ray.RespectCanCollide = true end)

    local origin = Camera.CFrame.Position
    local res = Workspace:Raycast(origin, Camera.CFrame.LookVector * 200, ray)
    if not res then return nil end
    local part = res.Instance
    if not part or not part:IsA("BasePart") then return nil end
    local model = part:FindFirstAncestorWhichIsA("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then return nil end
    local n = res.Normal
    local isFloor = n.Y > 0.5
    local isWall = math.abs(n.Y) < 0.6
    if isFloor and not Flags.NoclipFloors then return nil end
    if isWall and not Flags.NoclipWalls then return nil end
    if not (isFloor or isWall) then return nil end

    local layers = math.max(1, math.floor(tonumber(Flags.NoclipLayers) or 1))
    local push = 6 + layers * 6
    local dest
    if isFloor then
        dest = Vector3.new(root.Position.X, res.Position.Y - push, root.Position.Z)
    else
        local into = Vector3.new(-n.X, 0, -n.Z)
        if into.Magnitude < 0.001 then return nil end
        into = into.Unit
        dest = Vector3.new(res.Position.X, root.Position.Y, res.Position.Z) + into * push
    end
    return dest
end

local function RunNoclip(dt)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (char and hum and root) then
        NoclipClip = nil
        return
    end

    if NoclipClip then
        local clip = NoclipClip
        if not (clip.hum and clip.hum.Parent) or clip.hum ~= hum then
            for p, c in pairs(NoclipBackup) do pcall(function() if p and p.Parent then p.CanCollide = c end end) end
            NoclipBackup = {}
            NoclipClip = nil
            return
        end
        clip.t = math.min(1, clip.t + dt * (tonumber(Flags.NoclipSpeed) or 2) * 0.6)
        local e = 1 - (1 - clip.t) ^ 3
        root.CFrame = clip.start:Lerp(clip.dest, e)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if clip.t >= 1 then
            for p, c in pairs(NoclipBackup) do pcall(function() if p and p.Parent then p.CanCollide = c end end) end
            NoclipBackup = {}
            if clip.hum and clip.hum.Parent then pcall(function() clip.hum.PlatformStand = clip.stood end) end
            NoclipClip = nil
        end
        return
    end

    if not Flags.Noclip then return end

    local dest = noclipDetect(char, root, hum)
    if not dest then return end

    NoclipBackup = {}
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            NoclipBackup[p] = p.CanCollide
            p.CanCollide = false
        end
    end
    NoclipClip = {
        start = root.CFrame,
        dest = CFrame.new(dest) * (root.CFrame - root.CFrame.Position),
        hum = hum,
        stood = hum.PlatformStand,
        t = 0,
    }
    hum.PlatformStand = true
end

table.insert(Connections, RunService.Heartbeat:Connect(function(dt)
    RunNoclip(dt)
    RunForceRender(dt)

    if not Flags.InstantHit and not Flags.SA_NoPrediction and next(AmmoBackup) then
        for ammoData, b in pairs(AmmoBackup) do
            pcall(function()
                if ammoData and ammoData.Parent then
                    if b.drop ~= nil then ammoData:SetAttribute("ProjectileDrop", b.drop) end
                    if b.speed ~= nil then ammoData:SetAttribute("MuzzleVelocity", b.speed) end
                    if b.drag ~= nil then ammoData:SetAttribute("Drag", b.drag) end
                end
            end)
        end
        AmmoBackup = {}
    end
end))


-- Anti-aim
local function ApplyAntiAim(Root, Humanoid, NowTick)
    if not Flags.AntiAim then Humanoid.AutoRotate = true return end
    local LookVector = Camera.CFrame.LookVector
    local Angle = -math.atan2(LookVector.Z, LookVector.X) + (NowTick * 15) % 360
    local Offset = math.rad(Flags.AA_YawValue)
    local Angled = CFrame.new(Root.Position) * CFrame.Angles(0, Angle + Offset, 0)
    local _, Y = Angled:ToOrientation()
    Root.CFrame = CFrame.new(Angled.Position) * CFrame.Angles(0, Y, 0)
    Humanoid.AutoRotate = false
end

-- Player ESP and chams
local function GetPlayerVisualColor(visualKey)
    return Flags.ESPColors[visualKey]
end

-- Backtrack-style ESP helpers (text casing, distance units, dynamic bounds).
local function espCase(s)
    local c = Flags.ESP_TextCase
    if c == "Lowercase" then
        return s:lower()
    elseif c == "Uppercase" then
        return s:upper()
    elseif c == "Titlecase" then
        return (s:gsub("(%a)([%w']*)", function(a, b) return a:upper() .. b:lower() end))
    end
    return s
end

local function espDistance(d)
    return math.floor(d) .. (Flags.ESP_DistFormat or "m")
end

local espParts = {
    "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm",
    "LeftLowerArm", "RightLowerArm", "LeftUpperLeg", "RightUpperLeg",
    "LeftLowerLeg", "RightLowerLeg",
}

local function espBounds(char)
    local found = false
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for _, n in ipairs(espParts) do
        local part = char:FindFirstChild(n)
        if part and part:IsA("BasePart") then
            local cf, sz = part.CFrame, part.Size
            for sx = -1, 1, 2 do
                for sy = -1, 1, 2 do
                    for sz2 = -1, 1, 2 do
                        local p = cf:PointToWorldSpace(Vector3.new(sx * sz.X / 2, sy * sz.Y / 2, sz2 * sz.Z / 2))
                        local sp, on = Camera:WorldToViewportPoint(p)
                        if on and sp.Z > 0 then
                            found = true
                            if sp.X < minX then minX = sp.X end
                            if sp.Y < minY then minY = sp.Y end
                            if sp.X > maxX then maxX = sp.X end
                            if sp.Y > maxY then maxY = sp.Y end
                        end
                    end
                end
            end
        end
    end
    if not found then return nil end
    return minX, minY, maxX, maxY
end

local bonePairs = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"},
    {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
}

local function CreateESP(player)
    if player == LocalPlayer then return end
    local c = GetPlayerVisualColor("Box")
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = c
    box.Visible = false

    local glow = Drawing.new("Square")
    glow.Thickness = 1
    glow.Filled = true
    glow.Transparency = 0.7
    glow.Color = c
    glow.Visible = false

    local fill = Drawing.new("Square")
    fill.Thickness = 1
    fill.Filled = true
    fill.Transparency = 0.7
    fill.Color = c
    fill.Visible = false

    local hbbg = Drawing.new("Square")
    hbbg.Thickness = 1
    hbbg.Filled = true
    hbbg.Color = Color3.fromRGB(20, 20, 20)
    hbbg.Visible = false

    local hbfill = Drawing.new("Square")
    hbfill.Thickness = 1
    hbfill.Filled = true
    hbfill.Color = Color3.fromRGB(0, 255, 100)
    hbfill.Visible = false

    local name = Drawing.new("Text")
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Color = GetPlayerVisualColor("Name")
    name.Visible = false

    local dist = Drawing.new("Text")
    dist.Size = 12
    dist.Center = true
    dist.Outline = true
    dist.Color = GetPlayerVisualColor("Distance")
    dist.Visible = false

    local health = Drawing.new("Text")
    health.Size = 12
    health.Center = true
    health.Outline = true
    health.Color = GetPlayerVisualColor("Health")
    health.Visible = false

    local weapon = Drawing.new("Text")
    weapon.Size = 12
    weapon.Center = true
    weapon.Outline = true
    weapon.Color = GetPlayerVisualColor("Name")
    weapon.Visible = false

    local flagLine = Drawing.new("Text")
    flagLine.Size = 11
    flagLine.Center = true
    flagLine.Outline = true
    flagLine.Color = Color3.fromRGB(255, 210, 60)
    flagLine.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = GetPlayerVisualColor("Tracer")
    tracer.Visible = false

    local skeleton = {}
    for i = 1, #bonePairs do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = GetPlayerVisualColor("Skeleton")
        line.Visible = false
        table.insert(skeleton, line)
    end

    ESPObjects[player] = {
        box = box, glow = glow, fill = fill, hbbg = hbbg, hbfill = hbfill,
        name = name, dist = dist, health = health, weapon = weapon, flags = flagLine,
        tracer = tracer, skeleton = skeleton
    }
end

local function RemoveESP(player)
    local obj = ESPObjects[player]
    if obj then
        RemoveDrawingObject(obj)
        ESPObjects[player] = nil
    end
end

local function CreateChams(player)
    if player == LocalPlayer then return end
    if ChamObjects[player] then
        return ChamObjects[player]
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ChamsHighlight"
    highlight.FillTransparency = Flags.ChamsTransparency
    highlight.OutlineTransparency = 0
    highlight.FillColor = GetPlayerVisualColor("Chams")
    highlight.OutlineColor = GetPlayerVisualColor("Chams")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = player.Character
    highlight.Enabled = false
    highlight.Parent = Workspace
    ChamObjects[player] = highlight
    return highlight
end

local function RemoveChams(player)
    local obj = ChamObjects[player]
    if obj then
        if obj.Destroy then obj:Destroy() end
        ChamObjects[player] = nil
    end
end

local function RefreshChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local highlight = CreateChams(player)
            if highlight then
                local char = player.Character
                if char and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                    highlight.Adornee = char
                    highlight.FillTransparency = Flags.ChamsTransparency
                    highlight.FillColor = GetPlayerVisualColor("Chams")
                    highlight.OutlineColor = GetPlayerVisualColor("Chams")
                    highlight.Enabled = Flags.Chams
                else
                    highlight.Enabled = false
                end
            end
        end
    end

    for player, highlight in pairs(ChamObjects) do
        if player ~= LocalPlayer and (not player or not Players:GetPlayerFromUserId(player.UserId)) then
            if highlight then highlight:Destroy() end
            ChamObjects[player] = nil
        end
    end
end

for _, p in ipairs(Players:GetPlayers()) do CreateESP(p) end
table.insert(Connections, Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
    player.CharacterAdded:Connect(function()
        task.defer(function()
            RefreshChams()
        end)
    end)
end))
table.insert(Connections, Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    RemoveChams(player)
end))

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.defer(function()
                RefreshChams()
            end)
        end)
    end
end

-- AI ESP: targets hostiles that live under Workspace.AiZones (same layout the
-- silent-aim AI targeting uses). Draws box/name/distance/health/tracer/skeleton.
local AIESPObjects = {}
local AIBonePairs = bonePairs

local function GetAIColor()
    return Flags.ESPColors.AI or Color3.fromRGB(255, 80, 80)
end

local function CreateAIESP(model)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = GetAIColor()
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Color = GetAIColor()
    name.Visible = false

    local dist = Drawing.new("Text")
    dist.Size = 12
    dist.Center = true
    dist.Outline = true
    dist.Color = GetAIColor()
    dist.Visible = false

    local health = Drawing.new("Text")
    health.Size = 12
    health.Center = true
    health.Outline = true
    health.Color = GetAIColor()
    health.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = GetAIColor()
    tracer.Visible = false

    local skeleton = {}
    for i = 1, #AIBonePairs do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = GetAIColor()
        line.Visible = false
        skeleton[i] = line
    end

    AIESPObjects[model] = {
        box = box, name = name, dist = dist, health = health, tracer = tracer, skeleton = skeleton
    }
end

local function RemoveAIESP(model)
    local obj = AIESPObjects[model]
    if obj then
        RemoveDrawingObject(obj)
        AIESPObjects[model] = nil
    end
end

local function HideAIESP(obj)
    obj.box.Visible = false
    obj.name.Visible = false
    obj.dist.Visible = false
    obj.health.Visible = false
    obj.tracer.Visible = false
    for _, line in ipairs(obj.skeleton) do line.Visible = false end
end

local function CollectAI()
    local list = {}
    local zones = Workspace:FindFirstChild("AiZones")
    if not zones then return list end
    for _, zone in ipairs(zones:GetChildren()) do
        for _, model in ipairs(zone:GetChildren()) do
            if model:IsA("Model") then
                local hum = model:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local anchor = model:FindFirstChild("HumanoidRootPart")
                        or model:FindFirstChild("Head")
                        or model:FindFirstChild("UpperTorso")
                        or model:FindFirstChildWhichIsA("BasePart")
                    if anchor then
                        list[#list + 1] = { model = model, hum = hum, anchor = anchor }
                    end
                end
            end
        end
    end
    return list
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if Flags.AI_ESP then
        local seen = {}
        local col = GetAIColor()
        local maxDist = tonumber(Flags.AI_ESP_MaxDist) or 1000
        for _, target in ipairs(CollectAI()) do
            local model = target.model
            seen[model] = true
            if not AIESPObjects[model] then CreateAIESP(model) end
            local obj = AIESPObjects[model]
            obj.box.Color = col
            obj.name.Color = col
            obj.dist.Color = col
            obj.health.Color = col
            obj.tracer.Color = col
            for _, line in ipairs(obj.skeleton) do line.Color = col end

            local root = target.anchor
            local hum = target.hum
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local distance = (root.Position - Camera.CFrame.Position).Magnitude

            if onScreen and pos.Z > 0 and distance <= maxDist then
                local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))
                local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 2.5, 0))
                local height = math.abs(top.Y - bot.Y)
                local width = height * 0.55

                if Flags.AI_ESP_Box then
                    obj.box.Size = Vector2.new(width, height)
                    obj.box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                    obj.box.Visible = true
                else obj.box.Visible = false end

                if Flags.AI_ESP_Name then
                    obj.name.Text = model.Name
                    obj.name.Position = Vector2.new(pos.X, pos.Y - height / 2 - 16)
                    obj.name.Visible = true
                else obj.name.Visible = false end

                if Flags.AI_ESP_Distance then
                    obj.dist.Text = math.floor(distance) .. "m"
                    obj.dist.Position = Vector2.new(pos.X, pos.Y + height / 2 + 4)
                    obj.dist.Visible = true
                else obj.dist.Visible = false end

                if Flags.AI_ESP_Health then
                    obj.health.Text = math.floor(hum.Health) .. " HP"
                    obj.health.Position = Vector2.new(pos.X, pos.Y + height / 2 + 18)
                    obj.health.Visible = true
                else obj.health.Visible = false end

                if Flags.AI_ESP_Tracer then
                    obj.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    obj.tracer.To = Vector2.new(pos.X, pos.Y + height / 2)
                    obj.tracer.Visible = true
                else obj.tracer.Visible = false end

                if Flags.AI_ESP_Skeleton then
                    for i, pair in ipairs(AIBonePairs) do
                        local a = model:FindFirstChild(pair[1])
                        local b = model:FindFirstChild(pair[2])
                        local line = obj.skeleton[i]
                        if a and b and line then
                            local p1, v1 = Camera:WorldToViewportPoint(a.Position)
                            local p2, v2 = Camera:WorldToViewportPoint(b.Position)
                            if v1 and v2 and p1.Z > 0 and p2.Z > 0 then
                                line.From = Vector2.new(p1.X, p1.Y)
                                line.To = Vector2.new(p2.X, p2.Y)
                                line.Visible = true
                            else line.Visible = false end
                        elseif line then line.Visible = false end
                    end
                else
                    for _, line in ipairs(obj.skeleton) do line.Visible = false end
                end
            else
                HideAIESP(obj)
            end
        end
        for model, obj in pairs(AIESPObjects) do
            if not seen[model] then RemoveAIESP(model) end
        end
    else
        for model in pairs(AIESPObjects) do RemoveAIESP(model) end
    end
end))

-- Item, corpse, and extract ESP
local function CreateMiscDrawing(key, colorKey)
    local text = Drawing.new("Text")
    text.Size = 12
    text.Center = true
    text.Outline = true
    text.Color = Flags.ESPColors[colorKey]
    text.Visible = false
    MiscESP[key] = {text = text}
end

local function ScanMisc()
    for _, obj in pairs(MiscESP) do if obj.text then obj.text.Visible = false end end
    local function add(key, pos, label, enabled, colorKey)
        if not enabled or not pos then return end
        if not MiscESP[key] then CreateMiscDrawing(key, colorKey) end
        local obj = MiscESP[key]
        obj.text.Color = Flags.ESPColors[colorKey]
        local sp, on = Camera:WorldToViewportPoint(pos)
        if on and sp.Z > 0 then
            obj.text.Text = label .. " [" .. math.floor((pos - Camera.CFrame.Position).Magnitude) .. "m]"
            obj.text.Position = Vector2.new(sp.X, sp.Y)
            obj.text.Visible = true
        end
    end
    local dropped = Workspace:FindFirstChild("DroppedItems")
    if dropped and Flags.ItemESP then
        for _, item in ipairs(dropped:GetChildren()) do
            local part = item:IsA("BasePart") and item or item:FindFirstChildWhichIsA("BasePart") or item.PrimaryPart
            if part then add("item_"..tostring(item), part.Position, item.Name, true, "Item") end
        end
    end
    if Flags.CorpseESP then
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") then
                local n = model.Name:lower()
                if n:find("corpse") or n:find("body") then
                    local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    if part then add("corpse_"..tostring(model), part.Position, "Corpse", true, "Corpse") end
                end
            end
        end
    end
    local nocol = Workspace:FindFirstChild("NoCollision")
    if nocol and Flags.ExtractESP then
        local exits = nocol:FindFirstChild("ExitLocations")
        if exits then
            for _, exit in ipairs(exits:GetChildren()) do
                local pos = exit:IsA("BasePart") and exit.Position or (exit.PrimaryPart and exit.PrimaryPart.Position)
                if pos then add("extract_"..tostring(exit), pos, "Extract", true, "Extract") end
            end
        end
    end
end

-- ===================== AIMBOT / CROSSHAIR =====================
local AimbotGui=Instance.new("ScreenGui")
AimbotGui.Name="SpectrixHook_Crosshair"
AimbotGui.IgnoreGuiInset=true
AimbotGui.ResetOnSpawn=false
AimbotGui.DisplayOrder=999999
AimbotGui.Parent=CoreGui
AimbotCrosshair = (function()
    local root = Instance.new("Frame")
    root.Name = "CrosshairRoot"
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Size = UDim2.fromOffset(1, 1)
    root.BackgroundTransparency = 1
    root.Visible = false
    root.Parent = AimbotGui

    local names = { "Top", "Right", "Bottom", "Left" }
    local lines, strokes = {}, {}
    for _, n in ipairs(names) do
        local f = Instance.new("Frame")
        f.Name = n
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.fromScale(0.5, 0.5)
        f.Size = UDim2.fromOffset(1, 1)
        f.BackgroundColor3 = Color3.new(1, 1, 1)
        f.BorderSizePixel = 0
        f.Parent = root
        local st = Instance.new("UIStroke")
        st.Color = Color3.new(0, 0, 0)
        st.Thickness = 1
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.Parent = f
        lines[n] = f; strokes[n] = st
    end

    local dot = Instance.new("Frame")
    dot.Name = "Dot"
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.fromScale(0.5, 0.5)
    dot.Size = UDim2.fromOffset(2, 2)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.BorderSizePixel = 0
    dot.Visible = false
    dot.Parent = root

    local style = {}
    local spin = 0

    local api = { root = root }
    function api.update(dt, opts)
        if not opts.enabled then
            if root.Visible then root.Visible = false end
            return
        end
        local length = math.max(1, opts.length or 6)
        local thick = math.max(1, opts.thickness or 1)
        local gap = opts.gap or 3
        local col = opts.color or Color3.new(1, 1, 1)
        local alpha = 1 - math.clamp(opts.opacity or 1, 0, 1)
        local outline = opts.outline ~= false
        local b = gap + length * 0.5

        if style.len ~= length or style.th ~= thick or style.gap ~= gap or style.col ~= col
            or style.alpha ~= alpha or style.oOn ~= outline then
            style.len, style.th, style.gap, style.col, style.alpha, style.oOn = length, thick, gap, col, alpha, outline
            lines.Top.Size = UDim2.fromOffset(thick, length)
            lines.Bottom.Size = UDim2.fromOffset(thick, length)
            lines.Left.Size = UDim2.fromOffset(length, thick)
            lines.Right.Size = UDim2.fromOffset(length, thick)
            lines.Top.Position = UDim2.new(0.5, 0, 0.5, -b)
            lines.Bottom.Position = UDim2.new(0.5, 0, 0.5, b)
            lines.Left.Position = UDim2.new(0.5, -b, 0.5, 0)
            lines.Right.Position = UDim2.new(0.5, b, 0.5, 0)
            local stThick = math.max(1, math.floor(thick * 0.5))
            for _, n in ipairs(names) do
                lines[n].BackgroundColor3 = col
                lines[n].BackgroundTransparency = alpha
                strokes[n].Enabled = outline
                strokes[n].Color = Color3.new(0, 0, 0)
                strokes[n].Thickness = stThick
                strokes[n].Transparency = alpha
            end
        end

        dot.Visible = opts.dot == true
        if opts.dot then
            dot.BackgroundColor3 = col
            dot.BackgroundTransparency = alpha
            dot.Size = UDim2.fromOffset(math.max(1, thick), math.max(1, thick))
        end

        root.Position = UDim2.fromOffset(opts.x, opts.y)
        spin = (opts.spin and opts.spin or 0) * (dt or 0.016) * 60
        root.Rotation = opts.spin and ((root.Rotation + spin) % 360) or 0
        if not root.Visible then root.Visible = true end
    end
    return api
end)()

getAimbotTarget = function()
    local best,bestDist=nil,tonumber(Flags.AimFOV) or 180
    local center=Camera.ViewportSize/2
    local wanted=Flags.AimHitPart or "Head"
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer and plr.Character then
            local char=plr.Character; local hum=char:FindFirstChildOfClass("Humanoid")
            local part=char:FindFirstChild(wanted) or char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health>0 and part then
                if Flags.SA_TeamCheck and plr.Team and LocalPlayer.Team and plr.Team==LocalPlayer.Team then continue end
                local pos,on=Camera:WorldToViewportPoint(part.Position)
                if on and pos.Z>0 then
                    local worldDist=(Camera.CFrame.Position-part.Position).Magnitude
                    local maxDist=tonumber(Flags.SA_MaxDistance) or 300
                    if worldDist <= maxDist then
                        local d=(Vector2.new(pos.X,pos.Y)-center).Magnitude
                        if d<bestDist then bestDist=d; best=part end
                    end
                end
            end
        end
    end
    return best
end
local function crosshairSymbol(shape)
    return ({Dot="â€¢",Plus="+",X="Ã—",Diamond="â—†",Triangle="â–²",Circle="â—‹"})[shape] or "â€¢"
end

-- ===================== 06 | RENDER UPDATES =====================
table.insert(Connections, RunService.RenderStepped:Connect(function()
    if SAFOV then
        SAFOV.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        SAFOV.Radius = Flags.SA_FOV
        SAFOV.Color = Flags.SA_CircleColor
        SAFOV.Thickness = Flags.SA_CircleThickness
        SAFOV.Visible = Flags.SilentAim
    end

    if Flags.SilentAim and Flags.SA_Snapline and SASnap then
        local target = getClosest()
        if target then
            local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
            if onScreen then
                SASnap.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                SASnap.To = Vector2.new(screenPos.X, screenPos.Y)
                SASnap.Color = Flags.SA_SnapColor
                SASnap.Thickness = Flags.SA_SnapThickness
                SASnap.Transparency = Flags.SA_SnapTransparency
                SASnap.Visible = true
            else
                SASnap.Visible = false
            end
        else
            SASnap.Visible = false
        end
    else
        if SASnap then SASnap.Visible = false end
    end

    if Flags.ESP then
        local renderDist = tonumber(Flags.ESP_RenderDist) or 1300
        local function hidePlayerESP(obj)
            obj.box.Visible = false; obj.glow.Visible = false; obj.fill.Visible = false
            obj.hbbg.Visible = false; obj.hbfill.Visible = false
            obj.name.Visible = false; obj.dist.Visible = false; obj.health.Visible = false
            obj.weapon.Visible = false; obj.flags.Visible = false; obj.tracer.Visible = false
            for _, line in ipairs(obj.skeleton) do line.Visible = false end
        end
        for player, obj in pairs(ESPObjects) do
            local c = GetPlayerVisualColor("Box")
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local teamSkip = Flags.ESP_TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team

            if root and hum and hum.Health > 0 and not teamSkip then
                local distance = (root.Position - Camera.CFrame.Position).Magnitude
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen and pos.Z > 0 and distance <= renderDist then
                    local width, height, cx, cy
                    if Flags.ESP_BoxStyle == "Dynamic" then
                        local minX, minY, maxX, maxY = espBounds(char)
                        if minX then
                            cx, cy = (minX + maxX) / 2, (minY + maxY) / 2
                            width, height = maxX - minX, maxY - minY
                        end
                    end
                    if not width then
                        local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.5, 0))
                        local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 2.5, 0))
                        height = math.abs(top.Y - bot.Y)
                        width = height * 0.55
                        cx, cy = pos.X, pos.Y
                    end
                    width, height = math.max(width, 4), math.max(height, 4)
                    local left, topY = cx - width / 2, cy - height / 2

                    obj.box.Color = c
                    obj.box.Thickness = Flags.ESP_BoxThickness or 1

                    if Flags.ESP_Glow then
                        local pad = 4
                        obj.glow.Color = c
                        obj.glow.Transparency = Flags.ESP_GlowTransparency
                        obj.glow.Size = Vector2.new(width + pad * 2, height + pad * 2)
                        obj.glow.Position = Vector2.new(left - pad, topY - pad)
                        obj.glow.Visible = true
                    else obj.glow.Visible = false end

                    if Flags.ESP_Fill then
                        obj.fill.Color = c
                        obj.fill.Transparency = Flags.ESP_FillTransparency
                        obj.fill.Size = Vector2.new(width, height)
                        obj.fill.Position = Vector2.new(left, topY)
                        obj.fill.Visible = true
                    else obj.fill.Visible = false end

                    if Flags.ESP_Box then
                        obj.box.Size = Vector2.new(width, height)
                        obj.box.Position = Vector2.new(left, topY)
                        obj.box.Visible = true
                    else obj.box.Visible = false end

                    if Flags.ESP_Name then
                        obj.name.Text = espCase(player.Name)
                        obj.name.Size = Flags.ESP_TextSize or 13
                        obj.name.Color = GetPlayerVisualColor("Name")
                        obj.name.Position = Vector2.new(cx, topY - 16)
                        obj.name.Visible = true
                    else obj.name.Visible = false end

                    if Flags.ESP_Distance then
                        obj.dist.Text = espDistance(distance)
                        obj.dist.Size = math.max((Flags.ESP_TextSize or 13) - 1, 8)
                        obj.dist.Color = GetPlayerVisualColor("Distance")
                        obj.dist.Position = Vector2.new(cx, cy + height / 2 + 4)
                        obj.dist.Visible = true
                    else obj.dist.Visible = false end

                    if Flags.ESP_Health then
                        obj.health.Text = math.floor(hum.Health) .. " HP"
                        obj.health.Color = GetPlayerVisualColor("Health")
                        obj.health.Position = Vector2.new(cx, cy + height / 2 + 18)
                        obj.health.Visible = true
                    else obj.health.Visible = false end

                    if Flags.ESP_Weapon then
                        local tool
                        for _, t in ipairs(char:GetChildren()) do
                            if t:IsA("Tool") then tool = t break end
                        end
                        if tool then
                            obj.weapon.Text = espCase(tool.Name)
                            obj.weapon.Color = GetPlayerVisualColor("Name")
                            obj.weapon.Position = Vector2.new(cx, cy + height / 2 + 32)
                            obj.weapon.Visible = true
                        else obj.weapon.Visible = false end
                    else obj.weapon.Visible = false end

                    if Flags.ESP_Flags then
                        local bits = {}
                        local kd = player:GetAttribute("KDR") or player:GetAttribute("KD")
                        if kd then bits[#bits + 1] = "KD " .. tostring(kd) end
                        local head = char:FindFirstChild("Head")
                        if (root.Transparency > 0.5) or (head and head.Transparency > 0.5) then
                            bits[#bits + 1] = "INVIS"
                        end
                        if #bits > 0 then
                            obj.flags.Text = table.concat(bits, " | ")
                            obj.flags.Position = Vector2.new(cx, topY - 28)
                            obj.flags.Visible = true
                        else obj.flags.Visible = false end
                    else obj.flags.Visible = false end

                    if Flags.ESP_HealthBar then
                        local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                        local bx = left - 6
                        obj.hbbg.Size = Vector2.new(3, height)
                        obj.hbbg.Position = Vector2.new(bx, topY)
                        obj.hbbg.Visible = true
                        obj.hbfill.Size = Vector2.new(3, height * frac)
                        obj.hbfill.Position = Vector2.new(bx, topY + height * (1 - frac))
                        obj.hbfill.Color = Color3.fromRGB(255, 60, 60):Lerp(Color3.fromRGB(0, 255, 100), frac)
                        obj.hbfill.Visible = true
                    else
                        obj.hbbg.Visible = false
                        obj.hbfill.Visible = false
                    end

                    if Flags.ESP_Tracer then
                        obj.tracer.From = (Flags.ESP_SnaplineFrom == "Center")
                            and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            or Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        obj.tracer.To = Vector2.new(cx, cy + height / 2)
                        obj.tracer.Color = GetPlayerVisualColor("Tracer")
                        obj.tracer.Visible = true
                    else obj.tracer.Visible = false end

                    if Flags.ESP_Skeleton then
                        for i, pair in ipairs(bonePairs) do
                            local a = char:FindFirstChild(pair[1])
                            local b = char:FindFirstChild(pair[2])
                            local line = obj.skeleton[i]
                            line.Color = GetPlayerVisualColor("Skeleton")
                            if a and b and line then
                                local p1, v1 = Camera:WorldToViewportPoint(a.Position)
                                local p2, v2 = Camera:WorldToViewportPoint(b.Position)
                                if v1 and v2 and p1.Z > 0 and p2.Z > 0 then
                                    line.From = Vector2.new(p1.X, p1.Y)
                                    line.To = Vector2.new(p2.X, p2.Y)
                                    line.Visible = true
                                else
                                    line.Visible = false
                                end
                            else
                                line.Visible = false
                            end
                        end
                    else
                        for _, line in ipairs(obj.skeleton) do
                            line.Visible = false
                        end
                    end
                else
                    hidePlayerESP(obj)
                end
            else
                hidePlayerESP(obj)
            end
        end
    else
        for _, obj in pairs(ESPObjects) do
            obj.box.Visible = false
            obj.glow.Visible = false
            obj.fill.Visible = false
            obj.hbbg.Visible = false
            obj.hbfill.Visible = false
            obj.name.Visible = false
            obj.dist.Visible = false
            obj.health.Visible = false
            obj.weapon.Visible = false
            obj.flags.Visible = false
            obj.tracer.Visible = false
            for _, line in ipairs(obj.skeleton) do
                line.Visible = false
            end
        end
    end

    if Flags.Chams then
        RefreshChams()
    else
        for _, highlight in pairs(ChamObjects) do
            if highlight then
                highlight.Enabled = false
            end
        end
    end

    if Flags.ItemESP or Flags.CorpseESP or Flags.ExtractESP then
        ScanMisc()
    else
        for _, obj in pairs(MiscESP) do
            if obj.text then obj.text.Visible = false end
        end
    end
end))

-- ===================== 07 | MOVEMENT AND CAMERA CONTROLS =====================
table.insert(Connections, RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local NowTick = tick()

    if Flags.Speed then
        local move = hum.MoveDirection
        if move.Magnitude > 0.1 then
            local target = move.Unit * Flags.SpeedValue
            root.AssemblyLinearVelocity = Vector3.new(target.X, root.AssemblyLinearVelocity.Y, target.Z)
        end
    end

    if Flags.ThirdPerson then
        if not OriginalCameraMode then
            OriginalCameraMode = LocalPlayer.CameraMode
            OriginalMaxZoom = LocalPlayer.CameraMaxZoomDistance
            OriginalMinZoom = LocalPlayer.CameraMinZoomDistance
        end
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
        LocalPlayer.CameraMaxZoomDistance = Flags.ThirdPersonDist
        LocalPlayer.CameraMinZoomDistance = Flags.ThirdPersonDist
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        if OriginalCameraMode then
            LocalPlayer.CameraMode = OriginalCameraMode
            LocalPlayer.CameraMaxZoomDistance = OriginalMaxZoom or 128
            LocalPlayer.CameraMinZoomDistance = OriginalMinZoom or 0.5
            OriginalCameraMode = nil
        end
    end

    if Flags.BHop and hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        hum.Jump = true
    end

    if Flags.WalkOnWater then
        local ray = Ray.new(root.Position, Vector3.new(0, -10, 0))
        local _, pos, _, mat = Workspace:FindPartOnRayWithWhitelist(ray, {Terrain})
        if mat == Enum.Material.Water then
            if not WaterPart then
                WaterPart = Instance.new("Part")
                WaterPart.Transparency = 1
                WaterPart.Size = Vector3.new(10, 1, 10)
                WaterPart.CanCollide = true
                WaterPart.Anchored = true
                WaterPart.Parent = Workspace:FindFirstChild("NoCollision") or Workspace
            end
            WaterPart.Position = pos
        end
    elseif WaterPart then
        WaterPart:Destroy()
        WaterPart = nil
    end

    if Flags.NoFall then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    end

    -- Sliding noclip handled by dedicated heartbeat; simple fallback disabled.

    ApplyAntiAim(root, hum, NowTick)

    if Flags.VisualDesync then
        if not DesyncClone or not DesyncClone.Parent then
            if DesyncClone then DesyncClone:Destroy() end
            if DesyncHighlight then DesyncHighlight:Destroy() end
            local was = char.Archivable
            char.Archivable = true
            DesyncClone = char:Clone()
            char.Archivable = was
            DesyncClone.Name = "PD_DesyncClone"
            DesyncClone.Parent = Workspace:FindFirstChild("NoCollision") or Workspace
            for _, o in ipairs(DesyncClone:GetDescendants()) do
                if o:IsA("BasePart") then
                    o.Anchored = true
                    o.CanCollide = false
                    o.CanQuery = false
                    o.CanTouch = false
                elseif o:IsA("Script") or o:IsA("LocalScript") then
                    o:Destroy()
                end
            end
            DesyncHighlight = Instance.new("Highlight")
            DesyncHighlight.Adornee = DesyncClone
            DesyncHighlight.FillTransparency = 0.55
            DesyncHighlight.OutlineTransparency = 0.3
            DesyncHighlight.FillColor = Color3.fromRGB(0, 200, 255)
            DesyncHighlight.OutlineColor = Color3.new(1, 1, 1)
            DesyncHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            DesyncHighlight.Parent = CoreGui
        end
        if DesyncClone then DesyncClone:PivotTo(root.CFrame * CFrame.new(0, 0, 3)) end
    else
        if DesyncClone then DesyncClone:Destroy() DesyncClone = nil end
        if DesyncHighlight then DesyncHighlight:Destroy() DesyncHighlight = nil end
    end
end))

table.insert(Connections, RunService.RenderStepped:Connect(function()
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        return
    end
    if Flags.CustomFOV or Flags.Zoom then
        if not FOVWasApplied then
            OriginalFieldOfView = Camera.FieldOfView
            FOVWasApplied = true
        end
        Camera.FieldOfView = Flags.Zoom and Flags.ZoomValue or Flags.FOVValue
    elseif FOVWasApplied then
        Camera.FieldOfView = OriginalFieldOfView
        OriginalFieldOfView = nil
        FOVWasApplied = false
    end
end))

do
    local AutoPackLast = 0
    local AutoPackRemote = nil

    local function findPackRemote()
        if AutoPackRemote and AutoPackRemote.Parent then return AutoPackRemote end
        AutoPackRemote = nil
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return nil end
        for _, obj in ipairs(remotes:GetDescendants()) do
            if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                local n = string.lower(obj.Name)
                if string.find(n, "pack") and (string.find(n, "mag") or string.find(n, "ammo")) then
                    AutoPackRemote = obj
                    break
                end
            end
        end
        return AutoPackRemote
    end

    RunService.Heartbeat:Connect(function()
        if not Flags.AutoPackMags or os.clock() - AutoPackLast < 0.5 then return end
        AutoPackLast = os.clock()
        local remote = findPackRemote()
        if not remote then return end
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer()
            else
                remote:InvokeServer()
            end
        end)
    end)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Flags.InstantReload and input.KeyCode == Enum.KeyCode.R and not InstantReloadDebounce then
        InstantReloadDebounce = true
        pcall(function()
            local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if Remotes and Remotes:FindFirstChild("Reload") then
                Remotes.Reload:FireServer()
            end
        end)
        task.delay(0.15, function() InstantReloadDebounce = false end)
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Flags.DebugCamera and input.KeyCode == Enum.KeyCode.F4 then
        DebugCamActive = not DebugCamActive
        if DebugCamActive then
            DebugCamOrigin = Camera.CFrame
            Camera.CameraType = Enum.CameraType.Scriptable
            Status.Text = "â—  Debug Camera ON (F4)"
        else
            Camera.CameraType = Enum.CameraType.Custom
            if DebugCamOrigin then Camera.CFrame = DebugCamOrigin end
            Status.Text = "â—  ready"
        end
    end
end)

table.insert(Connections, RunService.RenderStepped:Connect(function(dt)
    if not (Flags.DebugCamera and DebugCamActive) then return end
    local speed = Flags.DebugCamSpeed * 0.5 * (dt * 60)
    local move = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.yAxis end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.yAxis end
    if move.Magnitude > 0 then Camera.CFrame = Camera.CFrame + move.Unit * speed end
    local delta = UserInputService:GetMouseDelta()
    Camera.CFrame *= CFrame.Angles(-math.rad(delta.Y), -math.rad(delta.X), 0)
end))

-- ===================== 08 | LIGHTING AND WORLD VISUALS =====================
local GrassBackup = {}
local FullBrightEffect = nil
local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
}

local function GetFullBrightEffect()
    if FullBrightEffect and FullBrightEffect.Parent then
        return FullBrightEffect
    end
    local existing = Lighting:FindFirstChild("SpectrixHookFullBright")
    if existing and existing:IsA("ColorCorrectionEffect") then
        FullBrightEffect = existing
        return existing
    end
    local effect = Instance.new("ColorCorrectionEffect")
    effect.Name = "SpectrixHookFullBright"
    effect.Parent = Lighting
    FullBrightEffect = effect
    return effect
end

function ApplyFullBright()
    if Flags.FullBright then
        pcall(function()
            Lighting.Brightness = 1.1
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(85, 85, 85)
            Lighting.OutdoorAmbient = Color3.fromRGB(95, 95, 95)
            Lighting.EnvironmentDiffuseScale = 1
            Lighting.EnvironmentSpecularScale = 1
            Lighting.ExposureCompensation = 0.15

            local fx = GetFullBrightEffect()
            fx.Enabled = true
            fx.Brightness = 0.06
            fx.Contrast = 0
            fx.Saturation = 0
        end)
    else
        pcall(function()
            if FullBrightEffect then
                FullBrightEffect.Enabled = false
                FullBrightEffect:Destroy()
                FullBrightEffect = nil
            end
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
            Lighting.FogEnd = OriginalLighting.FogEnd
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
            Lighting.ExposureCompensation = OriginalLighting.ExposureCompensation
            Lighting.EnvironmentDiffuseScale = OriginalLighting.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = OriginalLighting.EnvironmentSpecularScale
        end)
    end
end

-- Force Auto: best-effort full-auto for any gun by flipping common fire-mode
-- properties/attributes found on the equipped tool and its descendants.
local AUTO_KEYS = { "Automatic", "IsAutomatic", "FullAuto", "AutoFire", "Auto", "IsAuto", "AutomaticFire", "AutoFiringMode" }
local function ApplyForceAuto()
    if not Flags.ForceAuto then return end
    local char = LocalPlayer.Character
    if not char then return end
    local tool = char:FindFirstChildWhichIsA("Tool")
    if not tool then return end
    pcall(function()
        for _, key in ipairs(AUTO_KEYS) do
            if tool:GetAttribute(key) ~= nil then tool:SetAttribute(key, true) end
            if tool[key] ~= nil and typeof(tool[key]) == "boolean" then tool[key] = true end
        end
        for _, d in ipairs(tool:GetDescendants()) do
            for _, key in ipairs(AUTO_KEYS) do
                if d:GetAttribute(key) ~= nil then d:SetAttribute(key, true) end
                local ok = pcall(function() if typeof(d[key]) == "boolean" then d[key] = true end end)
            end
            if d:GetAttribute("FireMode") ~= nil then d:SetAttribute("FireMode", "Auto") end
        end
        if tool:GetAttribute("FireMode") ~= nil then tool:SetAttribute("FireMode", "Auto") end
        for _, key in ipairs({ "FireMode", "FiringMode", "Mode" }) do
            local ok, v = pcall(function() return tool[key] end)
            if ok and typeof(v) == "string" then tool[key] = "Auto" end
        end
    end)
end

-- World environment (femhax-style): fog, ambient, brightness, atmosphere, time.
local WorldEnvBackup = { FogEnd = nil, FogStart = nil, FogColor = nil, Ambient = nil, OutdoorAmbient = nil,
    Brightness = nil, AtmoDensity = nil, AtmoOffset = nil, AtmoGlare = nil, AtmoHaze = nil, AtmoColor = nil, ClockTime = nil }
local function ApplyWorldEnv()
    pcall(function()
        if Flags.NoFog then
            if WorldEnvBackup.FogEnd == nil then WorldEnvBackup.FogEnd = Lighting.FogEnd end
            if WorldEnvBackup.FogStart == nil then WorldEnvBackup.FogStart = Lighting.FogStart end
            if WorldEnvBackup.FogColor == nil then WorldEnvBackup.FogColor = Lighting.FogColor end
            Lighting.FogEnd = 100000
            Lighting.FogStart = 100000
            Lighting.FogColor = Color3.fromRGB(200, 200, 200)
        elseif WorldEnvBackup.FogEnd ~= nil then
            Lighting.FogEnd = WorldEnvBackup.FogEnd
            Lighting.FogStart = WorldEnvBackup.FogStart
            Lighting.FogColor = WorldEnvBackup.FogColor
            WorldEnvBackup.FogEnd, WorldEnvBackup.FogStart, WorldEnvBackup.FogColor = nil, nil, nil
        end

        if Flags.EnvAmbientOut then
            if WorldEnvBackup.OutdoorAmbient == nil then WorldEnvBackup.OutdoorAmbient = Lighting.OutdoorAmbient end
            Lighting.OutdoorAmbient = Flags.EnvAmbientOutColor
        elseif WorldEnvBackup.OutdoorAmbient ~= nil then
            Lighting.OutdoorAmbient = WorldEnvBackup.OutdoorAmbient
            WorldEnvBackup.OutdoorAmbient = nil
        end

        if Flags.EnvAmbientIn then
            if WorldEnvBackup.Ambient == nil then WorldEnvBackup.Ambient = Lighting.Ambient end
            Lighting.Ambient = Flags.EnvAmbientInColor
        elseif WorldEnvBackup.Ambient ~= nil then
            Lighting.Ambient = WorldEnvBackup.Ambient
            WorldEnvBackup.Ambient = nil
        end

        if Flags.EnvBrightness then
            if WorldEnvBackup.Brightness == nil then WorldEnvBackup.Brightness = Lighting.Brightness end
            Lighting.Brightness = Flags.EnvBrightnessVal
        elseif WorldEnvBackup.Brightness ~= nil then
            Lighting.Brightness = WorldEnvBackup.Brightness
            WorldEnvBackup.Brightness = nil
        end

        if Flags.EnvTime then
            if WorldEnvBackup.ClockTime == nil then WorldEnvBackup.ClockTime = Lighting.ClockTime end
            Lighting.ClockTime = Flags.EnvTimeVal
        elseif WorldEnvBackup.ClockTime ~= nil then
            Lighting.ClockTime = WorldEnvBackup.ClockTime
            WorldEnvBackup.ClockTime = nil
        end

        local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmo then
            if Flags.EnvAtmo and not Flags.NoFog then
                if WorldEnvBackup.AtmoDensity == nil then WorldEnvBackup.AtmoDensity = atmo.Density end
                if WorldEnvBackup.AtmoOffset == nil then WorldEnvBackup.AtmoOffset = atmo.Offset end
                if WorldEnvBackup.AtmoGlare == nil then WorldEnvBackup.AtmoGlare = atmo.Glare end
                if WorldEnvBackup.AtmoHaze == nil then WorldEnvBackup.AtmoHaze = atmo.Haze end
                if WorldEnvBackup.AtmoColor == nil then WorldEnvBackup.AtmoColor = atmo.Color end
                atmo.Density = Flags.EnvAtmoDensity
                atmo.Offset = Flags.EnvAtmoOffset
                atmo.Glare = Flags.EnvAtmoGlare
                atmo.Haze = Flags.EnvAtmoHaze
                atmo.Color = Flags.EnvAtmoColor
            elseif WorldEnvBackup.AtmoDensity ~= nil then
                atmo.Density = WorldEnvBackup.AtmoDensity
                atmo.Offset = WorldEnvBackup.AtmoOffset
                atmo.Glare = WorldEnvBackup.AtmoGlare
                atmo.Haze = WorldEnvBackup.AtmoHaze
                atmo.Color = WorldEnvBackup.AtmoColor
                WorldEnvBackup.AtmoDensity, WorldEnvBackup.AtmoOffset, WorldEnvBackup.AtmoGlare = nil, nil, nil
                WorldEnvBackup.AtmoHaze, WorldEnvBackup.AtmoColor = nil, nil
            end
        end
    end)
end

local function IsGrassLikeName(name)
    if not name then return false end
    local lower = string.lower(name)
    return lower:find("grass") ~= nil
        or lower:find("bush") ~= nil
        or lower:find("foliage") ~= nil
end

local function ProcessGrassToggle()
    if not Flags.NoGrass then
        for obj, data in pairs(GrassBackup) do
            if typeof(obj) == "Instance" then
                local ok, err = pcall(function()
                    if data.Material ~= nil then
                        obj.Material = data.Material
                    end
                    if data.Transparency ~= nil then
                        obj.Transparency = data.Transparency
                    end
                    if data.CanCollide ~= nil then
                        obj.CanCollide = data.CanCollide
                    end
                    if data.Visible ~= nil then
                        obj.Visible = data.Visible
                    end
                    if data.Parent ~= nil and obj.Parent ~= data.Parent then
                        obj.Parent = data.Parent
                    end
                end)
                if not ok then
                    warn("[NoGrass] Restore failed:", err)
                end
            end
        end
        table.clear(GrassBackup)
        return
    end

    local terrain = Workspace.Terrain
    if terrain and terrain.GrassLength ~= nil then
        pcall(function()
            terrain.GrassLength = 0
        end)
    end

    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Model") then
            local nameLower = d.Name and string.lower(d.Name) or ""
            if IsGrassLikeName(nameLower) then
                if not GrassBackup[d] then
                    GrassBackup[d] = {
                        Parent = d.Parent,
                    }
                end
                if d.Parent then
                    d.Parent = nil
                end
            end
        end

        if d:IsA("BasePart") and d ~= LocalPlayer.Character and not d:IsDescendantOf(LocalPlayer.Character) then
            local nameLower = d.Name and string.lower(d.Name) or ""
            local material = d.Material
            local isGrassPart = material == Enum.Material.Grass or IsGrassLikeName(nameLower)

            if isGrassPart then
                if not GrassBackup[d] then
                    GrassBackup[d] = {
                        Material = d.Material,
                        Transparency = d.Transparency,
                        CanCollide = d.CanCollide,
                        Visible = d.Visible,
                        Parent = d.Parent,
                    }
                end

                pcall(function()
                    d.Transparency = 1
                    d.CanCollide = false
                    d.Visible = false
                end)
            end
        end
    end
end

task.defer(function()
    ApplyFullBright()
end)

table.insert(Connections, RunService.Heartbeat:Connect(function()
    ApplyFullBright()
    ProcessGrassToggle()
    ApplyWorldEnv()
    ApplyForceAuto()

    if Flags.NoTrees then
        pcall(function()
            for _, d in ipairs(Workspace:GetDescendants()) do
                if d:IsA("Model") then
                    local n = d.Name:lower()
                    if n:find("tree") or n:find("pine") or n:find("oak") or n:find("bush") then
                        d:Destroy()
                    end
                end
            end
        end)
    end
end))

-- ===================== 09 | DETECTION =====================
local AC = {LastPosition = nil, RespawnCount = 0, LastRespawn = 0}
local function AC_Flag(reason)
    if not Flags.AC_Detection then return end
    if Flags.AC_Alert then
        warn("[AC] " .. reason)
        Status.Text = "â—  AC FLAGGED â€” " .. reason
        Status.TextColor3 = Color3.fromRGB(255, 70, 70)
    end
end

table.insert(Connections, RunService.Heartbeat:Connect(function()
    if not Flags.AC_Detection then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char then
        local now = tick()
        if now - AC.LastRespawn < 4 then
            AC.RespawnCount += 1
            if AC.RespawnCount >= 3 then AC_Flag("Rapid respawn") end
        else AC.RespawnCount = 0 end
        AC.LastRespawn = now
        return
    end
    if root then
        if AC.LastPosition then
            local dist = (root.Position - AC.LastPosition).Magnitude
            if dist > 180 and not Flags.Speed then
                AC_Flag("Teleport " .. math.floor(dist) .. " studs")
            end
        end
        AC.LastPosition = root.Position
    end
end))


-- Tab contents are defined above; no duplicate UI construction here.
