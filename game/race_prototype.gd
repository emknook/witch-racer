extends Node3D
## Minimal track-based arcade handling sandbox; geometry is generated at runtime.

const RADIUS_X := 110.0
const RADIUS_Z := 72.0
const TRACK_SEGMENTS := 320
const HOVER_HEIGHT := 1.5
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
var track_centers := PackedVector3Array()

func _ready() -> void:
    _create_environment()
    _create_track()
    _create_scenery()
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
    # Travel is along local +Z, so a right turn decreases Godot's Y rotation.
    heading -= steer * TURN_SPEED * delta * clampf(speed / 15.0, 0.0, 1.0)
    var forward := Vector3(sin(heading), 0.0, cos(heading))
    racer.position += forward * speed * delta
    var nearest := _nearest_track_position(racer.position - Vector3.UP * HOVER_HEIGHT)
    var on_track := Vector2(racer.position.x - nearest.x, racer.position.z - nearest.z).length() <= HALF_WIDTH
    var surface_height := nearest.y if on_track else 0.0
    racer.position.y = lerpf(racer.position.y, surface_height + HOVER_HEIGHT, 1.0 - exp(-8.0 * delta))
    racer.rotation.y = heading
    var body := racer.get_node("Body") as Node3D
    body.rotation.z = lerpf(body.rotation.z, steer * 0.25, minf(1.0, 7.0 * delta))
    camera.global_position = camera.global_position.lerp(racer.position - forward * 10.0 + Vector3.UP * 5.5, minf(1.0, 5.0 * delta))
    camera.look_at(racer.position + forward * 5.0 + Vector3.UP * 1.1)
    hud.text = "WITCH RACER | %d km/h | %s\nW/Up accelerate | S/Down brake | A,D/Arrows steer\nGamepad: left stick + A/B\nFigure eight: follow the raised crossover | No collision or laps yet" % [roundi(speed * 3.6), "ON TRACK" if on_track else "OFF TRACK"]

func _create_environment() -> void:
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_COLOR
    env.background_color = Color("79758d")
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
    plane.size = Vector2(800.0, 800.0)
    ground.mesh = plane
    ground.position.y = -0.25
    ground.material_override = _material(Color("394f49"))
    add_child(ground)

func _track_point(angle: float, offset: float) -> Vector3:
    var center := Vector3(RADIUS_X * sin(angle), 3.0 * pow(1.0 + cos(angle), 2.0), RADIUS_Z * sin(2.0 * angle))
    var tangent := Vector3(RADIUS_X * cos(angle), 0.0, 2.0 * RADIUS_Z * cos(2.0 * angle)).normalized()
    var normal := Vector3(tangent.z, 0.0, -tangent.x)
    return center + normal * offset

func _nearest_track_position(point: Vector3) -> Vector3:
    var nearest := track_centers[0]
    var best_distance := INF
    for i in range(TRACK_SEGMENTS):
        var start := track_centers[i]
        var segment := track_centers[i + 1] - start
        var weight := clampf((point - start).dot(segment) / segment.length_squared(), 0.0, 1.0)
        var candidate := start + segment * weight
        var distance := point.distance_squared_to(candidate)
        if distance < best_distance:
            best_distance = distance
            nearest = candidate
    return nearest

func _create_track() -> void:
    for i in range(TRACK_SEGMENTS + 1):
        track_centers.append(_track_point(TAU * float(i) / TRACK_SEGMENTS, 0.0))
    var surface := SurfaceTool.new()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)
    for i in range(TRACK_SEGMENTS):
        var a := TAU * float(i) / TRACK_SEGMENTS
        var b := TAU * float(i + 1) / TRACK_SEGMENTS
        var inside_a := _track_point(a, -HALF_WIDTH)
        var outside_a := _track_point(a, HALF_WIDTH)
        var inside_b := _track_point(b, -HALF_WIDTH)
        var outside_b := _track_point(b, HALF_WIDTH)
        for point in [inside_a, outside_a, inside_b, outside_a, outside_b, inside_b]:
            surface.set_color(Color("625978") if i % 2 == 0 else Color("756a8d"))
            surface.add_vertex(point)
    var track := MeshInstance3D.new()
    surface.generate_normals()
    track.mesh = surface.commit()
    var material := StandardMaterial3D.new()
    material.vertex_color_use_as_albedo = true
    material.cull_mode = BaseMaterial3D.CULL_DISABLED
    track.material_override = material
    add_child(track)
    for side in [-1.0, 1.0]:
        for i in range(TRACK_SEGMENTS):
            var a := TAU * float(i) / TRACK_SEGMENTS
            var b := TAU * float(i + 1) / TRACK_SEGMENTS
            _create_rail(_track_point(a, side * (HALF_WIDTH + 0.3)), _track_point(b, side * (HALF_WIDTH + 0.3)), Color("ffca76") if i % 8 < 4 else Color("8bdbdb"))

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
    racer = Node3D.new()
    var start_angle := PI * 0.25
    racer.position = _track_point(start_angle, 0.0) + Vector3.UP * HOVER_HEIGHT
    var tangent := (_track_point(start_angle + 0.001, 0.0) - _track_point(start_angle, 0.0)).normalized()
    heading = atan2(tangent.x, tangent.z)
    racer.rotation.y = heading
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
    var forward := Vector3(sin(heading), 0.0, cos(heading))
    camera.position = racer.position - forward * 10.0 + Vector3.UP * 5.5
    add_child(camera)
    var canvas := CanvasLayer.new()
    add_child(canvas)
    hud = Label.new()
    hud.position = Vector2(24.0, 24.0)
    hud.add_theme_font_size_override("font_size", 20)
    canvas.add_child(hud)

func _create_scenery() -> void:
    var random := RandomNumberGenerator.new()
    random.seed = 84321
    var stone_material := _material(Color("79868a"))
    var warm_stone_material := _material(Color("ac8064"))
    for i in range(96):
        var angle := TAU * float(i) / 96.0
        var side := -1.0 if i % 2 == 0 else 1.0
        var location := _track_point(angle, side * random.randf_range(12.0, 27.0))
        # Keep scenery out of both branches at the crossover.
        var clear_of_road := true
        for center in track_centers:
            if Vector2(location.x - center.x, location.z - center.z).length() < HALF_WIDTH + 3.0:
                clear_of_road = false
                break
        if not clear_of_road:
            continue
        var rock := MeshInstance3D.new()
        var mesh := SphereMesh.new()
        mesh.radial_segments = 5
        mesh.rings = 2
        rock.mesh = mesh
        var height := random.randf_range(1.0, 4.5)
        rock.scale = Vector3(random.randf_range(2.0, 5.0), height, random.randf_range(2.0, 4.0))
        rock.position = Vector3(location.x, height * 0.35, location.z)
        rock.rotation = Vector3(0.15, random.randf_range(0.0, TAU), 0.2)
        rock.material_override = warm_stone_material if sin(angle) > 0.0 else stone_material
        add_child(rock)
    # Tall, distinct landmarks make each lobe recognizable from a distance.
    for side in [-1.0, 1.0]:
        var landmark := MeshInstance3D.new()
        var spire := CylinderMesh.new()
        spire.top_radius = 1.0
        spire.bottom_radius = 7.0
        spire.height = 24.0 if side < 0.0 else 16.0
        spire.radial_segments = 5
        landmark.mesh = spire
        landmark.position = Vector3(side * 74.0, spire.height * 0.5, 0.0)
        landmark.material_override = stone_material if side < 0.0 else warm_stone_material
        add_child(landmark)

func _material(color: Color) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = 0.95
    return material
