package main

import "fae"
import "vendor:raylib"

Player :: struct {
	speed: f32,
}

main :: proc() {
	using fae
	app := init_app()
	defer deinit_app(&app)
	add_plugins(&app, draw_plugin)
	add_systems(&app, UpdateStep, quit_on_esc, move_player)
	add_systems(&app, DrawStep, draw_fps)

	entity := create_entity(&app)
	add_component(&app, entity, Transform2{position = {500, 500}, scale = {100, 100}})
	add_component(&app, entity, fae.Color(raylib.RED))
	add_component(&app, entity, Player{speed = 1000})

	run_app(&app)
}

move_player :: proc(args: fae.SystemArgs) {
	using fae
	for e in query_entities(args.ctx, []typeid{Transform2, Player}) {
		transform, _ := query_component(args.ctx, e, Transform2)
		player, _ := query_component(args.ctx, e, Player)
		direction := raylib.Vector2{0, 0}
		if raylib.IsKeyDown(raylib.KeyboardKey.W) {
			direction.y += -1
		}
		if raylib.IsKeyDown(raylib.KeyboardKey.S) {
			direction.y += 1
		}
		if raylib.IsKeyDown(raylib.KeyboardKey.A) {
			direction.x += -1
		}
		if raylib.IsKeyDown(raylib.KeyboardKey.D) {
			direction.x += 1
		}
		direction = normalize_vector2_or_zero(direction)
		transform.position.x += direction.x * player.speed * raylib.GetFrameTime()
		transform.position.y += direction.y * player.speed * raylib.GetFrameTime()
	}
}
