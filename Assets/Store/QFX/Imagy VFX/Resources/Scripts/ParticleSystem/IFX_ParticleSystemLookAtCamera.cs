using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.IFX
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(ParticleSystem))]
    public class IFX_ParticleSystemLookAtCamera : MonoBehaviour
    {
        private ParticleSystem _ps;
        private ParticleSystem.MainModule _psMain;
        private ParticleSystem.Particle[] _particles;

        private void OnEnable()
        {
            _ps = GetComponent<ParticleSystem>();
            _psMain = _ps.main;
            _particles = new ParticleSystem.Particle[_psMain.maxParticles];
        }

        private void LateUpdate()
        {
            if (_ps == null)
                return;

            var pos = Camera.main.transform.position;

            _ps.GetParticles(_particles);

            int particleCount = _ps.particleCount;

            for (int i = 0; i < particleCount; i++)
            {
                var relativePos = (pos - _particles[i].position).normalized;
                var rotation = Quaternion.LookRotation(relativePos, Vector3.up);
                _particles[i].rotation3D = new Vector3(_particles[i].rotation3D.x, rotation.eulerAngles.y, _particles[i].rotation3D.z);
            }

            _ps.SetParticles(_particles, particleCount);
        }
    }
}
