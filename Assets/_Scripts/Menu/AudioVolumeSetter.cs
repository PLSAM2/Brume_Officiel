using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class AudioVolumeSetter : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI myTextVolume;
    [SerializeField] Slider mySlider;

    private void Start()
    {
        UpdateText();
        mySlider.SetValueWithoutNotify(AudioManager.Instance.currentPlayerVolume);
    }

    public void OnSliderUpdate()
    {
        AudioManager.Instance.currentPlayerVolume = mySlider.value;

        AudioManager.Instance.OnVolumeChange?.Invoke(mySlider.value);
        UpdateText();
    }

    void UpdateText()
    {
        float percentVolume = 100 * AudioManager.Instance.currentPlayerVolume;
        myTextVolume.text = Mathf.RoundToInt(percentVolume) + "%";

        PlayerPrefs.SetFloat("Volume", AudioManager.Instance.currentPlayerVolume);
    }
}
