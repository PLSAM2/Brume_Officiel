using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxThirdEye : SpellModule
{
    [SerializeField] GameObject thirdEyeShockWavePrefab;
    Transform shockWave;

    [SerializeField] float cursedDuration = 3;

    bool inEchoMode = false;
    [SerializeField] float echoRange = 8;
    [SerializeField] float echoDuration = 10;

    [SerializeField] float waveRange = 15;
    [SerializeField] float waveDuration = 0.3f;
    float currentWaveTime = 0;
    [SerializeField] AnimationCurve waveCurve;

    [SerializeField] AudioClip waveAudio;

    shockWaveState shockWaveStatut = shockWaveState.hide;

    List<LocalPlayer> pingedPlayer = new List<LocalPlayer>();
    protected override void ResolveSpell(Vector3 _mousePosition)
    {
        base.ResolveSpell(_mousePosition);

        StartWave();
    }

    void StartWave()
    {
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
    }

    private void Update()
    {
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

        if (shockWaveStatut == shockWaveState.close)
        {
            currentWaveTime += Time.deltaTime;
            float size = Mathf.Lerp(waveRange, 0, waveCurve.Evaluate(currentWaveTime / waveDuration));
            shockWave.transform.localScale = new Vector3(size, size, size);

            if (currentWaveTime >= waveDuration)
            {
                shockWaveStatut = shockWaveState.hide;
                shockWave.gameObject.SetActive(false);
                OnShockWaveFinish();
            }
        }
    }

    void OnShockWaveFinish()
    {
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

        StartCoroutine(WaitToHideOutline());
    }

    IEnumerator WaitToHideOutline()
    {
        yield return new WaitForSeconds(cursedDuration);

        foreach(LocalPlayer p in pingedPlayer)
        {
            p.forceOutline = false;
        }

        SetInEchoMode();
    }

    void SetInEchoMode()
    {
        inEchoMode = true;

        StartCoroutine(WaitToHideEcho());
    }

    IEnumerator WaitToHideEcho()
    {
        yield return new WaitForSeconds(echoDuration);

        inEchoMode = false;
        GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", true);

        currentWaveTime = 0;
        shockWaveStatut = shockWaveState.close;
    }

    public enum shockWaveState
    {
        open,
        hide,
        close
    }
}
