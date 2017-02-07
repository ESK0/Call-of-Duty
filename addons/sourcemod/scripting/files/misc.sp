stock int GetExpFromNextLevel(int client)
{
  int i_ClientLevel = i_gClientClassLvl[client][i_gCurrentClass[client]] + 1;
  return i_ExpList[i_ClientLevel];
}
stock int GetClientExpReward(int client)
{
  int iExpReward = 0;
  if(IsClientVIP(client, g_AccType[ACC_EVIP]))
  {
    iExpReward = KILLREWARD;
  }
  else if(IsClientVIP(client, g_AccType[ACC_VIP]))
  {
    iExpReward = KILLREWARD;
  }
  else
  {
    iExpReward = KILLREWARD;
  }
  switch(i_gCurrentItem[client])
  {
    case Item_XPMaster:
    {
      iExpReward *= 2;
    }
  }
  return iExpReward;
}
stock void Client_AddClassExp(int client)
{
  int i_ClientNextLevel = i_gClientClassLvl[client][i_gCurrentClass[client]] + 1;
  int i_CurrentExp = i_gClientClassExp[client][i_gCurrentClass[client]];
  int i_RequiredExp = GetExpFromNextLevel(client);
  int i_KillReward = GetClientExpReward(client);
  int i_ExpDiff = (i_CurrentExp + i_KillReward) - i_RequiredExp;
  if(i_ExpDiff >= 0)
  {
    i_gClientClassLvl[client][i_gCurrentClass[client]]++;
    i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]++;
    if(i_ClientNextLevel == i_LevelMax)
    {
      i_gClientClassExp[client][i_gCurrentClass[client]] = 0;
    }
    else
    {
      i_gClientClassExp[client][i_gCurrentClass[client]] = i_ExpDiff;
      Client_CheckExpAndLevel(client);
    }
  }
  else
  {
    i_gClientClassExp[client][i_gCurrentClass[client]] += i_KillReward;
  }
}
stock void Client_CheckExpAndLevel(int client)
{
  int i_ClientNextLevel = i_gClientClassLvl[client][i_gCurrentClass[client]] + 1;
  int i_CurrentExp = i_gClientClassExp[client][i_gCurrentClass[client]];
  int i_RequiredExp = GetExpFromNextLevel(client);
  int i_ExpDiff = i_CurrentExp - i_RequiredExp;
  if(i_ExpDiff >= 0)
  {
    i_gClientClassLvl[client][i_gCurrentClass[client]]++;
    i_gClientClassAttributesPoints[client][i_gCurrentClass[client]]++;
    if(i_ClientNextLevel == i_LevelMax)
    {
      i_gClientClassExp[client][i_gCurrentClass[client]] = 0;
    }
    else
    {
      i_gClientClassExp[client][i_gCurrentClass[client]] = i_ExpDiff;
      Client_CheckExpAndLevel(client);
    }
  }
}
public void Client_ChangeClassTo(int client, ClassType type)
{
  if(IsPlayerAlive(client))
  {
    if(i_gCurrentClass[client] == Class_None)
    {
      i_gCurrentClass[client] = type;
      Class_SetUp(client);
      PrintToChat(client, "%s Nyní jsi %s!", CHAT_TAG, ClassNames[view_as<int>(type)]);
      if(i_Settings[client][Settings_FastMenu] == 0)
      {
        Menu_Cod(client);
      }
    }
    else
    {
      i_gChangeClassTo[client] = type;
      PrintToChat(client, "%s Tvoje class se změní na začátku příštího kola na %s!", CHAT_TAG, ClassNames[view_as<int>(type)]);
    }
  }
  else
  {
    i_gCurrentClass[client] = type;
    PrintToChat(client, "%s Změnil sis class na %s!", CHAT_TAG, ClassNames[view_as<int>(type)]);
  }
}
stock void SetCvarStr(char[] scvar, char[] svalue)
{
  SetConVarString(FindConVar(scvar), svalue, true);
}
stock void SetCvarInt(char[] scvar, int svalue)
{
  SetConVarInt(FindConVar(scvar), svalue, true);
}
stock void SetCvarFloat(char[] scvar, float svalue)
{
  SetConVarFloat(FindConVar(scvar), svalue, true);
}
stock void Class_EquipClient(int client, char[][] weaponlist, int len)
{
  for(int i; i < len; i++)
  {
    GivePlayerItem(client, weaponlist[i]);
  }
}
stock void FakeFlashClient(int client, int r = 0, int g = 0, int b = 0, int a = 0)
{
  #define FFADE_IN            0x0001
  #define FFADE_PURGE         0x0010
	Handle hFadeClient = StartMessageOne("Fade",client);
	if (GetUserMessageType() == UM_Protobuf)
	{
		int color[4];
		color[0] = r;
		color[1] = g;
		color[2] = b;
		color[3] = a;
		PbSetInt(hFadeClient, "duration", 1000);
		PbSetInt(hFadeClient, "hold_time", 500);
		PbSetInt(hFadeClient, "flags", (FFADE_PURGE|FFADE_IN));
		PbSetColor(hFadeClient, "clr", color);
	}
	EndMessage();
}
stock void ExplodeSteamId(const char[] steamid, char[] e_steamid,int l)
{
  char buffer[3][32];
  ExplodeString(steamid,":",buffer,sizeof(buffer),sizeof(buffer[]));
  Format(e_steamid,l,"%s",buffer[2]);
}
stock int WaterCheck(int client)
{
	return GetEntProp(client, Prop_Data, "m_nWaterLevel");
}
stock void ShowMotdToClient(int client, const char[] url)
{
  ShowMOTDPanel(client, "www.GameSites.cz", url, MOTDPANEL_TYPE_URL);
}
stock void Client_LoadSettings(int client)
{
  char buffer[3];
  for(int i; i < Settings_Count; i++)
  {
    GetClientCookie(client, h_Settigs[i], buffer, sizeof(buffer));
    if(StrEqual(buffer, "") == false)
    {
      i_Settings[client][i] = StringToInt(buffer);
    }
    else
    {
      i_Settings[client][i] = 0;
    }
  }
}
stock void Client_SaveSettings(int client)
{
  char buffer[3];
  for(int i; i < Settings_Count; i++)
  {
    IntToString(i_Settings[client][i], buffer, sizeof(buffer));
    SetClientCookie(client, h_Settigs[i], buffer);
  }
}
stock void StripAllWeapons(int client)
{
	int ent;
	for (int i = 0; i <= 4; i++)
	{
    while ((ent = GetPlayerWeaponSlot(client, i)) != -1)
    {
			RemovePlayerItem(client, ent);
			RemoveEdict(ent);
    }
	}
}
stock void StripWeapons(int client)
{
	int wepIdx;
	for (int x = 0; x <= 5; x++)
	{
		if (x != 2 && (wepIdx = GetPlayerWeaponSlot(client, x)) != -1)
		{
			RemovePlayerItem(client, wepIdx);
			RemoveEdict(wepIdx);
		}
	}
}
stock void CreateMissile(int client)
{
  int ent = CreateEntityByName("smokegrenade_projectile");
  DispatchSpawn(ent);
  SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", client);
  SetEntProp(ent, Prop_Send, "m_nModelIndex", iRocketIndex);
  SetEntPropFloat(ent, Prop_Data, "m_flGravity", 1.0);
  float f_VecOrg[3];
  float f_VecAng[3];
  float f_VecPos[3];
  float f_ClientVel[3]
  float f_VecVel[3];
  GetClientEyePosition(client, f_VecOrg);
  GetClientEyeAngles(client, f_VecAng);
  GetAngleVectors(f_VecAng, f_VecPos, NULL_VECTOR, NULL_VECTOR);
  ScaleVector(f_VecPos, 15.0);
  AddVectors(f_VecPos, f_VecOrg, f_VecPos);
  GetEntPropVector(client, Prop_Data, "m_vecVelocity", f_ClientVel);
  GetAngleVectors(f_VecAng, f_VecVel, NULL_VECTOR, NULL_VECTOR);
  ScaleVector(f_VecVel, 2250.0);
  AddVectors(f_VecVel, f_ClientVel, f_VecVel);
  SetEntProp(ent, Prop_Data, "m_nNextThinkTick", -1);
  AttachSmoke(ent);
  TeleportEntity(ent, f_VecPos, f_VecAng, f_VecVel);
  SDKHook(ent, SDKHook_StartTouch, SDKHook_OnStartTouch_FireSupportMissile);
}
stock void MissileExplode(int client, int entity)
{
  float f_MissilePos[3];
  float f_ClientPos[3];
  GetEntPropVector(entity, Prop_Send, "m_vecOrigin", f_MissilePos);
  TE_SetupExplosion(f_MissilePos, i_ExplosionIndex, 5.0, 1, 0, 50, 40, view_as<float>({0.0, 0.0, 1.0}));
  TE_SendToAll();
  TE_SetupSmoke(f_MissilePos, i_SmokeIndex, 10.0, 3);
  TE_SendToAll();
  LoopAliveClients(i)
  {
    GetEntPropVector(i, Prop_Send, "m_vecOrigin", f_ClientPos);
    if(GetVectorDistance(f_MissilePos, f_ClientPos) < 200)
    {
      SDKHooks_TakeDamage(i, 0, client, 50.0);
    }
  }
  char buffer[64];
  Format(buffer, sizeof(buffer), "weapons/hegrenade/explode%i.wav", GetRandomInt(3, 5));
  //EmitSoundToAllAny(buffer, entity, _, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.7);
}
stock void ThrowKnife(int client)
{
  float f_VecOrg[3];
  float f_VecAng[3];
  float f_Spin[] = {4000.0, 0.0, 0.0};
  float f_VecPos[3];
  float f_ClientVel[3]
  float f_VecVel[3];
  int iTeam = GetClientTeam(client);

  int ent = CreateEntityByName("smokegrenade_projectile");
  DispatchSpawn(ent)

  SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", client);
  SetEntPropEnt(ent, Prop_Send, "m_hThrower", client);
  SetEntProp(ent, Prop_Send, "m_iTeamNum", iTeam);

  char sModel[PLATFORM_MAX_PATH];
  Format(sModel, sizeof(sModel), "%s", iTeam == CS_TEAM_T ? "models/weapons/w_knife_default_t_dropped.mdl":"models/weapons/w_knife_default_ct_dropped.mdl");
  SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel(sModel));

  SetEntPropFloat(ent, Prop_Send, "m_flModelScale", 1.0);
  SetEntPropFloat(ent, Prop_Send, "m_flElasticity", 0.2);
  SetEntPropFloat(ent, Prop_Data, "m_flGravity", 1.0);

  GetClientEyePosition(client, f_VecOrg);
  GetClientEyeAngles(client, f_VecAng);

  GetAngleVectors(f_VecAng, f_VecPos, NULL_VECTOR, NULL_VECTOR);
  ScaleVector(f_VecPos, 15.0);
  AddVectors(f_VecPos, f_VecOrg, f_VecPos);
  GetEntPropVector(client, Prop_Data, "m_vecVelocity", f_ClientVel);
  GetAngleVectors(f_VecAng, f_VecVel, NULL_VECTOR, NULL_VECTOR);
  ScaleVector(f_VecVel, 2250.0);
  AddVectors(f_VecVel, f_ClientVel, f_VecVel);
  SetEntPropVector(ent, Prop_Data, "m_vecAngVelocity", f_Spin);
  SetEntProp(ent, Prop_Data, "m_nNextThinkTick", -1);
  TeleportEntity(ent, f_VecPos, f_VecAng, f_VecVel);

  SDKHook(ent, SDKHook_StartTouch, SDKHook_OnStartTouch_GhostKnife);
}
stock void WipeHandle(Handle &handle)
{
  if(handle != null)
  {
    CloseHandle(handle);
    handle = null;
  }
}
stock void DynamiteExplode(int client)
{
  float f_ClientPos[3];
  float f_IPos[3];
  GetEntPropVector(client, Prop_Send, "m_vecOrigin", f_ClientPos);
  TE_SetupExplosion(f_ClientPos, i_ExplosionIndex, 5.0, 1, 0, 50, 40, view_as<float>({0.0, 0.0, 1.0}));
  TE_SendToAll();
  TE_SetupSmoke(f_ClientPos, i_SmokeIndex, 10.0, 3);
  TE_SendToAll();
  char buffer[64];
  Format(buffer, sizeof(buffer), "weapons/hegrenade/explode%i.wav", GetRandomInt(3, 5));
  //EmitSoundToAllAny(buffer, client, _, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.7);
  LoopAliveClients(i)
  {
    if(i != client)
    {
      GetEntPropVector(i, Prop_Send, "m_vecOrigin", f_IPos);
      if(GetVectorDistance(f_IPos, f_ClientPos) < 430.0)
      {
        Client_TakeDamage(i, client, 90, DMG_BLAST, "weapon_hegrenade");
      }
    }
  }
}
stock void CreateMine(int client)
{
  float f_ClientPos[3];
  GetEntPropVector(client, Prop_Send, "m_vecOrigin", f_ClientPos);
  int mina = CreateEntityByName("prop_dynamic_override");
  DispatchKeyValue(mina, "model", MINA_MODEL);
  SetEntProp(mina, Prop_Send, "m_usSolidFlags", 12);
  SetEntProp(mina, Prop_Data, "m_nSolidType", 6);
  SetEntProp(mina, Prop_Send, "m_CollisionGroup", 1);
  SetEntPropEnt(mina, Prop_Send, "m_hOwnerEntity", client);
  DispatchSpawn(mina);
  SetEntityRenderMode(mina, RENDER_TRANSCOLOR);
  SetEntityRenderColor(mina, 255,255,255,20);
  TeleportEntity(mina, f_ClientPos, NULL_VECTOR, NULL_VECTOR);
  SDKHook(mina, SDKHook_StartTouch, SDKHook_OnStartTouch_SapperMina);
}
stock void PoisionBullet(int client, int victim)
{
  DataPack datapack = new DataPack();
  datapack.WriteCell(GetClientUserId(client));
  datapack.WriteCell(GetClientUserId(victim));
  CreateTimer(2.0, Timer_PoisionBullet, datapack, TIMER_FLAG_NO_MAPCHANGE);
}
stock void AttachSmoke(int ent)
{
  float f_VecPos[3];
  GetEntPropVector(ent, Prop_Send, "m_vecOrigin", f_VecPos);
  int index = CreateEntityByName("env_rockettrail");
  if (index != -1)
  {
    SetEntPropFloat(index, Prop_Send, "m_Opacity", 0.5);
    SetEntPropFloat(index, Prop_Send, "m_SpawnRate", 100.0);
    SetEntPropFloat(index, Prop_Send, "m_ParticleLifetime", 0.3);
    SetEntPropVector(index, Prop_Send, "m_StartColor", view_as<float>({0.5, 0.5, 0.5}));
    SetEntPropFloat(index, Prop_Send, "m_StartSize", 3.0);
    SetEntPropFloat(index, Prop_Send, "m_EndSize", 15.0);
    SetEntPropFloat(index, Prop_Send, "m_SpawnRadius", 0.0);
    SetEntPropFloat(index, Prop_Send, "m_MinSpeed", 0.0);
    SetEntPropFloat(index, Prop_Send, "m_MaxSpeed", 100.0);
    SetEntPropFloat(index, Prop_Send, "m_flFlareScale", 1.0);
    DispatchSpawn(index);
    ActivateEntity(index);

    SetVariantString("!activator");
    AcceptEntityInput(index, "SetParent", ent);
    SetVariantString("trail");
    AcceptEntityInput(index, "SetParentAttachment");
    TeleportEntity(index, f_VecPos, NULL_VECTOR, NULL_VECTOR);
	}
}
stock float Client_ItemChance(int client)
{
  float chance;
  if(IsClientVIP(client, g_AccType[ACC_EVIP]))
  {
    chance = 70.0;
  }
  else if(IsClientVIP(client, g_AccType[ACC_VIP]))
  {
    chance = 50.0;
  }
  else
  {
    chance = 30.0;
  }
  return chance
}
stock float Client_ItemTime(int client)
{
  float time;
  if(IsClientVIP(client, g_AccType[ACC_EVIP]))
  {
    time = 180.0;
  }
  else if(IsClientVIP(client, g_AccType[ACC_VIP]))
  {
    time = 120.0;
  }
  else
  {
    time = 60.0;
  }
  return time
}
stock void Client_RemoveItemEffect(int client)
{
  switch(i_gCurrentItem[client])
  {
    case Item_DoubleVesta:
    {
      SetEntProp(client, Prop_Send, "m_ArmorValue", i_ClientClassArmor[client] + i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength]);
    }
    case Item_NinjaCloak:
    {
      SetEntityRenderColor(client);
    }
    case Item_NasaVesta:
    {
      SetEntProp(client, Prop_Send, "m_ArmorValue", i_ClientClassArmor[client] + i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength]);
    }
    case Item_AntiGravity:
    {
      SetEntityGravity(client, 1.0);
    }
  }
}
stock void Client_CreateItemEffect(int client)
{
  switch(i_gCurrentItem[client])
  {
    case Item_DoubleVesta:
    {
      SetEntProp(client, Prop_Send, "m_ArmorValue", (i_ClientClassArmor[client] + i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength])*2);
    }
    case Item_NinjaCloak:
    {
      SetEntityRenderColor(client, 255, 255, 255, 100);
    }
    case Item_NasaVesta:
    {
      SetEntProp(client, Prop_Send, "m_ArmorValue", 250);
    }
    case Item_GhostHelm:
    {
      i_GhostHelpCount[client] = 3;
    }
    case Item_CptBook:
    {
      i_CptBookCount[client] = 3;
    }
  }
}
stock int GetClientClassWeapons(int client)
{
  switch(i_gCurrentClass[client])
  {
    case Class_Sniper: return sizeof(iClassWeapons_Sniper)+1;
    case Class_Rusher: return sizeof(iClassWeapons_Rusher)+1;
    case Class_Sharpshooter: return sizeof(iClassWeapons_Sharpshooter)+1;
    case Class_Protector: return sizeof(iClassWeapons_Protector)+1;
    case Class_Makarov: return sizeof(iClassWeapons_Makarov)+1;
    case Class_FireSupport: return sizeof(iClassWeapons_FireSupport)+1;
    case Class_Demolitions: return sizeof(iClassWeapons_Demolitions)+1;
    case Class_CptSoap: return sizeof(iClassWeapons_CptSoap)+1;
    case Class_Ghost: return sizeof(iClassWeapons_Ghost)+1;
    case Class_Sapper: return sizeof(iClassWeapons_Sapper)+1;
    case Class_Commando: return sizeof(iClassWeapons_Commando)+1;
    case Class_Rambo: return sizeof(iClassWeapons_Rambo)+1;
    case Class_CptPrice: return sizeof(iClassWeapons_CptPrice)+1;
    case Class_Engineer: return sizeof(iClassWeapons_Engineer)+1;
  }
  return 0;
}
stock void GiveRandomItem(int client)
{
  int iItem = GetRandomInt(1, view_as<int>(Item_Count)-1);
  i_gCurrentItem[client] = view_as<Item>(iItem);
  f_ClientItemStart[client] = GetGameTime();
  Client_CreateItemEffect(client);
}
stock bool IsClientShootingEnemyBack(int client, int target)
{
  #define min(%1,%2) (%1 < %2 ? %1 : %2)
  #define max(%1,%2) (%1 > %2 ? %1 : %2)
  float angAbsRotation1[3];
  float angAbsRotation2[3];
  GetEntPropVector(client, Prop_Data, "m_angRotation", angAbsRotation2);
  GetEntPropVector(target, Prop_Data, "m_angRotation", angAbsRotation1);
  float ang = max(angAbsRotation1[1], angAbsRotation2[1]) - min(angAbsRotation1[1], angAbsRotation2[1])
  if(ang > 180.0)
  {
    ang = 360.0 - ang;
  }
  if(ang < 55)
  {
    return true;
  }
  return false;
}
stock void PrecacheAndDownloadSounds()
{
  for(int i = 1; i <= 13; i++)
  {
    char buffer[64];
    Format(buffer, sizeof(buffer), "sound/gamesites/gs_callofduty/%in.mp3", i);
    AddFileToDownloadsTable(buffer);
    ReplaceString(buffer, sizeof(buffer), "sound/", "");
    PrecacheSoundAny(buffer);
  }
  for(int i = 1; i <= 11; i++)
  {
    char buffer[64];
    Format(buffer, sizeof(buffer), "sound/gamesites/gs_callofduty/rad%i.mp3", i);
    AddFileToDownloadsTable(buffer);
    ReplaceString(buffer, sizeof(buffer), "sound/", "");
    PrecacheSoundAny(buffer);
  }
  for(int i = 1; i <= 6; i++)
  {
    char buffer[64];
    Format(buffer, sizeof(buffer), "sound/gamesites/gs_callofduty/cttt%i.mp3", i);
    AddFileToDownloadsTable(buffer);
    ReplaceString(buffer, sizeof(buffer), "sound/", "");
    PrecacheSoundAny(buffer);
  }
  for(int i = 1; i <= 5; i++)
  {
    char buffer[64];
    Format(buffer, sizeof(buffer), "sound/gamesites/gs_callofduty/ttt%i.mp3", i);
    AddFileToDownloadsTable(buffer);
    ReplaceString(buffer, sizeof(buffer), "sound/", "");
    PrecacheSoundAny(buffer);
  }
}

stock void Client_TakeDamage(int victim,int attacker, int damage,int dmg_type = DMG_GENERIC, const char[] weapon)
{
  if(IsValidClient(victim) && IsValidClient(attacker))
  {
    char sDamage[16];
    char sDamageType[32];
    IntToString(damage, sDamage, sizeof(sDamage));
    IntToString(dmg_type, sDamageType, sizeof(sDamageType));
    int index = CreateEntityByName("point_hurt");
    if(index)
    {
      DispatchKeyValue(victim,"targetname","cod_hurtme");
      DispatchKeyValue(index,"DamageTarget","cod_hurtme");
      DispatchKeyValue(index,"Damage", sDamage);
      DispatchKeyValue(index,"DamageType",sDamageType);
      DispatchKeyValue(index,"classname",weapon);
      DispatchSpawn(index);
      AcceptEntityInput(index,"Hurt", attacker);
      DispatchKeyValue(index,"classname","point_hurt");
      DispatchKeyValue(victim,"targetname","cod_donthurtme");
      RemoveEdict(index);
    }
  }
}
