package fae

import ecs "external/odin-ecs"
import "vendor:raylib"

SystemArgs :: struct {
	ctx: ^ecs.Context,
	app: ^App,
}

System :: proc(args: SystemArgs)
Plugin :: proc(app: ^App)
Events :: map[typeid][dynamic]System
Plugins :: map[Plugin]bool


App :: struct {
	ctx:         ecs.Context,
	events:      Events,
	plugins:     Plugins,
	should_stop: bool,
}

Quit :: struct {}

StartStep :: struct {}
UpdateStep :: struct {}
StopStep :: struct {}

init_app :: proc() -> App {
	app := App {
		ctx         = ecs.init_ecs(),
		events      = make(map[typeid][dynamic]System),
		plugins     = make(map[Plugin]bool),
		should_stop = false,
	}
	add_systems(&app, Quit, stop_on_quit)
	return app
}

deinit_app :: proc(app: ^App) {
	ecs.deinit_ecs(&app.ctx)
}

should_stop_app :: proc(app: ^App) -> bool {
	return app.should_stop
}

run_app :: proc(app: ^App) {
	invoke(app, StartStep)
	for !app.should_stop {
		invoke(app, UpdateStep)
	}
	invoke(app, StopStep)
}

add_systems :: proc(app: ^App, $T: typeid, systems: ..System) {
	if T not_in app.events {
		app.events[T] = make([dynamic]System)
	}
	for system in systems {
		append(&app.events[T], system)
	}
}

add_plugins :: proc(app: ^App, plugins: ..Plugin) {
	for plugin in plugins {
		if plugin in app.plugins {
			return
		}
		app.plugins[plugin] = true
		plugin(app)
	}
}

set_resource_app :: proc(app: ^App, resource: $T) {
	set_resource_ctx(&app.ctx, resource)
}

set_resource_ctx :: proc(ctx: ^ecs.Context, resource: $T) {
	entities := ecs.get_entities_with_components(ctx, []typeid{T})
	if len(entities) < 1 {
		entity := ecs.create_entity(ctx)
		ecs.add_component(ctx, entity, resource)
	} else {
		entity := entities[0]
		ecs.set_component(ctx, entity, resource)
	}
}

get_resource :: proc(ctx: ^ecs.Context, $T: typeid) -> ^T {
	entities := ecs.get_entities_with_components(ctx, []typeid{T})
	if len(entities) < 1 {
		return nil
	}
	resource, err := ecs.get_component(ctx, entities[0], T)
	return resource
}

create_entity :: proc(app: ^App) -> Entity {
	return Entity(ecs.create_entity(&app.ctx))
}

invoke :: proc(app: ^App, $T: typeid) {
	if T not_in app.events {
		return
	}
	for system in app.events[T] {
		system(SystemArgs{ctx = &app.ctx, app = app})
	}
}

stop_on_quit :: proc(args: SystemArgs) {
	args.app.should_stop = true
}
