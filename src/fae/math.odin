package fae

import "core:math"
import "vendor:raylib"

normalize_vector2_or_zero :: proc(v: raylib.Vector2) -> raylib.Vector2 {
	length := math.sqrt(v.x * v.x + v.y * v.y)
	if length == 0 {
		return raylib.Vector2{0, 0}
	}
	return raylib.Vector2{v.x / length, v.y / length}
}
