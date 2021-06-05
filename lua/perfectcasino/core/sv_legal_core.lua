PerfectCasino.Legal = PerfectCasino.Legal or {}
PerfectCasino.Legal.UsersCC = PerfectCasino.Legal.UsersCC or {}
PerfectCasino.Legal.UsersAge = PerfectCasino.Legal.UsersAge or {}

util.AddNetworkString("pCasino:Legal:Age")
util.AddNetworkString("pCasino:Legal:ConfirmAge")

function PerfectCasino.Legal.GetCountryCodeFromIP(ply)
	http.Fetch(
		string.format(PerfectCasino.Legal.Config.API, string.Split(ply:IPAddress(), ":")[1]),
		function(body)
			if not IsValid(ply) then return end

			local ipData = util.JSONToTable(body)
			if not (ipData.geoplugin_status == 200) then
				for i=1, 10 do
					print("[pCasino Legal]", "There was an error getting IP data for the user", ply:SteamID64())
				end 
				return
			end

			PerfectCasino.Legal.UsersCC[ply:SteamID64()] = ipData.geoplugin_countryCode
		end
	)
end
hook.Add("PlayerInitialSpawn", "pCasino:Legal:LoadCountryCode", PerfectCasino.Legal.GetCountryCodeFromIP)

net.Receive("pCasino:Legal:ConfirmAge", function(_, ply)
	if PerfectCasino.Legal.UsersAge[ply:SteamID64()] then return end
	
	PerfectCasino.Legal.UsersAge[ply:SteamID64()] = true
end)

function PerfectCasino.Legal.BaseCheck(ply)
	if not PerfectCasino.Legal.UsersCC[ply:SteamID64()] then
		return false, PerfectCasino.Legal.Translation.UnknownError
	end

	if table.HasValue(PerfectCasino.Legal.Config.BlockedCountry, PerfectCasino.Legal.UsersCC[ply:SteamID64()]) then
		return false, PerfectCasino.Legal.Translation.BlockedCountry
	end

	if not PerfectCasino.Legal.UsersAge[ply:SteamID64()] then
		net.Start("pCasino:Legal:Age")
		net.Send(ply)
		return false
	end
end

hook.Add("pCasinoCanBlackjackBet", "pCasino:Legal:BaseCheck", PerfectCasino.Legal.BaseCheck)
hook.Add("pCasinoCanMysteryWheelSpin", "pCasino:Legal:BaseCheck", PerfectCasino.Legal.BaseCheck)
hook.Add("pCasinoCanRouletteBet", "pCasino:Legal:BaseCheck", PerfectCasino.Legal.BaseCheck)
hook.Add("pCasinoCanBasicSlotMachineBet", "pCasino:Legal:BaseCheck", PerfectCasino.Legal.BaseCheck)
hook.Add("pCasinoCanWheelSlotMachineBet", "pCasino:Legal:BaseCheck", PerfectCasino.Legal.BaseCheck)