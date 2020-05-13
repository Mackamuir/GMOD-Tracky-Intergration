--powered by VB and winnie blues 


if SERVER then

	util.AddNetworkString( "claim" )
	util.AddNetworkString( "claimed" )
	util.AddNetworkString( "fuckoff" )

	hook.Add( "PlayerSay", "CommandIndent", function( ply, text )

		local stmid = ply:SteamID()
		local claim = ""

		if string.lower(text) == "/claim" then
		local url = string.Replace( "http://www.api.trackyserver.com/vote/?action=claim&key=152855&steamid=stmid", "stmid", stmid )

				http.Fetch( url,
					function( body )
					claim = body
					print( claim )
					--this is a fucked way to do this but its easy and works
					if claim == "0" then
						net.Start("claim")
						net.Send(ply)
					end
					if claim == "1" then
						net.Start("claimed")
						net.Send(ply)
					end
					if claim == "2" then
						net.Start("fuckoff")
						net.Send(ply)
					end	
				end,
				function( error )
			 		print( "Tracky Servers are probs fucked" )
				end
			)
		end
	end)
end

if CLIENT then
	net.Receive("claim",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[DG] ", Color( 255, 255, 255 ), "You haven't voted! Type /vote to get the voting link!")
end)
	net.Receive("claimed",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[DG] ", Color( 255, 255, 255 ), "Thanks for voting! Here is your reward.")
end)
	net.Receive("fuckoff",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[DG] ", Color( 255, 255, 255 ), "You already claimed your reward in the past 24 hours!")
end)
end