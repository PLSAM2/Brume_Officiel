using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static KillFeedManager;

public class KillFeedManager : MonoBehaviour
{
    public List<KillFeedElement> killFeedElements = new List<KillFeedElement>();
    public List<killFeedElementToPull> killFeedElementsToPull = new List<killFeedElementToPull>();
    public int maxPulledKillFeedElements;

    private int pulledKillFeedElements;

    // 3 Enums correspondant aux icônes à afficher sur le KillFeedElement
    public enum character
    {
        yin,
        yang,
        shili
    }
    public enum action
    {
        kill,
        revive,
        capture
    }
    public enum target
    {
        yin,
        yang,
        shili,
        altar,
        tower
    }

    // NewEvent est appelé depuis l'extérieur lorsqu'un event doit être affiché. Les 3 arguments correspondent aux icônes à afficher.
    // S'il reste des KillFeedElements disponibles, il initie le premier qu'il trouve, sinon il garde en mémoire l'event et le met en file d'attente.
    public void NewEvent(character myCharacter, action myAction, target myTarget)
    {
        if (pulledKillFeedElements < maxPulledKillFeedElements)
        {
            for (int i = 0; i < killFeedElements.Count; i++)
            {
                if (!killFeedElements[i].isAvailable)
                    killFeedElements[i].MoveDown();
            }

            for (int i = 0; i < killFeedElements.Count; i++)
            {
                if (killFeedElements[i].isAvailable)
                {
                    killFeedElements[i].InitEvent(myCharacter, myAction, myTarget);
                    pulledKillFeedElements++;
                    break;
                }
            }

        } else if (pulledKillFeedElements == maxPulledKillFeedElements)
        {
            AddEventToWaitList(myCharacter, myAction, myTarget);
        }
    }

    // Cette fonction est appelé à chaque fois qu'un KillFeedElement disparait et check si la file d'attente est vide.
    // Une fois le KillFeedElement pullé, il faut le retirer de la liste.

    // /!\ C'EST ICI QUE LE BUG APPARAIT, Lorsqu'on lance pleins d'appels d'event et que la file d'attente se remplit, certains restent au mauvais endroit au lieu de disparaitre correctement.

    public void CheckKillFeedElementsToPull()
    {
        pulledKillFeedElements--;

        if (killFeedElementsToPull.Count > 0)
        {
            NewEvent(killFeedElementsToPull[0].myCharacter, killFeedElementsToPull[0].myAction, killFeedElementsToPull[0].myTarget);
            killFeedElementsToPull.Remove(killFeedElementsToPull[0]);
        }
    }

    // Cette fonction sert à ajouter un event à la liste d'attente.
    private void AddEventToWaitList(character myCharacter, action myAction, target myTarget)
    {
        killFeedElementToPull newEvent = new killFeedElementToPull();
        newEvent.myCharacter = 0;
        newEvent.myAction = 0;
        newEvent.myTarget = 0;

        killFeedElementsToPull.Add(newEvent);
    }

    /*private void Update()
    {
        if (Input.GetKeyDown(KeyCode.P))
            NewEvent((character)Random.Range(0,2), (action)Random.Range(0, 2), (target)Random.Range(0, 4));
    }*/
}

public class killFeedElementToPull
{
    public character myCharacter;
    public action myAction;
    public target myTarget;
}