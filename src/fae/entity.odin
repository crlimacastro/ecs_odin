package fae

import ecs "external/odin-ecs"

Entity :: distinct ecs.Entity

add_component :: proc(app: ^App, entity: Entity, component: $T) -> (^T, ecs.ECS_Error) {
	return ecs.add_component(&app.ctx, ecs.Entity(entity), component)
}
