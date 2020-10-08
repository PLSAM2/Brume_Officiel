using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameFactory
{
    public static int GerateRandomNumer(int min, int max)
    {
        return Random.Range(min, max);
    }
}
