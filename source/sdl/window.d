module window;

import std.string;
import std.stdio;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

enum Flags : int {
	FULLSCREEN = SDL_WINDOW_FULLSCREEN,
	FULLSCREEN_DESKTOP = SDL_WINDOW_FULLSCREEN_DESKTOP,
	OPENGL = SDL_WINDOW_OPENGL,
	SHOWN = SDL_WINDOW_SHOWN,
	HIDDEN = SDL_WINDOW_HIDDEN,
	BORDERLESS = SDL_WINDOW_BORDERLESS,
	RESIZABLE = SDL_WINDOW_RESIZABLE,
	MINIMIZED = SDL_WINDOW_MINIMIZED,
	MAXIMIZED = SDL_WINDOW_MAXIMIZED,
	INPUT_GRABBED = SDL_WINDOW_INPUT_GRABBED,
	INPUT_FOCUS = SDL_WINDOW_INPUT_FOCUS,
	MOUSE_FOCUS = SDL_WINDOW_MOUSE_FOCUS,
	FOREIGN = SDL_WINDOW_FOREIGN,
	ALLOW_HIGHDPI = SDL_WINDOW_ALLOW_HIGHDPI,
	MOUSE_CAPTURE = SDL_WINDOW_MOUSE_CAPTURE
}

class Window {
private: 
	SDL_Window *window_;
	uint tick_;
	uint timeInterval_=cast(uint)(1000UL / 60);
public:
	SDL_Window* ptr() {
		return window_;
	}
	this(string name,int x,int y,int w,int h, Flags f) {
		window_ = SDL_CreateWindow(toStringz(name),x,y,w,h,f); 
		tick_=SDL_GetTicks();
	}
	void setFrameLimit(int nbFramePerSec) {
		timeInterval_ = cast(uint)(1000UL / nbFramePerSec);
	}
	void frameLimitMe() {
		tick_ += timeInterval_;
		//auto todo = SDL_GetTicks();
		while(SDL_GetTicks()<tick_) {
			SDL_Delay(1);
			//writeln(SDL_GetTicks(),",",tick_);
		}
	}
}