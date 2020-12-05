using Sirenix.OdinInspector;
using Sirenix.OdinInspector.Editor;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class AtlasEditor : OdinEditorWindow
{
    public enum ExportType
    {
        PNG,
        JPG
    }

    [DetailedInfoBox("How to ....",
        "Ce tools peut crée ou modifier un Atlas à partir d'une liste de texture\n" +
        "L'atlas sera directement crée en type {exportType} dans le dossier {assetName}\n" +
        "La distance en pixel entre chaque texture est {texturePadding}\n" +
        "Création : Insérer les textures voulu dans l'ordre dans {atlasTextures} puis bouton Genererate Atlas \n" +
        "Modifications : Le Bouton Modify atlas récupère l'image dans {assetName} et la divise en texture (nombre de texture est {textureCountInAtlas}) \n" +
        "vous pouvez alors rajouter, supprimez ou restructurer la liste puis le bouton recreate atlas recreer l'image avec la nouvelle list \n"
        )]
    [DetailedInfoBox("Prérequis d'utilisation",
        "Chaque texture utilisé doit être modifiable : Texture --> Advanced --> Read/Write Enabled = true\n" +
        "La texture généré n'a pas de base l'attribut modifiable, lui rajoutez si vous voulez la modifier\n"
        )]

    [Header("ATLAS CREATOR")]
    public int texturePadding = 512;
    public string assetName = "HUGO/ASSETS/TEXTURES/";
    public ExportType exportType = ExportType.PNG;
    [TabGroup("ATLAS CREATOR")]
    public Texture2D[] atlasTextures;
    [TabGroup("ATLAS CREATOR")] private Texture2D packedTexture;
    [TabGroup("ATLAS MODIFIER")] [Header("ATLAS MODIFIER")] public UnityEngine.Object AtlasImage;
    [TabGroup("ATLAS MODIFIER")] public int textureCountInAtlas = 0;
    [TabGroup("ATLAS MODIFIER")] public List<Texture2D> decomposedAtlas = new List<Texture2D>();

    [MenuItem("Tools/Atlas editor")]
    private static void OpenWindow()
    {
        GetWindow<AtlasEditor>().Show();
    }

    [TabGroup("ATLAS CREATOR")]
    [Button("Generate Atlas")]
    public void GenerateAtlas()
    {

        Texture2D packedTexture = GenerateCombinedTexture(atlasTextures);

        byte[] _bytes;

        switch (exportType)
        {
            case ExportType.PNG:
                _bytes = packedTexture.EncodeToPNG();
                break;
            case ExportType.JPG:
                _bytes = packedTexture.EncodeToJPG();
                break;
            default: throw new System.Exception();
        }

        System.IO.File.WriteAllBytes(Application.dataPath + $"/{assetName}.png", _bytes);
        AssetDatabase.Refresh();

        Debug.Log("Atlas crée");

    }

    public Texture2D GenerateCombinedTexture(Texture2D[] t)
    {
        int heightcounter = (Convert.ToInt32(Math.Floor((float)(t.Length / 4)))) + 1;
        if (t.Length % 4 == 0)
        {
            heightcounter--;
        }

        int widthcounter = Mathf.Clamp(t.Length, 0, 4);
        int height = texturePadding * heightcounter;
        int width = (texturePadding * widthcounter);
        Texture2D _temp = new Texture2D(width, height);
        int imageNumber = t.Length;
        int counter = 1;

        for (int i = 0; i < imageNumber; i++)
        {
            for (int y = 0; y < texturePadding; y++) // height
            {
                for (int x = 0; x < texturePadding; x++) // width
                {
                    var pixels = t[i].GetPixel(x, y);
                    _temp.SetPixel(x + ((texturePadding * i) - (texturePadding * 4 * counter))
                        , y + (height - (texturePadding * counter))
                        , pixels);
                }
            }

            if ((i + 1) % 4 == 0) // décalage vertical
            {
                counter++;
            }
        }
        _temp.Apply();

        return _temp;
    }

    [TabGroup("ATLAS MODIFIER")]
    [Button("Get Atlas")]
    public void ModifyAtlas()
    {
        decomposedAtlas.Clear();
        Texture2D t = (Texture2D)AtlasImage;

        int counter = 1;
        int height = t.height;

        for (int i = 0; i < textureCountInAtlas; i++)
        {            
            Texture2D _temp = new Texture2D(texturePadding, texturePadding);

            for (int y = 0; y < texturePadding; y++) // height
            {
                for (int x = 0; x < texturePadding; x++) // width
                {
                    var pixels = t.GetPixel(x + ((texturePadding * i) - (texturePadding * 4 * counter))
                        , y + (height - (texturePadding * counter)));

                    _temp.SetPixel(x, y, pixels);
                }
            }

            if ((i + 1) % 4 == 0) // décalage vertical
            {
                counter++;
            }

            _temp.Apply();

            decomposedAtlas.Add(_temp);
        }
        Debug.Log("Atlas recupéré");
    }


    [TabGroup("ATLAS MODIFIER")]
    [Button("Recreate Atlas")]
    public void RecreateAtlas()
    {
        Texture2D[] _temp = decomposedAtlas.ToArray();

        Texture2D packedTexture = GenerateCombinedTexture(_temp);

        byte[] _bytes;
        switch (exportType)
        {
            case ExportType.PNG:
                _bytes = packedTexture.EncodeToPNG();
                break;
            case ExportType.JPG:
                _bytes = packedTexture.EncodeToJPG();
                break;
            default: throw new System.Exception();
        }

        System.IO.File.WriteAllBytes(Application.dataPath + $"/{assetName}.png", _bytes);

        AssetDatabase.Refresh();

        Debug.Log("Atlas Recrée");
    }

}
