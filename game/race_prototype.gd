extends Node3D
## Minimal track-based arcade handling sandbox; geometry is generated at runtime.

const RADIUS_X := 42.0
const RADIUS_Z := 28.0
const HALF_WIDTH := 7.0
const MAX_SPEED := 38.0
const ACCELERATION := 22.0
const BRAKING := 32.0
const FRICTION := 9.0
const TURN_SPEED := 2.2

var speed := 0.0
var heading := 0.0
var racer: Node3D
var camera: Camera3D
var hud: Label

func _ready() -> void:
    _create_environment()
    _create_track()
    _create_racer()
    _create_camera_and_hud()

func _physics_process(delta: float) -> void:
    var accelerate := Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP)
    var brake := Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN)
    var steer := float(int(Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT)) - int(Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT)))
    if not Input.get_connected_joypads().is_empty():
        var pad := Input.get_connected_joypads()[0]
        var axis := Input.get_joy_axis(pad, JOY_AXIS_LEFT_X)
        if absf(axis) > 0.15:
            steer = axis
        accelerate = accelerate or Input.is_joy_button_pressed(pad, JOY_BUTTON_A)
        brake = brake or Input.is_joy_button_pressed(pad, JOY_BUTTON_B)
    if brake:
        speed = move_toward(speed, 0.0, BRAKING * delta)
    elif accelerate:
        speed = move_toward(speed, MAX_SPEED, ACCELERATION * delta)
    else:
        speed = move_toward(speed, 0.0, FRICTION * delta)
    heading += steer * TURN_SPEED * delta * clampf(speed / 15.0, 0.0, 1.0)
    var forward := Vector3(sin(heading), 0.0, cos(heading))
    racer.position += forward * speed * delta
    racer.rotation.y = heading
    var body := racer.get_node("Body") as Node3D
    body.rotation.z = lerpf(body.rotation.z, -steer * 0.25, minf(1.0, 7.0 * delta))
    camera.global_position = camera.global_position.lerp(racer.position - forward * 10.0 + Vector3.UP * 5.5, minf(1.0, 5.0 * delta))
    camera.look_at(racer.position + forward * 5.0 + Vector3.UP * 1.1)
    var radius := sqrt(pow(racer.position.x / RADIUS_X, 2.0) + pow(racer.position.z / RADIUS_Z, 2.0))
    hud.text = "WITCH RACER | %d km/h | %s\nW/Up accelerate | S/Down brake | A,D/Arrows steer\nGamepad: left stick + A/B\nHandling sandbox: no collision or lap counting" % [roundi(speed * 6.0), "ON TRACK" if absf(radius - 1.0) < 0.23 else "OFF TRACK"]

func _create_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color("211c38")
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color("b5a6d0")
    env.ambient_light_energy = 0.65
    world.environment = env
    add_child(world)
    var light := DirectionalLight3D.new()
    light.rotation_degrees = Vector3(-55.0, 25.0, 0.0)
    add_child(light)
    var ground := MeshInstance3D.new()
    var plane := PlaneMesh.new()
    plane.size = Vector2(180.0, 150.0)
    ground.mesh = plane
    ground.position.y = -0.25
    ground.material_override = _material(Color("352e4b"))
    add_child(ground)

func _track_point(angle: float, offset: float) -> Vector3:
    var center := Vector3(RADIUS_X * cos(angle), 0.0, RADIUS_Z * sin(angle))
    var normal := Vector3(cos(angle) / RADIUS_X, 0.0, sin(angle) / RADIUS_Z).normalized()
    return center + normal * offset

func _create_track() -> void:
    var surface := SurfaceTool.new()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)
    for i in range(128):
        var a := TAU * float(i) / 128.0
        var b := TAU * float(i + 1) / 128.0
        var inside_a := _track_point(a, -HALF_WIDTH)
        var outside_a := _track_point(a, HALF_WIDTH)
        var inside_b := _track_point(b, -HALF_WIDTH)
        var outside_b := _track_point(b, HALF_WIDTH)
        for point in [inside_a, outside_a, inside_b, outside_a, outside_b, inside_b]:
            surface.set_color(Color("625978") if i % 2 == 0 else Color("756a8d"))
            surface.add_vertex(point)
    var track := MeshInstance3D.new()
    track.mesh = surface.commit()
    var material := StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.cull_mode = BaseMaterial3D.CULL_DISABLED
    track.material_override = material
    add_child(track)
    for side in [-1.0, 1.0]:
        for i in range(128):
            var a := TAU * float(i) / 128.0
            var b := TAU * float(i + 1) / 128.0
            _create_rail(_track_point(a, side * (HALF_WIDTH + 0.3)), _track_point(b, side * (HALF_WIDTH + 0.3)), Color("ffca76") if i % 8 < 4 else Color("8bdbdb"))

func _create_rail(start: Vector3, finish: Vector3, color: Color) -> void:
    start.y = 0.5
    finish.y = 0.5
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
    racer = Node3D.new()
    racer.position = Vector3(RADIUS_X, 1.5, 0.0)
    add_child(racer)
    var body := Node3D.new()
    body.name = "Body"
    racer.add_child(body)
    var pill := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.65
    capsule.height = 2.4
    pill.mesh = capsule
    pill.position.y = 0.5
    pill.material_override = _material(Color("65b9ff"))
    body.add_child(pill)
    var broom := MeshInstance3D.new()
    var stick := BoxMesh.new()
    stick.size = Vector3(0.22, 0.22, 3.5)
    broom.mesh = stick
    broom.position = Vector3(0.0, -0.55, 0.7)
    broom.material_override = _material(Color("b88655"))
    body.add_child(broom)

func _create_camera_and_hud() -> void:
    camera = Camera3D.new()
    camera.current = true
    camera.fov = 80.0
    camera.position = racer.position + Vector3(0.0, 5.5, -10.0)
    add_child(camera)
    var canvas := CanvasLayer.new()
    add_child(canvas)
    hud = Label.new()
    hud.position = Vector2(24.0, 24.0)
    hud.add_theme_font_size_override("font_size", 20)
    canvas.add_child(hud)

func _material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.95
    return material
