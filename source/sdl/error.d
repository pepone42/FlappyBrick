module error;

import std.string;
import std.format;

import derelict.sdl2.sdl;
import derelict.sdl2.image;

string get_error(const string message) {
	immutable string msg = format("%s : %s",message,SDL_GetError());
	return msg;
}