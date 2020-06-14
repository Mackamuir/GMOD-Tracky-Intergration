--powered by VB and winnie blues 


if SERVER then

	util.AddNetworkString( "claim" );
	util.AddNetworkString( "claimed" );
	util.AddNetworkString( "fuckoff" );
	util.AddNetworkString( "vote" );

	CreateConVar("tracky_key", "");

	hook.Add( "PlayerSay", "CommandIndent", function( ply, text )

		local stmid = ply:SteamID64()
		local claim = ""

		if string.lower(text) == "/claim" then
		local url1 = string.Replace( "http://www.api.trackyserver.com/vote/?action=claim&key=trackkey&steamid=stmid", "stmid", stmid )
		local url = string.Replace( url1, "trackkey", GetConVar( "tracky_key" ):GetString() )

				http.Fetch( url,
					function( body )
					claim = body
					--the API will return 0 if player has not voted, 1 if voted but not claimed or 2 if voted and claimed
					--https://www.trackyserver.com/listing/api
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
		elseif string.lower(text) == "/vote" then
			net.Start("vote")
			net.Send(ply)
		end
	end)
end

if CLIENT then
	CreateConVar("tracky_id", "", FCVAR_PROTECTED);

	net.Receive("claim",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[Tracky] ", Color( 255, 255, 255 ), "You haven't voted! Type /vote to get the voting link!")
end)
	net.Receive("claimed",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[Tracky] ", Color( 255, 255, 255 ), "Thanks for voting! Here is your reward.")
end)
	net.Receive("fuckoff",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[Tracky] ", Color( 255, 255, 255 ), "You already claimed your daily reward!")
end)
	net.Receive("vote",function(len)
	chat.AddText( Color( 50, 237, 225 ), "[Tracky] ", Color( 255, 255, 255 ), string.Replace( "https://www.trackyserver.com/server/trackid", "trackid", GetConVar( "tracky_id" ):GetString() ) )
end)

end
