module surface;

import std.string;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

import error;

class Surface {
private:
	SDL_Surface* surface_;
public:
	SDL_Surface* ptr() {
		return surface_;
	}
	this(string filename) {
		surface_ = IMG_Load(toStringz(filename));
		if (surface_==null) {
			throw new SDLError();
		}
	}
	void dispose() {
		SDL_FreeSurface(surface_);
	}
}