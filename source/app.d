import std.stdio;
import std.format;
import std.conv;

import derelict.sdl2.sdl;
import derelict.sdl2.image;
import sdl;

enum win_w = 144;
enum win_h = 256;

public interface Renderable {
	void draw(Renderer r);
}

class Flappy : Renderable {
	enum State {
		fall,
		fly,
		dye
	};

	immutable float x_;
	immutable float initial_vy_ = 18;
	immutable float dt_ = 0.16;
	float y_=50;
	float vy_=0;
	int orientation_;
	Texture[3] texture_;
	SDL_Rect dest_;

	this(const float x,float y,Renderer ren) {
		this.x_=x;
		this.texture_[0] = new Texture(ren,"./assets/wingy1.bmp");
		this.texture_[1] = new Texture(ren,"./assets/wingy2.bmp");
		this.texture_[2] = new Texture(ren,"./assets/wingy3.bmp");
		this.orientation_=0;
		dest_.w=16;
		dest_.h=16;
		this.y_ = y;
		this.vy_ = initial_vy_;
		dest_.x=cast(int)x;
	}

	override void draw(Renderer renderer) {
		dest_.y = cast(int)y_;
		renderer.copy(texture_[orientation_],null,&dest_);
	}

	public void jump() {
		writeln(to!string(vy_) ~ "," ~ to!string(initial_vy_));
		vy_ = initial_vy_;
	}
	public void update() {
		vy_ -= 5.5 * dt_;
		y_ -= dt_ * vy_;
		if (vy_>0) orientation_=0;
		if (vy_<0) orientation_=1;
		if (vy_<-5) orientation_=2;
	}
}

class Background : Renderable {
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
	}
}

void draw(T)(Renderer r,T object) if (is(T : Renderable)) {
	object.draw(r);
}

void main() {
	auto scale = 3;
	DerelictSDL2.load();
	DerelictSDL2Image.load();

	auto win = new Window("Flappy in D!", 100, 100, win_w*scale, win_h*scale, window.Flags.SHOWN);
	auto ren = new Renderer(win, renderer.Flags.ACCELERATED | renderer.Flags.PRESENTVSYNC);
	win.setFrameLimit(60);
	SDL_RenderSetScale(ren.ptr,scale,scale);
	//auto back_texture = new Texture(ren,"./assets/background.bmp");
	//auto back = new Background(0.3,0,back_texture);

	auto back_texture = new Texture(ren,"./assets/Sky-layer2.png");
	auto back = new Background(0.1,0,back_texture);

	auto city_texture = new Texture(ren,"./assets/buildings-layer.png");
	auto city = new Background(0.3,76,city_texture);

	auto cloud_texture = new Texture(ren,"./assets/Sky-layer3.png");
	auto cloud_back = new Background(0.2,46,cloud_texture);
	auto cloud = new Background(0.5,118,cloud_texture);
	auto cloud2 = new Background(0.7,138,cloud_texture);
	auto cloud3 = new Background(1,168,cloud_texture);

	auto flappy = new Flappy(32,128,ren);
	auto quit = false;

	SDL_Event e;

	// main loop
	while(!quit) {
		while (SDL_PollEvent(&e)) {
				switch (e.type) {
				//If user closes the window
				case SDL_QUIT:
					quit = true;
				break;
				case SDL_MOUSEBUTTONDOWN:
					flappy.jump();
				break;
				case SDL_KEYDOWN:
					switch(e.key.keysym.sym){
						case SDLK_ESCAPE:
							quit = true;
							break;
						default:
						flappy.jump();
				}
				break;
				default: break;

			}
		}	

		ren.clear();
		ren.draw(back);
		ren.draw(cloud_back);
		cloud_back.update();
		back.update();
		ren.draw(city);
		city.update();
		ren.draw(cloud);
		cloud.update();
		ren.draw(cloud2);
		cloud2.update();

		ren.draw(flappy);
		flappy.update();

		ren.draw(cloud3);
		cloud3.update();


		ren.present();
		win.frameLimitMe();
		//SDL_Delay(1000);
	}
}
