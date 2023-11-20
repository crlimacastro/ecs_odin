package fae

import ecs "external/odin-ecs"
import "vendor:raylib"

ClearColor :: distinct raylib.Color

draw_plugin :: proc(app: ^App) {
	set_resource_app(app, ClearColor(raylib.BLACK))
	add_systems(app, StartStep, init_drawing)
	add_systems(app, UpdateStep, stop_on_window_should_close, invoke_draw_step)
	add_systems(app, DrawStep, draw_transforms)
	add_systems(app, StopStep, deinit_drawing)
}

DrawStep :: struct {}

init_drawing :: proc(args: SystemArgs) {
	using raylib
	SetConfigFlags(ConfigFlags{ConfigFlag.WINDOW_RESIZABLE})
	InitWindow(1920, 1080, "")
	SetExitKey(KeyboardKey.KEY_NULL)
}

stop_on_window_should_close :: proc(args: SystemArgs) {
	if raylib.WindowShouldClose() {
		args.app.should_stop = true
	}
}

invoke_draw_step :: proc(args: SystemArgs) {
	using raylib
	BeginDrawing()
	defer EndDrawing()
	final_clear_color := raylib.BLACK
	clear_color := get_resource(args.ctx, ClearColor)
	if clear_color != nil {
		final_clear_color = Color(clear_color^)
	}
	ClearBackground(final_clear_color)
	invoke(args.app, DrawStep)
}

draw_transforms :: proc(args: SystemArgs) {
	using ecs
	for e in get_entities_with_components(args.ctx, []typeid{Transform2}) {
		transform, err := get_component(args.ctx, e, Transform2)
		final_color := raylib.WHITE
		if has_component(args.ctx, e, Color) {
			color, err := get_component(args.ctx, e, Color)
			final_color = raylib.Color(color^)
		}
		raylib.DrawRectangleV(transform.position, transform.scale, final_color)
	}
}

deinit_drawing :: proc(args: SystemArgs) {
	raylib.CloseWindow()
}
