using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class Settings : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI myTextMasterVolume;
    [SerializeField] Slider mySliderMasterVolume;

    [SerializeField] TextMeshProUGUI myTextMusicVolume;
    [SerializeField] Slider mySliderMusicVolume;

    private void Start()
    {
        mySliderMasterVolume.SetValueWithoutNotify(AudioManager.Instance.currentPlayerVolume);
        mySliderMusicVolume.SetValueWithoutNotify(AudioManager.Instance.currentMusicVolume);

        UpdateText(myTextMasterVolume, mySliderMasterVolume.value);
        UpdateText(myTextMusicVolume, mySliderMusicVolume.value);
    }

    public void Close()
    {
        SceneManager.UnloadSceneAsync("Settings");
    }

    public void OnSliderMasterVolumeUpdate()
    {
        AudioManager.Instance.currentPlayerVolume = mySliderMasterVolume.value;

        AudioManager.Instance.OnVolumeChange?.Invoke(mySliderMasterVolume.value);
        UpdateText(myTextMasterVolume, mySliderMasterVolume.value);

        PlayerPrefs.SetFloat("Volume", mySliderMasterVolume.value);
    }

    public void OnSliderMusicVolumeUpdate()
    {
        AudioManager.Instance.currentPlayerVolume = mySliderMusicVolume.value;
        UpdateText(myTextMusicVolume, mySliderMusicVolume.value);

        AudioManager.Instance.ChangeVolumeMusic(mySliderMusicVolume.value);
    }

    void UpdateText(TextMeshProUGUI _text, float _value)
    {
        float percentVolume = 100 * _value;
        _text.text = Mathf.RoundToInt(percentVolume) + "%";
    }
}
