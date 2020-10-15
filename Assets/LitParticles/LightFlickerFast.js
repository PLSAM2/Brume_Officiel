#pragma strict

var minFlickerSpeed : float = 0.1;
var maxFlickerSpeed : float = 2.0;

function Update () {//
	flicker();
}

 function flicker() {
 	//yield return new WaitForSeconds(Random.Range(minF
 	yield WaitForSeconds (Random.Range(minFlickerSpeed, maxFlickerSpeed ));
     GetComponent.<Light>().intensity = (Random.Range(minFlickerSpeed, maxFlickerSpeed ));
     //yield WaitForSeconds (Random.Range(minFlickerSpeed, maxFlickerSpeed ));
     //light.intensity = (Random.Range(minFlickerSpeed, maxFlickerSpeed ));
 }
 
 
    
