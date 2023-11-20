package fae

import ecs "external/odin-ecs"

query_entities :: proc(ctx: ^ecs.Context, components: []typeid) -> [dynamic]Entity {
	entities := make([dynamic]Entity)
	for e in ecs.get_entities_with_components(ctx, components) {
		append(&entities, Entity(e))
	}
	return entities
}


query_component :: proc(
	ctx: ^ecs.Context,
	e: Entity,
	$T: typeid,
) -> (
	component: ^T,
	error: ecs.ECS_Error,
) {
	return ecs.get_component(ctx, ecs.Entity(e), T)
}
