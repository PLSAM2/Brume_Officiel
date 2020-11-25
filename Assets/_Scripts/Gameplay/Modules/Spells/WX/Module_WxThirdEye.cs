using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxThirdEye : SpellModule
{
    [SerializeField] GameObject thirdEyeShockWavePrefab;
    Transform shockWave;

    [SerializeField] float fowRaduis = 4;

    [SerializeField] float cursedDuration = 3;

    bool inEchoMode = false;
    public float echoRange = 8;
    public float echoDuration = 10;

    public float waveRange = 15;
    public float waveDuration = 0.3f;
    float currentWaveTime = 0;
    public AnimationCurve waveCurve;

    [SerializeField] AudioClip waveAudio;

    [SerializeField] shockWaveState shockWaveStatut = shockWaveState.hide;

    List<LocalPlayer> pingedPlayer = new List<LocalPlayer>();

    bool isSpelling = false;

    LocalPlayer myLocalPlayer;

    private void Start()
    {
        myLocalPlayer = GameManager.Instance.GetLocalPlayerObj();
    }

    private void OnEnable()
    {
        GameManager.Instance.OnTowerTeamCaptured += OnTowerCaptured;
        GameManager.Instance.OnWardTeamSpawn += OnWardSpawn;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnTowerTeamCaptured -= OnTowerCaptured;
        GameManager.Instance.OnWardTeamSpawn += OnWardSpawn;
    }

    void OnTowerCaptured(VisionTower _tower)
    {
        if (isSpelling)
        {
            _tower.vision.gameObject.SetActive(false);
        }
    }

    void OnWardSpawn(Ward _ward)
    {
        if (isSpelling)
        {
            _ward.GetFow().gameObject.SetActive(false);
        }
    }

    protected override void ResolveSpell(Vector3 _mousePosition)
    {
        base.ResolveSpell(_mousePosition);
        GetComponent<PlayerModule>().firstSpellInput += OnCancelSpell;

        StartWave();
    }

    void OnCancelSpell(Vector3 mousePos)
    {
        StopAllCoroutines();

        foreach (LocalPlayer p in pingedPlayer)
        {
            p.forceOutline = false;
        }
        OnEndEcho();
    }

    void StartWave()
    {
        isSpelling = true;
        myLocalPlayer.myPlayerModule.isThirdEyes = true;

        if (!shockWave)
        {
            shockWave = Instantiate(thirdEyeShockWavePrefab, transform).transform;
            shockWave.transform.localPosition = Vector3.zero;
        }

        currentWaveTime = 0;
        shockWaveStatut = shockWaveState.open;

        shockWave.transform.localPosition = Vector3.zero;
        shockWave.transform.localScale = Vector3.zero;
        shockWave.gameObject.SetActive(true);

        AudioManager.Instance.Play3DAudio(waveAudio, transform.position);

        GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", true);

        HideShowAllFow(false);

        //network FX
        GameObject newFx = NetworkObjectsManager.Instance.NetworkInstantiate(1000, transform.position, Vector3.zero);
        newFx.SetActive(false);

    }

    void HideShowAllFow(bool _value)
    {
        //ward
        foreach (Ward ward in GameManager.Instance.allWard)
        {
            if (ward == null) { continue; }

            if (_value)
            {
                bool fogValue = false;
                if (GameFactory.PlayerWardAreOnSameBrume(myLocalPlayer.myPlayerModule, ward))
                {
                    fogValue = true;
                }
                else
                {
                    if (myLocalPlayer.myPlayerModule.isInBrume)
                    {
                        fogValue = false;
                    }
                    else
                    {
                        fogValue = true;
                    }
                }
                ward.GetFow().gameObject.SetActive(fogValue);
            }
            else
            {
                ward.GetFow().gameObject.SetActive(false);
            }
        }

        //tower
        foreach (VisionTower tower in GameManager.Instance.allTower)
        {
            if (tower == null) { continue; }

            if (_value)
            {
                if (myLocalPlayer.myPlayerModule.isInBrume)
                {
                    tower.vision.gameObject.SetActive(false);
                }
                else
                {
                    tower.vision.gameObject.SetActive(true);
                }
            }
            else
            {
                tower.vision.gameObject.SetActive(false);
            }
        }

        foreach(KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (player.Value == myLocalPlayer)
                continue;

            if(player.Value.myPlayerModule.teamIndex == RoomManager.Instance.GetLocalPlayer().playerTeam)
            {
                if (_value)
                {
                    player.Value.ResetFowRaduis();
                }
                else
                {
                    player.Value.SetFowRaduis(0);
                }
            }
        }
    }

    private void Update()
    {
        if (!isSpelling)
            return;

        if (shockWaveStatut == shockWaveState.open)
        {
            currentWaveTime += Time.deltaTime;
            float size = Mathf.Lerp(0, waveRange, waveCurve.Evaluate(currentWaveTime / waveDuration));
            shockWave.transform.localScale = new Vector3(size, size, size);

            if (currentWaveTime >= waveDuration)
            {
                shockWaveStatut = shockWaveState.hide;
                shockWave.gameObject.SetActive(false);
                OnShockWaveFinish();
            }
        }

        if (inEchoMode)
        {
            foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
            {
                if (player.Value == GameManager.Instance.GetLocalPlayerObj()) { continue; }

                player.Value.myPlayerModule.cursedByShili = (Vector3.Distance(transform.position, player.Value.transform.position) <= echoRange);
            }
        }
        else
        {
            foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
            {
                if (player.Value == GameManager.Instance.GetLocalPlayerObj()) { continue; }

                player.Value.myPlayerModule.cursedByShili = false;
            }
        }

        if (shockWaveStatut == shockWaveState.close)
        {
            currentWaveTime += Time.deltaTime;
            float size = Mathf.Lerp(waveRange, 0, waveCurve.Evaluate(currentWaveTime / waveDuration));
            shockWave.transform.localScale = new Vector3(size, size, size);

            if (currentWaveTime >= waveDuration)
            {
                shockWaveStatut = shockWaveState.hide;
                shockWave.gameObject.SetActive(false);
                isSpelling = false;
            }
        }
    }

    void OnShockWaveFinish()
    {
        GameManager.Instance.GetLocalPlayerObj().SetFowRaduis(fowRaduis);
        FindAllPlayerInRange();
    }

    void FindAllPlayerInRange()
    {
        pingedPlayer.Clear();

        foreach (LocalPlayer player in GameFactory.GetPlayerInRange(waveRange, transform.position))
        {
            player.forceOutline = true;
            pingedPlayer.Add(player);
        }

        StartCoroutine("WaitToHideOutline");
    }

    IEnumerator WaitToHideOutline()
    {
        yield return new WaitForSeconds(cursedDuration);

        SetInEchoMode();
    }

    void SetInEchoMode()
    {
        inEchoMode = true;

        StartCoroutine("WaitToHideEcho");

        foreach (LocalPlayer p in pingedPlayer)
        {
            p.forceOutline = false;
        }
    }

    IEnumerator WaitToHideEcho()
    {
        yield return new WaitForSeconds(echoDuration);
        OnEndEcho();
    }

    void OnEndEcho()
    {
        inEchoMode = false;
        GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", false);

        currentWaveTime = 0;
        shockWaveStatut = shockWaveState.close;

        shockWave.gameObject.SetActive(true);

        print("son");
        AudioManager.Instance.Play3DAudio(waveAudio, transform.position);

        GameManager.Instance.GetLocalPlayerObj().ResetFowRaduis();
        GetComponent<PlayerModule>().firstSpellInput -= OnCancelSpell;

        myLocalPlayer.myPlayerModule.isThirdEyes = true;

        HideShowAllFow(true);

        //network FX
        GameObject newFx = NetworkObjectsManager.Instance.NetworkInstantiate(1001, transform.position, Vector3.zero);
        newFx.SetActive(false);
    }

    public enum shockWaveState
    {
        open,
        hide,
        close
    }
}
