public Action Event_OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
  int victim = GetClientOfUserId(event.GetInt("userid"));
  int attacker = GetClientOfUserId(event.GetInt("attacker"));
  int weapon = GetEntPropEnt(attacker, Prop_Send, "m_hActiveWeapon");
  int iWeaponindex;
  if(IsValidEntity(weapon))
  {
    iWeaponindex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
  }
  if(IsValidClient(victim))
  {
    if(IsValidClient(attacker))
    {
      if(GetClientTeam(victim) != GetClientTeam(attacker))
      {
        if(i_gCurrentItem[attacker] == Item_None)
        {
          if(GetRandomFloat(0.0, 100.0) <= Client_ItemChance(attacker))
          {
            GiveRandomItem(attacker);
          }
        }
        switch(i_gCurrentClass[attacker])
        {
          case Class_Rambo:
          {
            SetEntityHealth(attacker, GetClientHealth(attacker)+20);
          }
        }

        switch(i_gCurrentClass[victim])
        {
          case Class_Rambo:
          {
            SetEntityHealth(attacker, GetClientHealth(attacker)+20);
          }
          case Class_CptPrice:
          {
            if(GetRandomFloat(0.0, 100.0) <= 25.0)
            {
              CreateTimer(1.0, Timer_RespawnClient, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
            }
          }
        }

        switch(i_gCurrentItem[attacker])
        {
          case Item_Adrenalin:
          {
            SetEntityHealth(attacker, GetClientHealth(attacker)+30);
          }
          case Item_Chuck:
          {
            SetEntityHealth(attacker, GetClientHealth(attacker)+20);

            for(int i; i < sizeof(WeaponDefinitionID); i++)
            {
              if(iWeaponindex == WeaponDefinitionID[i])
              {
                SetEntData(weapon, g_MainClipOffset, WeaponPrimaryAmmo[i]+1);
                break;
              }
            }

          }
        }
        switch(i_gCurrentItem[victim])
        {
          case Item_Morfin:
          {
            if(!IsPlayerAlive(victim))
            {
              if(GetRandomFloat(0.0, 100.0) < 33.3)
              {
                CreateTimer(1.0, Timer_RespawnClient, GetClientUserId(victim), TIMER_FLAG_NO_MAPCHANGE);
              }
            }
          }
        }
        if(i_gClientClassLvl[attacker][i_gCurrentClass[attacker]] < i_LevelMax)
        {
          Client_AddClassExp(attacker);
        }
      }
      b_HudDisabled[victim] = false;
    }
  }
}

public Action Event_OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
  int client = GetClientOfUserId(event.GetInt("userid"));
  if(IsValidClient(client, true))
  {
    SetEntityRenderMode(client, RENDER_TRANSCOLOR);
    if(i_Settings[client][Settings_Music] == 0)
    {
      char buffer[64];
      Format(buffer, sizeof(buffer), "gamesites/gs_callofduty/rad%i.mp3", i_RoundRadio);
      EmitSoundToClientAny(client, buffer, _, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3);
    }
    f_RoundStartMusic = GetGameTime();
    i_MakarovPoisoned[client] = 0;
    f_ItemModifySpeed[client] = 0.0;
    f_ClientHPRegenValue[client] = 0.0;
    b_NanoSuitWeared[client] = false;
    StripWeapons(client);
    b_HudDisabled[client] = false;
    if(i_Settings[client][Settings_Hud] == 1)
    {
      CreateTimer(1.0, Timer_DisableHud, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
    }
    if(i_gChangeClassTo[client] != Class_None)
    {
      i_gCurrentClass[client] = i_gChangeClassTo[client];
      i_gChangeClassTo[client] = Class_None;
    }
    if(i_Settings[client][Settings_FastMenu] == 0)
    {
      Menu_Cod(client);
    }
    if(i_gCurrentClass[client] == Class_None)
    {
      CreateTimer(0.2, Timer_ShowClassList, client);
    }
    SetEntityGravity(client, 1.0);
    Class_SetUp(client);
    if(i_gCurrentItem[client] != Item_None)
    {
      if(i_gCurrentItem[client] == Item_Veteran)
      {
        f_ItemModifySpeed[client] = 0.3;
        SetEntityHealth(client, GetClientHealth(client) + 50);
      }
      else if(i_gCurrentItem[client] == Item_Recruit)
      {
        f_ItemModifySpeed[client] = 0.3;
        SetEntityHealth(client, GetClientHealth(client) + 50);
        i_gCurrentItem[client] = Item_None;
      }
      else if(i_gCurrentItem[client] != Item_GhostHelm || i_gCurrentItem[client] != Item_CptBook)
      {
        Client_CreateItemEffect(client);
      }
    }
  }
}
public Action Event_OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
  SetCvarInt("sv_enablebunnyhopping", 1);
  SetCvarInt("sv_staminamax", 0);
  SetCvarInt("sv_staminajumpcost", 0);
  SetCvarInt("sv_staminalandcost", 0)
  i_RoundSound = GetRandomInt(1, 13);
  i_RoundRadio = GetRandomInt(1, 11);
}
public Action Event_OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
  int winner = event.GetInt("winner");
  if(winner == CS_TEAM_T || winner == CS_TEAM_CT)
  {
    for(int i; i <= MaxClients; i++)
    {
      if(IsValidClient(i))
      {
        if(i_Settings[i][Settings_Music] == 0)
        {
          char buffer[64];
          if(winner == CS_TEAM_CT)
          {
            Format(buffer, sizeof(buffer), "gamesites/gs_callofduty/cttt%i.mp3", GetRandomInt(1, 6));
          }
          else
          {
            Format(buffer, sizeof(buffer), "gamesites/gs_callofduty/ttt%i.mp3", GetRandomInt(1, 5));
          }
          EmitSoundToClientAny(i, buffer, _, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3);
        }
      }
    }
  }
}
