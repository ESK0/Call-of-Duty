public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
  if(IsValidClient(client))
  {
    int index;
    if(IsPlayerAlive(client))
    {
      index = client;
      if(GetClientTeam(client) > CS_TEAM_SPECTATOR)
      {
        int cFlags = GetEntityFlags(client);
        int cButtons = GetClientButtons(client);
        if(i_gCurrentClass[client] != Class_None)
        {
          if(i_gCurrentClass[client] == Class_Rambo || i_gCurrentItem[client] == Item_NinjaStep)
          {
            if (i_dJlFlags[client] & FL_ONGROUND)
            {
              if (!(cFlags & FL_ONGROUND) && !(i_dJlButtons[client] & IN_JUMP) && cButtons & IN_JUMP)
              {
                i_dJjCount[client]++;
              }
            }
            else if (cFlags & FL_ONGROUND)
            {
              i_dJjCount[client] = 0;
            }
            else if (!(i_dJlButtons[client] & IN_JUMP) && cButtons & IN_JUMP)
            {
              if (1 <= i_dJjCount[client] <= 1)
              {
                i_dJjCount[client]++;
                float vVel[3];
                GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
                vVel[2] = 250.0;
                TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel);
              }
            }
            i_dJlFlags[client]	= cFlags;
            i_dJlButtons[client]	= cButtons;
          }
        }
        if(i_gCurrentItem[client] == Item_BunnyHoper)
        {
            if (buttons & IN_JUMP)
            {
              if(!(GetEntityMoveType(client) & MOVETYPE_LADDER) && !(GetEntityFlags(client) & FL_ONGROUND))
              {
                if(WaterCheck(client) < 2)
                {
                  buttons &= ~IN_JUMP;
                }
              }
            }
        }
        if(f_RoundStartMusic != 0.0)
        {
          if(i_Settings[client][Settings_Music] == 0)
          {
            float timeleft = f_RoundStartMusic - GetGameTime() + 6.0
            if(timeleft < 0.01)
            {
              char buffer[64];
              Format(buffer, sizeof(buffer), "gamesites/gs_callofduty/%in.mp3", i_RoundSound);
              EmitSoundToClientAny(client, buffer, _, SNDCHAN_AUTO, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3);
              f_RoundStartMusic = 0.0;
            }
          }
        }
        if(i_gCurrentClass[client] != Class_None)
        {
          if(f_ClientHPRegenValue[client] != 0.0)
          {
            float timeleft = f_ClientHPRegenStart[client] - GetGameTime() + f_ClientHPRegenValue[client];
            if(timeleft < 0.01)
            {
              if(GetClientHealth(client) < i_ClientClassHealth[client])
              {
                if((GetClientHealth(client) + 1) == i_ClientClassHealth[client])
                {
                  SetEntityHealth(client, i_ClientClassHealth[client]);
                  f_ClientHPRegenValue[client] = 0.0;
                }
                else
                {
                  SetEntityHealth(client, GetClientHealth(client)+1);
                  f_ClientHPRegenStart[client] = GetGameTime();
                  f_ClientHPRegenValue[client] = 0.2;
                }
              }
              else
              {
                f_ClientHPRegenValue[client] = 0.0;
              }
            }
          }
        }
        if(i_gCurrentItem[client] != Item_None)
        {
          f_ItemTimeLeft[client] = f_ClientItemStart[client] - GetGameTime() + Client_ItemTime(client);
          if(f_ItemTimeLeft[client] < 0.01)
          {
            Client_RemoveItemEffect(client);
            i_gCurrentItem[client] = Item_None;
          }
        }
        // FlyModul
        if(i_gCurrentItem[client] == Item_FlyModul)
        {
          if(buttons & IN_JUMP && buttons & IN_USE && !(g_cLastButtons[client] & IN_JUMP))
          {
            if(GetEntityFlags(client) & FL_ONGROUND && GetEntityMoveType(client) != MOVETYPE_LADDER)
            {
              float f_VecVelocity[3];
              GetEntPropVector(client, Prop_Data, "m_vecVelocity", f_VecVelocity);
              f_VecVelocity[0] *= 1.8;
              f_VecVelocity[1] *= 1.8;
              TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, f_VecVelocity);
            }
          }
        }
        for (int i = 0; i < MAX_BUTTONS; i++)
        {
          int button = (1 << i);
          if ((buttons & button))
          {
            if (!(g_cLastButtons[client] & button))
            {
              OnButtonPress(client, button, cFlags);
            }
          }
          else if ((g_cLastButtons[client] & button))
          {
            //OnButtonRelease(client, button);
          }
        }
        g_cLastButtons[client] = buttons;
      }
    }
    else
    {
      if(IsValidClient(GetEntPropEnt(client, Prop_Send, "m_hObserverTarget")))
      {
        index = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
      }
    }
    if(IsValidClient(index))
    {
      if(b_HudDisabled[client] == false)
      {
        if(i_gCurrentClass[index] != Class_None)
        {
          char buffer[300];
          char temp[64];
          char itemleft[32];
          if(i_gClientClassLvl[index][i_gCurrentClass[index]] != i_LevelMax)
          {
            Format(temp, sizeof(temp), "<font color='#ff4e8d'>%i/%i</font>",i_gClientClassExp[index][i_gCurrentClass[index]], GetExpFromNextLevel(index));
          }
          Format(buffer, sizeof(buffer), " Class: <font color='#a0db8e'>%s</font>\n", ClassNames[i_gCurrentClass[index]]);
          Format(buffer, sizeof(buffer), "%s Level: <font color='#ff4e8d'>%i</font>  XP: %s\n", buffer, i_gClientClassLvl[index][i_gCurrentClass[index]], i_gClientClassLvl[index][i_gCurrentClass[index]] == i_LevelMax?"<font color='#ff4e8d'>MAX LEVEL</font>":temp);
          if(i_gCurrentItem[index] != Item_None)
          {
            Format(itemleft, sizeof(itemleft), "(%0.0fsec)", f_ItemTimeLeft[index]);
          }
          else
          {
            Format(itemleft, sizeof(itemleft), "")
          }
          Format(buffer, sizeof(buffer), "%s Item: %s %s", buffer, ItemNames[i_gCurrentItem[index]], itemleft);
          PrintHintText(client, buffer);
        }
      }
    }
  }
}
