public int m_Attributes(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      if(i_gClientClassAttributesPoints[client][i_gCurrentClass[client]] > 0)
      {
        char sItem[24];
        menu.GetItem(Position, sItem, sizeof(sItem));
        if(StrEqual(sItem,"intellect"))
        {
          i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]--;
          i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Intellect]++;
          PrintToChat(client, "%s Intellect vylepšen na %i",CHAT_TAG, i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Intellect]);
        }
        else if(StrEqual(sItem,"life"))
        {
          i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]--;
          i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Life]++;
          PrintToChat(client, "%s Life vylepšen na %i",CHAT_TAG, i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Life]);
        }
        else if(StrEqual(sItem,"strenght"))
        {
          i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]--;
          i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength]++;
          PrintToChat(client, "%s Strenght vylepšen na %i",CHAT_TAG, i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength]);
        }
        else if(StrEqual(sItem,"condition"))
        {
          i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]--;
          i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Condition]++;
          PrintToChat(client, "%s Condition vylepšen na %i",CHAT_TAG, i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Condition]);
        }
        EmitSoundToClientAny(client, "gamesites/gs_callofduty/attri.mp3", SOUND_FROM_PLAYER, 251, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.3);
      }
    }
  }
}
public int m_ClassList(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char sItem[3];
      menu.GetItem(Position, sItem, sizeof(sItem));
      int iTempClass = StringToInt(sItem);
      Client_ChangeClassTo(client, view_as<ClassType>(iTempClass));
      PrintToChat(client, "%s %s", CHAT_TAG, ClassInfo[iTempClass-1]);
    }
  }
}
public int m_Cod(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char sItem[32];
      menu.GetItem(Position, sItem, sizeof(sItem));
      if(StrEqual(sItem, "class"))
      {
        Menu_ClassList(client);
      }
      else if(StrEqual(sItem, "classinfo"))
      {
        ShowMotdToClient(client, "http://fastdownload.gamesites.cz/global/motd/cod_postavy.html");
      }
      else if(StrEqual(sItem, "iteminfo"))
      {
        ShowMotdToClient(client, "http://fastdownload.gamesites.cz/global/motd/cod_itemy.html");
      }
      else if(StrEqual(sItem, "gameinfo"))
      {
        ShowMotdToClient(client, "http://fastdownload.gamesites.cz/global/motd/cod_popis.html");
      }
      else if(StrEqual(sItem, "settings"))
      {
        Menu_Settings(client);
      }
      else if(StrEqual(sItem, "vip"))
      {
        char buffer[64];
        int port = GetConVarInt(FindConVar("hostport"));
        Format(buffer, sizeof(buffer), "http://fastdownload.gamesites.cz/global/motd/cod_vip%i.html", port);
        ShowMotdToClient(client, buffer);
      }
    }
  }
}
public int m_settings(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char sItem[32];
      menu.GetItem(Position, sItem, sizeof(sItem));
      if(StrEqual(sItem, "fastmenu"))
      {
        i_Settings[client][Settings_FastMenu] = !i_Settings[client][Settings_FastMenu];
      }
      else if(StrEqual(sItem, "music"))
      {
        i_Settings[client][Settings_Music] = !i_Settings[client][Settings_Music];
      }
      else if(StrEqual(sItem, "hud"))
      {
        i_Settings[client][Settings_Hud] = !i_Settings[client][Settings_Hud];
        if(IsPlayerAlive(client))
        {
          if(i_Settings[client][Settings_Hud] == 1)
          {
            b_HudDisabled[client] = false;
          }
          else
          {
            b_HudDisabled[client] = true;
          }
        }
      }
      Menu_Settings(client);
    }
    else if(action == MenuAction_Cancel)
    {
      if(Position == MenuCancel_ExitBack)
      {
        Menu_Cod(client);
      }
    }
  }
}
public int m_classinfo(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char sItem[3];
      menu.GetItem(Position, sItem, sizeof(sItem));
      int class = StringToInt(sItem);
      PrintToChat(client, "%s %s", CHAT_TAG, ClassInfo[class-1]);
      menu.DisplayAt(client, GetMenuSelectionPosition(), MENU_TIME_FOREVER);
    }
  }
}
public int m_pridatitem(Menu menu, MenuAction action, int client, int Position)
{
  if(IsValidClient(client))
  {
    if(action == MenuAction_Select)
    {
      char sItem[3];
      menu.GetItem(Position, sItem, sizeof(sItem));
      int iItem = StringToInt(sItem);
      if(i_gCurrentItem[client] != Item_None)
      {
        Client_RemoveItemEffect(client);
        i_gCurrentItem[client] = Item_None;
      }
      i_gCurrentItem[client] = view_as<Item>(iItem);
      f_ClientItemStart[client] = GetGameTime();
      Client_CreateItemEffect(client);
    }
  }
}
