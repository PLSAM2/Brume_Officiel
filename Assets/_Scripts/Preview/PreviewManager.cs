using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PreviewManager : MonoBehaviour
{
    private static PreviewManager _instance;
    public static PreviewManager Instance { get { return _instance; } }

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    [SerializeField] GameObject prefabCircle;
    [SerializeField] GameObject prefabSquare;
    [SerializeField] GameObject prefabShape;
    [SerializeField] GameObject prefabArrow;

    public ShapePreview GetShapePreview(Transform parent)
    {
        ShapePreview newShape = Instantiate(prefabShape, parent).GetComponent<ShapePreview>();
        newShape.transform.position += Vector3.up * 0.1f;

        return newShape;
    }

    public SquarePreview GetSquarePreview(Transform parent)
    {
        SquarePreview newSquare = Instantiate(prefabSquare, parent).GetComponent<SquarePreview>();
        newSquare.transform.position += Vector3.up * 0.1f;

        return newSquare;
    }

    public CirclePreview GetCirclePreview(Transform parent)
    {
        CirclePreview newCircle = Instantiate(prefabCircle, parent).GetComponent<CirclePreview>();
        newCircle.transform.position += Vector3.up * 0.1f;

        return newCircle;
    }

    public ArrowPreview GetArrowPreview()
    {
        ArrowPreview newArrow = Instantiate(prefabArrow, transform).GetComponent<ArrowPreview>();
        newArrow.transform.position += Vector3.up * 0.1f;

        return newArrow;
    }

    public void ReleasePreview(GameObject obj)
    {
        Destroy(obj);
    }
}
