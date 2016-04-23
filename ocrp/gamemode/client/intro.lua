
function GM:Intro_Start()
	timer.Simple(1,function()
		Sound_GlobalMusic = CreateSound(LocalPlayer(),"/ocrp/intro/IntroTheme.mp3")
		Sound_GlobalMusic:Play()
	end)
end

local client = LocalPlayer()
local SW,SH = ScrW(),ScrH()

function GM:Intro_Think() 

	surface.SetDrawColor(0,0,0,255)
	surface.DrawRect(0,0,ScrW(),ScrH())

	for name,data in pairs(GAMEMODE.OCRP_Intro) do 
		if name != "EndTime" && name != "Music" then
		
			if CurTime() > data.Time.Start && CurTime() < data.Time.End then
				data.Alpha.Cur = data.Alpha.Cur - data.Fade.In
				if data.Alpha.Cur < data.Alpha.Low then
					data.Alpha.Cur = data.Alpha.Low
				elseif data.Alpha.Cur > data.Alpha.High then
					data.Alpha.Cur = data.Alpha.High
				end
			elseif CurTime() > data.Time.End then
				data.Alpha.Cur = data.Alpha.Cur + data.Fade.Out
				if data.Alpha.Cur < data.Alpha.Low then
					data.Alpha.Cur = data.Alpha.Low
				elseif data.Alpha.Cur > data.Alpha.High then
					data.Alpha.Cur = data.Alpha.High
					data.NotActive = true
				end
			end
			
			if CurTime() > data.Time.Start && CurTime() < data.Time.End then

				local percent =  (CurTime() - data.Time.Start)  / (data.Time.End - data.Time.Start)
				
				data.Coords.CURXPOS =  data.Coords.STARTXPOS + ((data.Coords.ENDXPOS - data.Coords.STARTXPOS ) * percent)
				data.Coords.CURYPOS = data.Coords.STARTYPOS + ((data.Coords.ENDYPOS - data.Coords.STARTYPOS ) * percent)
				data.Coords.CURX = data.Coords.STARTX + ((data.Coords.ENDX - data.Coords.STARTX)* percent)
				data.Coords.CURY = data.Coords.STARTY + ((data.Coords.ENDY - data.Coords.STARTY)* percent)
					
			end
			if !data.NotActive then
				data.DrawFunc()		
				
				local xpos = data.Coords.CURXPOS
				local ypos = data.Coords.CURYPOS
				local x = data.Coords.CURX
				local y = data.Coords.CURY			
				if !data.Text then
					surface.SetDrawColor(0,0,0,data.Alpha.Cur)
					surface.DrawRect(xpos,ypos,x,y)
				end
			end
		end
	end	
	if GAMEMODE.OCRP_Intro.EndTime  < CurTime() then
		GAMEMODE:Intro_End()		
	end
end

function GM:Intro_End() 
	INTRO = false
	OCRP_Start_Model()
	file.Write("OCRP/Intro.txt","You have seen the intro")
end

OC_RP_Logo = Material("OCRP/intro/OCRP_Logo")
OC_SSG_Logo = Material("OCRP/intro/OCRP_SSG")
OC_OC_Logo = Material("OCRP/intro/OCRP_OC")

Gmod_Logo = Material("gui/gmod_logo")

OC_Noob = Material("OCRP/intro/OCRP_Noob")
OC_Jake = Material("OCRP/intro/OCRP_jake")
OC_Frosty = Material("OCRP/intro/OCRP_Frosty")
OC_Marc = Material("OCRP/intro/OCRP_Marc")


GM.OCRP_Intro = {
	EndTime = CurTime() + 70 + 15,
	Music = "",
 }

GM.OCRP_Intro["Gmod_Logo"] = {
	Time = {Start = CurTime() + 2 + 15,End = CurTime() + 5 + 15},
	Fade = {In = 1,Out = 1.2},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["Gmod_Logo"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(Gmod_Logo)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/2-64),STARTYPOS = (SH/2-64),STARTX = (128),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2-64),ENDYPOS = (SH/2-64),ENDX = (128),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_OC"] = {
	Time = {Start = CurTime() + 8 + 15,End = CurTime() + 11 + 15},
	Fade = {In = 2,Out = 1.2},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_OC"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_OC_Logo)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/2-256),STARTYPOS = (SH/2-64),STARTX = (512),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2-256),ENDYPOS = (SH/2-64),ENDX = (512),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_SSG"] = {
	Time = {Start = CurTime() + 15 + 15,End = CurTime() + 18 + 15},
	Fade = {In = 2,Out = 1.2},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_SSG"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_SSG_Logo)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/2-128),STARTYPOS = (SH/2-64),STARTX = (256),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2-128),ENDYPOS = (SH/2-64),ENDX = (256),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Logo"] = {
	Time = {Start = CurTime() + 22 + 15,End = CurTime() + 30 + 15},
	Fade = {In = 2,Out = 1.2},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Logo"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_RP_Logo)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/2-256),STARTYPOS = (SH/2-64),STARTX = (512),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2-256),ENDYPOS = (SH/2-64),ENDX = (512),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}
GM.OCRP_Intro["OCRP_Devs"] = {
	Time = {Start = CurTime() + 33 + 15,End = CurTime() + 52 + 15},
	Fade = {In = 1,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Devs"].Coords
					draw.DrawText("The Developers", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(210,120,30,255 - GAMEMODE.OCRP_Intro["OCRP_Devs"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/2),STARTYPOS = (SH/2),STARTX = (512),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2),ENDYPOS = (SH/2),ENDX = (512),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Noob"] = {
	Time = {Start = CurTime() + 36 + 15,End = CurTime() + 46 + 15},
	Fade = {In = 2,Out = 1},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Noob"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_Noob)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/8-128),STARTYPOS = (SH/8-128),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/4-128),ENDYPOS = (SH/4-128),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Noob_Label"] = {
	Time = {Start = CurTime() + 35 + 15,End = CurTime() + 46 + 15},
	Fade = {In = .5,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Noob_Label"].Coords
					draw.DrawText("Noobulater for Coding", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(255,100,100,255 - GAMEMODE.OCRP_Intro["OCRP_Noob_Label"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/8),STARTYPOS = (SH/8+128),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY = (1),
				ENDXPOS = (SW/4),ENDYPOS = (SH/4+128),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Jake"] = {
	Time = {Start = CurTime() + 38 + 15,End = CurTime() + 48 + 15},
	Fade = {In = 2,Out = 1},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Jake"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_Jake)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/1.125-128),STARTYPOS = (SH/1.125-128),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/1.25-128),ENDYPOS = (SH/1.25-128),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Jake_Label"] = {
	Time = {Start = CurTime() + 37 + 15,End = CurTime() + 48 + 15},
	Fade = {In = .5,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Jake_Label"].Coords
					draw.DrawText("Jake_1305 for Coding", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(255,100,100,255 - GAMEMODE.OCRP_Intro["OCRP_Jake_Label"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/1.125),STARTYPOS = (SH/1.125-150),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY = (1),
				ENDXPOS = (SW/1.25),ENDYPOS = (SH/1.25-150),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}


GM.OCRP_Intro["OCRP_Frosty"] = {
	Time = {Start = CurTime() + 40 + 15,End = CurTime() + 50 + 15},
	Fade = {In = 2,Out = 1},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Frosty"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_Frosty)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/8-128),STARTYPOS = (SH/1.125-128),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/4-128),ENDYPOS = (SH/1.25-128),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Frosty_Label"] = {
	Time = {Start = CurTime() + 39 + 15,End = CurTime() + 50 + 15},
	Fade = {In = .5,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Frosty_Label"].Coords
					draw.DrawText("::Frosty for Mapping", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(255,100,100,255 - GAMEMODE.OCRP_Intro["OCRP_Frosty_Label"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/8),STARTYPOS = (SH/1.125-150),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY = (1),
				ENDXPOS = (SW/4),ENDYPOS = (SH/1.25-150),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Marc"] = {
	Time = {Start = CurTime() + 42 + 15,End = CurTime() + 52 + 15},
	Fade = {In = 2,Out = 1},
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Marc"].Coords
					surface.SetDrawColor(Color( 255, 255, 255, 255 ))
					surface.SetMaterial(OC_Marc)
					surface.DrawTexturedRect(tbl.CURXPOS,tbl.CURYPOS,tbl.CURX,tbl.CURY)
				end,
	Coords = {
				STARTXPOS = (SW/1.125-128),STARTYPOS = (SH/8-128),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/1.25-128),ENDYPOS = (SH/4-128),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_Marc_Label"] = {
	Time = {Start = CurTime() + 41 + 15,End = CurTime() + 52 + 15},
	Fade = {In = .5,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Marc_Label"].Coords
					draw.DrawText("Captain McMarcus for GUI Graphics", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(255,100,100,255 - GAMEMODE.OCRP_Intro["OCRP_Marc_Label"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/1.125),STARTYPOS = (SH/8+150),STARTX = (256),STARTY =(256),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY = (1),
				ENDXPOS = (SW/1.25),ENDYPOS = (SH/4+150),ENDX = (256),ENDY =(256),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}

GM.OCRP_Intro["OCRP_OCCom"] = {
	Time = {Start = CurTime() + 55 + 15,End = CurTime() + 59 + 15},
	Fade = {In = 1,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_OCCom"].Coords
					draw.DrawText("Special Thanks to the OC community for ideas and support!", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(210,120,30,255 - GAMEMODE.OCRP_Intro["OCRP_OCCom"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/2),STARTYPOS = (SH/2),STARTX = (512),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2),ENDYPOS = (SH/2),ENDX = (512),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}


GM.OCRP_Intro["OCRP_Enjoy"] = {
	Time = {Start = CurTime() + 62 + 15,End = CurTime() + 67 + 15},
	Fade = {In = 1,Out = 1},
	Text = true,
	DrawFunc  = function()
					local tbl = GAMEMODE.OCRP_Intro["OCRP_Enjoy"].Coords
					draw.DrawText("Enjoy!", "Trebuchet22", tbl.CURXPOS, tbl.CURYPOS, Color(210,120,30,255 - GAMEMODE.OCRP_Intro["OCRP_Enjoy"].Alpha.Cur),1)
				end,
	Coords = {
				STARTXPOS = (SW/2),STARTYPOS = (SH/2),STARTX = (512),STARTY =(128),
				CURXPOS = (-1000),CURYPOS = (-1000),CURX = (1),CURY =(1),
				ENDXPOS = (SW/2),ENDYPOS = (SH/2),ENDX = (512),ENDY =(128),
			},
	Alpha = {Cur = 255,Low = 0,High = 255,},
}
