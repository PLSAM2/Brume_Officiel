using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxThirdEye : SpellModule
{
    [SerializeField] GameObject thirdEyeShockWavePrefab;
    Transform shockWave;

    [SerializeField] float cursedVisionRange = 4;
    [SerializeField] float cursedDuration = 8;

    [SerializeField] float echoRange = 8;

    [SerializeField] float waveRange = 15;
    [SerializeField] float waveDuration = 15;
    float currentWaveTime = 0;
    [SerializeField] AnimationCurve waveCurve;

    [SerializeField] AudioClip waveAudio;

    bool doShockWave = false;

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
        doShockWave = true;

        shockWave.transform.localPosition = Vector3.zero;
        shockWave.transform.localScale = Vector3.zero;
        shockWave.gameObject.SetActive(true);

        AudioManager.Instance.Play3DAudio(waveAudio, transform.position);

        GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", true);
    }

    private void Update()
    {
        if (doShockWave)
        {
            currentWaveTime += Time.deltaTime;
            float size = Mathf.Lerp(0, waveRange, waveCurve.Evaluate(currentWaveTime / waveDuration));
            shockWave.transform.localScale = new Vector3(size, size, size);

            if (currentWaveTime >= waveDuration)
            {
                doShockWave = false;
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
        foreach(KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if(player.Value == GameManager.Instance.GetLocalPlayerObj()) { continue; }

            if(Vector3.Distance(transform.position, player.Value.transform.position) <= waveRange)
            {
                player.Value.forceOutline = true;
                pingedPlayer.Add(player.Value);
            }
        }
    }
}
