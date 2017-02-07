#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <clientprefs>
#include <emitsoundany>


#include "files/globals.sp"
#include "files/onplayerruncmd.sp"
#include "files/client.sp"
#include "files/misc.sp"
#include "files/eventhooks.sp"
#include "files/menus.sp"
#include "files/menus_callbacks.sp"
#include "files/command_callbacks.sp"
#include "files/classes.sp"
#include "files/sdkhooks.sp"
#include "files/mysql.sp"
#include "files/timer.sp"

public Plugin myinfo =
{
  name = "[CS:GO] Call of Duty",
  author = "ESK0",
  description = "Call of Duty mod for CSGO",
  version = "1.0",
  url = "www.github.com/ESK0"
};
public void OnPluginStart()
{
  RegConsoleCmd("drop", Command_Drop);
  RegConsoleCmd("sm_drop", Command_Drop);
  RegConsoleCmd("sm_class", Command_Class);
  RegConsoleCmd("sm_classinfo", Command_ClassInfo);
  RegConsoleCmd("sm_item", Command_Item);
  RegConsoleCmd("sm_cod", Command_Cod);

  HookEvent("player_death", Event_OnPlayerDeath);
  HookEvent("player_spawn", Event_OnPlayerSpawn);
  HookEvent("round_start", Event_OnRoundStart);
  HookEvent("round_end", Event_OnRoundEnd);

  RegAdminCmd("sm_pridatitem", Command_GiveItem, ADMFLAG_RCON);

  RegConsoleCmd("sm_vl", Command_Vlastnosti);

  AddNormalSoundHook(OnNormalSoundPlayed);

  h_Settigs[Settings_FastMenu] = RegClientCookie("gs_cod_fastmenu", "", CookieAccess_Private);
  h_Settigs[Settings_Music] = RegClientCookie("gs_cod_music", "", CookieAccess_Private);
  h_Settigs[Settings_Hud] = RegClientCookie("gs_cod_disablehud", "", CookieAccess_Private);

  g_MainClipOffset = FindSendPropInfo("CBaseCombatWeapon", "m_iClip1");
}
public void OnMapStart()
{
  i_ExplosionIndex = PrecacheModel("sprites/blueglow2.vmt");
  i_SmokeIndex = PrecacheModel("sprites/steam1.vmt");
  iBlood = PrecacheDecal("sprites/blood.vmt");

  PrecacheModel(MINA_MODEL);
  iRocketIndex = PrecacheModel(RAKETA_MODEL);

  SetCvarStr("mp_ct_default_grenades", "");
  SetCvarStr("mp_ct_default_primary", "");
  SetCvarStr("mp_ct_default_secondary", "");
  SetCvarStr("mp_t_default_grenades", "");
  SetCvarStr("mp_t_default_primary", "");
  SetCvarStr("mp_t_default_secondary", "");
  SetCvarInt("ammo_grenade_limit_flashbang", 2);
  SetCvarInt("sv_disable_immunity_alpha", 1);

  MySql_Connect();

  PrecacheSoundAny("weapons/hegrenade/explode3.wav");
  PrecacheSoundAny("weapons/hegrenade/explode4.wav");
  PrecacheSoundAny("weapons/hegrenade/explode5.wav");


  for(int i; i < sizeof(MinaList); i++)
  {
    AddFileToDownloadsTable(MinaList[i]);
  }
  for(int i; i < sizeof(RocketList); i++)
  {
    AddFileToDownloadsTable(RocketList[i]);
  }
  PrecacheAndDownloadSounds();
}
public void OnClientPutInServer(int client)
{
  i_gCurrentClass[client] = Class_None;
  i_gChangeClassTo[client] = Class_None;
  i_gCurrentItem[client] = Item_None;
  if(IsValidClient(client))
  {
    if(IsFakeClient(client) == false)
    {
      SendConVarValue(client, FindConVar("sv_footsteps"), "0");
      MySql_LoadClient(client);
      Client_LoadSettings(client);
    }
    SDKHook(client, SDKHook_PreThink, EventSDK_OnClientThink);
    SDKHook(client, SDKHook_OnTakeDamage, EventSDK_OnTakeDamage);
    SDKHook(client, SDKHook_WeaponCanUse, EventSDK_OnWeaponCanUse);
    SDKHook(client, SDKHook_SetTransmit, EventSDK_SetTransmit);
  }
}
public void OnClientDisconnect(int client)
{
  if(IsClientInGame(client))
  {
    MySql_SaveClient(client);
    Client_SaveSettings(client);
    b_ClientVerified[client] = false;
  }
}
public OnClientDisconnect_Post(client)
{
    g_cLastButtons[client] = 0;
}
public Action OnNormalSoundPlayed(int clients[64], int &numClients, char sample[PLATFORM_MAX_PATH], int &entity, int &channel, float &volume, int &level, int &pitch, int &flags)
{
  if(StrContains(sample, "land") != -1)
  {
    return Plugin_Stop;
  }
  if (entity && entity <= MaxClients && StrContains(sample, "footsteps") != -1)
	{
    if(i_gCurrentItem[entity] != Item_Boty)
    {
      EmitSoundToAll(sample, entity, SNDCHAN_AUTO,SNDLEVEL_NORMAL,SND_NOFLAGS,0.5);
      return Plugin_Handled;
    }
    return Plugin_Handled;
  }
  return Plugin_Continue;
}
public void OnButtonPress(client, button, flags)
{
  switch(i_gCurrentClass[client])
  {
    case Class_Sapper:
    {
      if(button & IN_USE && flags & FL_ONGROUND)
      {
        if(i_SapperMina[client] > 0)
        {
          i_SapperMina[client]--;
          CreateMine(client);
          if(i_SapperMina[client] > 0)
          {
            PrintToChat(client, "%s Počet zbývajících min %i", CHAT_TAG, i_SapperMina[client]);
          }
          else
          {
            PrintToChat(client, "%s Vyházel jsi všechny miny", CHAT_TAG);
          }
        }
        else
        {
          PrintToChat(client, "%s Došly ti miny!", CHAT_TAG);
        }
      }
    }
    case Class_Demolitions:
    {
      if(button & IN_USE)
      {
        if(i_DemolitionsDynamit[client] > 0)
        {
          DynamiteExplode(client);
          i_DemolitionsDynamit[client]--;
          if(i_DemolitionsDynamit[client] > 0)
          {
            PrintToChat(client, "%s Počet zbývajících dynamitů %i", CHAT_TAG, i_DemolitionsDynamit[client]);
          }
          else
          {
            PrintToChat(client, "%s Odpálil jsi všechny dynamity", CHAT_TAG);
          }
        }
        else
        {
          PrintToChat(client, "%s Nemáš již žádný dynamit", CHAT_TAG);
        }
      }
    }
    case Class_FireSupport:
    {
      if(button & IN_USE)
      {
        if(i_FireSupportMissiles[client] > 0)
        {
          CreateMissile(client);
          i_FireSupportMissiles[client]--;
          if(i_FireSupportMissiles[client] > 0)
          {
            PrintToChat(client, "%s Počet zbývajících raket %i", CHAT_TAG, i_FireSupportMissiles[client]);
          }
          else
          {
            PrintToChat(client, "%s Vystřelil jsi všechny rakety", CHAT_TAG);
          }
        }
        else
        {
          PrintToChat(client, "%s Nemáš již žádné rakety.", CHAT_TAG);
        }
      }
    }
    case Class_Ghost:
    {
      if(button & IN_USE)
      {
        if(i_GhostKnifes[client] > 0)
        {
          ThrowKnife(client);
          i_GhostKnifes[client]--;
          if(i_GhostKnifes[client] > 0)
          {
            PrintToChat(client, "%s Počet zbývajících nožů %i", CHAT_TAG, i_GhostKnifes[client]);
          }
          else
          {
            PrintToChat(client, "%s Vyházel jsi všechny nože", CHAT_TAG);
          }
        }
        else
        {
          PrintToChat(client, "%s Nemáš již žádné házecí nože", CHAT_TAG);
        }
      }
    }
  }
  switch(i_gCurrentItem[client])
  {
    case Item_Klobouk:
    {
      if(button & IN_USE)
      {
        SetEntityHealth(client, 250);
        i_gCurrentItem[client] = Item_None;
      }
    }
    case Item_PrvniPomoc:
    {
      if(button & IN_USE)
      {
        SetEntityHealth(client, i_ClientClassHealth[client]+i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Life]);
        i_gCurrentItem[client] = Item_None;
      }
    }
    case Item_M4Style:
    {
      if(button & IN_USE)
      {
        int weapon = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
        RemovePlayerItem(client, weapon);
        RemoveEdict(weapon);
        GivePlayerItem(client, "weapon_m4a1");
        i_gCurrentItem[client] = Item_None;
      }
    }
    case Item_Nanosuit:
    {
      if(button & IN_USE)
      {
        b_NanoSuitWeared[client] = true;
        CreateTimer(4.0, Timer_NanoSuit, GetClientUserId(client), TIMER_FLAG_NO_MAPCHANGE);
        i_gCurrentItem[client] = Item_None;
      }
    }
  }
}
