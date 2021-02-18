using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GainUltiElement : MonoBehaviour
{
    [SerializeField] GameObject prefabUltiElement;

    [SerializeField] CanvasGroup myCanvasGroup;
    [SerializeField] float moveSpeed = 1;

    [SerializeField] float startSize = 40;
    [SerializeField] float endSize = 12;

    Vector3 destination;

    List<RectTransform> allUlti = new List<RectTransform>();

    public void Init(int numberUlti, Vector3 _destination)
    {
        destination = _destination;

        for (int i = 0; i < numberUlti; i++)
        {
            UltiElement newElement = Instantiate(prefabUltiElement, transform).GetComponent<UltiElement>();
            newElement.InstantSetValue(1);

            RectTransform rectElement = newElement.GetComponent<RectTransform>();
            SetSize(startSize, rectElement);
        }

        StartCoroutine(PlayAnimation());
    }

    IEnumerator PlayAnimation()
    {
        //wait avant de bouger
        yield return new WaitForSeconds(1);

        Vector3 startpos = transform.position;
        float startDistance = Vector3.Distance(startpos, destination);

        while (transform.position != destination)
        {
            transform.position = Vector3.Lerp(startpos, destination, moveSpeed * Time.deltaTime);

            float size = Mathf.Lerp(startSize, endSize, moveSpeed * Time.deltaTime);
            foreach(RectTransform rt in allUlti)
            {
                SetSize(size, rt);
            }

            myCanvasGroup.alpha = (Vector3.Distance(transform.position, destination) / startDistance) * 2;
            yield return null;
        }

        yield return null;

        Destroy(gameObject);
    }

    void SetSize(float size, RectTransform rt)
    {
        rt.sizeDelta = new Vector2(size, size);
    }
}
