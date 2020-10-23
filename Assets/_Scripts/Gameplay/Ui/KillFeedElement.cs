using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static KillFeedManager;
using UnityEngine.UI;

public class KillFeedElement : MonoBehaviour
{
    private bool isAvailable;

    public List<Image> imagesKillFeed = new List<Image>();
    public List<Sprite> spriteActors = new List<Sprite>();
    public List<Sprite> spriteActions = new List<Sprite>();

    public void InitEvent(character _characterActor, action _action, target _target)
    {
        switch (_characterActor)
        {
            case character.Yin:
                imagesKillFeed[0].sprite = spriteActors[0];
                break;

            case character.Yang:
                imagesKillFeed[0].sprite = spriteActors[1];
                break;

            case character.Shili:
                imagesKillFeed[0].sprite = spriteActors[2];
                break;
        }

        switch (_action)
        {
            case action.kill:

                break;

            case action.revive:

                break;

            case action.capture:

                break;
        }

        switch (_target)
        {
            case target.Yin:

                break;

            case target.Yang:

                break;

            case target.Shili:

                break;

            case target.Altar:

                break;

            case target.Tower:

                break;
        }
    }
}
