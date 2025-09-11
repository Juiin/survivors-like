class_name HurtboxComponent
extends Node

@export var health_component: HealthComponent
@export var area_2d: Area2D


func take_damage(damage: float):
    health_component.take_damage(damage)