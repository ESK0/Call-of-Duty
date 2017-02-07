public void Class_SetUp(int client)
{
  i_ClientClassHealth[client] = 100;
  switch(i_gCurrentClass[client])
  {
    case Class_Sniper:
    {
      Class_EquipClient(client, ClassEquip_Sniper, sizeof(ClassEquip_Sniper));
      i_ClientClassHealth[client] = 90;
      i_ClientClassArmor[client] = 50;
    }
    case Class_Rusher:
    {
      Class_EquipClient(client, ClassEquip_Rusher, sizeof(ClassEquip_Rusher));
      i_ClientClassHealth[client] = 120;
      i_ClientClassArmor[client] = 0;
    }
    case Class_Sharpshooter:
    {
      Class_EquipClient(client, ClassEquip_Sharpshooter, sizeof(ClassEquip_Sharpshooter));
      i_ClientClassHealth[client] = 140;
      i_ClientClassArmor[client] = 100;
    }
    case Class_Protector:
    {
      Class_EquipClient(client, ClassEquip_Protector, sizeof(ClassEquip_Protector));
      i_ClientClassHealth[client] = 200;
      i_ClientClassArmor[client] = 200;
    }
    case Class_Makarov:
    {
      Class_EquipClient(client, ClassEquip_Makarov, sizeof(ClassEquip_Makarov));
      i_ClientClassHealth[client] = 140;
      i_ClientClassArmor[client] = 100;
    }
    case Class_FireSupport:
    {
      Class_EquipClient(client, ClassEquip_Firesupport, sizeof(ClassEquip_Firesupport));
      i_ClientClassHealth[client] = 130;
      i_ClientClassArmor[client] = 100;
      i_FireSupportMissiles[client] = 3;
    }
    case Class_Demolitions:
    {
      Class_EquipClient(client, ClassEquip_Demolitions, sizeof(ClassEquip_Demolitions));
      i_ClientClassHealth[client] = 170;
      i_ClientClassArmor[client] = 100;
      i_DemolitionsDynamit[client] = 3;
    }
    case Class_CptSoap:
    {
      Class_EquipClient(client, ClassEquip_CptSoap, sizeof(ClassEquip_CptSoap));
      i_ClientClassHealth[client] = 140;
      i_ClientClassArmor[client] = 100;
    }
    case Class_Ghost:
    {
      Class_EquipClient(client, ClassEquip_Ghost, sizeof(ClassEquip_Ghost));
      i_ClientClassHealth[client] = 140;
      i_GhostKnifes[client] = 3;
      i_ClientClassArmor[client] = 100;
    }
    case Class_Sapper:
    {
      Class_EquipClient(client, ClassEquip_Sapper, sizeof(ClassEquip_Sapper));
      i_ClientClassHealth[client] = 120;
      i_ClientClassArmor[client] = 100;
      i_SapperMina[client] = 3;
    }
    case Class_Commando:
    {
      Class_EquipClient(client, ClassEquip_Commando, sizeof(ClassEquip_Commando));
      i_ClientClassHealth[client] = 130;
      i_ClientClassArmor[client] = 100;
    }
    case Class_Rambo:
    {
      Class_EquipClient(client, ClassEquip_Rambo, sizeof(ClassEquip_Rambo));
      GivePlayerItem(client, "weapon_famas");
      i_ClientClassHealth[client] = 120;
      i_ClientClassArmor[client] = 150;
    }
    case Class_CptPrice:
    {
      Class_EquipClient(client, ClassEquip_CptPrice, sizeof(ClassEquip_CptPrice));
      i_ClientClassHealth[client] = 90;
      i_ClientClassArmor[client] = 150;
    }
    case Class_Engineer:
    {
      Class_EquipClient(client, ClassEquip_Engineer, sizeof(ClassEquip_Engineer));
      i_ClientClassHealth[client] = 110;
      i_ClientClassArmor[client] = 0;
    }
  }
  i_ClientClassHealth[client] += i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Life];
  SetEntityHealth(client, i_ClientClassHealth[client]);
  SetEntProp(client, Prop_Send, "m_ArmorValue", i_ClientClassArmor[client] + i_gClientClassAttributes[client][i_gCurrentClass[client]][Attri_Strength]);
}
