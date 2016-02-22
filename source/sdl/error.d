module error;

import std.string;
import std.format;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

string get_error(const string message) {
	immutable string msg = format("%s : %s",message,SDL_GetError());
	return msg;
}

class SDLError : Error {
	this(string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
		super(cast(string)fromStringz(SDL_GetError()),file,line,next);
	}
}