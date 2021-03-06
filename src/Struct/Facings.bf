using System;
namespace Strawberry
{
	public enum Facings
	{
		case Right = 1;
		case Left = -1;

		[Inline]
		public float Angle => this == .Right ? Calc.Right : Calc.Left;

		public Facings Opposite()
		{
			if (this == .Right)
				return .Left;
			else
				return .Right;
		}

		static public Facings FromInt(int i, Facings ifZero = .Right)
		{
			if (i == 0)
				return ifZero;
			else
				return i;
		}

		[Inline, Commutable]
		static public int operator*(Facings a, int b)
		{
			return b * (int)a;
		}

		[Inline, Commutable]
		static public float operator*(Facings a, float b)
		{
			return b * (int)a;
		}

		static public implicit operator Facings(int i)
		{
			if (i < 0)
				return .Left;
			else
				return .Right;
		}

		static public implicit operator Point(Facings f)
		{
			return .((int)f, 0);
		}
	}
}
