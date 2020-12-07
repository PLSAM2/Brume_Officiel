using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PreviewManager : MonoBehaviour
{
    private static PreviewManager _instance;
    public static PreviewManager Instance { get { return _instance; } }

    [SerializeField] GameObject prefabCircle;
    [SerializeField] GameObject prefabSquare;
    [SerializeField] GameObject prefabShape;
    [SerializeField] GameObject prefabArrow;

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

    public ShapePreview GetShapePreview()
    {
        ShapePreview newShape = Instantiate(prefabShape, transform).GetComponent<ShapePreview>();
        newShape.transform.position += Vector3.up * 0.1f;

        return newShape;
    }

    public SquarePreview GetSquarePreview()
    {
        SquarePreview newSquare = Instantiate(prefabSquare, transform).GetComponent<SquarePreview>();
        newSquare.transform.position += Vector3.up * 0.1f;

        return newSquare;
    }

    public CirclePreview GetCirclePreview(Transform parent)
    {
        CirclePreview newCircle = Instantiate(prefabCircle, transform).GetComponent<CirclePreview>();
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

    public enum previewType
    {
        Shape,
        Circle,
        Square
    }
}
