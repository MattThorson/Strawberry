using System.Diagnostics;
namespace Strawberry
{
	public abstract class Module
	{
		public enum RunResults { Quit, Swap }

		private float msCounter;
		private uint32 prevTicks;
		private bool swap;

		public this()
		{
			Debug.Assert(PlatformLayer != null, "Must create PlatformLayer before Modules.");
		}

		private Module Run()
		{
			Time.RawPreviousElapsed = 0;
			Time.RawElapsed = 0;
			Time.PreviousElapsed = 0;
			Time.Elapsed = 0;
			Time.Freeze = 0;

			Started();

			while (true)
			{
				let tick = PlatformLayer.Ticks;
				msCounter += tick - prevTicks;

				// update
				if (Time.FixedTimestep)
				{
					Time.RawDelta = Time.TargetDeltaTime;
					while (msCounter >= Time.TargetMilliseconds)
					{
						msCounter -= Time.TargetMilliseconds;
						PlatformLayer.UpdateInput();
						Update();
						Input.AfterUpdate();
					}
				}
				else
				{
					Time.RawDelta = (tick - prevTicks) / 1000f;
					PlatformLayer.UpdateInput();
					Update();
					Input.AfterUpdate();
				}

				//Update elapsed
				{
					Time.RawPreviousElapsed = Time.RawElapsed;
					Time.RawElapsed += Time.RawDelta;
					Time.PreviousElapsed = Time.Elapsed;
					Time.Elapsed += Time.Delta;
				}

				// render
				Render();

				// exit or swap to another module
				if (PlatformLayer.Closed())
					return null;
				else if (swap || Input.KeyPressed(.F1))
				{
					let swapTo = CreateSwapModule();
					if (swapTo != null)
						return swapTo;
				}

				prevTicks = tick;
			}	
		}

		protected abstract void Started();
		protected abstract void Update();
		protected abstract void Render();

		public virtual Module CreateSwapModule()
		{
			return null;
		}

		public void Swap()
		{
			swap = true;
		}
	}
}
