module texture;

import std.string;
import std.format;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import renderer;
import surface;

class Texture {
private:
	SDL_Texture* texture_;
public:
	SDL_Texture* ptr() {
		return texture_;
	}
	this(Renderer renderer,string filename) {
		auto bmp = new Surface(filename);
		scope(exit) bmp.dispose();
		if (bmp is null) {
			auto msg = format("Error While trying to load %s :\n%s\n",filename,fromStringz(SDL_GetError()));
			throw new Exception(msg);
		}
		texture_ = SDL_CreateTextureFromSurface(renderer.ptr, bmp.ptr);
	}
}
