class Tags
{
    // Lobby 0 --> 299 >>       
    public static readonly ushort PlayerConnected = 0;
    public static readonly ushort Ping = 2;
    public static readonly ushort SendAllRooms = 5;
    public static readonly ushort CreateRoom = 10;
    public static readonly ushort DeleteRoom = 20;
    public static readonly ushort JoinRoom = 30;
    public static readonly ushort SwapHostRoom = 35;
    public static readonly ushort PlayerJoinedRoom = 40;
    public static readonly ushort PlayerQuitRoom = 45;
    public static readonly ushort QuitRoom = 50;
    public static readonly ushort StartGame = 80;
    public static readonly ushort LobbyStartGame = 90;
    public static readonly ushort QuitGame = 100;
    public static readonly ushort ChangeName = 110;
    public static readonly ushort ChangeTeam = 120;
    public static readonly ushort SetReady = 130;
    public static readonly ushort SetCharacter = 140;
    public static readonly ushort AskForCharacterSwap = 145;
    public static readonly ushort CharacterSwap = 146;
    public static readonly ushort RefuseCharacterSwap = 147;
    public static readonly ushort NewChatMessage = 160;
    // <<

    // InGame 300 --> XXXX >>   
    public static readonly ushort PlayerJoinGameScene = 300;
    public static readonly ushort AllPlayerJoinGameScene = 301;
    public static readonly ushort SetInGameUniqueID = 302;
    public static readonly ushort StartTimer = 305;
    public static readonly ushort StopGame = 310;
    public static readonly ushort AskForStopGame = 311;
    public static readonly ushort NewRound = 315;
    public static readonly ushort InstantiateObject = 500;
    public static readonly ushort SynchroniseObject = 510;
    public static readonly ushort DestroyObject = 515;
    public static readonly ushort Damages = 520;
    public static readonly ushort Heal = 522;
    public static readonly ushort AddPoints = 550;
    public static readonly ushort KillCharacter = 560;
    public static readonly ushort AddUltimatePoint = 600;
    public static readonly ushort AddUltimatePointToAllTeam = 601;

    //Anim 750 --> 769 >>
    public static readonly ushort SyncTrigger = 750;
    public static readonly ushort SyncBoolean = 754;
    public static readonly ushort SyncFloat = 756;
    public static readonly ushort SyncInt = 757;
    // <<

    //Interactible 770 --> 789 >>
    public static readonly ushort UnlockInteractible = 770;
    public static readonly ushort UnlockAllInteractibleOfType = 771;
    public static readonly ushort TryCaptureInteractible = 772;
    public static readonly ushort QuitInteractibleZone = 773;
    public static readonly ushort CaptureProgressInteractible = 774;
    public static readonly ushort StopCaptureInteractible = 775;
    public static readonly ushort CaptureInteractible = 776;
    public static readonly ushort PauseInteractible = 777;
    public static readonly ushort FrogTimerElapsed = 778;
    public static readonly ushort VisionTowerTimerElapsed = 779;
    public static readonly ushort HealthPackTimerElapsed = 780;
    public static readonly ushort ResurectPlayer = 783;
    public static readonly ushort BrumeSoulSpawnCall = 785;
    public static readonly ushort BrumeSoulPicked = 786;
    // <<

    //Ward & Vision 790 --> 799 >>
    public static readonly ushort LaunchWard = 790;
    public static readonly ushort StartWardLifeTime = 791;
    public static readonly ushort ChangeFowSize = 792;
    public static readonly ushort ForceFowSize = 793;
    // <<

    //Altar Buff 800 --> 810 >>
    public static readonly ushort AltarTrailDebuff = 800;
    public static readonly ushort AltarSpeedBuff = 802;
    public static readonly ushort AltarPoisonBuff = 804;
    public static readonly ushort AltarOutlineBuff = 806;
    // <<

    //Spells 810 --> XXX >>
    public static readonly ushort CurveSpellLaunch = 900;
    public static readonly ushort CurveSpellLanded = 901;

    //<<

    public static readonly ushort SpawnObjPlayer = 1000;
    public static readonly ushort MovePlayerTag = 1010;
    public static readonly ushort SupprObjPlayer = 1020;

    //CHARA STATE AND EFFECTS
    public static readonly ushort StateUpdate = 2570;
    public static readonly ushort AddForcedMovement = 2580;
    public static readonly ushort AddStatus = 2590;
    // <<

    //SPELLS CHARACTER
    public static readonly ushort LaunchSplouch = 2600;
    // <<

    //Audio
    public static readonly ushort Play2DSound = 3000;
    public static readonly ushort Play3DSound = 3001;
    // <<

    //Fx
    public static readonly ushort SpawnGenericFx = 4000;
    public static readonly ushort SpawnAOEFx = 4001;
    // <<
}
