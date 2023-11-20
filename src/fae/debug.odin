package fae

import ecs "external/odin-ecs"
import "vendor:raylib"

draw_fps :: proc(args: SystemArgs) {
	raylib.DrawFPS(4, 4)
}

quit_on_esc :: proc(args: SystemArgs) {
	if raylib.IsKeyReleased(raylib.KeyboardKey.ESCAPE) {
		invoke(args.app, Quit)
	}
}
