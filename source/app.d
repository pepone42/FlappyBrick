import std.stdio;
import derelict.sdl2.sdl;
import derelict.sdl2.image;
import sdl;

public interface renderable {
	void draw(Renderer r);
}

class Flappy : renderable{
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

	override void draw(Renderer renderer) {
	}
}

class Background : renderable {
private:
	int xSpeed_;
	int y_;
	int w_;
	int h_;
	Texture texture_;
	SDL_Rect src;
	SDL_Rect dest;
public:
	this(int xSpeed, int y, Texture texture=null) {
		xSpeed_= xSpeed;
		x_ = y;
		if (texture) {
			this.texture=texture;
		}
		src.x = 0;
		src.y = 0;
	}
	void texture(Texture texture) {
		texture_ = texture;
		w_ = texture.w;
		h_ = texture.h;
	}
	override void draw(Renderer renderer) {
		renderer.copy(texture_);
	}
}

void draw(T)(Renderer r,T object) if (is(T : renderable)) {
	object.draw(r);
}

void main() {
	auto scale = 2;
	DerelictSDL2.load();
	DerelictSDL2Image.load();

	auto win = new Window("Flappy in D!", 100, 100, 180*scale, 320*scale, window.Flags.SHOWN|window.Flags.RESIZABLE);
	auto ren = new Renderer(win, renderer.Flags.ACCELERATED | renderer.Flags.PRESENTVSYNC);
	auto back_texture = new Texture(ren,"./assets/background.bmp");
	auto back = new Background(0,0,back_texture);

	auto flappy = new Flappy(20);
	auto quit = false;

	SDL_Event e;

	// main loop
	while(!quit) {
		while (SDL_PollEvent(&e)) {
				switch (e.type) {
				//If user closes the window
				case SDL_QUIT:
				quit = true;break;
				default: break;

			}
		}	

		ren.clear();
		ren.draw(back);
		ren.present();
	}

	writeln("");
}
