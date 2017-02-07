public Action Timer_ShowClassList(Handle timer, any client)
{
  Menu_ClassList(client);
}
public Action Timer_PoisionBullet(Handle timer, DataPack datapack)
{
  datapack.Reset();
  int userid = datapack.ReadCell();
  int vuserid = datapack.ReadCell();
  int client = GetClientOfUserId(userid);
  int victim = GetClientOfUserId(vuserid);
  if(IsValidClient(client))
  {
    if(IsValidClient(victim, true))
    {
      if(i_MakarovPoisoned[victim] > 0)
      {
        i_MakarovPoisoned[victim]--;
        if((GetClientHealth(victim) -10) <= 0)
        {
          ForcePlayerSuicide(victim);
          SetEntProp(client, Prop_Data, "m_iFrags", GetEntProp(client, Prop_Data, "m_iFrags")+1);
        }
        else
        {
          SetEntityHealth(victim, GetClientHealth(victim)-10);
          DataPack dta = new DataPack();
          dta.WriteCell(GetClientUserId(client));
          dta.WriteCell(GetClientUserId(victim));
          if(i_MakarovPoisoned[victim] > 0)
          {
            CreateTimer(2.0, Timer_PoisionBullet, dta, TIMER_FLAG_NO_MAPCHANGE);
          }
        }
      }
      else
      {
        i_MakarovPoisoned[victim] = 0;
      }
    }
  }
}
public Action Timer_NanoSuit(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid)
  if(IsValidClient(client))
  {
    b_NanoSuitWeared[client] = false;
  }
}
public Action Timer_DisableHud(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client, true))
  {
    b_HudDisabled[client] = true;
  }
}
public Action Timer_RespawnClient(Handle timer, any userid)
{
  int client = GetClientOfUserId(userid);
  if(IsValidClient(client))
  {
    CS_RespawnPlayer(client);
  }
}
