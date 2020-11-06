using UnityEngine;

// ReSharper disable once CheckNamespace
namespace QFX.IFX
{
    public class IFX_RendererActivator : IFX_ControlledObject
    {
        private Renderer _renderer;

        public override void Run()
        {
            base.Run();
            _renderer.enabled = true;
        }

        public override void Stop()
        {
            base.Stop();
            _renderer.enabled = false;
        }

        private void Awake()
        {
            _renderer = GetComponent<Renderer>();
            _renderer.enabled = false;
        }
    }
}