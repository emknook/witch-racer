extends Node3D
## Input adapter and presentation. Authoritative state lives in RaceSimulation.

const Simulation = preload("res://simulation/race_simulation.gd")
const TRACK_SEGMENTS := Simulation.SEGMENTS
const HALF_WIDTH := Simulation.HALF_WIDTH / 1000.0

var simulation := Simulation.new()
var racer: Node3D
var camera: Camera3D
var hud: Label
var track_centers := PackedVector3Array()
var _previous_position := Vector3.ZERO
var _current_position := Vector3.ZERO
var _previous_heading := 0.0
var _current_heading := 0.0
var _visual_steering := 0.0

func _ready() -> void:
    if Engine.physics_ticks_per_second != Simulation.TICKS_PER_SECOND:
        push_error("Race simulation requires 60 physics ticks per second.")
        get_tree().quit(1)
        return
    _create_environment()
    _create_track()
    _create_scenery()
    _create_racer()
    _create_camera_and_hud()

func _physics_process(_delta: float) -> void:
    _remember_previous_state()
    _advance_simulation()
    _read_current_state()

func _remember_previous_state() -> void:
    _previous_position = _current_position
    _previous_heading = _current_heading

func _advance_simulation() -> void:
    var steering := clampi(roundi(_steering_input() * 127.0), -127, 127)
    simulation.step(_accelerating(), _braking(), steering)
    _visual_steering = float(steering) / 127.0

func _accelerating() -> bool:
    return Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or _gamepad_button(JOY_BUTTON_A)

func _braking() -> bool:
    return Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN) or _gamepad_button(JOY_BUTTON_B)

func _gamepad_button(button: int) -> bool:
    return _has_gamepad() and Input.is_joy_button_pressed(Input.get_connected_joypads()[0], button)

func _has_gamepad() -> bool:
    return not Input.get_connected_joypads().is_empty()

func _steering_input() -> float:
    var keyboard := _keyboard_steering()
    if not _has_gamepad():
        return keyboard
    var stick := Input.get_joy_axis(Input.get_connected_joypads()[0], JOY_AXIS_LEFT_X)
    return stick if absf(stick) > 0.15 else keyboard

func _keyboard_steering() -> float:
    var right := Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)
    var left := Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)
    return float(int(right) - int(left))

func _read_current_state() -> void:
    _current_position = Vector3(simulation.x, simulation.y, simulation.z) / 1000.0
    _current_heading = float(simulation.heading) * TAU / Simulation.TURN

func _process(delta: float) -> void:
    _interpolate_racer()
    _animate_lean(delta)
    _follow_racer(delta)
    _update_hud()

func _interpolate_racer() -> void:
    var fraction := Engine.get_physics_interpolation_fraction()
    racer.position = _previous_position.lerp(_current_position, fraction)
    racer.rotation.y = lerp_angle(_previous_heading, _current_heading, fraction)

func _animate_lean(delta: float) -> void:
    var body := racer.get_node("Body") as Node3D
    var smoothing := 1.0 - exp(-7.0 * delta)
    body.rotation.z = lerpf(body.rotation.z, _visual_steering * 0.25, smoothing)

func _follow_racer(delta: float) -> void:
    var forward := Vector3(sin(racer.rotation.y), 0.0, cos(racer.rotation.y))
    var target := racer.position - forward * 10.0 + Vector3.UP * 5.5
    camera.global_position = camera.global_position.lerp(target, minf(1.0, 5.0 * delta))
    camera.look_at(racer.position + forward * 5.0 + Vector3.UP * 1.1)

func _update_hud() -> void:
    var speed_kmh := float(simulation.speed) * 3.6 / (Simulation.TICKS_PER_SECOND * 1000)
    var status := "ON TRACK" if simulation.on_track else "OFF TRACK"
    hud.text = "WITCH RACER | %d km/h | %s\\nW/Up accelerate | S/Down brake | A,D/Arrows steer\\nGamepad: left stick + A/B\\nFigure eight: follow the raised crossover | No collision or laps yet" % [roundi(speed_kmh), status]

func _create_environment() -> void:
    _create_sky()
    _create_sun()
    _create_ground()

func _create_sky() -> void:
    var environment := Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color("79758d")
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color("b5a6d0")
    environment.ambient_light_energy = 0.65
    var world := WorldEnvironment.new()
    world.environment = environment
    add_child(world)

func _create_sun() -> void:
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-55.0, 25.0, 0.0)
    add_child(sun)

func _create_ground() -> void:
    var ground := MeshInstance3D.new()
    var plane := PlaneMesh.new()
    plane.size = Vector2(800.0, 800.0)
    ground.mesh = plane
    ground.position.y = -0.25
    ground.material_override = _material(Color("394f49"))
    add_child(ground)

func _track_point(angle: float, offset: float) -> Vector3:
    var sample := fposmod(angle / TAU * TRACK_SEGMENTS, float(TRACK_SEGMENTS))
    var index := floori(sample)
    var start := simulation.track_point(index, roundi(offset * 1000.0))
    var finish := simulation.track_point(index + 1, roundi(offset * 1000.0))
    return Vector3(start[0], start[1], start[2]).lerp(Vector3(finish[0], finish[1], finish[2]), sample - index) / 1000.0

func _create_track() -> void:
    _remember_track_centers()
    _create_road()
    _create_boundary_rails()

func _remember_track_centers() -> void:
    for index in range(TRACK_SEGMENTS + 1):
        track_centers.append(_track_point(_segment_angle(index), 0.0))

func _segment_angle(index: int) -> float:
    return TAU * float(index) / TRACK_SEGMENTS

func _create_road() -> void:
    var surface := SurfaceTool.new()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)
    for index in range(TRACK_SEGMENTS):
        _append_road_segment(surface, index)
    _add_road_mesh(surface)

func _append_road_segment(surface: SurfaceTool, index: int) -> void:
    var start := _segment_angle(index)
    var finish := _segment_angle(index + 1)
    var left_start := _track_point(start, -HALF_WIDTH)
    var right_start := _track_point(start, HALF_WIDTH)
    var left_finish := _track_point(finish, -HALF_WIDTH)
    var right_finish := _track_point(finish, HALF_WIDTH)
    var vertices := [left_start, right_start, left_finish, right_start, right_finish, left_finish]
    for vertex in vertices:
        surface.set_color(_road_color(index))
        surface.add_vertex(vertex)

func _road_color(index: int) -> Color:
    return Color("625978") if index % 2 == 0 else Color("756a8d")

func _add_road_mesh(surface: SurfaceTool) -> void:
    surface.generate_normals()
    var road := MeshInstance3D.new()
    road.mesh = surface.commit()
    road.material_override = _road_material()
    add_child(road)

func _road_material() -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.cull_mode = BaseMaterial3D.CULL_DISABLED
    return material

func _create_boundary_rails() -> void:
    for side in [-1.0, 1.0]:
        for index in range(TRACK_SEGMENTS):
            _create_boundary_segment(index, side)

func _create_boundary_segment(index: int, side: float) -> void:
    var offset := side * (HALF_WIDTH + 0.3)
    var start := _track_point(_segment_angle(index), offset)
    var finish := _track_point(_segment_angle(index + 1), offset)
    var color := Color("ffca76") if index % 8 < 4 else Color("8bdbdb")
    _create_rail(start, finish, color)

func _create_rail(start: Vector3, finish: Vector3, color: Color) -> void:
    start.y += 0.5
    finish.y += 0.5
    var rail := MeshInstance3D.new()
    var cylinder := CylinderMesh.new()
    cylinder.top_radius = 0.13
    cylinder.bottom_radius = 0.13
    cylinder.height = start.distance_to(finish)
    rail.mesh = cylinder
    rail.position = (start + finish) * 0.5
    rail.quaternion = Quaternion(Vector3.UP, (finish - start).normalized())
    rail.material_override = _material(color)
    add_child(rail)

func _create_racer() -> void:
    _initialize_racer_transform()
    _create_racer_body()

func _initialize_racer_transform() -> void:
    _read_current_state()
    _previous_position = _current_position
    _previous_heading = _current_heading
    racer = Node3D.new()
    racer.position = _current_position
    racer.rotation.y = _current_heading
    add_child(racer)

func _create_racer_body() -> void:
    var body := Node3D.new()
    body.name = "Body"
    racer.add_child(body)
    _add_racer_pill(body)
    _add_racer_broom(body)

func _add_racer_pill(body: Node3D) -> void:
    var pill := MeshInstance3D.new()
    pill.mesh = _pill_mesh()
    pill.position.y = 0.5
    pill.material_override = _material(Color("65b9ff"))
    body.add_child(pill)

func _pill_mesh() -> CapsuleMesh:
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.65
    capsule.height = 2.4
    return capsule

func _add_racer_broom(body: Node3D) -> void:
    var broom := MeshInstance3D.new()
    var stick := BoxMesh.new()
    stick.size = Vector3(0.22, 0.22, 3.5)
    broom.mesh = stick
    broom.position = Vector3(0.0, -0.55, 0.7)
    broom.material_override = _material(Color("b88655"))
    body.add_child(broom)

func _create_camera_and_hud() -> void:
    _create_chase_camera()
    _create_hud()

func _create_chase_camera() -> void:
    camera = Camera3D.new()
    camera.current = true
    camera.fov = 80.0
    var forward := Vector3(sin(_current_heading), 0.0, cos(_current_heading))
    camera.position = racer.position - forward * 10.0 + Vector3.UP * 5.5
    add_child(camera)

func _create_hud() -> void:
    var canvas := CanvasLayer.new()
    add_child(canvas)
    hud = Label.new()
    hud.position = Vector2(24.0, 24.0)
    hud.add_theme_font_size_override("font_size", 20)
    canvas.add_child(hud)

func _create_scenery() -> void:
    var random := RandomNumberGenerator.new()
    random.seed = 84321
    for index in range(96):
        _place_roadside_rock(random, index)
    _create_landmarks()

func _place_roadside_rock(random: RandomNumberGenerator, index: int) -> void:
    var angle := TAU * float(index) / 96.0
    var side := -1.0 if index % 2 == 0 else 1.0
    var position := _track_point(angle, side * random.randf_range(12.0, 27.0))
    if _overlaps_road(position):
        return
    _create_rock(random, position, angle)

func _overlaps_road(position: Vector3) -> bool:
    for center in track_centers:
        if Vector2(position.x - center.x, position.z - center.z).length() < HALF_WIDTH + 3.0:
            return true
    return false

func _create_rock(random: RandomNumberGenerator, position: Vector3, angle: float) -> void:
    var rock := MeshInstance3D.new()
    rock.mesh = _rock_mesh()
    _shape_rock(rock, random, position)
    rock.material_override = _material(Color("ac8064") if sin(angle) > 0.0 else Color("79868a"))
    add_child(rock)

func _rock_mesh() -> SphereMesh:
    var mesh := SphereMesh.new()
    mesh.radial_segments = 5
    mesh.rings = 2
    return mesh

func _shape_rock(rock: MeshInstance3D, random: RandomNumberGenerator, position: Vector3) -> void:
    var height := random.randf_range(1.0, 4.5)
    rock.scale = Vector3(random.randf_range(2.0, 5.0), height, random.randf_range(2.0, 4.0))
    rock.position = Vector3(position.x, height * 0.35, position.z)
    rock.rotation = Vector3(0.15, random.randf_range(0.0, TAU), 0.2)

func _create_landmarks() -> void:
    _create_landmark(-1.0, 24.0, Color("79868a"))
    _create_landmark(1.0, 16.0, Color("ac8064"))

func _create_landmark(side: float, height: float, color: Color) -> void:
    var landmark := MeshInstance3D.new()
    landmark.mesh = _spire_mesh(height)
    landmark.position = Vector3(side * 74.0, height * 0.5, 0.0)
    landmark.material_override = _material(color)
    add_child(landmark)

func _spire_mesh(height: float) -> CylinderMesh:
    var mesh := CylinderMesh.new()
    mesh.top_radius = 1.0
    mesh.bottom_radius = 7.0
    mesh.height = height
    mesh.radial_segments = 5
    return mesh

func _material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.95
    return material
