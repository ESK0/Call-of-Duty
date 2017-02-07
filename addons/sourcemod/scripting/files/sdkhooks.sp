 public void EventSDK_OnClientThink(int client)
{
	if(IsValidClient(client))
	{
		if(IsPlayerAlive(client))
		{
			if(i_gCurrentClass[client] != Class_None)
			{
				float fSpeedMultiplier = 1.0;
				switch(i_gCurrentClass[client])
				{
					case Class_Sniper:
					{
						fSpeedMultiplier += 0.2;
					}
					case Class_Rusher:
					{
						SetEntityGravity(client, 0.7);
						fSpeedMultiplier += 0.3
					}
					case Class_Sharpshooter:
					{
						fSpeedMultiplier -= 0.2
					}
					case Class_Protector:
					{
						fSpeedMultiplier -= 0.3
					}
					case Class_Ghost:
					{
						fSpeedMultiplier += 0.2;
					}
					case Class_Commando:
					{
						fSpeedMultiplier += 0.35;
					}
					case Class_Rambo:
					{
						fSpeedMultiplier += 0.2;
					}
					case Class_CptPrice:
					{
						fSpeedMultiplier += 0.1;
					}
				}
				switch(i_gCurrentItem[client])
				{
					case Item_AntiGravity:
					{
						SetEntityGravity(client, 0.5);
					}
				}
				fSpeedMultiplier += i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Condition]*0.05;
				fSpeedMultiplier -= f_ItemModifySpeed[client];
				SetEntPropFloat(client, Prop_Data, "m_flLaggedMovementValue", fSpeedMultiplier);
			}
		}
	}
}
public Action EventSDK_OnTakeDamage(int victim,int &attacker,int &inflictor, float &damage,int &damagetype,int &weapon, float damageForce[3], float damagePosition[3])
{
	char sWeaponClass[32];
	int iWeaponindex;
	if(IsValidEntity(weapon))
	{
		iWeaponindex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
		GetEntityClassname(weapon, sWeaponClass, sizeof(sWeaponClass));
	}
	f_ClientHPRegenStart[victim] = GetGameTime();
	f_ClientHPRegenValue[victim] = 4.0;
	if(IsValidClient(attacker))
	{
		if(IsValidClient(victim))
		{
			if(i_gCurrentClass[attacker] != Class_None)
			{
				if(IsPlayerAlive(attacker))
				{
					switch(i_gCurrentItem[attacker])
					{
						case Item_AwpSniper:
						{
							if(iWeaponindex == 9)
							{
								SDKHooks_TakeDamage(victim, inflictor, attacker, 500.0, damagetype, weapon, damageForce, damagePosition);
								return Plugin_Handled;
							}
						}
						case Item_UltraKnife:
						{
							if(StrEqual(sWeaponClass, "weapon_knife"))
							{
								SDKHooks_TakeDamage(victim, inflictor, attacker, 500.0, damagetype, weapon, damageForce, damagePosition);
								return Plugin_Handled;
							}
						}
						case Item_SecretMil:
						{
							if(GetRandomFloat(0.0, 100.0) < 33.3)
							{
								FakeFlashClient(victim, 255,255,255,255);
							}
						}
						case Item_BigGrenade:
						{
							if(damagetype == 64)
							{
								SDKHooks_TakeDamage(victim, inflictor, attacker, 500.0, damagetype, weapon, damageForce, damagePosition);
								return Plugin_Handled;
							}
						}
						case Item_GhostHelm:
						{
							if(damagetype & CS_DMG_HEADSHOT)
							{
								if(i_GhostHelpCount[attacker] > 0)
								{
									i_GhostHelpCount[attacker]--;
									if(i_GhostHelpCount[attacker] == 0)
									{
										i_gCurrentItem[attacker] = Item_None;
									}
									return Plugin_Handled;
								}
							}
						}
						case Item_CptBook:
						{
							if(i_CptBookCount[attacker] > 0)
							{
								i_CptBookCount[attacker]--;
								if(i_CptBookCount[attacker] == 0)
								{
									i_gCurrentItem[attacker] = Item_None;
								}
								return Plugin_Handled;
							}
						}
					}
					switch(i_gCurrentClass[attacker])
					{
						case Class_Makarov:
						{
							if(GetRandomFloat(0.0, 100.0) <= 10.0)
							{
								if(i_MakarovPoisoned[victim] == 0)
								{
									i_MakarovPoisoned[victim] = 3;
									PoisionBullet(attacker, victim);
								}
								else
								{
									i_MakarovPoisoned[victim] = 3;
								}

							}
						}
						case Class_Sniper:
						{
							if(StrEqual(sWeaponClass, "weapon_knife"))
							{
								if(GetRandomInt(0,1) == 1)
								{
									damage = 400.0;
									return Plugin_Changed;
								}
							}
							else if(iWeaponindex == 9)
							{
								damage *= 1.1;
								return Plugin_Changed;
							}
						}
						case Class_Rusher:
						{
							if(GetRandomFloat(0.0, 100.0) <= 10.0)
							{
								FakeFlashClient(victim, 255,255,255,255);
							}
						}
						case Class_Sharpshooter:
						{
							if(GetRandomFloat(0.0, 100.0) <= 10.0)
							{
								damage *= 2.0;
								return Plugin_Changed;
							}
						}
						case Class_FireSupport:
						{
							damage *= 1.1;
							return Plugin_Changed;
						}
						case Class_CptSoap:
						{
							if(iWeaponindex == 2)
							{
								damage *= 1.5;
								return Plugin_Changed;
							}
						}
						case Class_Commando:
						{
							if(StrContains(sWeaponClass, "weapon_knife") != -1)
							{
								Client_TakeDamage(victim, attacker, 500, DMG_SLASH, "weapon_knife");
								return Plugin_Handled;
							}
						}
					}

					damage += i_gClientClassAttributes[attacker][i_gCurrentClass[attacker]][Attri_Intellect]*0.5;

					switch(i_gCurrentItem[attacker])
					{
						case Item_VeteranKnife:
						{
							if(StrEqual(sWeaponClass, "weapon_knife"))
							{
								damage*= 2.0;
							}
						}
						case Item_DeagleMaster:
						{
							if(StrEqual(sWeaponClass, "weapon_knife"))
							{
								damage*= 2.0;
							}
						}
						case Item_TitanBox:
						{
							damage += 10.0;
						}
						case Item_PlukSwitch:
						{
							damage += 15.0;
						}
						case Item_ReflectArm:
						{
							if(GetRandomFloat(0.0,100.0) < 33.3)
							{
								SDKHooks_TakeDamage(attacker, inflictor, victim, damage, damagetype, weapon, damageForce, damagePosition);
								return Plugin_Handled;
							}
						}
						case Item_ShockEnemy:
						{
							if(IsClientShootingEnemyBack(attacker, victim))
							{
								damage *= 2.0;
								return Plugin_Changed;
							}
						}
					}

					switch(i_gCurrentItem[victim])
					{
						case Item_SecretMil:
						{
							damage /= 3.0;
						}
						case Item_SpecialVesta:
						{
							if(damagetype == 64)
							{
								damage *= 0.7;
							}
						}
					}
					return Plugin_Changed;
				}
			}
		}
	}
	return Plugin_Continue;
}
public void EventSDK_OnPostThinkPost(int client)
{
	if(IsValidClient(client, true))
	{
		SetEntProp(client, Prop_Send, "m_iAddonBits", 0);
	}
}
public Action SDKHook_OnStartTouch_FireSupportMissile(int entity, int client)
{
	if(IsValidEntity(entity))
  {
    int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
    if(IsValidClient(owner))
    {
			MissileExplode(owner, entity);
			AcceptEntityInput(entity, "kill");
    }
  }
}
public Action SDKHook_OnStartTouch_GhostKnife(int entity, int client)
{
	if(IsValidEntity(entity))
  {
		int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
		if(IsValidClient(owner))
		{
			if(IsValidClient(client))
			{
				if(GetClientTeam(client) != GetClientTeam(owner))
				{
					float f_VecPos[3];
					int iColor[] = {255, 0, 0, 255};
					float f_Dir[3];
					Client_TakeDamage(client, owner, 500, DMG_SLASH, "weapon_knife");
					GetEntPropVector(entity, Prop_Data, "m_vecOrigin", f_VecPos);
					TE_SetupBloodSprite(f_VecPos, f_Dir, iColor, 1, iBlood, iBlood);
					TE_SendToAll(0.0);
				}
			}
		}
		AcceptEntityInput(entity, "kill");
  }
}
public Action SDKHook_OnStartTouch_SapperMina(int entity, int client)
{
	if(IsValidEntity(entity))
  {
    int owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
    if(IsValidClient(owner))
    {
			if(IsValidClient(client))
			{
				if(GetClientTeam(client) != GetClientTeam(owner))
				{
					if(i_gCurrentClass[client] != Class_Protector)
					{
						float f_MinePos[3];
						GetEntPropVector(entity, Prop_Send, "m_vecOrigin", f_MinePos);
						TE_SetupExplosion(f_MinePos, i_ExplosionIndex, 5.0, 1, 0, 50, 40, view_as<float>({0.0, 0.0, 1.0}));
						TE_SendToAll();
						TE_SetupSmoke(f_MinePos, i_SmokeIndex, 10.0, 3);
						TE_SendToAll();
						char buffer[64];
						Format(buffer, sizeof(buffer), "weapons/hegrenade/explode%i.wav", GetRandomInt(3, 5));
						//EmitSoundToAllAny(buffer, entity, _, SNDLEVEL_NORMAL, SND_NOFLAGS, 0.7);
						Client_TakeDamage(client, owner, 500, DMG_BLAST, "weapon_hegrenade");
						AcceptEntityInput(entity, "kill");
					}
				}
			}
    }
  }
}
public Action EventSDK_OnWeaponCanUse(int client, int weapon)
{
	if(IsValidEntity(weapon))
	{
		int iWeaponIndex;
		char sWeaponClassname[64];
		GetEntityClassname(weapon, sWeaponClassname, sizeof(sWeaponClassname));
		if(IsValidClient(client, true))
		{
			iWeaponIndex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
			if(StrContains(sWeaponClassname, "weapon_knife") != -1)
			{
				return Plugin_Continue;
			}
			if(i_gCurrentClass[client] != Class_None)
			{
				int len = GetClientClassWeapons(client);
				for(int i; i < len; i++)
				{
					if(iWeaponIndex == iClassWeapons[i_gCurrentClass[client]][i])
					{
						return Plugin_Continue;
					}
				}
				if(i_gCurrentItem[client] == Item_M4Style)
				{
					if(iWeaponIndex == 16)
					{
						return Plugin_Continue;
					}
				}
				if(GetClientTeam(client) == CS_TEAM_T)
				{
					if(iWeaponIndex == 49)
					{
						return Plugin_Continue;
					}
				}
			}
			else
			{
        if(IsFakeClient(client))
        {
          return Plugin_Continue;
        }
        return Plugin_Handled;
			}
		}
	}
	return Plugin_Handled;
}
public Action EventSDK_SetTransmit(int entity, int client)
{
	if(IsValidClient(entity) && IsValidEntity(client))
	{
		if (client != entity && b_NanoSuitWeared[entity] == true)
		{
			if(IsPlayerAlive(client))
			{
				return Plugin_Handled;
			}
			else
			{
				int iSpecTarget = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");
				if(iSpecTarget == entity)
				{
					return Plugin_Continue;
				}
				else
				{
					return Plugin_Handled;
				}
			}
		}
	}
	return Plugin_Continue;
}
