using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static KillFeedManager;
using UnityEngine.UI;
using DG.Tweening;

public class KillFeedElement : MonoBehaviour
{
    public bool isAvailable;

    public List<Image> imagesKillFeed = new List<Image>();
    public List<Sprite> spriteActors = new List<Sprite>();
    public List<Sprite> spriteActions = new List<Sprite>();

    public KillFeedManager killFeedManager;

    public RectTransform rectTransform;
    public Vector2 InitPos;
    public float lifeTime;

    private int moveDownCount = 1;

    // Initie le KillFeedElement et affiche les bonnes icônes.
    public void InitEvent(character _characterActor, action _action, target _target)
    {
        isAvailable = false;

        switch (_characterActor)
        {
            case character.yin:
                imagesKillFeed[0].sprite = spriteActors[0];
                break;

            case character.yang:
                imagesKillFeed[0].sprite = spriteActors[1];
                break;

            case character.shili:
                imagesKillFeed[0].sprite = spriteActors[2];
                break;
        }

        switch (_action)
        {
            case action.kill:
                imagesKillFeed[1].sprite = spriteActors[0];
                break;

            case action.revive:
                imagesKillFeed[1].sprite = spriteActors[1];
                break;

            case action.capture:
                imagesKillFeed[1].sprite = spriteActors[2];
                break;
        }

        switch (_target)
        {
            case target.yin:
                imagesKillFeed[2].sprite = spriteActors[0];
                break;

            case target.yang:
                imagesKillFeed[2].sprite = spriteActors[1];
                break;

            case target.shili:
                imagesKillFeed[2].sprite = spriteActors[2];
                break;

            case target.altar:
                imagesKillFeed[2].sprite = spriteActors[3];
                break;

            case target.tower:
                imagesKillFeed[2].sprite = spriteActors[4];
                break;
        }

        MoveIn();
    }

    private void MoveIn()
    {
        rectTransform.DOAnchorPos(new Vector2(0, -60), 0);
        rectTransform.DOAnchorPos(new Vector2(270, -60), 0.5f).SetEase(Ease.OutCubic);
        StartCoroutine(WaitAndMoveOut());
    }

    public void MoveDown()
    {
        if (moveDownCount < killFeedManager.maxPulledKillFeedElements)
        {
            rectTransform.DOAnchorPos(new Vector2(270, -60 - 95 * moveDownCount), 0.5f).SetEase(Ease.OutCubic);
            moveDownCount++;
        }
    }

    private void MoveOut()
    {
        rectTransform.DOAnchorPos(InitPos, 0);
        moveDownCount = 1;
        isAvailable = true;
        killFeedManager.CheckKillFeedElementsToPull();
    }

    private IEnumerator WaitAndMoveOut()
    {
        yield return new WaitForSeconds(lifeTime);
        MoveOut();
    }

    /*private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
            MoveIn();

        if (Input.GetKeyDown(KeyCode.Z))
            MoveDown();

        if (Input.GetKeyDown(KeyCode.E))
            MoveOut();
    }*/
}
