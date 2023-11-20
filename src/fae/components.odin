package fae

import "vendor:raylib"

Transform2 :: struct {
	position: raylib.Vector2,
	scale:    raylib.Vector2,
}

Color :: distinct raylib.Color
