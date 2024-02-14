class_name DetectionProfile
extends Resource

@export_range(0.0, 20.0, 0.2, "or_greater") var motion_range: float = 8.0
@export var motion_sensitivity: float = 1.0
@export_range(0.0, 20.0, 0.2, "or_greater") var environment_range: float = 6.0
@export var environment_sensitivity: float = 0.2
@export var decay: float = 0.2
