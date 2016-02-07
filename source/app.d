import std.stdio;
import derelict.sdl2.sdl;


class Flappy {
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
}

void main() {
	DerelictSDL2.load();

	auto flappy = new Flappy(20);
}
