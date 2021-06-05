PerfectCasino.Legal = PerfectCasino.Legal or {}
-- Function cache
local color = Color
local draw_simpletext = draw.SimpleText
local draw_notexture = draw.NoTexture
local draw_roundedboxex = draw.RoundedBoxEx
local draw_roundedbox = draw.RoundedBox
local surface_setdrawcolor = surface.SetDrawColor
local surface_drawrect = surface.DrawRect
local surface_setdrawcolor = surface.SetDrawColor
local surface_setmaterial = surface.SetMaterial
local surface_drawtexturedrect = surface.DrawTexturedRect
-- Color cache
local mainBlack = color(38, 38, 38)
local bodyBlack = color(40, 40, 40)
local textWhite = color(220, 220, 220)
local mainRed = color(155, 50, 50)
local mainGreen = color(50, 155, 50)
local lineBreak = color(255, 255, 255, 10)
local scrollBackground = color(0, 0, 0, 100)

-- Material cache
local gradientDown = Material("gui/gradient_down")
local gradientMain = Material("gui/gradient")

function PerfectCasino.Legal.AgeMenu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.6, ScrH() * 0.6)
	frame:SetTitle("")
	frame:Center()
	frame:MakePopup()
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)
	frame:DockPadding(0, 0, 0, 0)
	frame.Paint = function(self, w, h)
		-- We drop the 40 to allow for rounded edges on the header
		surface_setdrawcolor(bodyBlack)
		surface_drawrect(0, 40, w, h-40)
	end
	frame.fullScreen = false
	frame.centerX, frame.centerY = frame:GetPos()

	local header = vgui.Create("DPanel", frame)
	header:Dock(TOP)
	header:SetTall(40)
	header:DockMargin(0, 0, 0, 0)
	header.Paint = function(self, w, h)
		draw_roundedboxex(frame.fullScreen and 0 or 5, 0, 0, w, 40, mainBlack, true, true)
		draw_simpletext(PerfectCasino.Legal.Translation.MenuHeader, "pCasino.Header.Static", 10, 20, mainRed, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

		-- Header buttons
		local close = vgui.Create("DButton", header)
		close:Dock(RIGHT)
		close:SetSize(header:GetTall(), header:GetTall())
		close:SetText("")
		close.animationLerp = 0
		close.Paint = function(self, w, h)
			if self:IsHovered() then
				self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
			else
				self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
			end

			draw_notexture()
			surface_setdrawcolor(200 - (self.animationLerp*55), 0, 0, 255)
			PerfectCasino.UI.DrawCircle(w*0.5, h*0.5, w*0.2, 1)
		end
		close.DoClick = function()
			frame:Hide()
		end

		local scale = vgui.Create("DButton", header)
		scale:Dock(RIGHT)
		scale:SetSize(header:GetTall(), header:GetTall())
		scale:SetText("")
		scale.animationLerp = 0
		scale.Paint = function(self, w, h)
			if self:IsHovered() then
				self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
			else
				self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
			end

			draw_notexture()
			surface_setdrawcolor(255, 165 - (self.animationLerp*25), 0, 255)
			PerfectCasino.UI.DrawCircle(w*0.5, h*0.5, w*0.2, 1)
		end
		scale.DoClick = function()
			if frame.fullScreen then
				frame:SizeTo(ScrW()*0.6, ScrH()*0.6, 0.5)
				frame:MoveTo(frame.centerX, frame.centerY, 0.5)
			else
				frame:SizeTo(ScrW(), ScrH(), 0.5)
				frame:MoveTo(0, 0, 0.5)
			end

			frame.fullScreen = not frame.fullScreen
		end

	-- Used to apply padding as DScrollPanel doesn't allow it
	local shell = vgui.Create("DPanel", frame)
	shell:Dock(FILL)
	shell:DockPadding(5, 5, 5, 5)
	shell.Paint = function(self, w, h)
		surface_setdrawcolor(0, 0, 0, 155)
		-- Header shadow
		surface_setmaterial(gradientDown)
		surface_drawtexturedrect(0, 0, w, 10)
		-- Navbar shadow
		surface_setmaterial(gradientMain)
		surface_drawtexturedrect(0, 0, 10, h)
	end

	local title = vgui.Create("DPanel", shell)
	title:Dock(TOP)
	title:DockMargin(0, 0, 0, 5)
	title:SetTall(57.5)
	title.Paint = function(self, w, h)
		draw_simpletext(PerfectCasino.Legal.Translation.MenuTitle, "pCasino.Entity.Bid", 10, 0, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	end

	local content = vgui.Create("DLabel", shell)
	content:Dock(FILL)
	content:DockMargin(0, 0, 0, 5)
	content:SetText(PerfectCasino.Legal.Translation.MenuContent)
	content:SetWrap(true)
	content:SetFont("pCasino.SubTitle.Static")
	content:SetColor(color_white)

	local confirmAge = vgui.Create("DButton", shell)
	confirmAge:SetText("")
	confirmAge:Dock(BOTTOM)
	confirmAge:SetTall(30)
	confirmAge:DockMargin(10, 5, 10, 5)
	confirmAge.animationLerp = 0
	confirmAge.Paint = function(self, w, h)
		if self:IsHovered() then
			self.animationLerp = math.Approach(self.animationLerp or 0, 1, 5*FrameTime())
		else
			self.animationLerp = math.Approach(self.animationLerp or 1, 0, 5*FrameTime())
		end
		draw_roundedbox(0+(5*self.animationLerp), 0, 0, w, h, mainGreen)
		draw_simpletext(PerfectCasino.Legal.Translation.MenuConfirm, "pCasino.Main.Static", w*0.5, (h*0.5), textWhite, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	confirmAge.DoClick = function()
		net.Start("pCasino:Legal:ConfirmAge")
		net.SendToServer()

		frame:Close()
	end
end