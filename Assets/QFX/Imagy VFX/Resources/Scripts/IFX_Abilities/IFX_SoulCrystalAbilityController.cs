using UnityEngine;
using Random = UnityEngine.Random;

// ReSharper disable once CheckNamespace
namespace QFX.IFX
{
    public class IFX_SoulCrystalAbilityController : MonoBehaviour, IFX_IAbilityFx
    {
        public float ShakeRadius;
        public float ShakeDuration;
        public float ShakeRate;

        public Transform Crystal;

        public Transform BrokenCrystal;
        public float BrokenPartOffset;
        public float BrokenPartSpeed;
        public float BrokenPartLifeTime;
        public IFX_ShaderAnimator BrokenPartShaderAnimator;

        public IFX_HomingParticleSystem HomingParticleSystem;
        public IFX_ShaderAnimator HomingParticleSystemShaderAnimator;
        public IFX_ObjectFinder ObjectFinder;

        public AudioSource AudioSource;
        public float LaunchSoulsAudioDelay;
        public AudioClip LaunchSoulsAudioClip;

        private Vector3 _originalPosition;

        public void Launch()
        {
            _originalPosition = transform.position;

            InvokeRepeating("Shake", 0, ShakeRate);

            IFX_InvokeUtil.RunLater(this, delegate
            {
                CancelInvoke("Shake");
                BrokeCrystal();
                SetTarget();
            }, ShakeDuration);

            IFX_InvokeUtil.RunLater(this, DestroyCrystal, BrokenPartLifeTime);

            if (AudioSource != null && LaunchSoulsAudioClip != null)
                IFX_InvokeUtil.RunLater(this, delegate { AudioSource.PlayOneShot(LaunchSoulsAudioClip); }, LaunchSoulsAudioDelay);
        }

        private void Shake()
        {
            transform.position = _originalPosition + Random.insideUnitSphere * ShakeRadius;
        }

        private void BrokeCrystal()
        {
            BrokenPartShaderAnimator.Setup();

            var crystalParts = BrokenCrystal.GetComponentsInChildren<Transform>(true);
            foreach (var crystalPart in crystalParts)
            {
                crystalPart.gameObject.SetActive(true);

                var dir = (crystalPart.transform.position - BrokenCrystal.transform.position).normalized;
                var lerpMotion = crystalPart.gameObject.AddComponent<IFX_LerpMotion>();
                lerpMotion.Speed = BrokenPartSpeed;
                lerpMotion.LaunchPosition = crystalPart.transform.position;
                lerpMotion.TargetPosition = crystalPart.position + dir * BrokenPartOffset;
                lerpMotion.Run();
            }

            Crystal.gameObject.SetActive(false);
        }

        private void SetTarget()
        {
            var foundObjects = ObjectFinder.FindObjects(Crystal.position);
            if (foundObjects != null && foundObjects.Count > 0)
            {
                var firstFoundObject = foundObjects[0];

                HomingParticleSystem.Target = firstFoundObject.transform;
                HomingParticleSystem.Run();
            }
            else
            {
                //Dissolve trails if there is no target
                HomingParticleSystemShaderAnimator.RunWithDelay();
            }
        }

        private void DestroyCrystal()
        {
            BrokenPartShaderAnimator.RunWithDelay();
        }
    }
}
