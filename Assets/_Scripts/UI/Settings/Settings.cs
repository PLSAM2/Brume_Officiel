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

        qualitySelected[QualitySettings.GetQualityLevel() - 1].SetActive(true);
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
        UpdateText(myTextMusicVolume, mySliderMusicVolume.value);
        AudioManager.Instance.ChangeVolumeMusic(mySliderMusicVolume.value);
    }

    void UpdateText(TextMeshProUGUI _text, float _value)
    {
        float percentVolume = 100 * _value;
        _text.text = Mathf.RoundToInt(percentVolume) + "%";
    }


    public List<GameObject> qualitySelected = new List<GameObject>();
    public void ChangeQuality(int quality)
    {
        foreach(GameObject obj in qualitySelected)
        {
            obj.SetActive(false);
        }

        qualitySelected[quality - 1].SetActive(true);

        switch (quality)
        {
            case 0:
                QualitySettings.SetQualityLevel(0, true);
                break;
            case 1:
                QualitySettings.SetQualityLevel(1, true);
                break;
            case 2:
                QualitySettings.SetQualityLevel(2, true);
                break;
            case 3:
                QualitySettings.SetQualityLevel(3, true);
                break;
            default:
                Debug.LogError("Not a quality");
                break;
        }
    }
}
