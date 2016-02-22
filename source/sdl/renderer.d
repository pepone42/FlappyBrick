module renderer;

import std.format;
import std.string;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import window;
import texture;
import error;


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
		if (r!=0)
			throw new Error(get_error(__PRETTY_FUNCTION__~" Error:\n"));
	}
	void copy(Texture texture,SDL_Rect *src=null,SDL_Rect *dst=null) {
		auto r = SDL_RenderCopy(renderer_, texture.ptr, src, dst);
		if (r!=0)
			throw new Exception(get_error(__PRETTY_FUNCTION__~":\n"));
	}
	void present() {
		SDL_RenderPresent(renderer_);	
	}
	
	//
}