module texture;

import std.string;
import std.format;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import renderer;
import surface;
import error;

class Texture {
private:
	SDL_Texture* texture_;
	int w_;
	int h_;
public:
	SDL_Texture* ptr() {
		return texture_;
	}
	this(Renderer renderer,string filename) {
		auto bmp = new Surface(filename);
		scope(exit) bmp.dispose();
		texture_ = SDL_CreateTextureFromSurface(renderer.ptr, bmp.ptr);
		SDL_QueryTexture(texture_, null, null, &w_, &h_);
	}
	int w() {
		return w_;
	}
	int h() {
		return h_;
	}
}
