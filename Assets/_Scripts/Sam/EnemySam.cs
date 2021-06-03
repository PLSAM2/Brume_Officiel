using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnemySam : MonoBehaviour
{
    int life = 50;
    int maxLife = 50;

    [SerializeField] Image lifeBar;
    [SerializeField] Image damageBar;

    [SerializeField] MeshRenderer myMesh;

    [SerializeField] Material blue;
    [SerializeField] Material red;

    // Start is called before the first frame update
    void Start()
    {
        lifeBar.fillAmount = (float)    life / (float)  maxLife;
        damageBar.fillAmount = (float)life / (float)maxLife;
    }

    // Update is called once per frame
    void Update()
    {
        lifeBar.fillAmount = (float)life / (float)maxLife;
        damageBar.fillAmount = Mathf.Lerp(damageBar.fillAmount, lifeBar.fillAmount, 3 * Time.deltaTime);

        if(life <= 0)
        {
            Destroy(gameObject);
        }
    }

    public void GetDamage(int damage)
    {
        life -= damage;
        StartCoroutine(AnimDamage());
    }

    IEnumerator AnimDamage()
    {
        myMesh.material = red;
        yield return new WaitForSeconds(0.4f);
        myMesh.material = blue;
    }
}
