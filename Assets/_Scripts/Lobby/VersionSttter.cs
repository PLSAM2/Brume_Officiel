#if UNITY_EDITOR

using UnityEngine;
using TMPro;
using UnityEditor;
using UnityEditor.Build;

class VersionSttter : IPreprocessBuild
{
    public int callbackOrder { get { return 0; } }
    public void OnPreprocessBuild(BuildTarget target, string path)
    {
        int numberVersion = 0;
        int.TryParse(LobbyManager.Instance.version.text, out numberVersion);

        LobbyManager.Instance.version.text = numberVersion.ToString();
    }
}
#endif
