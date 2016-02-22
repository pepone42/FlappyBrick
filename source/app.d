import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import sdl;

class Flappy {
	enum State {
		fall,
		fly,
		dye
	};

	immutable float x;
	float y;
	float orientation;

	this(const float x) {
		this.x=x;
	}
}

void main() {
	auto scale = 2;
	DerelictSDL2.load();
	DerelictSDL2Image.load();

	auto win = new Window("Flappy in D!", 100, 100, 180*scale, 320*scale, window.Flags.SHOWN|window.Flags.RESIZABLE);
	auto ren = new Renderer(win, renderer.Flags.ACCELERATED | renderer.Flags.PRESENTVSYNC);
	auto back = new Texture(ren,"./assets/background.bmp");

	auto flappy = new Flappy(20);
	auto quit = false;

	SDL_Event e;

	writeln(back);


	// main loop
	while(!quit) {
		while (SDL_PollEvent(&e)) {
				switch (e.type) {
				//If user closes he window
				case SDL_QUIT:
				quit = true;break;
				default: break;

			}
		}	
		//SDL_RenderClear(ren.ren);
		//SDL_RenderCopy(ren.ren, back.tex, null, null);
		ren.clear();
		ren.copy(back);
		ren.present();
		//SDL_RenderPresent(ren.sdl_renderer);
	}

	writeln("");
}
