#define CHAT_TAG "[CoD]"

#define KILLREWARD 5

#define MINA_MODEL "models/custom_props/mine/mine.mdl"
#define RAKETA_MODEL "models/custom_props/rocket/rocket.mdl"
int iRocketIndex;

Handle db = null;
char db_error[200];
char db_query[600];
int i_LevelMax = 75;
enum
{
  ACC_ZERO = 0,
  ACC_VIP,
  ACC_EVIP
};
AdminFlag g_AccType[3] = {Admin_Reservation ,Admin_Custom6, Admin_Custom5};
enum ClassAttributes
{
  Attri_Intellect,
  Attri_Life,
  Attri_Strength,
  Attri_Condition,
  Attri_Count
};

bool b_ClientVerified[MAXPLAYERS+1] = {false,...};

enum ClassType
{
  Class_None,  Class_Sniper,  Class_Rusher,  Class_Sharpshooter,  Class_Protector,  Class_Makarov,  Class_FireSupport,  Class_Demolitions,  Class_CptSoap,  Class_Ghost,  Class_Sapper,  Class_Commando,  Class_Rambo,  Class_CptPrice,  Class_Count, Class_Engineer
};
char ClassNames[][] =
{
  "Žádná",  "Sniper",  "Rusher",  "Sharpshooter",  "Protector",  "Makarov",  "Fire Support",  "Demolition",  "Cpt.Soap",  "Ghost",  "Sapper",  "Commando",  "Rambo",  "Cpt.Price",  "Engineer"
};
int ClassVIP[] =
{
  //0,0,0,0,0,0,0,0,0,0,1,1,2,2,2
  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};
enum Item
{
  Item_None,  Item_Boty,  Item_DoubleVesta,  Item_SpecialVesta,  Item_VeteranKnife,  Item_ShockEnemy,  Item_NinjaCloak,  Item_Morfin,  Item_UltraKnife,  Item_DeagleMaster,  Item_BigGrenade,  Item_NinjaStep,  Item_SecretMil,
  Item_AwpSniper,  Item_Adrenalin,  Item_Chuck,  Item_XPMaster,  Item_NasaVesta,  Item_Veteran,  Item_PrvniPomoc,  Item_TitanBox,  Item_PlukSwitch,  Item_Nanosuit,  Item_Recruit,
  Item_ReflectArm,  Item_CptBook,  Item_FlyModul,  Item_AntiGravity,  Item_Klobouk,  Item_BunnyHoper, Item_M4Style,  Item_GhostHelm,  Item_Count
};
char ItemNames[][] =
{
  "Žádný",  "Boty",  "2x Vesta",  "Speciální vesta",  "Veteran Knife",  "Shock enemy",  "Ninja Cloak",  "Morfin",  "Ultra knife",  "Deagle master",  "Big Grenade",  "Ninja step",  "Secret Mil",  "AWP Sniper",  "Adrenalin",  "Chuck",  "XP Master",
  "NASA Vesta",  "Veteran",  "První pomoc",  "Titan box",  "Pluk switch", "Nanosuit",  "Recruit",  "Reflect Arm",  "Cpt.Book",  "Fly modul",  "AntiGravity",  "Klobouk",  "BunnyHoper", "M4 Style",  "Ghost Helm"
};
ClassType i_gCurrentClass[MAXPLAYERS+1] = Class_None;
ClassType i_gChangeClassTo[MAXPLAYERS+1] = Class_None;
int i_gClientClassLvl[MAXPLAYERS+1][ClassType];
int i_gClientClassExp[MAXPLAYERS+1][ClassType];
int i_gClientClassAttributes[MAXPLAYERS+1][ClassType][ClassAttributes];
int i_gClientClassAttributesPoints[MAXPLAYERS+1][ClassType];
Item i_gCurrentItem[MAXPLAYERS+1] = Item_None;

int	i_dJjCount[MAXPLAYERS+1];
int	i_dJlButtons[MAXPLAYERS+1];
int	i_dJlFlags[MAXPLAYERS+1];
int iClassWeapons[view_as<int>(Class_Count)][10] =
{
  {0, 0},
  {9, 1},
  {25, 43},
  {7},
  {14, 43, 44, 45, 46},
  {19, 1},
  {24},
  {8, 43, 44, 45, 46},
  {2, 44},
  {10, 43},
  {13, 44},
  {1, 43, 44},
  {10},
  {16, 1, 44, 43}
  //{17, 1, 44}
};

char ClassEquip_Sniper[][] = {"weapon_awp", "weapon_deagle"};
char ClassEquip_Rusher[][] = {"weapon_xm1014", "weapon_flashbang", "weapon_flashbang"};
char ClassEquip_Sharpshooter[][] = {"weapon_ak47"};
char ClassEquip_Protector[][] = {"weapon_m249", "weapon_flashbang", "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade", "weapon_molotov"};
char ClassEquip_Makarov[][] = {"weapon_p90", "weapon_deagle"};
char ClassEquip_Firesupport[][] = {"weapon_ump45"};
char ClassEquip_Demolitions[][] = {"weapon_aug", "weapon_flashbang", "weapon_flashbang", "weapon_hegrenade", "weapon_smokegrenade", "weapon_molotov"};
char ClassEquip_CptSoap[][] = {"weapon_elite", "weapon_hegrenade"};
char ClassEquip_Ghost[][] = {"weapon_famas", "weapon_flashbang"};
char ClassEquip_Sapper[][] = {"weapon_galilar", "weapon_hegrenade"};
char ClassEquip_Commando[][] = {"weapon_deagle", "weapon_hegrenade", "weapon_flashbang", "weapon_flashbang"};
char ClassEquip_Rambo[][] = {"weapon_famas"};
char ClassEquip_CptPrice[][] = {"weapon_m4a1", "weapon_deagle", "weapon_hegrenade", "weapon_flashbang"};
char ClassEquip_Engineer[][] = {"weapon_mac10", "weapon_deagle", "weapon_hegrenade"};

int iClassWeapons_Sniper[2];
int iClassWeapons_Rusher[2];
int iClassWeapons_Sharpshooter[1];
int iClassWeapons_Protector[5];
int iClassWeapons_Makarov[2];
int iClassWeapons_FireSupport[1];
int iClassWeapons_Demolitions[5];
int iClassWeapons_CptSoap[2];
int iClassWeapons_Ghost[2];
int iClassWeapons_Sapper[2];
int iClassWeapons_Commando[3];
int iClassWeapons_Rambo[1];
int iClassWeapons_CptPrice[4];
int iClassWeapons_Engineer[3];

#define MAX_BUTTONS 25
int g_cLastButtons[MAXPLAYERS+1];
int i_ClientClassHealth[MAXPLAYERS+1];
int i_ClientClassArmor[MAXPLAYERS+1];

enum
{
  Settings_FastMenu,
  Settings_Music,
  Settings_Hud,
  Settings_Count
};
Handle h_Settigs[Settings_Count];
int i_Settings[MAXPLAYERS+1][Settings_Count];

char ClassInfo[][] =
{
  "Sniper: Ziskas AWP, Deagle & Scout, 90hp a 50armor 50% sance na okamzite zabiti nozem, vetsi dmg u sniperky, 110 Speed",
  "Rusher: Ziskas XM1014 + M3, 10% sance na oslepeni neprtiele po zasahu, 2x flash, 120 hp, 145 Speed, Nizka gravitace",
  "Sharpshooter: Ziskas AK47, M4A1 & 140hp. 90 Speed, 100 Armor, 10% sance na kriticky zasah (2xdmg)",
  "Protector: Ziskas M249, 200hp & vsechny granaty, imunnita proti minam Sappera, 200 Armor, pomalejsi beh",
  "Makarov: Ziskas P90, Deagle, 140hp, 10% sance na poison zasah (jedovate naboje), 100 Armor, 110 speed",
  "Fire Support: Ziskas MP5, UMP, 130hp, 3 rakety, 100 speed, 100 Armor",
  "Demolitions: Ziskas AUG, 140 hp, vsechny granaty, dynamit na blizko (pouziti klavesou E), 100 Armor",
  "Cpt.Soap: Ziskas Dual guns s velkym poskozenim +50%, 140 HP, 140 Armor, HE",
  "Ghost: Ziskas Famas, Scout, Flash, muze hazet noze (pouziti klavesy E),140 HP, 100 Armor",
  "Sapper: Ziskas Galil + MP5, 120hp, HE, 3 neviditelne miny (pouziti klavesy E), 100speed, 100 Armor",
  "Commando: Ziskas Deagle, 130hp, HE, 2x Flash, zabiti na 1 hit s knife, 135 Speed, 100 Armor",
  "Rambo: Ziskas Famas, 120 hp, 120 Speed, 20 HP za kill, dvojite skakani, rychly clip, 150 Armor",
  "Cpt.Price: Ziskas M4A1, MP5, Deagle, HE, Flash, 90hp, 110 speed, Morfin (1/4 sance na respawn po zabiti), 150 Armor",
  "Engineer: Ziskas TMP, MAC, Deagle, HE, 100hp, 110 speed, Muze stavet strileci veze (pouziti klavesy E)"
}

int WeaponDefinitionID[] = {1,2,3,4,7,8,9,10,11,13,14,16,17,19,24,25,26,27,28,29,30,32,33,34,35,36,38,39,40,60,61,63,64};
int WeaponPrimaryAmmo[] = {7,30,20,20,30,30,10,25,20,35,100,30,30,50,25,7,64,5,150,7,24,13,30,30,8,13,20,30,10,20,12,12,8};
//int WeaponSecondaryAmmo[] = {35,120,100,120,90,90,30,90,90,90,200,90,100,100,100,32,120,32,200,32,120,52,120,120,32,26,90,90,90,40,24,12,8};

int g_MainClipOffset;
int i_FireSupportMissiles[MAXPLAYERS+1];
int i_ExplosionIndex;
int i_SmokeIndex;
int iBlood;

int i_GhostKnifes[MAXPLAYERS+1];
int i_DemolitionsDynamit[MAXPLAYERS+1];
int i_SapperMina[MAXPLAYERS+1];

char MinaList[][] =
{
  "models/custom_props/mine/mine.vvd",
  "models/custom_props/mine/mine.dx90.vtx",
  "models/custom_props/mine/mine.mdl",
  "models/custom_props/mine/mine.phy",
  "materials/models/custom_props/mine/combine_mine03_normal.vtf",
  "materials/models/custom_props/mine/combine_mine03.vmt",
  "materials/models/custom_props/mine/combine_mine03.vtf",
}
char RocketList[][] =
{
  "models/custom_props/rocket/rocket.mdl",
  "models/custom_props/rocket/rocket.phy",
  "models/custom_props/rocket/rocket.vvd",
  "models/custom_props/rocket/rocket.dx90.vtx",
  "materials/models/custom_props/rocket/w_rocket01.vtf",
  "materials/models/custom_props/rocket/w_rocket01.vmt"
}

int i_MakarovPoisoned[MAXPLAYERS+1];
float f_ClientItemStart[MAXPLAYERS+1];

int i_GhostHelpCount[MAXPLAYERS+1];
int i_CptBookCount[MAXPLAYERS+1];

float f_ItemModifySpeed[MAXPLAYERS+1];
bool b_NanoSuitWeared[MAXPLAYERS+1];

float f_ItemTimeLeft[MAXPLAYERS+1];
bool b_HudDisabled[MAXPLAYERS+1];

int i_RoundSound;
int i_RoundRadio;

float f_RoundStartMusic;

float f_ClientHPRegenStart[MAXPLAYERS+1];
float f_ClientHPRegenValue[MAXPLAYERS+1];

int i_ExpList[] =
{
  0,
  30,50,70,100,130,160,190,210,240,270,
  330,390,450,520,600,680,760,820,900,1000,
  1090,1180,1270,1360,1450,1540,1430,1520,1610,1700,
  2300,2350,2390,2435,2470,2500,2545,2570,2630,2700,
  2800,2900,3000,3100,3200,3300,3400,3500,3600,3700,
  3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,
  5010,5120,5230,5340,5450,5560,5670,5780,5890,6000,
  5250,6500,5750,7000,7500
};
