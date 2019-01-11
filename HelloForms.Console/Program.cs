using Xamarin.Forms.Mocks;
using static System.Console;

namespace HelloForms.Console
{
	class Program
	{
		static void Main (string [] args)
		{
			MockForms.Init ();

			var app = new App {
				MainPage = new MainPage ()
			};

			WriteLine ("Loaded Xamarin.Forms!");
			ReadLine ();
		}
	}
}
