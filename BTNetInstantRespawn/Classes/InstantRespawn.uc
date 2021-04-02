/*
 * Released under the Creative Commons Attribution-NonCommercial-ShareAlike
 * license. See https://creativecommons.org/licenses/by-nc-sa/4.0/
 */
class InstantRespawn extends Mutator;

struct BTNet_Players
{
  	var PlayerPawn PP;
  	var bool       isBeingKilledByScript;
};

var BTNet_Players PlayersArray[32];
var int           CurrentID;

replication {
	// Replicate config vars to client
	reliable if (role == ROLE_Authority)
		PlayersArray;
}

function PreBeginPlay() {
	Log("");
	Log("+--------------------------------------------------------------------------+");
	Log("| BTNetRespawn                                                             |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Author:      Dizzy <dizzy@bunnytrack.net>                                |");
	Log("| Description: Instantly respawns players when they die                    |");
	Log("| Version:     2021-04-02                                                  |");
	Log("| Website:     bunnytrack.net                                              |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Released under the Creative Commons Attribution-NonCommercial-ShareAlike |");
	Log("| license. See https://creativecommons.org/licenses/by-nc-sa/4.0/          |");
	Log("+--------------------------------------------------------------------------+");

	// Register mutator
	Level.Game.BaseMutator.AddMutator(Self);
	Level.Game.RegisterMessageMutator(Self);
}

function bool PreventDeath(Pawn Killed, Pawn Killer, name damageType, vector HitLocation) {
	local int index;
	local TournamentPlayer PP;

	if (TournamentPlayer(Killed) != None) { 
		PP    = TournamentPlayer(Killed);
		index = GetPlayerIndex(PP);

		if (PlayersArray[index].isBeingKilledByScript != true) {
			FastRespawn(PP, damageType);
			return true;
		}
	}

	return false;
}

// Executed on server
function FastRespawn(TournamentPlayer PP, name DeathName) {

	local int index;

	index = GetPlayerIndex(PP);

	PP.Weapon = None;

	// Suicide
	PlayersArray[index].isBeingKilledByScript = true;
	PP.NextState = '';
	PP.Health = -1;
	PP.Died(PP, DeathName, PP.Location);

	// Clean up and reset suicide status
	PP.bFrozen = False;
	PP.ServerReStartPlayer();
	PlayersArray[index].isBeingKilledByScript = false;

}

simulated function int GetPlayerIndex(PlayerPawn PP) {

	local int i;
	local int FirstEmptySlot;

	FirstEmptySlot = -1;

	// Search existing entries
	for (i = 0; i < ArrayCount(PlayersArray); i++) {
		if (PlayersArray[i].PP == PP) break;
		else if (PlayersArray[i].PP == None && FirstEmptySlot == -1) {
			FirstEmptySlot = i;
		}
	}

	// Not found, create new entry
	if (i == ArrayCount(PlayersArray)) {
		i = FirstEmptySlot;
		PlayersArray[i].PP                    = PP;
		PlayersArray[i].isBeingKilledByScript = false;
	}

	return i;

}

function ModifyPlayer(Pawn Other) {
	/*
	 * This mod is released under the Creative Commons Attribution-NonCommercial-ShareAlike license. 
	 * Visible, client-side attribution to BunnyTrack.net is required to use the mod and/or its code.
	 */
    PlayerPawn(Other).ClientMessage("[BTNet] This server uses the Instant Respawn mutator from BunnyTrack.net");
}

defaultproperties
{
    bAlwaysRelevant=true
    RemoteRole=ROLE_SimulatedProxy
}