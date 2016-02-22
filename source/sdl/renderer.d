module renderer;

import std.format;
import std.string;

import window;
import texture;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

enum Flags : int {
	SOFTWARE = SDL_RENDERER_SOFTWARE,
	ACCELERATED = SDL_RENDERER_ACCELERATED,
	PRESENTVSYNC = SDL_RENDERER_PRESENTVSYNC,
	TARGETTEXTURE = SDL_RENDERER_TARGETTEXTURE
}

class Renderer {
private:
	SDL_Renderer* renderer_;
public:
	SDL_Renderer* ptr() {
		return renderer_;
	}
	this(Window window,Flags flags) {
		renderer_ = SDL_CreateRenderer(window.ptr, -1, flags);
	}
	void clear() {
		auto r=SDL_RenderClear(renderer_);
		if (r!=0) {
			auto msg = format("Error %s",fromStringz(SDL_GetError()));
			throw new Exception(msg);
		}
	}
	void copy(Texture texture,SDL_Rect *src=null,SDL_Rect *dst=null) {
		// TODO : add sourceRect and DestRect support
		//SDL_RenderCopy(ren.ren, back.tex, null, null);
		auto r = SDL_RenderCopy(renderer_, texture.ptr, src, dst);
		if (r!=0) {
			auto msg = format("Error %s",fromStringz(SDL_GetError()));
			throw new Exception(msg);
		}
	}
	void present() {
		SDL_RenderPresent(renderer_);	
	}
	
	//
}