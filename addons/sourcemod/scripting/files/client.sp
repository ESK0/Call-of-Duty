#define LoopAllClients(%1) for(int %1 = 1;%1 <= MaxClients;%1++)
#define LoopClients(%1) for(int %1 = 1;%1 <= MaxClients;%1++) if(IsValidClient(%1))
#define LoopAliveClients(%1) for(int %1 = 1;%1 <= MaxClients;%1++) if(IsValidClient(%1, true))

stock bool IsValidClient(int client, bool alive = false)
{
  if(0 < client && client <= MaxClients && IsClientInGame(client) && IsFakeClient(client) == false && (alive == false || IsPlayerAlive(client)))
  {
    return true;
  }
  if(0 < client && client <= MaxClients && IsClientInGame(client) && IsFakeClient(client) && (alive == false || IsPlayerAlive(client)))
  {
    return true;
  }
  return false;
}
stock bool IsClientAdmin(int client)
{
  if (GetAdminFlag(GetUserAdmin(client), Admin_Generic))
  {
    return true;
  }
  return false;
}
stock bool IsClientVIP(int client, AdminFlag type)
{
  if (GetAdminFlag(GetUserAdmin(client), type))
  {
    return true;
  }
  return false;
}
