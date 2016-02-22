import std.stdio;
import std.format;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import sdl;

enum win_w = 144;
enum win_h = 256;

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
	double xSpeed_;
	int y_;
	double x_;
	int w_;
	int h_;
	Texture texture_;
	SDL_Rect src;
	SDL_Rect dest;
public:
	this(float xSpeed, int y, Texture texture=null) {
		xSpeed_= xSpeed;
		y_ = y;
		x_ = 0;
		if (texture) {
			this.texture=texture;
		}
		src.x  = 0;
		src.y  = 0;
		dest.x = 0;
		dest.y = y_;
	}
	void texture(Texture texture) {
		texture_ = texture;
		w_ = texture.w;
		h_ = texture.h;
		dest.w = w_;
		dest.h = h_;
		src.w = w_;
		src.h = h_;
		writeln(format("%d %d %d %d",src.x,src.y,src.w,src.h));
		writeln(format("%d %d %d %d",dest.x,dest.y,dest.w,dest.h));
		writeln(x_);
	}
	override void draw(Renderer renderer) {
		renderer.copy(texture_,&src,&dest);
		dest.x-=w_;
		renderer.copy(texture_,&src,&dest);
		dest.x+=w_;
	}
	void update() {
		x_-=xSpeed_;
		if (x_<0) {
			x_=w_;
		}
		dest.x = cast(int)x_;
		//writeln(dest.x);
	}
}

void draw(T)(Renderer r,T object) if (is(T : renderable)) {
	object.draw(r);
}

void main() {
	auto scale = 2;
	DerelictSDL2.load();
	DerelictSDL2Image.load();

	auto win = new Window("Flappy in D!", 100, 100, win_w*2, win_h*2, window.Flags.SHOWN);
	auto ren = new Renderer(win, renderer.Flags.ACCELERATED | renderer.Flags.PRESENTVSYNC);
	win.setFrameLimit(60);
	SDL_RenderSetScale(ren.ptr,scale,scale);
	auto back_texture = new Texture(ren,"./assets/background.bmp");
	auto back = new Background(0.3,0,back_texture);

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
		back.update();
		ren.present();
		win.frameLimitMe();
		//SDL_Delay(1000);
	}

	writeln("");
}
